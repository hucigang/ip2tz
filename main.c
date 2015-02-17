//
//  main.c
//  geoip
//
//  Created by hucg on 15/2/14.
//  Copyright (c) 2015年 hucg. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include "unistd.h"
#include "zlib.h"
#define CNTL_Z EOF
#define SLEN 50

// 记录公共HEAD部分的数量
#define HEADCOUNT 16
// 记录公共HEAD  IPHEAD,IPCOUNT 循环获取
#define IPHEAD 8
// 记录对应公共HEAD的记录数
#define IPCOUNT 16
// 记录剩余IP IP TZ 循环获取
#define IP 24
// 记录时区， 最大12 发现大于16 则为负数 需-256
#define TZ 8

int fgetbit(FILE *fp){
    static int msk = 0x100;
    static int chr = 0;
    int bit;
    
    if(chr == EOF){
        return EOF;
    }
    
    if(msk >= 0x100){
        chr = getc(fp);
        if(chr == EOF){
            return EOF;
        }
        msk = 1;
    }
    
    bit = (chr & msk) != 0;
    msk <<= 1;
    
    return bit;
}


void getPos(char* src, char a[]){

    long l = atol(src);


     for(int i=31; i >= 0;i--)
    {
        int t = l%2;

        if(l==0){
            a[i] = '0';
        }else{
            a[i] = t+'0';
        }
        l=l/2;
    }
    a[32] = '\0';
    return;
}

char* substr(const char*str,unsigned start, unsigned end)
{
    unsigned n = end - start;
    static char stbuf[256];
    strncpy(stbuf, str + start, n);
    stbuf[n] = 0;
    return stbuf;
}

int main(int argc, const char * argv[]) {
    char file[SLEN];
    FILE *fp;
    int bit;

    char headCount[HEADCOUNT+1] = {0};
    char ipCount[IPCOUNT+1] = {0};
    char ipHead[IPHEAD+1] = {0};
    
    char ip[IP+1] = {0};
//    char dx[DX+1] = {0};
    char tz[TZ+1] = {0};
    
    int ips  = 1;
    
    char bin_addr[33] = {0};
    getPos(argv[2], bin_addr);
    printf("%s\n", bin_addr);
    
    if ((fp = fopen(argv[1],"rb")) == NULL)
    {
        printf("reverse 不能打开 %s\n", file);
        return -1;
    }

    int headCountPos = HEADCOUNT;
    int ipHeadPos = IPHEAD;
    int ipCountPos = IPCOUNT;
    int ipPos = IP;
//    int dxPos = DX;
    int tzPos = TZ;
    
    int count = 0;
    int headcount = 0;
    
    char* temp;
    temp=(char*)malloc(8*sizeof(char));
    temp = substr(bin_addr, 0, 8);
//
    
    char* _temp;

    
    int curPos = 0;
    int curCount = 0;

    //  记录所在头的记录数
    int realHeadCount = 0;
    //  记录获取的时区
    int realPos = 0;
    
    while((bit = fgetbit(fp)) != EOF){
        //putchar('0'+bit);
        
        if (headCountPos == 0 ){
            headCount[HEADCOUNT] = '\0';
            ips = (int)strtol(headCount, NULL, 2 );
            headCountPos = -1;
            count = 0;
        }

        if (ipHeadPos == 0){
            ipHead[IPHEAD] = '\0';
            ipHeadPos = -1;
            count = 0;
        }
        
        if (ipCountPos == 0){
            ipCount[HEADCOUNT] = '\0';
            int _curCount = strtol(ipCount, NULL, 2);
            printf("取得一个Head:%s %d Count %ld 还有%d个\n", ipHead,  strtol(ipCount, NULL, 2), curCount, ips-1);

            if (strcmp(ipHead, temp) == 0){
                printf("%d %s\n", curCount, "Find");
                realHeadCount = _curCount;
                curPos = headcount;
            }else{
                if (realHeadCount == 0)
                    curCount += _curCount;
            }
            headCountPos = -1;
            count = 0;
            ips--;
            if (ips > 0){
                ipHeadPos = IPHEAD;
                ipCountPos = IPCOUNT;
                headcount++;
            }else{
                ipHeadPos = -1;
                ipCountPos = -1;
                printf ("%s %d\n", temp, curPos);
                int btCount = 16;
                int bHead = 8;
                int bCount = 16;
                int head = btCount+(bHead+bCount)*(headcount+1);
                printf ("%d %d %d\n", head/8, head%8, curCount);
                fseek(fp,4*curCount,1);
            }
        }
        //000000000101100100101000  000101110110000000000000
        //                          000101110111000000000000
        if (ipPos == 0){
            ip[count] = '\0';
            printf("%d IP: %s\n", realHeadCount, ip);
            ipPos = -1;
            count = 0;
        }

     
        if (tzPos == 0){
            tz[count] = '\0';
            int ttemp = (int) strtol(tz, NULL, 2);
            if (ttemp > 16){
                ttemp = ttemp - 256;
            }
            printf("TZ: %d\n", ttemp);
            tzPos = -1;
            count = 0;

            _temp=(char*)malloc(24*sizeof(char));
            _temp = substr(bin_addr, 8, 32);
            
            long argIP = strtol(_temp, NULL, 2 );
            long curIP = strtol(ip, NULL, 2 );
            printf("%s %s, %s\n", temp, _temp, ip);
            
            // 判断当前IP段比数据库中的IP段大则将时区保存，
            // 发现小于这个IP段时 则表示在上个IP段中 即可停止查找
            if (argIP < curIP || realHeadCount <= 1){
           
                printf("%s, %s\n",  _temp, ip);
                
                printf("%d %ld, %ld\n", realHeadCount, argIP, curIP);
                break;
            }else{
                realPos = ttemp;
                realHeadCount--;
                ipPos = IP;
                tzPos = TZ;
            }
        }
        
        if (headCountPos > 0 && headCountPos <= HEADCOUNT){
            headCount[count++] = '0'+bit;
            headCountPos--;
            continue;
        }

        if (ipHeadPos > 0 && ipHeadPos <= IPHEAD){
            ipHead[count++] = '0'+bit;
            ipHeadPos--;
            continue;
        }
        
        if (ipCountPos > 0 && ipCountPos <= IPCOUNT){
            ipCount[count++] = '0'+bit;
            ipCountPos--;
            continue;
        }
        
        if (ipPos > 0 && ipPos <= IP){

            
            ip[count++] = '0'+bit;
            ipPos--;
            continue;
        }
//        if (dxPos > 0 && dxPos <= DX){
//            
//            dx[count++] = '0'+bit;
//            dxPos--;
//            continue;
//        }
        if (tzPos > 0 && tzPos <= TZ){
            tz[count++] = '0'+bit;
            tzPos--;
            continue;
        }
        
        
    }
    
    printf("%s : %d\n", argv[2],  realPos);
    fclose(fp);
    
    return 0;
}
