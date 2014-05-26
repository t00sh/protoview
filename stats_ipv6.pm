package stats_ipv6;

use format;
use misc;

use constant {
    IPV6_PROTO_ICMP   => 1,
    IPV6_PROTO_IGMP   => 2,
    IPV6_PROTO_TCP    => 6,
    IPV6_PROTO_UDP    => 17,
    IPV6_PROTO_ICMPV6 => 58,
};

# Called for every IPv6 packet
# Update the stats Object
sub update {
    my ($stats_ref, $pkt_ref) = @_;

    $$stats_ref->{tot}++;
    $$stats_ref->{src}{$$pkt_ref->{src}}++;
    $$stats_ref->{dst}{$$pkt_ref->{dst}}++;
    $$stats_ref->{next_header}{$$pkt_ref->{next_header}}++;
}

# Build lines for the displayer
sub build_lines {
    my ($ref, $spaces, $lines, $i) = @_;
    my @keys;

    $lines->[$$i++] = format::line(' 'x$spaces . "   Total packets", $$ref->{tot});

    $lines->[$$i++] = ' ';

    @keys = sort {$$ref->{next_header}{$b} <=> $$ref->{next_header}{$a}} keys %{$$ref->{next_header}};
    foreach my $p(@keys) {
	$lines->[$$i++] = format::line(' 'x$spaces . "   Proto:" . _proto_to_str($p), 
				       $$ref->{next_header}{$p} . ' (' . percentage($$ref->{next_header}{$p}, $$ref->{tot}) . '%)');
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

    return 'icmp' if($proto == IPV6_PROTO_ICMP);
    return 'igmp' if($proto == IPV6_PROTO_IGMP);
    return 'tcp' if($proto == IPV6_PROTO_TCP);
    return 'udp' if($proto == IPV6_PROTO_UDP);
    return 'icmpv6' if($proto == IPV6_PROTO_ICMPV6);

    return $proto;
}

1;
