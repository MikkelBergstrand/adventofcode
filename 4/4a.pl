use strict;
use warnings;
use v5.30;

my $sum = 0;
while(<>) {
    $_ =~ /:(.+)\|(.*)/;

    my @winningNos = split ' ', $1;
    my @guessNos = split ' ', $2;

    my @overlap = grep { my $look = $_;  grep(/^$look$/, @winningNos); } @guessNos;
    my $noMatch = scalar @overlap;
    $sum += 2**($noMatch-1) if $noMatch > 0;
}
say $sum;

