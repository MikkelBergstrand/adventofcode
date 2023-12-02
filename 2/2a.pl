use strict;
use warnings;

my %limits = (
    'red' => 12,
    'blue' => 14,
    'green' => 13 );

my $id = 0;
my $sum = 0;
OUTER: while(<>) {
    $id++;
    my $line = ($_ =~ /:(.*)/);
    foreach my $pick (split(';', $1)) {
       while($pick =~ /(\d+) (\w+)/g) {
            next OUTER if($limits{$2} < $1);
        }
    }

    #End up here, it is valid
    $sum += $id;
}

print "$sum\n";
