use strict;
use warnings;
use v5.30;
use Storable qw(dclone);
my @maps = ();

<> =~ /seeds: (.*)/;
my @seeds = split ' ', $1;
my @tmp = @{dclone(\@seeds)};


while(<>) {
    my $line = $_;
    if($line =~ /\d/) {
        my ($dest, $src, $len) = split ' ', $line; 
        my $i = -1;
        foreach my $val (@tmp){
            $i++;
            #Check that we are in range, and that we have not already overwritten it.
            if(($val >= $src && $val < $src + $len) && $tmp[$i] == $seeds[$i]) {
                $tmp[$i] = ($dest + $val - $src);
            }
        }
    }
    elsif($line =~ /\w/){
        @seeds = @tmp;
        @tmp = @{dclone(\@seeds)};
        say join ", ", @seeds;
    }
}

@seeds = @tmp;
say join ", ", @seeds;

my $min = $seeds[0];
foreach(@seeds){
    $min = $_ if ($_ < $min);
}
say "Min: $min";
