use strict;
use warnings;
use v5.30;
use Storable qw(dclone);

#Read seed data
<> =~ /seeds: (.*)/;
my @seedData = split ' ', $1;
my @seedRanges = ();
while(scalar @seedData){
    my $start = shift @seedData;
    my $range = shift @seedData;

    push @seedRanges,[$start, $range];
}

@seedRanges = sort { $a->[0] <=> $b->[0] } @seedRanges;

my $current = $seedRanges[0]->[0]; #First seed.
my $last = $seedRanges[-1]->[0] + $seedRanges[-1]->[1] - 1;#Last seed.

#Forces a number into the defined seed range.
#Since seed ranges are sorted, thi is trivial
sub snap_to_seed {
    my $val = shift;
    foreach(@seedRanges) {
        my ($start, $len) = @{$_};
        return $start if $val < $start; #Skip to next range
        return $val if ($val >= $start && $val < $start + $len); #Already valid, so fine
    }
    return $last+1; #Out of seeds
}

#Returns the minimum, or one of the values if the other is undefined.
sub min {
    my ($a, $b) = @_;
    return $a if not defined $b;
    return $b if not defined $a;
    return $a < $b ? $a : $b;
}

#Construct data structure.
my @maps = ();
my @ranges = ();
while(<>) {
    my $line = $_;
    if($line =~ /\d/) {
        my ($dest, $src, $len) = split ' ', $line; 
        push @ranges, [$dest, $src, $len];

    }
    elsif($line =~ /\w/){
        push @maps, dclone(\@ranges);
        @ranges = ();
    }
}
push @maps, dclone(\@ranges);

#Sort each map by the source start index
foreach(@maps){
    @{$_} = sort { $a->[1] <=> $b->[1]; } @{$_};
}

my ($min, $val, $jump);
while($current <= $last){
    $val = $current; #value to be transformed by the maps

    #How much forward can we jump the next iteration
    #How far we can jump will be the smallest distance to the next range, 
    #or to the end of the current range.
    #This is because all ranges are sorted. 
    $jump = undef; 

    step: foreach (@maps) {
       my @ranges = @{$_};     
       foreach (@ranges) {
            my($dest, $src, $len) = @{$_};
            if($val < $src){ #We are outside any range.
                $jump = min($jump, $src - $val); 
                next step;
            }
            elsif($val >= $src && $val < $src + $len) { #We are in this range.
                $jump = min($jump, $src + $len - $val); 
                $val = $dest + $val - $src;  
                next step;
            }
       }
    }
    $min = $val if ((!$min || $val <= $min));
    $current = snap_to_seed($current + ($jump // 1));
}
say $min;
