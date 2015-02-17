#!/usr/bin/perl -w
use strict;
use Test::More;

sub getLongByIp{
    my $ip = shift;
    my ($a,$b,$c,$d) = split(/\./, $ip);

    my $e = ($a << 24) | ($b << 16) | ($c <<  8) | ($d <<  0);

    #print $e."\n";
    return $e;
    #return ($a*256*256*256)+($b*256*256)+($c*256)+$d;
}

sub getLocids{
    my $ipLong = shift;
    my $pos = shift;
    my @infos;
    return \@infos if (length($ipLong) <= $pos);
    my $key = substr($ipLong, 0, $pos);
    @infos = `grep \"\\"$key\" GeoLiteCity-Blocks.csv`;

    if (scalar(@infos) == 0){
        getLocids($ipLong, --$pos);
    }else{
        return \@infos;
    }
}

sub getLocId{
    my $ipLong = shift;
    my $infos = shift;

    #print scalar(@{$infos});
    return "" if (scalar(@{$infos}) <= 0);
    foreach my $info (@{$infos}){
        $info =~ s/\"//g;
        my ($start, $end, $locid) = split/,/, $info;
        my @nums = ($start, $end, $ipLong);
        my @snums = sort {$a <=> $b} @nums;
        if ($snums[1] == $ipLong){
            return $locid;
        }
    }

    return "";
}

sub getTzByLocId{
    my $locid = shift;

    chomp($locid);
    #print "aaa".$locid;
    my @tzs = `grep \"^$locid,\" GeoLiteCity-Location.csv`;
    #print @tzs;
    if (scalar(@tzs) != 1){
        return -100;
    }else{
        my @temp = split/,/, $tzs[0];
        return int(($temp[6]+7.5)/15);
    }
}

sub getTz{
    my $ip = shift;
    my $ipLong = getLongByIp($ip);

    my $infos = getLocids($ipLong, -9);
    my $locId = getLocId($ipLong, $infos);

    return getTzByLocId($locId);
}

sub getTzByP{
    my $ip = shift;
    my @pinfo = readpipe("./tz $ip")  or die "$!\n";
    my $ppinfo = $pinfo[scalar(@pinfo)-1];
    chomp($ppinfo);
    my @tempinfo = split/ /, $ppinfo;
    
    return $tempinfo[scalar(@tempinfo)-1];
}

my $caseNum = 20;
my $ipNum = 4;
my $ip = "";
#
#A类地址：73.0.0.0 
#
#B类地址：160.153.0.0 
#
#C类地址：210.73.140.0 

my @aip = ();
my @oip = ();
my $cnt = 0;

foreach my $i ( 10 .. 220){
    next if ($i == 10 || $i == 192 || $i == 172 || $i == 127);
    $aip[$cnt] = $i;
    $cnt++;
}
$cnt = 0;
foreach my $i ( 1 .. 255){
    $oip[$cnt] = $i;
    $cnt++;
}
while (1){
    last if ($caseNum == 0);
    my $random = int( rand(254)) + 1; 
    if ($ipNum == 4){
        my $ipc = int (rand(scalar(@aip)));
        $ip = $aip[$ipc];
    }
    if ($ipNum < 4){
        my $ipc = int (rand(scalar(@oip)));
        $ip .= ".".$oip[$ipc];
    }
    $ipNum--;
    if ($ipNum == 0){
        #print "Ip: $ip\n";
        my $ptz = getTzByP($ip);
        my $ttz = getTz($ip);
        ok( $ptz == $ttz , "ok $ip Program: $ptz Test: $ttz");
        $caseNum--;
        $ipNum = 4;
        $ip = "";
    }
}


#print getTzByP("174.35.6.74")."\n";
#print getTz("113.121.23.210")."\n";
#print getTz("123.155.155.24")."\n";
#print getTz("174.35.6.74")."\n";
