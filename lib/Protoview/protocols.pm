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

package protocols;

our $list;

use Protoview::pkt_eth;
use Protoview::pkt_ipv4;
use Protoview::pkt_ipv6;
use Protoview::pkt_icmp;
use Protoview::pkt_icmpv6;

use Protoview::stats_eth;
use Protoview::stats_ipv4;
use Protoview::stats_ipv6;
use Protoview::stats_icmp;
use Protoview::stats_icmpv6;

# Constructor
sub new {
    my ($class) = @_;
    my $this = {};

    bless($this, $class);    

    return $this;
}

# Add a protocol to the list
sub add {
    my ($this, $name, $h) = @_;

    %{$this->{$name}} = %{$h};
    
}

# Init the protocols
BEGIN {
    $list = protocols->new();

    $list->add('ETHERNET', {
	parser       => \&pkt_eth::parse,
	build_lines  => \&stats_eth::build_lines,
	update       => \&stats_eth::update
		    });

    $list->add('IPV4', {
	parser      => \&pkt_ipv4::parse,
	build_lines => \&stats_ipv4::build_lines,
	update      => \&stats_ipv4::update,
	from        => 'ETHERNET',
	test       => sub {$_[0]->{proto} ==  0x0800}
		    });    

    $list->add('IPV6', {
	parser      => \&pkt_ipv6::parse,
	build_lines => \&stats_ipv6::build_lines,
	update      => \&stats_ipv6::update,
	from        => 'ETHERNET',
	test        => sub {$_[0]->{proto} == 0x86DD}
		    });    

    $list->add('ICMP', {
	parser      => \&pkt_icmp::parse,
	build_lines => \&stats_icmp::build_lines,
	update      => \&stats_icmp::update,
	from        => 'IPV4',
	test        => sub {$_[0]->{proto} == 1}
		    });    

    $list->add('ICMPV6', {
	parser      => \&pkt_icmpv6::parse,
	build_lines => \&stats_icmpv6::build_lines,
	update      => \&stats_icmpv6::update,
	from        => 'IPV6',
	test        => sub {$_[0]->{next_header} ==  58}
		    });    

}

1;
