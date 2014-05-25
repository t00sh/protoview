#!/usr/bin/perl

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

=item B <-r -refresh>

Refresh time in seconds (default: 1 second)

=item B<-v -version>

Print version

=item B<-h -help>

Print help

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

B<This program> is a network monitoring tool.
It make statistiques with protocols wich are used on your network.


=head1 VERSION

V1.0

=head1 AUTHOR

Written by B<Tosh>

(duretsimon73 -at- gmail -dot- com)


=head1 LICENCE

This program is a free software. 
It is distrubued with the terms of the B<GPLv3 licence>.


=head1 DEPENDS

=over 4

=item B<perl 5>

=item B<Net::Pcap>

=item B<Curses>

=back

=cut
