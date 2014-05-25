package event;

use strict;
use warnings;

use keys;

use IO::Select;

# Constructor for event manager
sub new {
    my ($class) = @_;
    my $this = {};

    bless($this, $class);

    $this->{_select} = IO::Select->new;

    return $this;
}

# Add a file decriptor to monitor
sub add {
    my ($this, $handle, $callback, $user) = @_;

    $this->{_select}->add($handle);
    $this->{$handle}->{_callback} = $callback;
    $this->{$handle}->{_user} = $user;
}

# Delete a file descriptor
sub del {
    my ($this, $handle) = @_;
    
    $this->{_select}->remove($handle);
    delete($this->{$handle});
}

# Process events
sub process {
    my $this = shift;
    my @ready;

    @ready = $this->{_select}->can_read(0.1);

    foreach(@ready) {
	$this->{$_}->{_callback}($this->{$_}->{_user});
    }
    
    keys::process();

    $this->_exec_timers;
}

# Set a timer, called every $refresh seconds (not very accurate)
sub set_timer {
    my ($this, $callback, $user, $refresh) = @_;
    $refresh = $refresh || 5;

    push(@{$this->{_user_timers}}, 
	 {
	     _callback     => $callback,
	     _user         => $user, 
	     _refresh      => $refresh, 
	     _next_refresh => time + $refresh 
	 });
}

# Verify timers, and execute them
sub _exec_timers {
    my $this = shift;

    foreach my $t(@{$this->{_user_timers}}) {
	if(time >= $t->{_next_refresh}) {
	    $t->{_next_refresh} = time + $t->{_refresh};
	    $t->{_callback}($t->{_user});
	}
    }
}

1;
