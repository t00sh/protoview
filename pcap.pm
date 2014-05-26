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

package pcap;

# Standard modules
use strict;
use warnings;

# Non-standard modules
use Net::Pcap;

# Protoview modules
use pkt;

# Create new Pcap object
# Init the pcap library
sub new {
    my ($class, $dev, $callback, $user) = @_;
    my $this = {};

    bless($this, $class);

    $this->_init_dev($dev);
    $this->{_callback} = $callback;
    $this->{_user} = $user;
    $this->{_handle} = pcap_get_selectable_fd($this->{_pcap});
    $this->{_timestamp} = time();

    return $this;    
}

# Init the device for sniffing
sub _init_dev {
    my ($this, $dev) = @_;
    my $err;

    unless(defined $dev) {
	$dev = Net::Pcap::lookupdev(\$err);
	unless(defined $dev) {
	    die "[-] Can't lookupdev: $err\n";
	}
    }

    $this->{_dev} = $dev;

    $this->{_pcap} = Net::Pcap::open_live($dev, 1500, 0, -1, \$err);

    unless(defined $this->{_pcap}) {
	die "[-] Can't open live ($dev): $err\n";
    }
}

# Get the next packet
sub next_pkt {
    my ($this) = @_;
    my (%hdr, $pkt);

    $pkt = Net::Pcap::next($this->{_pcap}, \%hdr); 
    if(defined $pkt) {
	$this->{_callback}($pkt, \%hdr, $this->{_user});
    }
}

# Get the device name
sub get_dev {
    my $this = shift;

    return $this->{_dev};
}

# Get the socket handle
sub get_handle {
    my $this = shift;

    return $this->{_handle};
}

# Procedure used as a callback for the pcap library
sub handle {
    my ($raw, $hdr, $stats) = @_;
    my $pkt = pkt->new($raw);

    $stats->add_pkt($pkt);    
}

1;
