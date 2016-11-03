# NAME

Validate::TinyX::Checks::Common - A collection of check routines for Validate::Tiny

# SYNOPSIS

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

# DESCRIPTION

This module provides check routines designed for use with
[Validate::Tiny](https://metacpan.org/pod/Validate::Tiny).

# SUBROUTINES

## is\_number

    is_number( $optional_error_message )

`is_number` provides a shortcut to an anonymous subroutine that
checks if the matched field is a number.

Optionally, you can provide a custom error message. The default is _Not a number_.

## is\_positive\_number

    is_positive_number( $optional_error_message )

`is_positive_number` provides a shortcut to an anonymous subroutine that
checks if the matched field is a number and is greater than zero.

Optionally, you can provide a custom error message. The default is _Not a positive number_.

## is\_integer

    is_integer( $optional_error_message )

`is_integer` provides a shortcut to an anonymous subroutine that
checks if the matched field is a integer and is greater than zero.

Optionally, you can provide a custom error message. The default is _Not an integer_.

## is\_positive\_integer

    is_positive_integer( $optional_error_message )

`is_positive_integer` provides a shortcut to an anonymous subroutine that
checks if the matched field is a integer and is greater than zero.

Optionally, you can provide a custom error message. The default is _Not a positive integer_.

## is\_code\_reference

    is_code_reference( $optional_error_message )

`is_code_reference` provides a shortcut to an anonymous subroutine that
checks if the matched field is a code reference

Optionally, you can provide a custom error message. The default is _Not a code reference_.

## is\_instance\_of

    is_instance_of( $class, $optional_error_message )

`is_instance_of` provides a shortcut to an anonymous subroutine that
checks if the matched field is an instance of the given class.

Optionally, you can provide a custom error message. The default is _Not an instance of $class_.

## is\_any\_of

    is_any_of( [ $coderef, $coderef, $coderef, ...] , $optional_error_message )

`is_any_of` provides a shortcut to an anonymous subroutine that
checks if the matched field passes any of the passed checks.

Optionally, you can provide a custom error message. The default is _Did not match any criteria_.

For example, to accept either a positive number of an instance of [Math::BigInt](https://metacpan.org/pod/Math::BigInt):

    is_any_of( [ is_positive_number, is_instance_of( 'Math::BigInt' ) ] )

## is\_undef

    is_undef( $optional_error_message )

`is_undef` provides a shortcut to an anonymous subroutine that checks
if the matched field is undefined.  Optionally, you can provide a
custom error message. The default is _Is defined_.

This is typically used with [**is\_any\_of**](#is_any_of) to
explicitly document that an undefined value is acceptable.

# DEPENDENCIES

[Safe::Isa](https://metacpan.org/pod/Safe::Isa), [Scalar::Util](https://metacpan.org/pod/Scalar::Util). Will use [Ref::Util](https://metacpan.org/pod/Ref::Util) if available.

# BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
`bug-validate-tinyx-checks-common@rt.cpan.org`, or through the web interface at
[http://rt.cpan.org/Public/Dist/Display.html?Name=Validate-TinyX-Checks-Common](http://rt.cpan.org/Public/Dist/Display.html?Name=Validate-TinyX-Checks-Common).

# SEE ALSO

[Validate::Tiny](https://metacpan.org/pod/Validate::Tiny)

# VERSION

Version 0.01

# LICENSE AND COPYRIGHT

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
along with this program.  If not, see &lt;http://www.gnu.org/licenses/>.

# AUTHOR

Diab Jerius  <djerius@cpan.org>
