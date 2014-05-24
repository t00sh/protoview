package stats_ipv4;

sub update {
    my ($this, $pkt) = @_;

    $this->{IPV4}{tot}++;
    $this->{IPV4}{src}{$pkt->{IPV4}{src}}++;
    $this->{IPV4}{dst}{$pkt->{IPV4}{dst}}++;
    $this->{IPV4}{have_options}++ if($pkt->{IPV4}{options});
    $this->{IPV4}{proto}{$pkt->{IPV4}{proto}}++;
    $this->{IPV4}{ttl}{$pkt->{IPV4}{ttl}}++;
    $this->{IPV4}{tot_len} += $pkt->{IPV4}{tot_len};

}

1;
