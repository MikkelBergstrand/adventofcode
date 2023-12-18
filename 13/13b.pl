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
    my @patternStrings = @_;
    my @patternColumns = ();
    my @patternRows = ();

    for(my $i = 0; $i < length($patternStrings[0]); $i++){
        push @patternColumns, [];
    }

    foreach(@patternStrings){
        my @patternArr = split //, $_;
        push @patternRows, \@patternArr;

        while(my($j, $patternSymbol) = each(@patternArr)){
            push @{$patternColumns[$j]}, $patternSymbol; 
        }
    }

    foreach(0..scalar(@patternRows)-2){
        return 100*($_+1) if (pattern_analysis($_, @patternRows));
    }
    foreach(0..scalar(@patternColumns)-2){
        return ($_+1) if (pattern_analysis($_, @patternColumns));
    }
    say "No conclusion";
}

sub pattern_analysis {
    my($idx, @patterns) = @_;
    my $len = scalar @patterns;

    my $lower = $idx; 
    my $upper = $idx+1; 
    my $cmp = 0;
    while($lower >= 0 and $upper < $len){
        $cmp += pattern_compare($patterns[$lower], $patterns[$upper]);
        return 0 if $cmp > 1; #Early exit
        $lower--; $upper++;
    }
    return $cmp == 1;
}

#Compare two patterns. Return 0 on equality, 1 if we have one excessive hash, 2 if we have more than one hash different.
sub pattern_compare {
    my($pa,$pb) = @_;
    my @a = @$pa; my @b = @$pb;

    my $hashesA = 0;
    my $hashesB = 0;
    for(my $i = 0; $i < scalar @a; $i++){
        $hashesA++ if($a[$i] eq "#" and $b[$i] eq ".");
        $hashesB++ if($a[$i] eq "." and $b[$i] eq "#");
        return 2 if $hashesA + $hashesB > 1;
    }
    return $hashesA || $hashesB;
}

