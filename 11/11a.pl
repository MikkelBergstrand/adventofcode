use strict;
use warnings;
use v5.34;
use Array::Utils qw(:all);

my @galaxies = ();
my $h = 0;
my $w = 0;
my ($xm, $ym) = (100000, 100000);
my $y = 0;
while(<>){
    while($_ =~ /(#)/g){
        
        my @pos = ($-[1], $y);
        my ($x, $y) = ($-[1], $y);

        push @galaxies, \@pos;

        $w = $x if $x > $w;
        $h = $y if $y > $h;

        $xm = $x if $x < $xm;
        $ym = $y if $y < $ym;
    }
    $y++;
}

my @galaxyXs = map { $_->[0] } @galaxies;
my @galaxyYs = map { $_->[1] } @galaxies;

my @emptyYDir = ($ym+1..$h-1);
my @emptyXDir = ($xm+1..$w-1);

@emptyXDir = array_minus(@emptyXDir, @galaxyXs);
@emptyYDir = array_minus(@emptyYDir, @galaxyYs);
say join ",", @emptyXDir;
say join ",", @emptyYDir;

@emptyXDir = reverse @emptyXDir;
@emptyYDir = reverse @emptyYDir;

foreach(@galaxies){
    say join(",",@$_);
}
foreach my $x (@emptyXDir) {
    @galaxies = map { $_ = [$_->[0] + ($_->[0] > $x ? 1 : 0), $_->[1]] } @galaxies;
}
foreach my $y (@emptyYDir) {
    @galaxies = map { $_ = [$_->[0], $_->[1] + ($_->[1] > $y ? 1 : 0)] } @galaxies;
}

my $total = 0;
for(my $i = 0; $i < scalar(@galaxies); $i++){
    for(my $j = $i + 1; $j < scalar @galaxies; $j++){
        my ($galaxy, $galaxy2) = ($galaxies[$i], $galaxies[$j]);
        my $dist = abs($galaxy2->[1] - $galaxy->[1]) + abs($galaxy2->[0] - $galaxy->[0]);
        $total += $dist;
    }
}
say $total;
