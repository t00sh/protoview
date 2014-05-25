package keys;

use Curses;
use displayer;

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
	    $main::displayer->dec_y_view(displayer::win_y()/2);
	} elsif($ch == KEY_NPAGE) {
	    $main::displayer->inc_y_view(displayer::win_y()/2);
	}

	$main::displayer->update;
    }
}

1;
