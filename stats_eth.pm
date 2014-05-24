package stats_eth;

use Data::Dumper;

sub update {
    my ($this, $pkt) = @_;

    $this->{ETHERNET}{_tot}++;
    $this->{ETHERNET}{src}{$pkt->{ETHERNET}{_src}}++;
    $this->{ETHERNET}{dst}{$pkt->{ETHERNET}{_dst}}++;
    $this->{ETHERNET}{proto}{$pkt->{ETHERNET}{_proto}}++;
}

1;
