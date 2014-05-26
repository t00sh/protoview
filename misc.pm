package misc;

use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(percentage);

sub percentage {
    my ($n, $tot) = @_;

    return "0.00" unless($n);
    return sprintf "%.2f", ($n/$tot)*100.0;
}

1;
