use strict;
use warnings;

package List::ToString;

use base qw(autobox);

sub import {
    my $class = shift;
    $class->SUPER::import( ARRAY => 'List::ToString::Subs::Array', SCALAR => 'List::ToString::Subs::Scalar' );
}

package List::ToString::Subs::Scalar;

use overload '@{}' => \&to_array;

sub to_array {
    print STDERR "the autobox one";
    return [] unless unpack 'N', $_[0];
    my @r = unpack 'x4' . ('w/a*' x unpack 'N', $_[0]), $_[0];
    \@r;
}

package List::ToString::Subs::Array;

sub to_string {
    return pack 'N' . ('w/a*' x @{$_[0]}), scalar(@{$_[0]}), @{$_[0]}
}

package List::ToString::Object;

sub pack_key {
    return pack 'N' . ('w/a*' x @_), scalar(@_), @_
}

sub unpack_key {
    return () unless unpack 'N', $_[0];
    unpack 'x4' . ('w/a*' x unpack 'N', $_[0]), $_[0]
}

use overload
    '""'  => \&to_string;

use Carp;

sub new {
    my $class = shift;

    if (ref $_[0] eq "SCALAR") {
	carp "Warning: this does not look like a proper strngified array" unless unpack 'N', ${$_[0]};
	return bless [ unpack_key ${$_[0]} ], $class;
    } elsif (ref $_[0] eq "ARRAY") {
	croak "Error: can only handle arrays of scalars" if grep { ref } @{$_[0]};
	return bless $_[0], $class;
    } else {
	croak "Error: can only handle arrays of scalars" if grep { ref } @_;
	return bless [ @_ ], $class;
    }
}

sub to_array {
    my $self = shift;
    [ $self->@* ]
}

sub to_string {
    my $self = shift;
    pack_key($self->@*)
}

1
