#include <sys/cdefs.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <err.h>
#include <stdio.h>

#include "tz.h"

/* data base format
 * hdr
 * data
 */
typedef struct tz_hdr_data {
	uint8_t hip;
	uint16_t cnt;
} hdr_data_t;

typedef struct  tz_hdr {
	uint8_t cnt[2];
} tz_hdr_t;

typedef struct tz_data {
	uint8_t lip[3];
	int8_t  tz;
} tz_data_t;

#ifndef DB_PATH
#define DB_PATH "/emmc/tz.db"
#endif

typedef struct tz_private {
	int fd; /* tz db fd */

	int hdr_cnt;
	hdr_data_t hdr[256];

	int data_offset;
} tz_t;

void *tz_setup(const char *server)
{
	int fd, res, i;
	tz_t *tz = NULL;

	fd = open(DB_PATH, O_RDONLY);
	if (fd == -1)
	{
		goto out;
	}

	tz = malloc(sizeof(tz_t));
	if (tz)
	{
		tz->fd = fd;
	}

	tz_hdr_t hdr;
	res = read(fd, (void *)&hdr, sizeof(hdr));
	if (res != sizeof(hdr))
	{
		close(fd);
		free(tz);
		tz = NULL;
	}
	tz->data_offset += sizeof(hdr);

	tz->hdr_cnt = ((uint32_t)hdr.cnt[0] << 8) | ((uint32_t)hdr.cnt[1] << 0);
	for (i = 0; i < tz->hdr_cnt; i++)
	{
		uint8_t buf[3];
		res = read(fd, buf, sizeof(buf));
		if (res != sizeof(buf))
		{
			close(fd);
			free(tz);
			tz = NULL;
		}
		tz->hdr[i].hip = buf[0];
		tz->hdr[i].cnt = (((uint32_t)buf[1]) << 8) | ((uint32_t)buf[2]);
		tz->data_offset += sizeof(buf);
	}

out:
	return tz;
}

/* A 010.000.0.0 - 010.255.255.255
 * B 172.016.0.0 - 172.031.255.255
 * C 192.168.0.0 - 192.168.255.255
 */
static int to_ipv4(char *addr, sa_family_t type, uint64_t *ipv4_addr)
{
	uint64_t buf[4];
	int res;

	if (type != AF_INET)
		return -1;

	res = sscanf(addr, "%llu.%llu.%llu.%llu", buf, buf+1, buf+2, buf+3);
	if (res != 4)
		return -EINVAL;

	if ((buf[0] == 10) ||
		(buf[0] == 172 && (buf[1] > 15 && buf[1] < 32)) ||
		(buf[0] == 172 && buf[1] == 168))
		return -2;
   
	*ipv4_addr = (buf[0] << 24) + (buf[1] << 16) + (buf[2] <<  8) + (buf[3] <<  0);

	return 0;
}

static int tz_offset(tz_t *tz, uint8_t hip, int *hdr_index)
{
	uint64_t offset = tz->data_offset;
	int i;

	*hdr_index = 0;
	for (i = 0; i < tz->hdr_cnt; i ++)
	{
		hdr_data_t *hdr = &tz->hdr[i];
		if (hdr->hip > hip){
			break;
        }
		(*hdr_index) ++;
		offset += hdr->cnt * sizeof(tz_data_t);
	}

	return offset;
}

static int tz_search(tz_t *tz, int offset, uint64_t lip, int index, int *tmz)
{
	hdr_data_t *hdr = &tz->hdr[index];
	int i;

    //printf ("index %d %d offset: %d\n", index, hdr->cnt, offset);

	for (i = 0; i < hdr->cnt; i ++)
	{
		unsigned char buf[3];
		signed char buft[1];
		uint64_t cip;

		int res = pread(tz->fd, buf, sizeof(buf), offset);
		int rest = pread(tz->fd, buft, sizeof(buft), offset+sizeof(buf));

		if (res != sizeof(buf) || rest != sizeof(buft))
			return -EIO;
		cip  = ((uint64_t)buf[0]) << 16;
		cip += ((uint64_t)buf[1]) << 8;
		cip += ((uint64_t)buf[2]) << 0;
		if (cip > lip)
			break;
		*tmz = buft[0];
		offset += sizeof(buf)+sizeof(buft);
	}

	return 0;
}

/* type = INET
 * addr = "72.14.223.91"
 */
int tz_lookup(void *obj, char *addr, sa_family_t type, int *tz)
{
	uint64_t ipv4_addr, hip, lip;
	int res = to_ipv4(addr, type, &ipv4_addr);
	int offset, index;

	if (res != 0)
		return res;

	hip = ipv4_addr >> 24;
	lip = ipv4_addr & 0xffffff;

	offset = tz_offset(obj, hip, &index);

	return tz_search(obj, offset, lip, index, tz);
}

void tz_shutdown(void *obj)
{
	tz_t *tz = obj;
	close(tz->fd);
	free(tz);
}

#ifdef TEST
int main(int argc, char *argv[])
{
	char *ip = argv[1];
	void *obj = tz_setup("xx");
	int res, tz = -1;


	if (obj == NULL || argc != 2)
		return -1;

	res = tz_lookup(obj, ip, AF_INET, &tz);

	printf("res %d, ip %s, tz %d\n", res, ip, tz);

	return 0;
}
#endif
