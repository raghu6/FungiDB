#!/usr/bin/perl -w

#--------------------------------------------------------------------
# Downloads short reads from NCBI SRA ftp using Aspera plugin 
# usage: perl download_SRA.pl --acc {accession Number} /      
#        --loc {path/directory location to save the files}    
#
# eg: perl download_SRA.pl --acc SRP008146 -loc '/home/raghu/testDir'
#--------------------------------------------------------------------

use strict;
use Getopt::Long;

my $accession;
my $dirLocation = '.';     #sets current directory as default location 

GetOptions(
	   'a|acc=s' => \$accession,
	   'l|loc|p|path=s' => \$dirLocation);

my $metaChar = substr($accession,2,1);

my $metaData;
if ($metaChar eq 'P') {

   $metaData = 'ByStudy'; 
}
elsif ($metaChar eq 'R') {

  $metaData = 'ByRun'; 
}
elsif ($metaChar eq 'S') { 
    
  $metaData = 'BySample'; 
}
elsif ($metaChar eq 'X') { 

  $metaData = 'ByExperiment'; 
}

my $command = '/usr/local/pkg/aspera/connect/bin/ascp -k 1 -l 300M -QTr -i /usr/local/pkg/aspera/connect/etc/asperaweb_id_dsa.putty anonftp@ftp-private.ncbi.nlm.nih.gov:/sra/sra-instant/reads/'."$metaData".'/litesra/'.substr($accession,0,3).'/'.substr($accession,0,6).'/'.$accession.' '.$dirLocation ;

print $command, "\n" ;

`$command`;

# fastq-dump
opendir(DIR, "$dirLocation/$accession") || die $!;
for my $d ( readdir(DIR) ) {

 print "mv $dirLocation/$accession/$d/$d.lite.sra $dirLocation/$accession/. \n";
 print "rm -r $dirLocation/$accession/$d \n";
 `mv $dirLocation/$accession/$d/$d.lite.sra $dirLocation/$accession/.` ;
 `rm -r $dirLocation/$accession/$d`;
 `fastq-dump $dirLocation/$accession/$d.lite.sra`;
 `rm $dirLocation/$accession/$d.lite.sra`;
 `mv $d.fastq $dirLocation/$accession/.`;
}
