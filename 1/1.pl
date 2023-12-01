use strict; 
use warnings;

open(FH, '<', '1.txt');
my $sum = 0;
while(<FH>){
    my @nums = $_ =~ /(\d)/g;
    my $number = 10*$nums[0] + $nums[-1];
    $sum += $number;
}
close(FH);
print "The sum is $sum \n";
