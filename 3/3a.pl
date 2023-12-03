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
foreach (@lines) {
    $y++; 
    while($_ =~ /(\d+)/g){
        $sum += $1 if(find_adjacent_symbol($y, $-[1], $+[1]));
    }

}

print $sum . "\n";

sub find_adjacent_symbol {
    my ($y, $li, $ri) = @_;
    return 1 if $y > 0  and check_adjacent_line($lines[$y-1], $li, $ri);
    return 1 if $y < $h-1 and check_adjacent_line($lines[$y+1], $li, $ri);
    return 1 if $li > 0 and substr($lines[$y], $li-1, 1) ne '.';
    return 1 if $ri <= $w-1 and substr($lines[$y], $ri, 1) ne '.';
    return 0;
}

sub check_adjacent_line {
    my ($line, $li, $ri) = @_;
    my $length = $ri-$li;
    $length += 1 if $li > 0;
    $length += 1 if $ri < $h -1;
    return substr($line, $li > 0 ? $li -1 : 0, $length) =~ /[^\.]/;
}

