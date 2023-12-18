use strict;
use warnings;
use v5.34;

my @map = ();

sub read_map {
    my ($x, $y) = @_;
    return $map[$y]->[$x];
}

sub write_map {
    my ($x, $y, $val) = @_;
    $map[$y]->[$x] = $val;
}

sub print_map {
    foreach(@map){
        say @$_;
    }
}

while(<>){
    chomp $_;
    my @row = split //, $_;
    push @map, \@row;
}

my $h = scalar @map;
my $w = scalar @{$map[0]};

my $weightSum = 0;
for(my $y = 0; $y < $h; $y++){
    for(my $x = 0; $x < $w; $x++){
        if(read_map($x, $y) eq 'O'){
            my $lowestY = $y;
            $lowestY-- while($lowestY > 0 && read_map($x, $lowestY-1) eq '.');
            write_map($x, $y, '.');
            write_map($x, $lowestY, 'O');
            $weightSum += ($h-$lowestY);
                           
        }
    }
}

print_map();
say $weightSum;
say $w;


