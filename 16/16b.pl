use strict;
use warnings;
use v5.34;


my @map = ();
my ($w, $h);

sub read_map {
    my ($x, $y) = @_;
    return $map[$y]->[$x];
}

sub in_bounds {
    my ($x, $y) = @_;
    return $x >= 0 && $x < $w && $y >= 0 && $y < $h;
}

while(<>) {
    chomp $_;
   my @row = split //, $_; 
   push @map, \@row;
}

$w = scalar @{$map[0]};
$h = scalar @map;

my @startingPositons = ();
for(my $x = 0; $x < $w; $x++){
    push @startingPositons, [$x, 0, 0, 1];
    push @startingPositons, [$x, $h-1,, 0, -1];
}
for(my $y = 0; $y < $h; $y++){
    push @startingPositons, [0, $y, 1, 0];
    push @startingPositons, [$w-1, $y, -1, 0];
}

my $best = 0;

my @beams = ();
my %seenTiles = ();
my %cache = ();

foreach(@startingPositons){
    my ($ix, $iy, $dx, $dy) = @$_;
    @beams = (); %seenTiles = (); %cache = ();

    push @beams, { x => $ix, y => $iy, dx => $dx, dy => $dy };
    while(@beams){
        my $n = scalar @beams;
        for(my $i = 0; $i < $n; $i++){
            if(beam_tick($beams[$i])) {
                splice(@beams, $i, 1);
                $i--; $n--;
            }
        }
    }
    my $energized = scalar keys %seenTiles;
    $best = $energized if $energized > $best;
}
say $best;


sub beam_tick {
    my $beam = shift;
    my ($x, $y) = ($beam->{x}, $beam->{y});
    my $dx = $beam->{dx};
    my $dy = $beam->{dy};

    return 1 if (not in_bounds($x, $y));
    return 1 if $cache{($y*$w+$x) . " " . $dx . $dy};

    $cache{($y*$w+$x) . " " . $dx . $dy} = 1;

    my $tile = read_map($x, $y);
    $seenTiles{$y*$w + $x} = 1;

    if($tile eq '|' && $dx != 0){

        push @beams, {
            x => $x, y => $y+1, dx => 0, dy => 1 
        } if $y+1 <$h;
        push @beams, {
            x => $x, y => $y-1, dx => 0, dy => -1 
        } if $y-1 >= 0;
        return 1;
    }
    if($tile eq '-' && $dy != 0){
        push @beams, {
            x => $x - 1, y => $y,dx => -1, dy => 0
        } if $x-1 >= 0;
        push @beams, {
            x => $x +1, y => $y,dx => 1, dy => 0
        } if $x+1 < $w; 
        return 1;
    }

    if($tile eq '/') {
        $beam->{dx} = -$dy;
        $beam->{dy} = -$dx;
    }
    elsif($tile eq '\\'){
        $beam->{dx} = $dy;
        $beam->{dy} = $dx;
    }

    $beam->{x} += $beam->{dx};
    $beam->{y} += $beam->{dy};

    return 0;
}





