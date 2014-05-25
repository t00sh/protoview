package stats;

use strict;
use warnings;

use protocols;
use stats_eth;
use stats_ipv4;
use format;

sub new {
    my $class = shift;
    my $this = {};

    bless($this, $class);

    $this->{_tot_bytes} = 0;
    $this->{_tot_pkt} = 0;
    $this->{_timestamp} = time;

    return $this;
}

sub add_pkt {
    my ($this, $pkt) = @_;
    my $cur_ref = \$this;

    $this->inc_tot_pkt;
    $this->inc_tot_bytes($pkt->get_len);

    foreach my $ref(@{$pkt->{PROTO_REFS}}) {
	$cur_ref = \$$cur_ref->{$ref->[0]};

	if(exists $protocols::list->{$ref->[0]}) {
	    $protocols::list->{$ref->[0]}->{update}($cur_ref, $ref->[1]);
	}
    }
}

sub inc_tot_pkt {
    my $this = shift;

    $this->{_tot_pkt}++;
}

sub inc_tot_bytes {
    my ($this, $bytes) = @_;

    $this->{_tot_bytes} += $bytes;
}

sub get_elapsed_time {
    return time - $_[0]->{_timestamp};
}

sub get_pkt_per_sec {
    my $this = shift;

    return 0 unless $this->get_elapsed_time;
    return sprintf "%.2f", $this->get_tot_pkt/$this->get_elapsed_time;
}

sub get_tot_pkt {
    return $_[0]->{_tot_pkt};
}

sub get_tot_bytes {
    return $_[0]->{_tot_bytes};
}

sub get_kbits_per_sec {
    my $this = shift;

    return 0 unless $this->get_elapsed_time;
    return sprintf "%.2f", (($this->get_tot_bytes*8)/$this->get_elapsed_time)/1000;
}

sub get_bytes_per_pkt {
    my $this = shift;

    return 0 unless $this->get_tot_pkt;
    return sprintf "%.2f", $this->get_tot_bytes / $this->get_tot_pkt;
}

sub build_lines {
    my $this = shift;
    my @lines;
    my $i = 0;

    $lines[$i++] = "++ INFOS";
    $lines[$i++] = format::line("   Packets captured",  $this->get_tot_pkt);
    $lines[$i++] = format::line("   Packets/sec",  $this->get_pkt_per_sec);
    $lines[$i++] = format::line("   Kb/sec.", $this->get_kbits_per_sec);
    $lines[$i++] = format::line("   bytes/packet", $this->get_bytes_per_pkt);
    $lines[$i++] = format::line("   Elapsed secondes", $this->get_elapsed_time);
    $lines[$i++] = ' ';

    _build_lines_rec(\$this, 0, \@lines, \$i);

    return \@lines;

}

sub _build_lines_rec {
    my ($ref, $spaces, $lines, $i) = @_;

    foreach my $k(keys %{$$ref}) {
	if($k =~ m/^[A-Z0-9]+$/) {
	    if(exists $protocols::list->{$k}) {
		$lines->[$$i++] = '+'x$spaces . "++ $k";
		$protocols::list->{$k}->{build_lines}(\$$ref->{$k}, $spaces, $lines, $i);
	    }
	    _build_lines_rec(\$$ref->{$k}, $spaces + 3, $lines, $i);
	}
    }
}

1;
