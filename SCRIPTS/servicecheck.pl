#!/usr/bin/perl
use Getopt::Std;
use POSIX;

### Define our client include file
$opt_s = "0";
getopt('s:');
chomp($opt_s);

### Process Our Options
if($opt_s eq 'start'){
    startServices();

}elsif($opt_s eq 'stop'){
    stopServices();

}else{
    statusServices();

}

### Start Unity Sub System
sub startServices(){

    my $FTPStatus = `/bin/ps cax | /bin/grep vsftpd`;
    if(!$FTPStatus){
        print  "* FTP Not Running... starting\n";
        `service vsftpd start`;
    }

    my $QTSSService = `/bin/ps cax | /bin/grep DarwinStreaming`;
    if(!$QTSSService){
        print "* QTSS Not Running... starting\n";
        `/usr/bin/perl /usr/local/sbin/streamingadminserver.pl`;
    }

}

### Stop Unity Sub System
sub stopServices(){

    my $FTPStatus = `/bin/ps cax | /bin/grep vsftpd`;
    if($FTPStatus){
        print  "* FTP Running... stopping\n";
        `service vsftpd stop`;
    };

    my $QTSSService = `/bin/ps cax | /bin/grep DarwinStreaming`;
    ### Stop the QTSS Processes
    if($QTSSService){
        print "* QTSS Running... stopping\n";

        ## `killall DarwinStreamingServer > /dev/null 2>&1`;
        ## my $QTSSid = `pidof /usr/bin/perl /usr/local/sbin/streamingadminserver.pl`;
        ## `kill $QTSSid > /dev/null 2>&1`;
        ## sleep 1;
        ## `killall DarwinStreamingServer > /dev/null 2>&1`;
        `pkill -u qtss`;
    }

}

### Unity Sub System Status
sub statusServices(){

    #print "* Unity Server Status: ";
    #print "(try sending): checkservice.pl -s start OR stop\n";
    print "* ".`service vsftpd status`;
    my $FTPStatus = `/bin/ps cax | /bin/grep vsftpd`;
    if($FTPStatus){
        print  "* ftp is running\n";
    }else{
        print  "* ftp is stopped\n";
    }

    my $QTSSService = `/bin/ps cax | /bin/grep DarwinStreaming`;
    if($QTSSService){
        print "* qtss is running";
    }else{
        print "* qtss is stopped";
    }
    print "\n";

}
