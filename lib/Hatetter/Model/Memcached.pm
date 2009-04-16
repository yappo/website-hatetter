package Hatetter::Model::Memcached;
use Mouse;
use Cache::Memcached::Fast;

has cache => (
    is      => 'ro',
    isa     => 'Cache::Memcached::Fast',
    default => sub {
        Cache::Memcached::Fast->new({
            servers   => [ { address => 'localhost:11211' }, ],
            namespace => 'hatetter',
        });
    },
    handles => [qw/set get/],
);

__PACKAGE__->meta->make_immutable;
