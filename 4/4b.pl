use strict;
use warnings;
use v5.30;

my @cardCount = (0);

while(<>) {
    chomp $_;
    $_ =~ /Card\s+(\d+):([^\|]+)\|(.*)/;

    my $cardID = $1;
    $cardCount[$cardID] += 1;

    my @winningNos = split ' ', $2;
    my @guessNos = split ' ', $3;

    my @overlap = grep { my $look = $_; grep(/^$look$/, @winningNos); } @guessNos;

    my $noMatch = scalar @overlap;
    for(my $i = 0; $i < $noMatch; $i++){
        $cardCount[$cardID + $i + 1] += $cardCount[$cardID];
    }
}

my $sum = 0;
foreach(@cardCount) {
    $sum += $_;
}
say $sum;
