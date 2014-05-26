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

=pod

=head1 NAME

 - protoview -
Make statistiques with protocols wich come to your interface

=head1 SYNOPSIS

protoview [OPTIONS]


=head1 OPTIONS

=over 4

=item B<-i -iface>

Specify the interface to sniff

=item B<-r -refresh>

Refresh time in seconds (default: 1 second)

=item B<-n -nocolor>

Don't color the terminal

=item B<-v -version>

Print version

=item B<-h -help>

Print help

=item B<-m -man>

Print complete help

=back

=head1 CONTROLS

=over 4

=item B<PAGE UP>

Scroll backward

=item B<PAGE DOWN>

Scroll forward

=item B<ARROWS>

Browse into the window

=back

=head1 DESCRIPTION

B<This program> is a network monitoring tool using Curses.
It make statistiques with protocols wich are used on your network.

=head1 SCREENSHOTS

=begin html

<img src="https://github.com/t00sh/protoview/blob/master/screenshots/version_1_0.jpg" alt="screen" />

=end html

=head1 DEPENDS

=over 4

=item B<perl 5>

=item B<Net::Pcap>

=item B<Curses>

=back

=head1 PROTOCOLS

=over 4

=item B<L2>

=over 4

=item Ethernet

=back

=back

=over 4

=item B<L3>

=over 4

=item IPv4

=item IPv6

=back

=back

=head1 LICENCE

This program is a free software. 
It is distrubued with the terms of the B<GPLv3 licence>.

=head1 VERSION

V1.0-beta

=head1 AUTHOR

Written by B<Tosh>

(duretsimon73 -at- gmail -dot- com)

=cut
