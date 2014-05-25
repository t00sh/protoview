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
    my ($this, $ref) = @_;

    ($$ref->{dst}, 
     $$ref->{src}, 
     $$ref->{proto},
     $$ref->{data}) = unpack('H12H12na*', $this->{raw});    

    $this->{raw} = $$ref->{data};
}

1;


# ++ INFOS
#    Packets captured   61043
#    Packets/sec        26.4943576388889
#    Kb/sec.            29.9714756944444
#    bytes/packet       141.404993201514
#    Elapsed secondes   2304


# ++++ ETHERNET
#      Packets          1212
#      src: 52:12:10:12:52:42   5 
#      src: 52:12:10:12:52:41   5 
#      dst: 52:12:10:12:52:42   5 
#      dst: 52:12:10:12:52:41   5 
#      proto: IPV4              10
#      proto: ARP               21
#      proto: IPV6              54

# ++++++ IPV4    
#        Packets                151
#        src: 10.0.8.1          51
#        dst: 52.45.85.1        300
#        proto: tcp             51

# ++++++++ TCP
#          ??????????????????
#          ??????????????????

# ++++++ IPV6
#        ????????????????????
#        ????????????????????

# ++++++++ TCP
#          ???????????????????


#     stats = {INFOS => {},
# 	     PROTOS => [ETHERNET => {IPV4 => {TCP => {}}}]

