#!perl

use Test::More;

use Validate::TinyX::Checks::Common ':all';


subtest 'is_number' => sub {

    for my $value ( 3, 3.33, -3, -3.33, 0 ) {

        is( is_number->( $value ), undef, "value = $value" );
    }

    for my $value ( 'Lake Street' ) {

        is( is_number->( $value ), 'Not a number', "value = $value" );
    }

    is( is_number( 'Bogus' )->( 'Lake Street' ),
        'Bogus', 'custom error message' );
};

subtest 'is_positive_number' => sub {

    for my $value ( 3, 3.33, ) {

        is( is_number->( $value ), undef, "value = $value" );
    }

    for my $value ( 0, -3, -3.2, 'Lake Street' ) {

        is(
            is_positive_number->( $value ),
            'Not a positive number',
            "value = $value"
        );
    }

    is( is_positive_number( 'Bogus' )->( 'Lake Street' ),
        'Bogus', 'custom error message' );
};

subtest 'is_integer' => sub {

    for my $value ( -3, 0, 3 ) {

        is( is_integer->( $value ), undef, "value = $value" );
    }

    for my $value ( -3.3, -0.1, 0.1, 3.3, 'Lake Street' ) {

        is( is_integer->( $value ), 'Not an integer', "value = $value" );

    }

    is( is_integer( 'Bogus' )->( 'Lake Street' ),
        'Bogus', 'custom error message' );

};

subtest 'is_positive_integer' => sub {

    for my $value ( 3 ) {

        is( is_positive_integer->( $value ), undef, "value = $value" );
    }


    for my $value ( 0, -3, -3.2, 'Lake Street' ) {

        is(
            is_positive_integer->( $value ),
            'Not a positive integer',
            "value = $value"
        );

    }

    is( is_positive_integer( 'Bogus' )->( 'Lake Street' ),
        'Bogus', 'custom error message' );
};

subtest 'is_code_reference' => sub {

    is( is_code_reference->( sub { } ), undef, "ok" );


    for my $value ( 0, -3, -3.2, 'Lake Street' ) {

        is(
            is_code_reference->( $value ),
            'Not a code reference',
            "value = $value"
        );

    }

    is( is_code_reference( 'Bogus' )->( 'Lake Street' ),
        'Bogus', 'custom error message' );
};

subtest 'is_instance_of' => sub {

    is( is_instance_of( 'MyClass' )->( bless {}, 'MyClass' ), undef, "ok" );


    for my $value ( 0, -3, -3.2, 'Lake Street' ) {

        is(
            is_instance_of( 'MyClass' )->( $value ),
            'Not an instance of MyClass',
            "value = $value"
        );

    }

    is( is_instance_of( 'MyClass', 'Bogus' )->( 'Lake Street' ),
        'Bogus', 'custom error message' );
};

subtest 'is_any_of' => sub {

    my $sub
      = is_any_of( [ is_instance_of( 'MyClass' ), is_positive_integer, ], );

    for my $value ( 3, bless( {}, 'MyClass' ) ) {

        is( $sub->( $value ), undef, "value = $value" );
    }

    for my $value ( 0, -3, -3.2, 'Lake Street' ) {

        is( $sub->( $value ), 'Did not match any criteria', "value = $value" );

    }

    is(
        is_any_of( [ is_instance_of( 'MyClass' ), is_positive_integer, ],
            'Bogus' )->( 'Lake Street' ),
        'Bogus',
        'custom error message'
    );
};

subtest 'is_undef' => sub {

    is( is_undef->( undef ), undef, "ok" );


    for my $value ( 0, -3, -3.2, 'Lake Street' ) {

        is( is_undef->( $value ), 'Is defined', "value = $value" );

    }

    is( is_undef('Bogus')->( 'Lake Street' ), 'Bogus', 'custom error message' );
};



done_testing;
