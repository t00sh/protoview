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

package stats_icmp;

use strict;
use warnings;

use Protoview::format;
use Protoview::misc;

my %icmp_types = (
    0  => 'echo-reply',
    3  => 'dest-unreachable',
    4  => 'source-quench',
    5  => 'redirect',
    8  => 'echo-request',
    9  => 'router-adv',
    10 => 'router-sol',
    11 => 'ttl-exceded',
    12 => 'param-problem',
    13 => 'timestamp',
    14 => 'timestamp-reply',
    15 => 'info-request',
    16 => 'info-reply',
    17 => 'addr-mask-req',
    18 => 'addr-mask-rep',
    30 => 'traceroute',
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

    if(exists $icmp_types{$type}) {
	return $icmp_types{$type};
    }

    return $type;
}

1;
