use strict;
use warnings;
use v5.30;
use List::Util qw(sum);

my @patterns = ();
my $sum = 0;
while(<>) {
    if(/^$/) {
        $sum += handle_pattern(@patterns);
        @patterns = ();
    }
    else {
        chomp $_;
        push @patterns, $_;
    }
}

$sum += handle_pattern(@patterns);

say $sum;
sub handle_pattern {
    my @patternRows = @_;
    my @patternColumns = ();


    while(my($i, $patternRow) = each(@patternRows)){
        my @patternArr = split //, $patternRow; 
        while(my($j, $patternSymbol) = each(@patternArr)){
            $patternColumns[$j] = ($patternColumns[$j] // "") . $patternArr[$j]; 
        }
    }

    my @rowPairs = (grep { test_if_mirrored($_, @patternRows) } (find_identical_pairs(@patternRows)));
    my @colPairs = (grep { test_if_mirrored($_, @patternColumns) } (find_identical_pairs(@patternColumns)));

    return ((sum(@rowPairs)//0)*100 + (sum(@colPairs)//0));
}

#Returns the upper index of matching pattern pairs. 
sub find_identical_pairs {
   my @patterns = @_; 
   my @ret = ();
   for(my $i = 0; $i < scalar @patterns - 1; $i++){
       if($patterns[$i] eq $patterns[$i+1]) {
           push @ret, $i+1;
       }
   }
   return @ret;
}

sub test_if_mirrored{
    my($idx, @patterns) = @_;
    my $len = scalar @patterns;
    
    my $lower = $idx-2; #Say rows 4,5 match. Then $idx=5. Then the next we should test are 3,6
    my $upper = $idx+1; 
    while(1){
        return 1 if($lower < 0 or $upper >= $len); #Out of bounds: hence valid.
        return 0 if $patterns[$lower] ne $patterns[$upper];

        $lower--; $upper++;
    }
    return 1;
}
