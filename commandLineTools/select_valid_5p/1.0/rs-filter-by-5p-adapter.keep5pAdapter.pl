#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;

my $help;
my $adapter;
my $gzip;
GetOptions(
    "adapter=s" => \$adapter,
    "help"      => \$help,
    "h"         => \$help,
    "gzip"      => \$gzip
);

my $showhelp = 0;
$showhelp = 1 if ( not defined $adapter );
$showhelp = 1 if ( defined $help );

if ($showhelp) {
    print STDERR "[ERROR] Usage: perl $0 --adapter=....TTT --gzip file.fa.gz \n";
    print STDERR "[ERROR] Usage for uncompressed fasta files: perl $0 --adapter=....TTT file.fa\n\n";
    exit 1;
}

$adapter = uc($adapter);
print STDERR "[INFO]   Adapter sequence: $adapter\n";
my $regexp = $adapter;
$regexp =~ s/N/\./g;
print STDERR "[INFO] Regular expression: $regexp\n";

my $header     = '';
my $header_cnt = 0;
my $cnt        = 0;
my $fh;
if( $gzip ){
    open($fh, "gzip -dc $ARGV[0] | ") or die "Can not open pipe to $ARGV[0]\n";
} else {
    open($fh, "< $ARGV[0]") or die "Can not read $ARGV[0]\n";
}
while (<$fh>) {
  chomp;
  $cnt++;
  if ( $_ =~ m/^>(.*)/ ) {
    $header = $1;
    $header_cnt = $cnt;
    next;
  }
  if ( $header_cnt + 1 != $cnt ) {
    print STDERR "[ERROR] Script only works with FASTA 1-liners.\n";
    exit;
  }
  if ( $_ =~ m/^($regexp)(.*)/ ) {
    my $newseq = $2;
    (my $umi = $1) =~ s/T{3}$//;
    $header .= "-$umi";
    if ( length($newseq) > 5 ) {
      print ">$header\n$newseq\n";
    }
  }
}
close($fh);
