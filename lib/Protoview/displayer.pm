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

package displayer;

use strict;
use warnings;

use Curses;

use Protoview::colors;
use Protoview::format;

# Constructor for the displayer
# Init the curses mode
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

    # Init colors if terminal support it
    if(has_colors) {
	start_color();
	init_pair(colors::COLOR_WHITE_BG_BLACK, COLOR_WHITE, COLOR_BLACK);
	init_pair(colors::COLOR_RED_BG_BLACK, COLOR_RED, COLOR_BLACK);
	init_pair(colors::COLOR_GREEN_BG_BLACK, COLOR_GREEN, COLOR_BLACK);
	init_pair(colors::COLOR_BLACK_BG_WHITE, COLOR_BLACK, COLOR_WHITE);
    }

    $this->update;

    return $this;
}

# Get the X window
sub win_x {
    return $COLS-2;
}

# Get the Y window
sub win_y {
    return $LINES-3;
}

sub print_line {
    my ($this, $x, $y, $line) = @_;
    my $color = has_colors() && !$main::options->{nocolor};

    foreach my $c(split //, $line) {
	if(ord($c) < colors::COLOR_MAX) {
	    if($color) {
		attron(COLOR_PAIR(ord($c)));
	    }
	} else {
	    move($x, $y);
	    addch($c);
	    $y++;
	}
    }

    if($color) {
	for(1..colors::COLOR_MAX) {
	    attroff(COLOR_PAIR($_));
	}
    }
}

# Refresh the terminal
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

	$this->print_line($i-$start_y+1, 
			  1, 
			  substr($lines->[$i], 
				 $start_x, $end_x-$start_x));	
    }

    $end_y = scalar @{$lines} if($end_y > @{$lines});
    $this->print_line($LINES-2,
		      1,
		      substr(format::help('[ ' . $end_y . '/' . @{$lines} . ' lines. Press PAGE_UP or PAGE_DOWN ]'),
			     $start_x, $end_x-$start_x));
    refresh;
}

# Calculate where to start and end lines (X)
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

# Calculate where to start and end lines (Y)
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

# Increment the X view
sub inc_x_view {
    my ($this, $n) = @_;
    $n = $n || 1;

    $this->{_x_view} += $n;
}

# Increment the Y view
sub inc_y_view {
    my ($this, $n) = @_;
    $n = $n || 1;

    $this->{_y_view} += $n;
}

# Decrement the X view
sub dec_x_view {
    my ($this, $n) = @_;
    $n = $n || 1;

    $this->{_x_view} -= $n;
    $this->{_x_view} = 0 if($this->{_x_view} < 0);
}

# Decrement the Y view
sub dec_y_view {
    my ($this, $n) = @_;
    $n = $n || 1;

    $this->{_y_view} -= $n;
    $this->{_y_view} = 0 if($this->{_y_view} < 0);
}

END {
    endwin();
}

1;
