use strict;
use warnings; 
use v5.34;
use Storable qw(dclone);
my @data;

my $sum = 0;
my $endHash = -1;
while(<>){
    /(.+) (.+)/;
    @data = split //, $1;
    my @arrangements = split ",", $2;
     
    for(my $i = scalar(@data) - 1; $i >= 0; $i--) {
       $endHash = $i;
       last if $data[$i] eq "#"; 
    }
    say join ",", @arrangements;

    my $val = do_arrangement(0, \@arrangements, 0);
    say $val;
    $sum += $val;
}    

say $sum;
sub do_arrangement {
    my ($idx, $i, $count) = @_;
    my $n = scalar(@data);
    my @arrangements = @$i;
    for(; $idx < $n; $idx++){
        my $s = $data[$idx];
        $count++ if $s eq '#';

        if($s eq '.' && $count > 0) {
            my $val = shift @arrangements;
            return 0 if not $val or $val != $count; #Invalid range
            if(defined $val && $val == $count && !scalar(@arrangements) && $idx >= $endHash) {
                return 1;
            }
            $count = 0;
        }
        if($s eq '?') {
            $data[$idx] = "#";
            my $ret = do_arrangement($idx, dclone(\@arrangements), $count); #We place another #
            $data[$idx] = ".";
            $ret += do_arrangement($idx, dclone(\@arrangements), $count); #We place another .
            $data[$idx] = "?";
            return $ret;
        }
    }
    
    if($count > 0){
        my $last = shift @arrangements; 
        if($last && $last == $count && not scalar(@arrangements)) {
           return 1;
        }
    }
    return 0;
}
