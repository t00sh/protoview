package stats_eth;

use stats;
use format;

sub update {
    my ($stats_ref, $pkt_ref) = @_;

    $$stats_ref->{tot}++;
    $$stats_ref->{src}{$$pkt_ref->{src}}++;
    $$stats_ref->{dst}{$$pkt_ref->{dst}}++;
    $$stats_ref->{proto}{$$pkt_ref->{proto}}++;
}

sub build_lines {
    my ($ref, $spaces, $lines, $i) = @_;

    $lines->[$$i++] = format::line(' 'x$spaces . "   Total packets", $$ref->{tot});

    foreach my $p(keys %{$$ref->{proto}}) {
	$lines->[$$i++] = format::line(' 'x$spaces . "   Proto:$p", $$ref->{proto}{$p});
    }

    $lines->[$$i++] = ' ';
}

1;
