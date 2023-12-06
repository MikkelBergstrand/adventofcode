use strict;
use warnings;

use v5.30;

<> =~ /Time: (.*)/;
my @times = split ' ', $1;
<> =~ /Distance: (.*)/;
my @distances = split ' ', $1;

my $output = 1; 
for(my $i = 0; $i < scalar @times; $i++){
    my $time = $times[$i];
    my $distance = $distances[$i];
    my $winningWays = 0;
    say "Look at $time, $distance"; 
    for(my $charge = 0; $charge < $time; $charge++){
        my $newDist = ($time - $charge)*$charge;
        say "$charge $newDist";
        $winningWays++ if $newDist > $distance;
        
    }
    $output *= $winningWays;
    say "$winningWays winning ways";
}

say $output;
