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

#ifndef DB_PATH
#define DB_PATH "/emmc/tz.db"
#endif

typedef struct tz_private {
	int fd; /* tz db fd */
} tz_t;

void *tz_setup(const char *server)
{
	int fd;
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

out:
	return tz;
}

/* A 010.000.0.0 - 010.255.255.255
 * B 172.016.0.0 - 172.031.255.255
 * C 192.168.0.0 - 192.168.255.255
 */
static int to_ipv4(char *addr, sa_family_t type, uint32_t *ipv4_addr)
{
	uint32_t buf[4];
	int res;

	if (type != AF_INET)
		return -1;

	res = sscanf(addr, "%d.%d.%d.%d", buf, buf+1, buf+2, buf+3);
	if (res != 4)
		return -EINVAL;

	if ((buf[0] == 10) ||
		(buf[0] == 172 && (buf[1] > 15 && buf[1] < 32)) ||
		(buf[0] == 172 && buf[1] == 168))
		return -2;

	*ipv4_addr = (buf[0] << 23) | (buf[1] << 16) | (buf[2] <<  8) | (buf[3] <<  0);

	return 0;
}

/* type = INET
 * addr = "72.14.223.91"
 */
int tz_lookup(void *obj, char *addr, sa_family_t type, int *tz)
{
	uint32_t ipv4_addr;
	int res = to_ipv4(addr, type, &ipv4_addr);

	if (res != 0)
		return res;

	/* TODO */

	return 0;
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
	char *ip = "8.8.8.8";
	void *obj = tz_setup("xx");
	int res, tz = -1;

	if (obj == NULL)
		return -1;

	res = tz_lookup(obj, ip, AF_INET, &tz);

	printf("res %d, %s tz %d\n", res, ip, tz);

	return 0;
}
#endif
