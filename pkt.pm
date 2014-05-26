############################################################################
# This file is part of protoview.					   #
# 									   #
# Protoview is free software: you can redistribute it and/or modify	   #
# it under the terms of the GNU General Public License as published by     #
# the Free Software Foundation, either version 3 of the License, or	   #
# (at your option) any later version.				           #
# 									   #
# Protoview is distributed in the hope that it will be useful,  	   #
# but WITHOUT ANY WARRANTY; without even the implied warranty of	   #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the	           #
# GNU General Public License for more details.			           #
# 									   #
# You should have received a copy of the GNU General Public License	   #
# along with Protoview.  If not, see <http://www.gnu.org/licenses/>	   #
# 									   #
# Tosh (duretsimon73 -at- gmail -dot- com)				   #
# - 2014 -								   #
#                                                                          #
############################################################################

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


