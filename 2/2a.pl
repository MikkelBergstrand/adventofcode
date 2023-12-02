use strict;
use warnings;

my %limits = (
    'red' => 12,
    'blue' => 14,
    'green' => 13 );

OUTER: while(<>) {
    while(/(\d+) (\w+)/g) {
        next OUTER if($limits{$2} < $1);
    }
    $sum += $.;
}

print "$sum\n";
