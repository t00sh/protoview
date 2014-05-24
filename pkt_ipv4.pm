package pkt_ipv4;

sub parse {
    my ($this) = @_;
    my ($ver_ihl, $dscp_ecn, $flags_fragoff);
    
    ($ver_ihl,
     $dscp_ecn,
     $this->{IPV4}{tot_len},
     $this->{IPV4}{ident},
     $flags_fragoff,
     $this->{IPV4}{ttl},
     $this->{IPV4}{proto},
     $this->{IPV4}{checksum},
     $this->{IPV4}{src},
     $this->{IPV4}{dst})
	= unpack('CCnnnCCnNN', $this->{_raw});


    $this->{IPV4}{version} = $ver_ihl >> 4;
    $this->{IPV4}{ihl} = $ver_ihl & 0xf;
    $this->{IPV4}{flags} = $flags_fragoff >> 13;
    $this->{IPV4}{frag_off} = $flags_fragoff & 0x1FFF;
    $this->{IPV4}{src} = _inet_ntoa($this->{IPV4}{src});
    $this->{IPV4}{dst} = _inet_ntoa($this->{IPV4}{dst});
    $this->{IPV4}{options} = substr($this->{_raw}, 20, $this->{ihl}*4);
    $this->{_raw} = substr($this->{_raw}, $this->{ihl}*4);

}

sub _inet_ntoa {
    my $int = shift;

    return join('.', unpack('CCCC', pack('N', $int)));
}

1;
