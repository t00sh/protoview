package pkt_ipv4;

# Parse the IPv4 packet
sub parse {
    my ($this, $ref) = @_;
    my ($ver_ihl, $dscp_ecn, $flags_fragoff);
    
    ($ver_ihl,
     $dscp_ecn,
     $$ref->{tot_len},
     $$ref->{ident},
     $flags_fragoff,
     $$ref->{ttl},
     $$ref->{proto},
     $$ref->{checksum},
     $$ref->{src},
     $$ref->{dst})
	= unpack('CCnnnCCnNN', $this->{raw});


    $$ref->{version} = $ver_ihl >> 4;
    $$ref->{ihl} = $ver_ihl & 0xf;
    $$ref->{flags} = $flags_fragoff >> 13;
    $$ref->{frag_off} = $flags_fragoff & 0x1FFF;
    $$ref->{src} = _inet_ntoa($$ref->{src});
    $$ref->{dst} = _inet_ntoa($$ref->{dst});
    $$ref->{options} = substr($this->{raw}, 20, $this->{ihl}*4);
    $this->{raw} = substr($this->{raw}, $this->{ihl}*4);
}

# Convert 32bits IPv4 into dotted notation
sub _inet_ntoa {
    my $int = shift;

    return join('.', unpack('CCCC', pack('N', $int)));
}

1;
