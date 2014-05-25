package format;

sub line {
    my ($key, $value) = @_;

    return sprintf "%-40s %s", $key, $value;
}

1;
