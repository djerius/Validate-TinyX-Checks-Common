#!perl -T

use Test::More;

BEGIN {
  use_ok('Validate::TinyX::Checks::Common');
}

diag( "Testing Validate::TinyX::Checks::Common $Validate::TinyX::Checks::Common::VERSION, Perl $], $^X" );

done_testing;
