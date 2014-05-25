package stats_eth;

use format;

use constant {
    ETH_PROTO_IPV4 => 0x0800,
    ETH_PROTO_IPV6 => 0x86DD,
    ETH_PROTO_ARP  => 0x0806,
    ETH_PROTO_RARP => 0x8035,	
};

# This function is called for every ETHERNET packet
# Update stats object
sub update {
    my ($stats_ref, $pkt_ref) = @_;

    $$stats_ref->{tot}++;
    $$stats_ref->{src}{$$pkt_ref->{src}}++;
    $$stats_ref->{dst}{$$pkt_ref->{dst}}++;
    $$stats_ref->{proto}{$$pkt_ref->{proto}}++;
}

# Build the lines for the displayer
sub build_lines {
    my ($ref, $spaces, $lines, $i) = @_;

    $lines->[$$i++] = format::line(' 'x$spaces . "   Total packets", $$ref->{tot});

    foreach my $p(keys %{$$ref->{proto}}) {
	$lines->[$$i++] = format::line(' 'x$spaces . "   Proto:$p", $$ref->{proto}{$p});
    }

    $lines->[$$i++] = ' ';
}

1;
