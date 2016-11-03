#! perl

use strict;
use warnings;
use inc::Module::Install;

name 'Validate-TinyX-Checks-Common';
license 'gpl3';
auto_license( holder => 'Smithsonian Astrophysical Observatory' );
all_from 'lib/Validate/TinyX/Checks/Common.pm';

readme_from;
readme_from '', { format => 'md' };;

resources (
   license    => 'http://www.gnu.org/licenses/gpl-3.0.html',
   repository => 'https://github.com/djerius/Validate-TinyX-Checks-Common',
   bugtracker => 'https://rt.cpan.org/Public/Dist/Display.html?Name=Validate-TinyX-Checks-Common',
);

author_tests( 'xt' );

tests_recursive;

cpanfile;

WriteAll;
