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

package stats_icmpv6;

use strict;
use warnings;

use Protoview::format;
use Protoview::misc;

my %icmpv6_types = (
    1   => 'dst-unreachable',
    2   => 'pkt-too-big',
    3   => 'ttl-exceded',
    4   => 'param-problem',
    128 => 'echo-request',
    129 => 'echo-reply',
    130 => 'multicast-listener-query',
    131 => 'multicast-listener-report',
    132 => 'multicast-listener-done',
    133 => 'router-solicitation',
    134 => 'router-advertisment',
    135 => 'neighboor-solicitation',
    136 => 'neighboor-advertisment',
    137 => 'redirect',
    138 => 'router-renumbering',
    139 => 'node-info-query',
    140 => 'node-info-response',
    141 => 'invert-neighboor-sol',
    142 => 'invert-neighboor-adv',
    143 => 'multicast-listener-discovery',
    144 => 'home-agent-addr-request',
    145 => 'home-agent-addr-reply',
    146 => 'mobile-prefix-sol',
    147 => 'mobile-prefix-adv',
    148 => 'cert-path-solicitation',
    149 => 'cert-path-advertisment',
    151 => 'multicast-router-adv',
    152 => 'multicast-router-sol',
    153 => 'multicast-router-term',
    155 => 'RPL-control-msg',    
    );

# This function is called for every ICMP packet
# Update stats object
sub update {
    my ($stats_ref, $pkt_ref) = @_;

    $$stats_ref->{tot}++;
    $$stats_ref->{type}{$$pkt_ref->{type}}++;
}

# Build lines for the displayer
sub build_lines {
    my ($ref, $spaces, $lines, $i) = @_;
    my @keys;

    $lines->[$$i++] = format::line(' 'x$spaces . "   Total packets", $$ref->{tot});
    $lines->[$$i++] = ' ';

    _build_type_lines($ref, $spaces, $lines, $i);
    $lines->[$$i++] = ' ';
}

# Build lines corresponding to the ICMP type
sub _build_type_lines {
   my ($ref, $spaces, $lines, $i) = @_;
   my @keys;

   @keys = sort {$$ref->{type}{$b} <=> $$ref->{type}{$a}} keys %{$$ref->{type}};
   foreach my $p(@keys) {
       $lines->[$$i++] = format::line(' 'x$spaces . "   Proto:" . _type_to_str($p), 
				      $$ref->{type}{$p} . ' (' . misc::percentage($$ref->{type}{$p}, $$ref->{tot}) . '%)');
   }   
}

sub _type_to_str {
    my $type = shift;


    if(exists $icmpv6_types{$type}) {
	return $icmpv6_types{$type};
    }

    return $type;
}

1;
