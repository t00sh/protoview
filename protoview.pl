#!/usr/bin/perl

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

# standard modules
use strict;
use warnings;

# protoview modules
use options;
use pcap;
use event;
use stats;
use displayer;

# Parse command line options
our $options = options->new;

# Create a STATS structure
our $stats = stats->new;

# Create event manager
our $event = event->new;

# Init PCAP
our $pcap = pcap->new($options->{iface}, \&pcap::handle, $stats);
$event->add($pcap->get_handle, \&pcap::next_pkt, $pcap);

# Init displayer
our $displayer = displayer->new;
$event->set_timer(\&displayer::update, $displayer, $options->{refresh});


# Main loop
while(1) {
    $event->process;
}
