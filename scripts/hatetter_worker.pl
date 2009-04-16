use strict;
use warnings;
use lib 'lib';

use Hatetter::Worker::Fetcher;

my $worker = Hatetter::Worker::Fetcher->new;

while (1) {
    $worker->running;
}
