use strict;
use warnings;

use v5.30;

sub parse_input {
    my $tmp = shift;
    $tmp =~ s/ //g;
    $tmp =~ /:(.*)/;
    return $1;
}

my $a = <>;
my $b = <>;
my @times = (parse_input($a));
my @distances = (parse_input($b));

my $output = 1; 
for(my $i = 0; $i < scalar @times; $i++){
    my $time = $times[$i];
    my $distance = $distances[$i];
    my $winningWays = 0;
    for(my $charge = 0; $charge < $time; $charge++){
        my $newDist = ($time - $charge)*$charge;
        $winningWays++ if $newDist > $distance;
        
    }
    $output *= $winningWays;
}
say $output;
