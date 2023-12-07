use strict; use warnings;
use v5.30;
use Storable qw(dclone);

my %values = (
    A => 14,
    K => 13,
    Q => 12,
    J => 11,
    T => 10
);

sub card_value {
    my $card = shift;
    return ($values{$card} // $card);
}

sub hand_type {
    my $hand = shift;
    my @cards = split //, $hand;
    
    my %counts = ();
    foreach(@cards){
        $counts{$_} = ($counts{$_} // 0) + 1;
    }
    
    my @sorted_counts = sort { $counts{$b} <=> $counts{$a} } keys %counts;
    my $largest_count = $counts{$sorted_counts[0]}; 

    my $unique_cards = scalar %counts;
    return 0 if $unique_cards == 5; #High card.
    return 1 if $unique_cards == 4 and $largest_count == 2; #One pair 
    return 2 if $unique_cards == 3 and $largest_count == 2; #Two pairs
    return 3 if $unique_cards == 3 and $largest_count == 3; #Three of a kind
    return 4 if $unique_cards == 2 and $largest_count == 3; #Full house
    return 5 if $unique_cards == 2 and $largest_count == 4; #Four of a kind
    return 6 if $unique_cards == 1;
    say "Error: could not deduce type $hand";
}

sub tie_break{
    my ($entryA, $entryB) = @_;

    my ($a, $b) = ($entryA->{'hand'}, $entryB->{hand});
    my @cardsA = split //, $a;
    my @cardsB = split //, $b;

    for(my $i = 0; $i < 5; $i++){
        my $cmp = card_value($cardsA[$i]) <=> card_value($cardsB[$i]);
        return $cmp if $cmp != 0; 
    }
    say "Error: could not tiebreak.";
}

my @entries = ();
while(<>){
    /(.*) (.*)/;

    my %input = (
        'hand' => $1,
        'bid' => $2,
        'type' => hand_type($1)
    );
    push @entries, dclone(\%input);
}

@entries = sort {
    $a->{type} <=> $b->{type} || tie_break($a, $b);
} @entries; 


my $sum = 0;
while(my ($i, $val) = each @entries){
    $sum += (($i + 1)* $val->{bid});
}

say $sum;
