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

package keys;

use Curses;
use Protoview::displayer;

# Process the keys event
sub process {
    my $ch;

    while(($ch = getch()) != ERR) {
	if($ch == KEY_LEFT) {
	    $main::displayer->dec_x_view;
	} elsif($ch == KEY_RIGHT) {
	    $main::displayer->inc_x_view;
	} elsif($ch == KEY_UP) {
	    $main::displayer->dec_y_view;
	} elsif($ch == KEY_DOWN) {
	    $main::displayer->inc_y_view;
	} elsif($ch == KEY_PPAGE) {
	    $main::displayer->dec_y_view(int(displayer::win_y()/2));
	} elsif($ch == KEY_NPAGE) {
	    $main::displayer->inc_y_view(int(displayer::win_y()/2));
	} elsif($ch == KEY_q) {
	    exit 0;
	}

	$main::displayer->update;
    }
}

1;
