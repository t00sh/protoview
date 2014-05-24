package pkt;

use strict;
use warnings;

use protocols;

sub new {
    my ($class, $raw) = @_;
    my $this = {};

    bless($this, $class);

    $this->{_len} = length($raw);
    $this->pkt_eth::parse;

    $this->{_raw} = $raw;
    $this->parse('ETHERNET');

    return $this;
}

sub parse {
    my ($this, $proto) = @_;

    $protocols::list->{$proto}->{parser}($this);

    foreach my $p(keys %{$protocols::list}) {
	if(defined $protocols::list->{$p}->{from}) {
	    if($protocols::list->{$p}->{from} eq $proto) {
		my $field = $protocols::list->{$p}->{field}->[0];
		my $value = $protocols::list->{$p}->{field}->[1];

		if($this->{$proto}{$field} == $value) {
		    $this->parse($p);
		}
	    }
	}
    }
}

sub get_len {
    return $_[0]->{_len};
}

1;


