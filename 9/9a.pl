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
    my @last_values = ($input[-1]);
    while((any { $_ != 0 } @input)){
        my @new = (); 
        for(my $i = 0; $i < scalar @input - 1; $i++){
            push @new, $input[$i+1]-$input[$i];
        }
        push @last_values, $new[-1];
        @input = @{dclone(\@new)};
    }
    $out += sum(@last_values) if scalar @input > 0;
}
say $out;
