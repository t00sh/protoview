package options;

use strict;
use warnings;

use Pod::Usage;
use Getopt::Long;

# Create new options object
sub new {
    my $class = shift;
    my $this = {};

    bless($this, $class);

    $this->{nocolor} = 0;
    $this->{refresh} = 1;
    $this->{iface} = 'eth0';
    $this->{port} = '15751';

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
	'port=s'       => \$this->{port},
	'help'         => \$this->{help},
	'version'      => \$this->{version}
	);

    pod2usage(1) if $this->{help};
    pod2usage(-verbose => 99, -sections => 'VERSION') if $this->{version};
}


1;
