package pkt_ipv6;

# Parse the IPv6 packet
sub parse {
    my ($this, $ref) = @_;
    my $dword1;
    
    ($dword1,
     $$ref->{payload_len},
     $$ref->{next_header},
     $$ref->{hop_limit})
	= unpack('NnCC', $this->{raw});

    $$ref->{src}  = substr($this->{raw}, 8, 24);
    $$ref->{dst}  = substr($this->{raw}, 24, 40);
    $$ref->{data} = substr($this->{raw}, 40);

    $$ref->{version}      = $dword1 >> 28;
    $$ref->{trafic_class} = ($dword1 >> 20) & 0xFF;
    $$ref->{flow_label}   = $dword1 & 0xFFF;
    $$ref->{src} = _inet_ntoa($$ref->{src});
    $$ref->{dst} = _inet_ntoa($$ref->{dst});
    $this->{raw} = $$ref->{data};
}

# Convert 128bits IPv6 into dotted notation
sub _inet_ntoa {
    my $addr = shift;

    return join(':', map ({ sprintf "%04x", $_} unpack('n[8]', $addr)));
}

1;
