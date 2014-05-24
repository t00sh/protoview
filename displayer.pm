package displayer;

use strict;
use warnings;

use Curses;

sub new {
    my ($class) = @_;
    my $this = {};

    bless($this, $class);

    $this->{_main_win} = initscr;
#    cbreak();
#    nodelay($this->{_main_win}, 1);

    $this->update;

    return $this;
}

sub update {
    my $this = shift;
    

#    clear();

    addstr(1, 1, "Total packet captured   " . $main::stats->get_tot_pkt);
    addstr(2, 1, "Packets/secondes        " . $main::stats->get_pkt_per_sec);
    addstr(3, 1, "bits/secondes           " . $main::stats->get_bits_per_sec);
    addstr(4, 1, "bytes/packet            " . $main::stats->get_bytes_per_pkt);
    addstr(6, 1, "Elapsed secondes        " . $main::stats->get_elapsed_time);

    refresh();
}

1;
