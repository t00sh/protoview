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

package stats_ipv6;

use strict;
use warnings;

use Protoview::format;
use Protoview::misc;

my %ipv6_protos = (
    1  => 'icmp',
    2  => 'igmp',
    6  => 'tcp',
    17 => 'udp',
    58 => 'icmpv6',
);

# Called for every IPv6 packet
# Update the stats Object
sub update {
    my ($stats_ref, $pkt_ref) = @_;

    $$stats_ref->{tot}++;
    $$stats_ref->{src}{$$pkt_ref->{src}}++;
    $$stats_ref->{dst}{$$pkt_ref->{dst}}++;
    $$stats_ref->{proto}{$$pkt_ref->{next_header}}++;
}

# Build lines for the displayer
sub build_lines {
    my ($ref, $spaces, $lines, $i) = @_;
    my @keys;

    $lines->[$$i++] = format::line(' 'x$spaces . "   Total packets", $$ref->{tot});
    $lines->[$$i++] = ' ';

    _build_proto_lines($ref, $spaces, $lines, $i);
    $lines->[$$i++] = ' ';

    _build_addr_lines($ref, $spaces, $lines, $i);
    $lines->[$$i++] = ' ';
}

# Build lines corresponding to the protocol
sub _build_proto_lines {
   my ($ref, $spaces, $lines, $i) = @_;
   my @keys;

   @keys = sort {$$ref->{proto}{$b} <=> $$ref->{proto}{$a}} keys %{$$ref->{proto}};
   foreach my $p(@keys) {
       $lines->[$$i++] = format::line(' 'x$spaces . "   Proto:" . _proto_to_str($p), 
				      $$ref->{proto}{$p} . ' (' . misc::percentage($$ref->{proto}{$p}, $$ref->{tot}) . '%)');
   }   
}

# Build lines corresponding to src/dst address
sub _build_addr_lines {
    my ($ref, $spaces, $lines, $i) = @_;
    my @keys;

    unless($main::options->{addr}) {
	$lines->[$$i++] = ' ';

	@keys = sort {$$ref->{src}{$b} <=> $$ref->{src}{$a}} keys %{$$ref->{src}};
	foreach my $p(@keys) {
	    $lines->[$$i++] = format::line(' 'x$spaces . "   Src:$p", 
					   $$ref->{src}{$p} . ' (' . misc::percentage($$ref->{src}{$p}, $$ref->{tot}) . '%)');
	}

	$lines->[$$i++] = ' ';

	@keys = sort {$$ref->{dst}{$b} <=> $$ref->{dst}{$a}} keys %{$$ref->{dst}};
	foreach my $p(@keys) {
	    $lines->[$$i++] = format::line(' 'x$spaces . "   Dst:$p", 
					   $$ref->{dst}{$p} . ' (' . misc::percentage($$ref->{dst}{$p}, $$ref->{tot}) . '%)');
	}
    }
}

sub _proto_to_str {
    my $proto = shift;

    if(exists $ipv6_protos{$proto}) {
	return $ipv6_protos{$proto};
    }

    return $proto;
}

1;
