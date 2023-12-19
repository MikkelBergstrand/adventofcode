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

my @beams = ();
my %seenTiles = ();
my ($LEFT, $RIGHT, $UP, $DOWN) = (1..4);
my ($NOACTION, $KILL, $DUPLICATE) = (1, 2, 3);
push @beams, { 
    x => 0,
    y => 0,
    dx => 1,
    dy => 0
};

while(@beams){
    my $n = scalar @beams;
    for(my $i = 0; $i < $n; $i++){
        if(beam_tick($beams[$i]) == $KILL) {
            splice(@beams, $i, 1);
            $i--; $n--;
        }
    }
    say scalar (keys %seenTiles);

    for(my $y = 0; $y < $h; $y++) {
        for(my $x = 0; $x < $w; $x++) {
            #print ((exists $seenTiles{$y*$w+$x}) ? "#" : ".");
        }
        #say "";
    }
}



sub beam_tick {
    my $beam = shift;
    my ($x, $y) = ($beam->{x}, $beam->{y});
    my $dx = $beam->{dx};
    my $dy = $beam->{dy};

    return $KILL if (not in_bounds($x, $y));

    my $tile = read_map($x, $y);
    $seenTiles{$y*$w + $x} = 1;
    
    if($tile eq '|' && $dx != 0){

        push @beams, {
            x => $x, y => $y+1, dx => 0, dy => 1 
        } if $y+1 <$h;
        push @beams, {
            x => $x, y => $y-1, dx => 0, dy => -1 
        } if $y-1 >= 0;
        return $KILL;
    }
    if($tile eq '-' && $dy != 0){
        push @beams, {
            x => $x - 1, y => $y,dx => -1, dy => 0
        } if $x-1 >= 0;
        push @beams, {
            x => $x +1, y => $y,dx => 1, dy => 0
        } if $x+1 < $w; 
        return $KILL;
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

   return $NOACTION;
}





