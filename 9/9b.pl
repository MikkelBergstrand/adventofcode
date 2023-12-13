use strict;
use warnings;
use v5.30;
use List::Util qw(sum  any);
use Storable qw(dclone);

my @inputs = ();

while(<>){
    my @input = split ' ', $_;
    push @inputs, \@input;
}

my $out = 0;
foreach(@inputs) {
    my @input = @$_;
    my @first_values = ($input[0]);
    while((any { $_ != 0 } @input)){
        my @new = (); 
        for(my $i = 0; $i < scalar @input - 1; $i++){
            push @new, $input[$i+1]-$input[$i];
        }
        push @first_values, $new[0];
        @input = @{dclone(\@new)};
    }

    my @left_adds = ();
    $left_adds[scalar @first_values -1] = 0;
    for(my $i = (scalar @first_values - 2); $i >= 0; $i--){
       $left_adds[$i] = $first_values[$i] - $left_adds[$i+1];
    }
    $out += $left_adds[0];
}
say $out;
