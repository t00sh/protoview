package pkt;

use strict;
use warnings;

use protocols;
use Data::Dumper;

sub new {
    my ($class, $raw) = @_;
    my $this = {};

    bless($this, $class);

    $this->{len} = length($raw);
    $this->pkt_eth::parse;

    $this->{raw} = $raw;
    $this->parse('ETHERNET', \$this->{ETHERNET});

    return $this;
}

sub parse {
    my ($this, $proto, $ref) = @_;

    push(@{$this->{PROTO_REFS}}, [$proto, $ref]);
    $protocols::list->{$proto}->{parser}($this, $ref);

    foreach my $p(keys %{$protocols::list}) {
	if(defined $protocols::list->{$p}->{from}) {
	    if($protocols::list->{$p}->{from} eq $proto) {
		my $field = $protocols::list->{$p}->{field}->[0];
		my $value = $protocols::list->{$p}->{field}->[1];

		if($$ref->{$field} == $value) {
		    $this->parse($p, \$$ref->{$p});
		}
	    }
	}
    }
}

sub get_len {
    return $_[0]->{len};
}

1;


