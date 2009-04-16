package Hatetter::Model::Queue;
use strict;
use warnings;
use base 'Data::Model';
use Data::Model::Mixin modules => ['Queue::Q4M'];

use Data::Model::Schema;
use Data::Model::Driver::Queue::Q4M;

BEGIN {
    $ENV{Q4M_DSN}     ||= 'dbi:mysql:database=test_hatetter';
    $ENV{Q4M_TIMEOUT} ||= 10;
};

my $driver = Data::Model::Driver::Queue::Q4M->new(
    dsn      => $ENV{Q4M_DSN},
    username => $ENV{Q4M_USERNAME},
    password => $ENV{Q4M_PASSWORD},
    timeout  => $ENV{Q4M_TIMEOUT},
);

base_driver $driver;

install_model fetch_queue => schema {
    column id
            => char => {
                size => 100,
            };
    column type       => 'tinyint';
    column retry      => 'tinyint';
    column running_at
        => int => {
            default => sub { time() + 30 },
        };
};

sub TYPE_JSON () { 1 } ## no critic
sub TYPE_XML  () { 2 } ## no critic


1;

