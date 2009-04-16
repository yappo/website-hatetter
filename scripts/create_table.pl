use strict;
use warnings;
use lib 'lib';
use Hatetter::Model::Queue;
for my $sql (Hatetter::Model::Queue->as_sqls) {
    print "$sql\n";
}
