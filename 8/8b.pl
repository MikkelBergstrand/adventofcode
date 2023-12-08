use strict;
use warnings;
use v5.30;
use Storable qw(dclone); 

chomp(my $sequenceLine = <>);

my @sequence = split //, $sequenceLine;

my %nodes = ();
while(<>){
    chomp(my $line = $_);
    next if not $line; #Skip empty line

    $line =~ /([\w]{3}) = \(([\w]{3}), ([\w]{3})\)/;

    my %node = (
        left => $2,
        right => $3
    );
    $nodes{$1} = \%node;
}

my $nSequence = scalar @sequence;
my @currentNodes = grep { $_ =~ /A$/ } (keys %nodes);

#All node paths are cyclical. That means every start node has an end node at
#(n+1)*interval, where n is a whole number
my @intervals = ();
foreach(@currentNodes) {
    my $node = $_;
    my $idx = 0;
    while($node !~ /Z$/){
        my $seq = $sequence[$idx++ % $nSequence]; 
        $node = ($seq eq 'L') ? $nodes{$node}->{left} : $nodes{$node}->{right};
    }
    push @intervals, $idx;
}

#Find greatest common divisor.
sub gcd{
    my ($a, $b) = @_;
    while($b != 0) {
        my $t = $b;
        $b = $a % $b;
        $a = $t;
    }
    return $a;
}

#Find the least common multiple of all the intervals.
my $gcd = $intervals[0];
my $lcm = $intervals[0];
for(my $i = 1; $i < scalar  @intervals; $i++){
    $gcd = gcd($intervals[$i], $gcd);
    $lcm = $lcm * $intervals[$i] / $gcd;
}

say $lcm;
