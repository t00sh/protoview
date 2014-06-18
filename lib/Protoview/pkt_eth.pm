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
# Tosh (tosh -at- t0x0sh -dot- org)        				   #
# - 2014 -								   #
#                                                                          #
############################################################################

package pkt_eth;

use strict;
use warnings;

# Parse the ethernet packet
sub parse {
    my ($this, $ref) = @_;

    $$ref->{dst}   = substr($this->{raw}, 0 , 6);
    $$ref->{src}   = substr($this->{raw}, 6, 12);
    $$ref->{proto} = substr($this->{raw}, 12, 14);
    $$ref->{data}  = substr($this->{raw}, 14);

    ($$ref->{proto}) = unpack('n', $$ref->{proto});
    $$ref->{dst} = _inet_ntoa($$ref->{dst});
    $$ref->{src} = _inet_ntoa($$ref->{src});
    
    $this->{raw} = $$ref->{data};
}

sub _inet_ntoa {
    my $addr = shift;

    return join(':', map ({ sprintf "%02x", $_} unpack('C[6]', $addr)));
}

1;
