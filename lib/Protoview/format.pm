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

package format;

use strict;
use warnings;

use Protoview::colors;

# Format a line which look like "KEY   VALUE"
sub line {
    my ($key, $value) = @_;

    return sprintf "%-55s %s", chr(colors::COLOR_WHITE_BG_BLACK) . $key, chr(colors::COLOR_GREEN_BG_BLACK) . $value;
}

# Format a menu
sub menu {
    my $menu = shift;

    return chr(colors::COLOR_RED_BG_BLACK) . $menu;
}

# Format the help message
sub help {
    my $help = shift;

    return chr(colors::COLOR_BLACK_BG_WHITE) . $help;
}

1;
