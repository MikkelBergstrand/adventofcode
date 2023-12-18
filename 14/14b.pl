use strict;
use warnings;
use v5.34;
use Storable qw(dclone);

my @map = ();

my $perspective = 0;
my ($NORTH, $WEST, $SOUTH, $EAST) = (0, 1, 2, 3);

my $w;
sub transform_coords {
    my ($x, $y) = @_;
    $y = $w - 1 - $y if ($perspective == $EAST || $perspective == $SOUTH);
    if($perspective == $WEST || $perspective == $EAST){
        my $tmp = $x;
        $x = $y;
        $y = $tmp;
    }
    return ($x, $y);
}
sub read_map {
    my ($x, $y) = transform_coords(@_); 
    return $map[$y]->[$x];
}

sub write_map {
    my ($x, $y, $val) = @_;
    ($x, $y) = transform_coords($x, $y);
    $map[$y]->[$x] = $val;
}

sub print_map {
    foreach(@map){
        say @$_;
    }
}

sub map_copy {
    my @map = @_;
    my @new = ();
    foreach(@map) {
       push @new, dclone(\@$_); 
    }
    return @new;
}



while(<>){
    chomp $_;
    my @row = split //, $_;
    push @map, \@row;
}

my $h = scalar @map;
$w = scalar @{$map[0]};

my $load  = 0;
my $oldLoad = 0;
my @last8Nums = ();

my $terminationIndex = 0; 
for(my $i = 0; ; $i++) {
    $perspective = $i % 4;
    
    if($perspective == 0) {
        $oldLoad = $load; 
        push @last8Nums, $oldLoad;
        $terminationIndex = $i;
        last if (scalar @last8Nums > 7 and (shift @last8Nums) == $oldLoad); 
    }

    $load = 0;
    for(my $y = 0; $y < $h; $y++){
        for(my $x = 0; $x < $w; $x++){
            if(read_map($x, $y) eq 'O'){
                my $lowestY = $y;
                $lowestY-- while($lowestY > 0 && read_map($x, $lowestY-1) eq '.');

                if($y != $lowestY) {
                    write_map($x, $y, '.');
                    write_map($x, $lowestY, 'O');
                } 
            my ($tx, $ty) = transform_coords($x, $lowestY);
            $load += ($h-$ty);
        }
    }
}

say "$i $load" if $perspective == 3;
}
say $oldLoad;
my $index = ($terminationIndex)/4;
foreach(@last8Nums){
    say "$index $_"; 
    $index++;
}
say @last8Nums; 

