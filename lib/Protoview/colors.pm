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

use Exporter;

package colors;

our @ISA = qw(Exporter);
our @EXPORT = qw(COLOR_WHITE_BG_BLACK COLOR_RED_BG_BLACK COLOR_GREEN_BG_BLACK COLOR_BLACK_BG_WHITE COLOR_MAX);

use constant {
    COLOR_WHITE_BG_BLACK => 1,
    COLOR_RED_BG_BLACK   => 2,
    COLOR_GREEN_BG_BLACK => 3,
    COLOR_BLACK_BG_WHITE => 4,
    COLOR_MAX            => 5
};

1;

