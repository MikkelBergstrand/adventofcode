use strict;
use warnings;

my @lines = ();
while(<>){
    chomp $_;
    push @lines, $_;
}

my $w = length $lines[0];
my $h = scalar @lines;

my $y = -1;
my $sum = 0;

my %foundPositions = ();

foreach (@lines) {
    $y++; 
    while($_ =~ /(\d+)/g){
        my $pos = find_adjacent_symbol($y, $-[1], $+[1]);
        if (defined $pos) {
            if (exists $foundPositions{$pos}) {
               $sum +=  $1 * $foundPositions{$pos};
            }
            else {
                $foundPositions{$pos} = $1;
            }
        }
    }
}
print $sum . "\n";

sub find_adjacent_symbol {
    my ($y, $li, $ri) = @_;
    if($y > 0) {
        my $val = check_adjacent_line($y-1, $li, $ri) ;
        return $val if $val;
    }    
    if($y < $h - 1) {
        my $val = check_adjacent_line($y+1, $li, $ri); 
        return $val if $val;
    }
    return $li-1 + $y*$w if $li > 0 and substr($lines[$y], $li-1, 1) eq '*';
    return $ri   + $y*$w if $ri <= $w-1 and substr($lines[$y], $ri, 1) eq '*';

    return;
}

sub check_adjacent_line {
    my ($y, $li, $ri) = @_;
    my $line = $lines[$y];

    my $length = $ri-$li;
    $length += 1 if $li > 0;
    $length += 1 if $ri < $w-1;

    $li = $li > 0 ? $li - 1 : 0;
    if(substr($line, $li, $length) =~ /(\*)/) {
        return $li + $-[1] + $y*$w;
    }
}

