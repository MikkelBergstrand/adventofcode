use strict;
use warnings;

my $sum = 0;
while(<>) {
    my %currentMax = ();
    while($_ =~ /(\d+) (\w+)/g) {
        $currentMax{$2} = $1 if not exists $currentMax{$2} or $currentMax{$2} >= $1);
    }

    my $power = 1;
    for my $m (values %currentMax){
        $power *= $m;
    }
    $sum += $power;
}

print "$sum\n";
