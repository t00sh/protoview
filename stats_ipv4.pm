package stats_ipv4;

use format;

# Called for every IPv4 packet
# Update the stats Object
sub update {
    my ($stats_ref, $pkt_ref) = @_;

    $$stats_ref->{tot}++;
    $$stats_ref->{src}{$$pkt_ref->{src}}++;
    $$stats_ref->{dst}{$$pkt_ref->{dst}}++;
    $$stats_ref->{have_options}++ if($$pkt_ref->{options});
    $$stats_ref->{proto}{$$pkt_ref->{proto}}++;
    $$stats_ref->{ttl}{$$pkt_ref->{ttl}}++;
    $$stats_ref->{tot_len} += $$pkt_ref->{tot_len};

}

# Build lines for the displayer
sub build_lines {
    my ($ref, $spaces, $lines, $i) = @_;

    $lines->[$$i++] = format::line(' 'x$spaces . "   Total packets", $$ref->{tot});
    $lines->[$$i++] = ' ';
}

1;
