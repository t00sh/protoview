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

package stats_ipv6;

use format;
use misc;

use constant {
    IPV6_PROTO_ICMP   => 1,
    IPV6_PROTO_IGMP   => 2,
    IPV6_PROTO_TCP    => 6,
    IPV6_PROTO_UDP    => 17,
    IPV6_PROTO_ICMPV6 => 58,
};

# Called for every IPv6 packet
# Update the stats Object
sub update {
    my ($stats_ref, $pkt_ref) = @_;

    $$stats_ref->{tot}++;
    $$stats_ref->{src}{$$pkt_ref->{src}}++;
    $$stats_ref->{dst}{$$pkt_ref->{dst}}++;
    $$stats_ref->{next_header}{$$pkt_ref->{next_header}}++;
}

# Build lines for the displayer
sub build_lines {
    my ($ref, $spaces, $lines, $i) = @_;
    my @keys;

    $lines->[$$i++] = format::line(' 'x$spaces . "   Total packets", $$ref->{tot});

    $lines->[$$i++] = ' ';

    @keys = sort {$$ref->{next_header}{$b} <=> $$ref->{next_header}{$a}} keys %{$$ref->{next_header}};
    foreach my $p(@keys) {
	$lines->[$$i++] = format::line(' 'x$spaces . "   Proto:" . _proto_to_str($p), 
				       $$ref->{next_header}{$p} . ' (' . percentage($$ref->{next_header}{$p}, $$ref->{tot}) . '%)');
    }

    $lines->[$$i++] = ' ';

    @keys = sort {$$ref->{src}{$b} <=> $$ref->{src}{$a}} keys %{$$ref->{src}};
    foreach my $p(@keys) {
	$lines->[$$i++] = format::line(' 'x$spaces . "   Src:$p", 
				       $$ref->{src}{$p} . ' (' . percentage($$ref->{src}{$p}, $$ref->{tot}) . '%)');
    }

    $lines->[$$i++] = ' ';

    @keys = sort {$$ref->{dst}{$b} <=> $$ref->{dst}{$a}} keys %{$$ref->{dst}};
    foreach my $p(@keys) {
	$lines->[$$i++] = format::line(' 'x$spaces . "   Dst:$p", 
				       $$ref->{dst}{$p} . ' (' . percentage($$ref->{dst}{$p}, $$ref->{tot}) . '%)');
    }

    $lines->[$$i++] = ' ';
}

sub _proto_to_str {
    my $proto = shift;

    return 'icmp' if($proto == IPV6_PROTO_ICMP);
    return 'igmp' if($proto == IPV6_PROTO_IGMP);
    return 'tcp' if($proto == IPV6_PROTO_TCP);
    return 'udp' if($proto == IPV6_PROTO_UDP);
    return 'icmpv6' if($proto == IPV6_PROTO_ICMPV6);

    return $proto;
}

1;
