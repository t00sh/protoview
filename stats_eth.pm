package stats_eth;

use format;
use misc;

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
    my @keys;

    $lines->[$$i++] = format::line(' 'x$spaces . "   Total packets", $$ref->{tot});

    $lines->[$$i++] = ' ';

    @keys = sort {$$ref->{proto}{$b} <=> $$ref->{proto}{$a}} keys %{$$ref->{proto}};
    foreach my $p(@keys) {
	$lines->[$$i++] = format::line(' 'x$spaces . "   Proto:" . _proto_to_str($p), 
				       $$ref->{proto}{$p} . ' (' . percentage($$ref->{proto}{$p}, $$ref->{tot}) . '%)');
    }

    $lines->[$$i++] = ' ';

    @keys = sort {$$ref->{src}{$b} <=> $$ref->{src}{$a}} keys %{$$ref->{src}};
    foreach my $p(@keys) {
	$lines->[$$i++] = format::line(' 'x$spaces . "   Src:$p", 
				       $$ref->{src}{$p} . ' (' . percentage($$ref->{src}{$p}, $$ref->{tot}) . '%)');
    }

    $lines->[$$i++] = ' ';

    @keys = sort {$$ref->{dst}{$b} <=> $$ref->{dst}{$a}} keys %{$$ref->{dst}};
    foreach my $p(@keys) {
	$lines->[$$i++] = format::line(' 'x$spaces . "   Dst:$p", 
				       $$ref->{dst}{$p} . ' (' . percentage($$ref->{dst}{$p}, $$ref->{tot}) . '%)');
    }

    $lines->[$$i++] = ' ';
}

sub _proto_to_str {
    my $proto = shift;

    return 'ipv4' if($proto == ETH_PROTO_IPV4);
    return 'ipv6' if($proto == ETH_PROTO_IPV6);
    return 'arp' if($proto == ETH_PROTO_ARP);
    return 'rarp' if($proto == ETH_PROTO_RARP);

    return $proto;
}

1;
