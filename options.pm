package options;

use strict;
use warnings;

use Pod::Usage;
use Getopt::Long;

sub new {
    my $class = shift;
    my $this = {};

    bless($this, $class);

    $this->{refresh} = 1;
    $this->{iface} = 'eth0';
    $this->{port} = '15751';

    $this->_parse;

    return $this;
}

sub _parse {
    my ($this, $argv) = @_;

    GetOptions(
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
