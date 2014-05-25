package format;

# Format a line which look like "KEY   VALUE"
sub line {
    my ($key, $value) = @_;

    return sprintf "%-40s %s", $key, $value;
}

1;
