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

     # new_distance = $charge * ($time - $charge) (is a second-order poly)
     # $charge is the variable, $time is constant
     # Its derivative is t - 2c. So the top point is c = t/2
     my $charge = $time / 2;

     # Intersection of parabola and straight line = $distance
     # Solve equation -c^2 - t*c - distance = 0
     my $intersect = (($time + sqrt($time*$time - 4*$distance)) / 2);

     # Check if intersection is a whole number.
     # That means that we include two unwanted results
     # (those where new distance = distance), and must subtract them.
     my $intersect_whole_no = ($intersect =~ /^\d+$/);

     #Since the parabola is symmetric about the axis $charge
     #We must also add one if $charge is odd.
     my $n = (int($intersect) - int($charge))*2 + ($time % 2 == 0) +  ($intersect_whole_no ? -2 : 0);
     $output *=$n;
}
say $output;
