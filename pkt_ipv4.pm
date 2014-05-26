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

package pkt_ipv4;

# Parse the IPv4 packet
sub parse {
    my ($this, $ref) = @_;
    my ($ver_ihl, $dscp_ecn, $flags_fragoff);
    
    ($ver_ihl,
     $dscp_ecn,
     $$ref->{tot_len},
     $$ref->{ident},
     $flags_fragoff,
     $$ref->{ttl},
     $$ref->{proto},
     $$ref->{checksum},
     $$ref->{src},
     $$ref->{dst})
	= unpack('CCnnnCCnNN', $this->{raw});


    $$ref->{version} = $ver_ihl >> 4;
    $$ref->{ihl} = $ver_ihl & 0xf;
    $$ref->{flags} = $flags_fragoff >> 13;
    $$ref->{frag_off} = $flags_fragoff & 0x1FFF;
    $$ref->{src} = _inet_ntoa($$ref->{src});
    $$ref->{dst} = _inet_ntoa($$ref->{dst});
    $$ref->{options} = substr($this->{raw}, 20, $this->{ihl}*4);
    $this->{raw} = substr($this->{raw}, $this->{ihl}*4);
}

# Convert 32bits IPv4 into dotted notation
sub _inet_ntoa {
    my $int = shift;

    return join('.', unpack('CCCC', pack('N', $int)));
}

1;
