package colors;

use Exporter;

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
