package pkt_eth;

use Data::Dumper;
use Data::HexDump;

# Parse the ethernet packet
sub parse {
    my ($this, $ref) = @_;

    $$ref->{dst}   = substr($this->{raw}, 0 , 6);
    $$ref->{src}   = substr($this->{raw}, 6, 12);
    $$ref->{proto} = substr($this->{raw}, 12, 14);
    $$ref->{data}  = substr($this->{raw}, 14);

    ($$ref->{proto}) = unpack('n', $$ref->{proto});
    $$ref->{dst} = _inet_ntoa($$ref->{dst});
    $$ref->{src} = _inet_ntoa($$ref->{src});
    
    $this->{raw} = $$ref->{data};
}

sub _inet_ntoa {
    my $addr = shift;

    return join(':', map ({ sprintf "%02x", $_} unpack('C[6]', $addr)));
}

1;
