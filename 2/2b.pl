use strict;
use warnings;

my $id = 0;
my $sum = 0;
while(<>) {
    $id++;
    my %currentMax;
    my $line = ($_ =~ /:(.*)/);
    foreach my $pick (split(';', $1)) {
        while($pick =~ /(\d+) (\w+)/g) {
            $currentMax{$2} = $1 unless exists $currentMax{$2} and $currentMax{$2} >= $1; 
        }
    }
    my $power = 1;
    for my $m (values %currentMax){
        $power *= $m;
    }
    $sum += $power;
}

print "$sum\n";
