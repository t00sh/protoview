package displayer;

use strict;
use warnings;

use Curses;

sub new {
    my ($class) = @_;
    my $this = {};

    bless($this, $class);

    $this->{_main_win} = initscr;
    $this->{_x_view} = 0;
    $this->{_y_view} = 0;

    cbreak;
    noecho;
    nodelay($this->{_main_win}, 1);
    keypad($this->{_main_win}, 1);

    $this->update;

    return $this;
}

sub win_x {
    return $COLS-2;
}

sub win_y {
    return $LINES-2;
}

sub update {
    my $this = shift;
    my $lines;
    my ($start_x, $start_y, $end_x, $end_y);

    clear;

    box($this->{_main_win}, 0,0);
    $lines = $main::stats->build_lines;


    ($start_x, $end_x) = $this->calc_x($lines);
    ($start_y, $end_y) = $this->calc_y($lines);

    for(my $i = $start_y; $i < $end_y && $lines->[$i]; $i++) {
	addstr($i-$start_y+1, 1, substr($lines->[$i], $start_x, $end_x-$start_x));
    }

    refresh;
}

sub calc_x {
    my ($this, $lines) = @_;
    my ($start_x, $end_x);
    my $max_line = 0;

    foreach my $l(@{$lines}) {
	$max_line = length $l if(length $l > $max_line);
    }

    if($max_line <= win_x()) {
	return (0, win_x())
    }

    $start_x = $this->{_x_view};
    $start_x = $max_line-win_x() if($start_x > $max_line-win_x());

    $end_x = $max_line;
    $end_x = $start_x+win_x() if($end_x > $start_x+win_x());

    $this->{_x_view} = $start_x;
    return ($start_x, $end_x);
}

sub calc_y {
    my ($this, $lines) = @_;
    my ($start_y, $end_y);
    my $tot_lines = scalar @{$lines};

    if($tot_lines <= win_y()) {
	return (0, win_y())
    }

    $start_y = $this->{_y_view};
    $start_y =  $tot_lines-win_y() if($start_y > $tot_lines-win_y());

    $end_y = $tot_lines;
    $end_y = $start_y+win_y() if($end_y > $start_y+win_y());

    $this->{_y_view} = $start_y;
    return ($start_y, $end_y);
}

sub inc_x_view {
    my ($this, $n) = @_;
    $n = $n || 1;

    $this->{_x_view} += $n;
}

sub inc_y_view {
    my ($this, $n) = @_;
    $n = $n || 1;

    $this->{_y_view} += $n;
}

sub dec_x_view {
    my ($this, $n) = @_;
    $n = $n || 1;

    $this->{_x_view} -= $n;
    $this->{_x_view} = 0 if($this->{_x_view} < 0);
}

sub dec_y_view {
    my ($this, $n) = @_;
    $n = $n || 1;

    $this->{_y_view} -= $n;
    $this->{_y_view} = 0 if($this->{_y_view} < 0);
}

1;
