use strict;
use warnings;
use v5.34;

my @data = ();
my ($w, $h); 

my $UP = 1;
my $DOWN = 2;
my $LEFT = 3;
my $RIGHT = 4;

my %dirTable =  (
    "|" => [$UP, $DOWN],
    "-" => [$LEFT, $RIGHT],
    L => [$UP, $RIGHT],
    J => [$UP, $LEFT],
    7 => [$DOWN, $LEFT],
    F => [$DOWN, $RIGHT]
);

my %offsets = (
    $UP => [0, -1],
    $DOWN => [0, 1],
    $LEFT => [-1, 0],
    $RIGHT => [1, 0]
);

my @allOffsets = values %offsets;

sub valid_coord {
    my ($x, $y) = @_;
    return $x >= 0 && $x < $w && $y >= 0 && $y < $h;
}

sub get_coord {
    my ($x, $y) = @_;
    return @{$data[$y]}[$x];
}

#Returns an array of direction we may go
sub get_directions {
    my($x, $y) = @_;
    my $square = get_coord($x, $y)->{data};    
    return @{$dirTable{$square}};
}

#Returns (x, y) pairs of neighbors we may visit from the specified (x, y) position
sub get_neighbors {
    my ($x, $y) = @_;

    return visitable_neighbors(@_) if(get_coord(@_)->{data} eq 'S');

    my @directions = get_directions(@_);
    my @ret = ();
    foreach(@directions){
        my ($ox, $oy) = @{$offsets{$_}};
        my ($nx, $ny) = ($x + $ox, $y + $oy);
        push @ret, [$nx, $ny] if  valid_coord($nx, $ny);
    }
    return @ret;
}

#Used for the S tile, as we don't know what type of tile it is.
sub visitable_neighbors {
    my ($x, $y) = @_;
    my @ret = ();
    foreach(@allOffsets) {
        my ($xo, $yo) = @$_;
        my ($nx, $ny) = ($x + $xo, $y + $yo);
        next if not valid_coord($nx, $ny) or get_coord($nx, $ny)->{data} eq '.';
        
        my @others_neighbors = get_neighbors($nx, $ny);
        push @ret, [$nx, $ny] if(grep { $_->[0] == $x and $_->[1] == $y; } @others_neighbors);
    }
    return @ret;
}

my @startPos;
while(<>){
    my @line = split(//, $_);
    @line = map { { data => $_, dist => undef  } } @line;
    if($_ =~ /(S)/){
       @startPos = ($-[1], $.-1);
    }
    push @data, \@line;
}

$w = scalar @{$data[0]};
$h = scalar @data; 
say "W: $w, H: $h";

my $maxDist = 0;

sub visit {
    my ($sx, $sy) = @_;
    my @neighs = (\@startPos);
    while(scalar @neighs > 0){
        my @next = @{(shift @neighs)};

        my $baseDist = get_coord(@next)->{dist};
        my @newNeighbors = get_neighbors(@next);
        foreach(@newNeighbors) {
            my ($nx, $ny) = @$_;
            my $dist = get_coord($nx, $ny)->{dist};
            if(not defined($dist)) {
                get_coord($nx, $ny)->{dist} = $baseDist + 1;
                push @neighs, [$nx, $ny];
                $maxDist = $baseDist + 1 if $baseDist + 1 > $maxDist;
                say $maxDist;
            }
        }
    }
}

get_coord(@startPos)->{dist} = 0;
visit($startPos[0], $startPos[1]);
say $maxDist;
