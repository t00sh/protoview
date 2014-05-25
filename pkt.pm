package pkt;

# Standard modules
use strict;
use warnings;

# Protoview modules
use protocols;

# Pkt constructor
sub new {
    my ($class, $raw) = @_;
    my $this = {};

    bless($this, $class);

    $this->{len} = length($raw);

    $this->{raw} = $raw;

    # TODO: handle overs L2 protocols
    $this->parse('ETHERNET', \$this->{ETHERNET});

    return $this;
}

# Parse recursivly the packet
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

# Get the packet len (in bytes)
sub get_len {
    return $_[0]->{len};
}

1;


