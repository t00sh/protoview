package pkt_eth;

use Data::Dumper;
use Data::HexDump;

# Parse the ethernet packet
sub parse {
    my ($this, $ref) = @_;

    ($$ref->{dst}, 
     $$ref->{src}, 
     $$ref->{proto},
     $$ref->{data}) = unpack('H12H12na*', $this->{raw});    

    $this->{raw} = $$ref->{data};
}

1;
