use strict; 
use warnings;

my %literals = (
    'one' => 1,
    'two' => 2, 
    'three' => 3,
    'four' => 4,
    'five' => 5,
    'six' => 6,
    'seven' => 7,
    'eight' => 8,
    'nine' => 9,
);

sub conv_to_num {
    my $input = $_[0];
    if (exists $literals{$input}) {
        return $literals{$input};
    }
    return int($input);
}

open(FH, '<', '1.txt');
my $sum = 0;
my $keyRegex = join("|", keys %literals);
print $keyRegex;
while(<FH>){
    my @nums = $_ =~ /(?=(\d|$keyRegex))/g;
    my $first = conv_to_num($nums[0]);
    my $last = conv_to_num($nums[-1]);
    $sum += $first*10 + $last;
}
close(FH);
print "The sum is $sum \n";
