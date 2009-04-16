use strict;
use warnings;
use Test::More tests => 2;

BEGIN {
    *Test::Memcached::get = sub {};
    *Test::Memcached::set = sub {};
}

use HTTP::Request::Common;
use HTTP::Engine::Test::Request;

use Hatetter::Web;

my $web = Hatetter::Web->new;
do {
    no warnings 'redefine';
    local *Hatetter::Model::Memcached::cache = sub { 'Test::Memcached' };

    my $req = HTTP::Engine::Test::Request->new(
        GET 'http://example.com/example/statuses/friends_timeline.json?callback=CB',
    );

    my $res = $web->handler($req);
    is($res->body, 'CB([]);', 'jsonp');
    is_deeply([ $res->content_type ], ['application/json', 'charset=UTF-8'], 'response content-type');
};
