package Data::CompactDump 0.03;
# ABSTRACT: Perl extension for dumping xD structures in compact form

=head1 SYNOPSIS

	use Data::CompactDump qw/compact/;

	my $xd_structure = [ [ 1, 2 ], [ 3, [ 4, 5 ] ] ];
	my $dump = compact( $xd_structure );


=head1 DESCRIPTION

Module provides some functions for dumping xD structures (like L<Data::Dump> or
L<Data::Dumper>) but in compact form.

=cut

use strict;
use base 'Exporter';

our @EXPORT = qw(compact);

=head1 FUNCTIONS

=head2 compact( xD )

Make eval-compatible form of xD structure for saving and restoring data
(compact form)

	my $xd_structure = [ [ 1, 2 ], [ 3, [ 4, 5 ] ] ];
	my $dump = compact($xd_structure);

=cut

sub compact {
        unless (defined (my $q = shift)) {
                return 'undef';
	} elsif (not ref $q) {
		if ($q =~ /^\d+$/) {
			return $q;
		} else {
			$q =~ s/\n/\\n/g;  $q =~ s/\r/\\r/g;  $q =~ s/'/\\'/g;
                	return "\'" . $q . "\'";
		}
        } elsif ((my $rr = ref $q) eq 'ARRAY') {
                return '[ ' . join(', ',map { compact($_); } @$q) . ' ]';  
        } elsif ($rr eq 'SCALAR') {   
                return '\\' . compact($$q);       
        } elsif ($rr eq 'HASH') {
                return  '{ ' . join(', ',map { $_ . ' => ' . compact($$q{$_}); }
				keys %$q) . ' }';
        } else { return '\?'; }
}

1;

__END__

=head1 SEE ALSO

L<Data::Dump>
L<Data::Dumper>

=cut
