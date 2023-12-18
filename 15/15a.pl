use strict;
use warnings;
use v5.34;

my @strings = split(',', <>);
my $sum = 0;
foreach(@strings){
    chomp $_;
   $sum += hash($_); 
}
say $sum;

sub hash {
    my $s = shift;
    my $sum = 0;
    foreach(split(//, $s)) {
        $sum += ord($_);
        $sum *= 17; $sum %= 256;
    }
    return $sum;
}
