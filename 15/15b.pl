use strict;
use warnings;
use v5.34;

my @strings = split(',', <>);

my @boxes = ();
push @boxes, [] foreach(0..255);

foreach(@strings){
    /(\w+)[\-\=](\d*)/;
    my($label, $value) = ($1, $2);
    my $box = $boxes[hash($label)];
    if($2){
        my $exists = 0;
        #Check if label is already in box.
        foreach(@$box){
           if($_->{label} eq $label){
                $_->{value} = $value;
                $exists = 1;
                last;
           }
        }
        
        push @$box, {
            label => $label,
            value => $value
        } if not $exists;

    }
    else {
        #Delete from queue, if it exists.
        my $index = 0;
        $index++ until (not defined @$box[$index] or @$box[$index]->{label} eq $label);
        splice(@$box, $index, 1) if $index < scalar @$box;
    }
}

my $sum = 0;
while(my($box_id, $b) = each(@boxes)){
    while(my($slot_id, $slot) = each(@$b)) {
        $sum += ($box_id+1) * ($slot_id+1) * $slot->{value}; 
    }
}
say $sum;

sub hash {
    my $s = shift;
    my $sum = 0;
    foreach(split(//, $s)) {
        $sum += ord($_);
        $sum *= 17; $sum %= 256;
    }
    return $sum;
}

