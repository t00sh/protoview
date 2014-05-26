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

package pkt_ipv6;

# Parse the IPv6 packet
sub parse {
    my ($this, $ref) = @_;
    my $dword1;
    
    ($dword1,
     $$ref->{payload_len},
     $$ref->{next_header},
     $$ref->{hop_limit})
	= unpack('NnCC', $this->{raw});

    $$ref->{src}  = substr($this->{raw}, 8, 24);
    $$ref->{dst}  = substr($this->{raw}, 24, 40);
    $$ref->{data} = substr($this->{raw}, 40);

    $$ref->{version}      = $dword1 >> 28;
    $$ref->{trafic_class} = ($dword1 >> 20) & 0xFF;
    $$ref->{flow_label}   = $dword1 & 0xFFF;
    $$ref->{src} = _inet_ntoa($$ref->{src});
    $$ref->{dst} = _inet_ntoa($$ref->{dst});
    $this->{raw} = $$ref->{data};
}

# Convert 128bits IPv6 into dotted notation
sub _inet_ntoa {
    my $addr = shift;

    return join(':', map ({ sprintf "%04x", $_} unpack('n[8]', $addr)));
}

1;
