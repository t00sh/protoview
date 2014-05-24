package pkt_eth;

use constant {
    ETH_PROTO_IPV4 => 0x0800,
    ETH_PROTO_IPV6 => 0x86DD,
    ETH_PROTO_ARP  => 0x0806,
    ETH_PROTO_RARP => 0x8035,	
};


use Data::Dumper;
use Data::HexDump;

sub parse {
    my ($this) = @_;

    ($this->{ETHERNET}{_dst}, 
     $this->{ETHERNET}{_src}, 
     $this->{ETHERNET}{_proto},
     $this->{ETHERNET}{_data}) = unpack('H12H12na*', $this->{_raw});    

    $this->{_raw} = $this->{ETHERNET}{_data};
}

1;
