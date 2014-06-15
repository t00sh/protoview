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
use Protoview::pkt;

# Create new Pcap object
# Init the pcap library
sub new {
    my ($class, %h) = @_;
    my $this = {};

    my $dev = $h{dev};
    my $pcap = $h{pcap};
    my $callback = $h{callback};
    my $user = $h{user};

    if(!$dev && !$pcap) {
	die "No device or pcap file given !\n";
    }
    
    if($dev && $pcap) {
	die "You must give a pcap OR a device (not twice) !\n";
    }
    
    if(!$callback) {
	die "You must give a callback !\n";
    }

    bless($this, $class);

    if($dev) {
	$this->_init_dev($dev);
    } else { 
	$this->_init_pcap($pcap);
    }

    $this->{_file} = $pcap;
    $this->{_callback} = $callback;
    $this->{_user} = $user;
    $this->{_handle} = Net::Pcap::pcap_get_selectable_fd($this->{_pcap});
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

# Init pcap library with a pcap file
sub _init_pcap {
    my ($this, $pcap) = @_;
    my $err;
    
    $this->{_pcap} = Net::Pcap::open_offline($pcap, \$err);

    unless(defined $this->{_pcap}) {
	die "[-] Can't open pcap file ($pcap) : $err\n";
    }
}

# Get the next packet
sub next_pkt {
    my ($this) = @_;
    my (%hdr, $pkt);

    $pkt = Net::Pcap::next($this->{_pcap}, \%hdr); 
    if(defined $pkt) {
	$this->{_callback}($pkt, \%hdr, $this->{_user});
    } elsif($this->{_file}) {
	$main::event->del($this->get_handle);
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
