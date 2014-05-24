package stats;

use strict;
use warnings;

use protocols;
use stats_eth;
use stats_ipv4;

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

    $this->inc_tot_pkt;
    $this->inc_tot_bytes($pkt->get_len);

    foreach my $p(keys %{$protocols::list}) {
	if(exists $pkt->{$p}) {
	    $protocols::list->{$p}->{update}($this, $pkt);
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
    return $this->get_tot_pkt/$this->get_elapsed_time;
}

sub get_tot_pkt {
    return $_[0]->{_tot_pkt};
}

sub get_tot_bytes {
    return $_[0]->{_tot_bytes};
}

sub get_bits_per_sec {
    my $this = shift;

    return 0 unless $this->get_elapsed_time;
    return ($this->get_tot_bytes*8)/$this->get_elapsed_time;
}

sub get_bytes_per_pkt {
    my $this = shift;

    return 0 unless $this->get_tot_pkt;
    return $this->get_tot_bytes / $this->get_tot_pkt;
}

1;
