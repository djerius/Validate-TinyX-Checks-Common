# --8<--8<--8<--8<--
#
# Copyright (C) 2016 Smithsonian Astrophysical Observatory
#
# This file is part of Validate::TinyX::Checks::Common
#
# Validate::TinyX::Checks::Common is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# -->8-->8-->8-->8--

package Validate::TinyX::Checks::Common;

use feature 'state';


use strict;
use warnings;
use Carp;

our $VERSION = '0.01';

use Exporter 'import';

our @EXPORT_OK = qw(
  is_number
  is_integer
  is_positive_integer
  is_positive_number
  is_code_reference
  is_instance_of
  is_any_of
  is_undef
);

our %EXPORT_TAGS = ( all => \@EXPORT_OK );

use Safe::Isa;
use Scalar::Util qw'looks_like_number reftype';

## no critic (Subroutines::ProhibitSubroutinePrototypes)
sub _is_coderef($);

BEGIN {

    ## no critic (BuiltinFunctions::ProhibitStringyEval)

    *_is_coderef
      = eval 'use Ref::Util; 1'
      ? \&Ref::Util::is_coderef
      : sub { 'CODE' eq reftype $_[0] };

}

=pod

=head1 NAME

Validate::TinyX::Checks::Common - A collection of check routines for Validate::Tiny

=head1 SYNOPSIS

  use Validate::Tiny ':all';
  use Validate::TinyX::Checks::Common ':all';

  my % rules = (

    checks => [

        cardinal_number => is_positive_integer,
        required_cash   => is_positive_number,

        code_reference  => is_code_reference,
        object          => is_instance_of( 'MyClass' ),
        number_maybe_undef     => is_any_of( is_undef, is_positive_number )


    ]

  );


=head1 DESCRIPTION

This module provides check routines designed for use with
L<Validate::Tiny>.


=head1 SUBROUTINES

=cut


=head2 is_number

  is_number( $optional_error_message )

C<is_number> provides a shortcut to an anonymous subroutine that
checks if the matched field is a number.

Optionally, you can provide a custom error message. The default is I<Not a number>.

=cut

sub is_number {

    my $err_msg = shift || 'Not a number';

    sub {

        my $value = shift;

        return
             if defined $value
          && looks_like_number( $value );

        return $err_msg;
    };

}

=head2 is_positive_number

  is_positive_number( $optional_error_message )

C<is_positive_number> provides a shortcut to an anonymous subroutine that
checks if the matched field is a number and is greater than zero.

Optionally, you can provide a custom error message. The default is I<Not a positive number>.

=cut

sub is_positive_number {

    my $err_msg = shift || 'Not a positive number';

    sub {

        my $value = shift;

        return
             if defined $value
          && looks_like_number( $value )
          && $value > 0;

        return $err_msg;
    };

}

=head2 is_integer

  is_integer( $optional_error_message )

C<is_integer> provides a shortcut to an anonymous subroutine that
checks if the matched field is a integer and is greater than zero.

Optionally, you can provide a custom error message. The default is I<Not an integer>.

=cut

sub is_integer {

    my $err_msg = shift || 'Not an integer';

    sub {

        my $value = shift;

        return
             if defined $value
          && looks_like_number( $value )
          && int( $value ) == $value;

        return $err_msg;
    };

}

=head2 is_positive_integer

  is_positive_integer( $optional_error_message )

C<is_positive_integer> provides a shortcut to an anonymous subroutine that
checks if the matched field is a integer and is greater than zero.

Optionally, you can provide a custom error message. The default is I<Not a positive integer>.

=cut

sub is_positive_integer {

    my $err_msg = shift || 'Not a positive integer';

    sub {

        my $value = shift;

        return
             if defined $value
          && looks_like_number( $value )
          && $value > 0
          && int( $value ) == $value;

        return $err_msg;
    };

}

=head2 is_code_reference

  is_code_reference( $optional_error_message )

C<is_code_reference> provides a shortcut to an anonymous subroutine that
checks if the matched field is a code reference

Optionally, you can provide a custom error message. The default is I<Not a code reference>.

=cut

sub is_code_reference {

    my $err_msg = shift || 'Not a code reference';

    my $sub = sub {
        my $value = shift;

        return if defined $value && _is_coderef( $value );

        return $err_msg;
    };

}

=head2 is_instance_of

  is_instance_of( $class, $optional_error_message )

C<is_instance_of> provides a shortcut to an anonymous subroutine that
checks if the matched field is an instance of the given class.

Optionally, you can provide a custom error message. The default is I<Not an instance of $class>.

=cut

sub is_instance_of {

    my $class = shift;
    my $err_msg = shift || "Not an instance of $class";

    return sub {
        my $value = shift;

        return if defined $value && $value->$_isa( $class );

        return $err_msg;
    };

}

=head2 is_any_of

  is_any_of( [ $coderef, $coderef, $coderef, ...] , $optional_error_message )

C<is_any_of> provides a shortcut to an anonymous subroutine that
checks if the matched field passes any of the passed checks.

Optionally, you can provide a custom error message. The default is I<Did not match any criteria>.

For example, to accept either a positive number of an instance of L<Math::BigInt>:

  is_any_of( [ is_positive_number, is_instance_of( 'Math::BigInt' ) ] )

=cut

sub is_any_of {

    my $coderefs = shift;
    my $err_msg = shift || 'Did not match any criteria';


    my @coderefs = map {
        croak __PACKAGE__ . "::is_any_of: argument [$_] is not a coderef"
          if !_is_coderef( $coderefs->[$_] );
        $coderefs->[$_]
    } 0 .. ( @$coderefs - 1 );

    sub {

        for my $code ( @coderefs ) {
            return if !defined $code->( @_ );
        }


        return $err_msg;
    };
}

=head2 is_undef

  is_undef( $optional_error_message )

C<is_undef> provides a shortcut to an anonymous subroutine that checks
if the matched field is undefined.  Optionally, you can provide a
custom error message. The default is I<Is defined>.

This is typically used with L<< B<is_any_of>|/is_any_of >> to
explicitly document that an undefined value is acceptable.

=cut

sub is_undef {

    my $err_msg = shift || 'Is defined';

    sub {

        return unless defined $_[0];
        return $err_msg;
    };
}


__END__

=head1 DEPENDENCIES

L<Safe::Isa>, L<Scalar::Util>. Will use L<Ref::Util> if available.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-validate-tinyx-checks-common@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/Public/Dist/Display.html?Name=Validate-TinyX-Checks-Common>.

=head1 SEE ALSO

L<Validate::Tiny>

=head1 VERSION

Version 0.01

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2016 The Smithsonian Astrophysical Observatory

Validate::TinyX::Checks::Common is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

=head1 AUTHOR

Diab Jerius  E<lt>djerius@cpan.orgE<gt>


