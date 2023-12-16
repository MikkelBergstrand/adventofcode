use strict;
use warnings;
use v5.34;
use Data::Dumper;
use Storable qw(dclone);

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
    foreach my $key (keys %offsets) {
        my ($xo, $yo) = @{$offsets{$key}};
        my ($nx, $ny) = ($x + $xo, $y + $yo);
        next if not valid_coord($nx, $ny) or get_coord($nx, $ny)->{data} eq '.';
        
        my @others_neighbors = get_neighbors($nx, $ny);
        push @ret, $key if(grep { $_->[0] == $x and $_->[1] == $y; } @others_neighbors);
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

my @can_go_from_start = visitable_neighbors(@startPos);
@can_go_from_start = sort @can_go_from_start;

while(my ($k, $v) = each (%dirTable)) {
    if(@{$v} ~~ @can_go_from_start){
       get_coord(@startPos)->{data} = $k; 
       last;
    }
}

my $maxDist = 0;

my @in_loop = ();
    push @in_loop, \@startPos;
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
                push @in_loop, [$nx, $ny];
            }
        }
    }
}

get_coord(@startPos)->{dist} = 0;
visit($startPos[0], $startPos[1]);

@in_loop = sort { ($a->[1] <=> $b->[1]) || ($a->[0] <=> $b->[0]) } @in_loop;
foreach(@in_loop){
    my ($x, $y) = @$_;
}
say "Searching through map...";
my @starting_points = (); #All points == '.'
my @edge_points = (); #All points == '.' that lie on the edge of the map
#Modify map so that all pipes not part of the loop constitutes a ground tile.
my $in_loop_idx = 0; 
my $in_loop_elem = $in_loop[0];
for(my $y = 0; $y < $h; $y++){
    for(my $x = 0; $x < $w; $x++){
        if($in_loop_idx < scalar(@in_loop) && $x == $in_loop_elem->[0] and $y == $in_loop_elem->[1]){
            $in_loop_elem = $in_loop[++$in_loop_idx];
        }
        else {
            my $p_ref = get_coord($x, $y);
            $p_ref->{data} = '.';
        }
        if(get_coord($x, $y)->{data} eq '.'){
            my $tx = $x == $w-1 ? 2*$x-1 : 2*$x;
            my $ty = $x == $h-1 ? 2*$x-1 : 2*$y;
            push @starting_points, [$tx, $ty]; 
            push @edge_points, [$tx, $ty] if($x == 0 || $x == $w-1 || $y == 0 || $y == $h-1);
        }
    }
}

sub insert_inbetween_tile{
    my($x, $y, $right) = @_;
    my $val = get_coord($x, $y)->{data};
    return 0 if $val eq '.';

    my @current_dirs = get_directions($x, $y);
    return 1 if (grep { $_ == $right } @current_dirs);
    return 0;
}

sub make_tile {
    my $val = shift;
    return { data => $val,
        visited => 0,
        outside => 0 };
}

#Modify the map - effectively create tiles for all in-between points, to
#signify that we may move in-between pipes
#We differentiate between inserted space "," and pre-existing space "."

say "Making new map...";
my @newmap = ();
for(my $y = 0; $y < $h; $y++){
    my @row = ();
    my @row2 = ();
    for(my $x = 0; $x < $w - 1; $x++){
        my $val = get_coord($x, $y)->{data};
        push @row, make_tile($val);
        push @row, make_tile(insert_inbetween_tile($x, $y, $RIGHT) ? '-' : ',');

        push @row2, make_tile(insert_inbetween_tile($x, $y, $DOWN) ? '|' : ',');
        push @row2, make_tile(',');
    }

    push @row, make_tile(get_coord($w-1, $y)->{data});
    push @row2, make_tile(",");

    push @newmap, \@row;
    push @newmap, \@row2 if $y < $h - 1;
}


@data = @newmap;

$w = scalar @{$newmap[0]};
$h = scalar @newmap;

say "Beginning Search...";
my $visited = 0;
sub visit_edge {
    my ($x, $y) = @_;
    return if get_coord(@_)->{visited};
    get_coord($x, $y)->{visited} = 1;
    get_coord($x, $y)->{outside} = 1;

    $visited++ if get_coord($x, $y)->{data} eq '.';
    get_coord($x, $y)->{data} = 'O';

    foreach(@allOffsets){
        my ($ox, $oy) = @$_;
        my ($nx, $ny) = ($x + $ox, $y + $oy);
        next if not valid_coord($nx, $ny);
        my $val = get_coord($nx, $ny)->{data};
        next if ($val ne '.' and $val ne ','); 
        visit_edge($nx, $ny);
    }
}

foreach my $pt (@edge_points){
    visit_edge(@$pt);
}

say ((scalar @starting_points) - $visited);



