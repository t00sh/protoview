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

package stats_icmp;

use strict;
use warnings;

use Protoview::format;
use Protoview::misc;

use constant {
    ICMP_TYPE_ECHO_REPLY   => 0,
    ICMP_TYPE_DST_UNREACH  => 3,
    ICMP_TYPE_SRC_QUENCH   => 4,
    ICMP_TYPE_REDIRECT     => 5,
    ICMP_TYPE_ECHO_REQ     => 8,
    ICMP_TYPE_RA           => 9,
    ICMP_TYPE_RS           => 10,
    ICMP_TYPE_TIME_EXCEDED => 11,
    ICMP_TYPE_BAD_IP_HDR   => 12,
    ICMP_TYPE_TIMESTAMP    => 13,
    ICMP_TYPE_TIMESTAMP_REP=> 14,
    ICMP_TYPE_INFO_REQ     => 15,
    ICMP_TYPE_INFO_REP     => 16,
    ICMP_TYPE_MASK_REQ     => 17,
    ICMP_TYPE_MASK_REP     => 18,
    ICMP_TYPE_TRACEROUTE   => 19,
};

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

    
    return 'echo-reply' if($type == ICMP_TYPE_ECHO_REPLY);
    return 'dst-unreachable' if($type == ICMP_TYPE_DST_UNREACH);
    return 'src-quench' if($type == ICMP_TYPE_SRC_QUENCH);
    return 'redirect' if($type == ICMP_TYPE_REDIRECT);
    return 'echo-request' if($type == ICMP_TYPE_ECHO_REQ);
    return 'router-adv' if($type == ICMP_TYPE_RA);
    return 'router-sol' if($type == ICMP_TYPE_RS);
    return 'time-exceded' if($type == ICMP_TYPE_TIME_EXCEDED);
    return 'bad-ip-header' if($type == ICMP_TYPE_BAD_IP_HDR);
    return 'timestamp' if($type == ICMP_TYPE_TIMESTAMP);
    return 'timestamp-reply' if($type == ICMP_TYPE_TIMESTAMP_REP);
    return 'info-request' if($type == ICMP_TYPE_INFO_REQ);
    return 'info-reply' if($type == ICMP_TYPE_INFO_REP);
    return 'mask-request' if($type == ICMP_TYPE_MASK_REQ);
    return 'mask-reply' if($type == ICMP_TYPE_MASK_REP);
    return 'traceroute' if($type == ICMP_TYPE_TRACEROUTE);

    return $type;
}

1;
