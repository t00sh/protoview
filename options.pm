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

package options;

use strict;
use warnings;

use Pod::Usage;
use Getopt::Long;

use constant POD => 'README.pod';

# Create new options object
sub new {
    my $class = shift;
    my $this = {};

    bless($this, $class);

    $this->{nocolor} = 0;
    $this->{refresh} = 1;
    $this->{iface} = 'eth0';

    $this->_parse;

    return $this;
}

# Parse command lines options
sub _parse {
    my ($this, $argv) = @_;

    GetOptions(
	'nocolor'      => \$this->{nocolor},
	'refresh=s'    => \$this->{refresh},
	'iface=s'      => \$this->{iface},
	'addr'         => \$this->{addr},
	'help'         => \$this->{help},
	'man'          => \$this->{man},
	'version'      => \$this->{version}
	);

    pod2usage(-input => POD, -verbose => 1) if $this->{help};
    pod2usage(-input => POD, -verbose => 99, -sections => 'VERSION') if $this->{version};
    pod2usage(-input => POD, -verbose => 2, -exitval => 0) if($this->{man});
}


1;
