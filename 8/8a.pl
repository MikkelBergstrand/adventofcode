use strict;
use warnings;
use v5.30;

chomp(my $sequenceLine = <>);

my @sequence = split //, $sequenceLine;

my %nodes = ();
while(<>){
    chomp(my $line = $_);
    next if not $line; #Skip empty line

    $line =~ /(\w{3}) = \((\w{3}), (\w{3})\)/;

    my %node = (
        left => $2,
        right => $3
    );
    $nodes{$1} = \%node;
}

my $idx = 0;
my $currentNode = 'AAA';
my $nSequence = scalar @sequence;

while($currentNode ne 'ZZZ'){
    my $seq = $sequence[$idx % $nSequence]; 
    $currentNode = ($seq eq 'L') ? $nodes{$currentNode}->{left} : $nodes{$currentNode}->{right};
    $idx++; 
}

say $idx;

