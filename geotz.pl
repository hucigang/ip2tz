#!/bin/perl -w
use strict;
#use Compress::Zlib;

my $geoPath=".";

my $location = `sed -n '3,\$p' $geoPath"/"GeoLiteCity-Location.csv`;
#my $block = `sed -n '3,\$p' $geoPath"/"GeoLiteCity-Blocks.csv`;
my $blockFile = $geoPath."/GeoLiteCity-Blocks.csv";

my @l = split ('\n',$location);
#my @b = split ('\n',$block);
my %hashLong = ();

foreach my $t (@l){
    my @temp = split (',',$t);
    my $longitude = $temp[6];
    my $tz = int(($longitude + 7.5 )/15);
    
    if (exists $hashLong{$temp[0]}){
        my $ttt = ",".$temp[0];
        $hashLong{$ttt} .= $tz;
    }else{
        $hashLong{$temp[0]} = $tz;
    }
}

open(FILE, $blockFile) || die "文件不存在!!";

my %all= ();
my @allStart = ();
my @allEnd = ();

my %start_1 = ();
my @astart_1 = ();
my @aend_1 = ();

my %start_2 = ();
my @astart_2 = ();
my @aend_2 = ();

my %start_3 = ();
my @astart_3 = ();
my @aend_3 = ();

my %start_4 = ();
my @astart_4 = ();
my @aend_4 = ();


my %start_5 = ();
my @astart_5 = ();
my @aend_5 = ();


my %start_6 = ();
my @astart_6 = ();
my @aend_6 = ();


my %start_7 = ();
my @astart_7 = ();
my @aend_7 = ();


my %start_8 = ();
my @astart_8 = ();
my @aend_8 = ();


my %start_9 = ();
my @astart_9 = ();
my @aend_9 = ();

my %start_10 = ();
my @astart_10 = ();
my @aend_10 = ();

my %start_11 = ();
my @astart_11 = ();
my @aend_11 = ();

my %start0 = ();
my @astart0 = ();
my @aend0 = ();

my %start1 = ();
my @astart1 = ();
my @aend1 = ();

my %start2 = ();
my @astart2 = ();
my @aend2 = ();

my %start3 = ();
my @astart3 = ();
my @aend3 = ();

my %start4 = ();
my @astart4 = ();
my @aend4 = ();


my %start5 = ();
my @astart5 = ();
my @aend5 = ();


my %start6 = ();
my @astart6 = ();
my @aend6 = ();


my %start7 = ();
my @astart7 = ();
my @aend7 = ();


my %start8 = ();
my @astart8 = ();
my @aend8 = ();


my %start9 = ();
my @astart9 = ();
my @aend9 = ();

my %start10 = ();
my @astart10 = ();
my @aend10 = ();

my %start11 = ();
my @astart11 = ();
my @aend11 = ();

my %start12 = ();
my @astart12 = ();
my @aend12 = ();

my $curStart = 0;
my $curEnd = 0;
my $preStart = 0;
my $preEnd = 0;
while (my $line = <FILE>){
    chomp($line);
    $line =~ s/"//g;
    next if (!($line =~ m/^[0-9]/));
    my @temp = split (',',$line);
    # print $temp[2]."\n";
    # print $temp[0].",".($temp[1]-$temp[0]).",".$hashLong{$temp[2]}."\n";
    my $tz = $hashLong{$temp[2]};
    if ($tz == 1){
        $start1{$temp[0]} = $temp[1];
        push @aend1, $temp[1];
        push @astart1, $temp[0];
    }elsif($tz == 2){
        $start2{$temp[0]} = $temp[1];
        push @aend2, $temp[1];
        push @astart2, $temp[0];
    }elsif($tz == 3){
        $start3{$temp[0]} = $temp[1];
        push @aend3, $temp[1];
        push @astart3, $temp[0];
    }elsif($tz == 4){
        $start4{$temp[0]} = $temp[1];
        push @aend4, $temp[1];
        push @astart4, $temp[0];
    }elsif($tz == 5){
        $start5{$temp[0]} = $temp[1];
        push @aend5, $temp[1];
        push @astart5, $temp[0];
    }elsif($tz == 6){
        $start6{$temp[0]} = $temp[1];
        push @aend6, $temp[1];
        push @astart6, $temp[0];
    }elsif($tz == 7){
        $start7{$temp[0]} = $temp[1];
        push @aend7, $temp[1];
        push @astart7, $temp[0];
    }elsif($tz == 8){
        $start8{$temp[0]} = $temp[1];
        push @aend8, $temp[1];
        push @astart8, $temp[0];
    }elsif($tz == 9){
        $start9{$temp[0]} = $temp[1];
        push @aend9, $temp[1];
        push @astart9, $temp[0];
    }elsif($tz == 10){
        $start10{$temp[0]} = $temp[1];
        push @aend10, $temp[1];
        push @astart10, $temp[0];
    }elsif($tz == 11){
        $start11{$temp[0]} = $temp[1];
        push @aend11, $temp[1];
        push @astart11, $temp[0];
    }elsif($tz == 12){
        $start12{$temp[0]} = $temp[1];
        push @aend12, $temp[1];
        push @astart12, $temp[0];
    }elsif($tz == 0){
        $start0{$temp[0]} = $temp[1];
        push @aend0, $temp[1];
        push @astart0, $temp[0];
    }elsif($tz == -1){
        $start_1{$temp[0]} = $temp[1];
        push @aend_1, $temp[1];
        push @astart_1, $temp[0];
    }elsif($tz == -2){
        $start_2{$temp[0]} = $temp[1];
        push @aend_2, $temp[1];
        push @astart_2, $temp[0];
    }elsif($tz == -3){
        $start_3{$temp[0]} = $temp[1];
        push @aend_3, $temp[1];
        push @astart_3, $temp[0];
    }elsif($tz == -4){
        $start_4{$temp[0]} = $temp[1];
        push @aend_4, $temp[1];
        push @astart_4, $temp[0];
    }elsif($tz == -5){
        $start_5{$temp[0]} = $temp[1];
        push @aend_5, $temp[1];
        push @astart_5, $temp[0];
    }elsif($tz == -6){
        $start_6{$temp[0]} = $temp[1];
        push @aend_6, $temp[1];
        push @astart_6, $temp[0];
    }elsif($tz == -7){
        $start_7{$temp[0]} = $temp[1];
        push @aend_7, $temp[1];
        push @astart_7, $temp[0];
    }elsif($tz == -8){
        $start_8{$temp[0]} = $temp[1];
        push @aend_8, $temp[1];
        push @astart_8, $temp[0];
    }elsif($tz == -9){
        $start_9{$temp[0]} = $temp[1];
        push @aend_9, $temp[1];
        push @astart_9, $temp[0];
    }elsif($tz == -10){
        $start_10{$temp[0]} = $temp[1];
        push @aend_10, $temp[1];
        push @astart_10, $temp[0];
    }elsif($tz == -11){
        $start_11{$temp[0]} = $temp[1];
        push @aend_11, $temp[1];
        push @astart_11, $temp[0];
    }
}
my $totalCount = 0;
sub mergeHash{
    my ($tz, $hash, $start, $end) = @_;

    my $count = 0;
    my $dcount = 0;
    ##
    # 如果EndIP+1 存在StartHash中 则delete EndIP+1
    #             不存在则开始下一段区域的合并
    #             
    my $startV = $start->[$count];
    foreach my $val (sort {$a <=> $b} @{$end}){
        my $valt = $val + 1;
        if (exists $hash->{$valt}){
            $hash->{$startV} = $hash->{$valt};
            delete $hash->{$valt};
            $dcount++;
        }else{
            $startV = $start->[$count];
        }
        $count++;
    }

    foreach my $val (keys %{$hash}){
        if (exists $all{$val}){
            print "!!!!!!!!!!!!!!!!\n";
        }
        $tz =~ s/x/-/g;
        $all{$val} = $tz;
    }

    my $rcount = scalar(keys %{$hash});
    print "合并时区[$tz]信息(删除数量/合并后/合并前): $dcount/$rcount/$count\n";
    $totalCount += $rcount;
}
mergeHash("0", \%start0, \@astart0, \@aend0);
mergeHash("1", \%start1, \@astart1, \@aend1);
mergeHash("2", \%start2, \@astart2, \@aend2);
mergeHash("3", \%start3, \@astart3, \@aend3);
mergeHash("4", \%start4, \@astart4, \@aend4);
mergeHash("5", \%start5, \@astart5, \@aend5);
mergeHash("6", \%start6, \@astart6, \@aend6);
mergeHash("7", \%start7, \@astart7, \@aend7);
mergeHash("8", \%start8, \@astart8, \@aend8);
mergeHash("9", \%start9, \@astart9, \@aend9);
mergeHash("10", \%start10, \@astart10, \@aend10);
mergeHash("11", \%start11, \@astart11, \@aend11);
mergeHash("12", \%start12, \@astart12, \@aend12);
mergeHash("x1", \%start_1, \@astart_1, \@aend_1);
mergeHash("x2", \%start_2, \@astart_2, \@aend_2);
mergeHash("x3", \%start_3, \@astart_3, \@aend_3);
mergeHash("x4", \%start_4, \@astart_4, \@aend_4);
mergeHash("x5", \%start_5, \@astart_5, \@aend_5);
mergeHash("x6", \%start_6, \@astart_6, \@aend_6);
mergeHash("x7", \%start_7, \@astart_7, \@aend_7);
mergeHash("x8", \%start_8, \@astart_8, \@aend_8);
mergeHash("x9", \%start_9, \@astart_9, \@aend_9);
mergeHash("x10", \%start_10, \@astart_10, \@aend_10);
mergeHash("x11", \%start_11, \@astart_11, \@aend_11);

sub getFileString{
    my $hash = shift;
    my $result = "";
    my $headResult = "";
    my $headResultCount = 0;

    my $preHead = "";
    my $preHeadCount = 0;
    my $preHeadPos = 20;
    my @temphash = sort {$a <=> $b} keys %{$hash};
    my $aaacount = 0;
    foreach my $key (@temphash)
    {
        $aaacount++;
        my $value = $hash->{$key};
        if ($aaacount <= 30){
        print "$key, $value\n";
    }
        my $offset = 0;

        my @tstart = split //, unpack("B32",pack("N",$key));
        my @tzs = split //, unpack("B8",pack("i",$value));
=pod
        my @dx = ();
        if ($value > 0){
            @dx = split //, unpack("B8",pack("i",1));
        }else{
            @dx = split //, unpack("B8",pack("i",0));
        }
=cut
        my $bitStart = "";
        my $bitTZ= "";
        my $bitDX= "";
        # 预留20个Bit(长度) + 4Bit(相同的4位数据)
        # 总数据约40W 需要20个Bit记录 
        # 记录 Head
        my $curHead = "";
        foreach my $i (0 .. 7){
            $curHead .= $tstart[$i];
        }

        my $tempcount = 0;
        foreach my $bit (@tstart){
            # 少写Head部分
            next if ($tempcount++ < 8);    
            vec($bitStart, $offset++, 1) = $bit;
        }
        $offset = 0;
        foreach my $bit (@tzs){
            vec($bitTZ, $offset++, 1) = $bit;
        }
=pod
        $offset = 0;
        foreach my $bit (@dx){
            vec($bitDX, $offset++, 1) = $bit;
        }
=cut
        if (((($preHead cmp "") != 0) 
                && (($preHead cmp $curHead) != 0)) 
            || $aaacount == $totalCount){
            my $bitHead = "";
            $offset = 0;
            foreach my $i(0 .. 7){
                my @preHeadArray = split //, $preHead;
                vec($bitHead, $offset++, 1) = $preHeadArray[$i];
            }
            my @lengths = split //, unpack("B16",pack("n",$preHeadCount));
            my $lengthBit = "";
            $offset = 0;
            foreach my $bit (@lengths){
                vec($lengthBit, $offset++, 1) = $bit;
            }

            $headResult .=  $bitHead.$lengthBit;
            print "End $preHead : $preHeadCount\n";
            # 重置计数器
            $preHeadCount = 0;
            $headResultCount++;
            # 这里已处理完毕 在后面计数器会多一个
        }
        $preHead = $curHead;
        $preHeadCount++;
        #$result .= $bitStart.$bitDX.$bitTZ;
        $result .= $bitStart.$bitTZ;
    } 
    print "HeadResultCount : $headResultCount  $aaacount\n";
    my @headResultCounts = split //, unpack("B16",pack("n",$headResultCount));
    my $CountBit = "";
    my $oset = 0;
    foreach my $bit (@headResultCounts){
        vec($CountBit , $oset++, 1) = $bit;
    }

    return $CountBit.$headResult.$result;
}
print "信息记录数为:$totalCount\n";
my $allcount = scalar(keys %all);
print "Total $allcount\n";

my $info = getFileString(\%all);

open(WRITE, ">ALL.txt") || die "文件不存在!!";
binmode(WRITE);
print WRITE $info;
#my $gz = gzopen(\*WRITE, "wb") or die "Cannot open stdout: $gzerrno\n" ;
#$gz->gzwrite($info); 
#$gz->gzclose();
close(WRITE);
close(FILE);
