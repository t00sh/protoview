package stats_ipv4;

use format;
use misc;

use constant {
    IPV4_PROTO_ICMP => 1,
    IPV4_PROTO_IGMP => 2,
    IPV4_PROTO_TCP  => 6,
    IPV4_PROTO_UDP  => 17,
};

# Called for every IPv4 packet
# Update the stats Object
sub update {
    my ($stats_ref, $pkt_ref) = @_;

    $$stats_ref->{tot}++;
    $$stats_ref->{src}{$$pkt_ref->{src}}++;
    $$stats_ref->{dst}{$$pkt_ref->{dst}}++;
    $$stats_ref->{have_options}++ if($$pkt_ref->{options});
    $$stats_ref->{proto}{$$pkt_ref->{proto}}++;
#    $$stats_ref->{ttl}{$$pkt_ref->{ttl}}++;
#    $$stats_ref->{tot_len} += $$pkt_ref->{tot_len};

}

# Build lines for the displayer
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

    return 'icmp' if($proto == IPV4_PROTO_ICMP);
    return 'igmp' if($proto == IPV4_PROTO_IGMP);
    return 'tcp' if($proto == IPV4_PROTO_TCP);
    return 'udp' if($proto == IPV4_PROTO_UDP);

    return $proto;
}

1;
