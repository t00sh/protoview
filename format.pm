package format;

use colors;

# Format a line which look like "KEY   VALUE"
sub line {
    my ($key, $value) = @_;

    return sprintf "%-55s %s", chr(COLOR_WHITE_BG_BLACK) . $key, chr(COLOR_GREEN_BG_BLACK) . $value;
}

# Format a menu
sub menu {
    my $menu = shift;

    return chr(COLOR_RED_BG_BLACK) . $menu;
}

# Format the help message
sub help {
    my $help = shift;

    return chr(COLOR_BLACK_BG_WHITE) . $help;
}

1;
