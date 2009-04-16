use inc::Module::Install;
name 'Hatetter';
all_from 'lib/Hatetter.pm';

# requires '';

tests 't/*.t t/*/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
