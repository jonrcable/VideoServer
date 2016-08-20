#!/usr/bin/perl
# use strict;
# use warnings FATAL => 'all';
use Getopt::Std;
use POSIX;

### Define our client include file
$opt_s = "0";
getopt('s:');
chomp($opt_s);

require "/home/home/ubuntu/Source/INCLUDE/MasterConfig.inc";

if($opt_s eq 'start'){

	### Check Unity Video
	$testMount = $livsmount;
	$s3bucket = 'unity-client-video';
	checkEndpoint($testMount, $s3bucket);

	### Check Unity Documents
	$testMount = $docsmount;
	$s3bucket = 'unity-client-documents';
	checkEndpoint($testMount, $s3bucket);

	### Global Checks
	checkPaths();

}elsif($opt_s eq 'stop'){

	stopMounts();

}elsif($opt_s eq 'service'){

    ### Check Unity Video
    $testMount = $livsmount;
    $s3bucket = 'unity-client-video';
    checkEndpoint($testMount, $s3bucket);

}else{

    ### Global Checks
    ### Check Unity Video
    $testMount = $livsmount;
    $s3bucket = 'unifi-client-video';
    checkEndpoint($testMount, $s3bucket);

    ### Global Checks
    checkPaths();
        
}

### Sub Routines
sub checkEndpoint($testMount, $s3bucket){

    print "* Mount Test - $testMount >> $s3bucket -> ";
    `/bin/df | /bin/grep $testMount`;
    if($? != 0){

        if(-d "$testMount"){
            ## No need to create a directory
            print "Mount Point Exists -> CHECK";
            `umount $testMount > /dev/null 2>&1`;
            `s3fs $s3bucket $testMount -o allow_other -o -use_cache=/tmp -o -connect_timeout=30 -o -retries=6 -o passwd_file=/home/ubuntu/.s3/creds`;
            checks3($testMount);
        }else{
            ## Create The Path
            print "Creating Mount Point -> CHECK";
            `mkdir $testMount`;
            `s3fs $s3bucket $testMount -o allow_other -o -use_cache=/tmp -o -connect_timeout=30 -o -retries=6 -o passwd_file=/home/ubuntu/.s3/creds`;
            checks3($testMount);
        }

    }else{

        checks3($testMount);

    }
    # print "DONE \n";

}

sub checks3($testMount){

    require "/home/home/ubuntu/Source/INCLUDE/MasterConfig.inc";

    print "\n* Client Test - $testMount -> ";
    if(-d "$testMount/$client"){
        print "Client Exists -> ";
    }else{
        ## Make client directory
        print "Client Created -> ";
        `mkdir $testMount/$client`;
    }

    if(-d "$testMount/$client/$project"){
        print "Project Exists -> ";
    }else{
        ## Make project directory
        print "Project Created -> ";
        `mkdir $testMount/$client/$project`;
    }
	print " DONE \n";

}

sub checkPaths(){

    require "/home/home/ubuntu/Source/INCLUDE/MasterConfig.inc";

	print "* Path Test - "; 
    if(-d "$docsmount/$client/$project/Video"){
        print "* Documents Path Exists -> ";
    }else{
        ## Make project directory
        print "* Documents Path Created -> ";
        `mkdir $docsmount/$client/$project/Video`;
    }

	print " DONE \n";

}

sub stopMounts(){

	require "/home/home/ubuntu/Source/INCLUDE/MasterConfig.inc";
	print "Disconnecting Mounted Devices -> ";
	`umount $livsmount`;
	print "DONE \n";
		
}
