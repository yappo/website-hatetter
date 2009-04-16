use strict;
use warnings;
use Test::More tests => 32;

use Hatetter::Model::Queue;

# generate mock class
BEGIN {
    my $is   = \&is;
    my $like = \&like;

    for my $type (qw/ json xml /) {
        for my $suffix ('_empty', '') {
            my $i = 0;
            no strict 'refs';

            my $id;
            my $retval;
            if ($type eq 'json') {
                $id = Hatetter::Model::Queue->TYPE_JSON . ':example';
                $retval = '[{"dummy":"data"}]' unless $suffix;
            } else {
                $id = Hatetter::Model::Queue->TYPE_XML  . ':example2';
                $retval = '<dummy></dummy>' unless $suffix;
            }

            *{"Test::Memcached::${type}${suffix}::get"} = sub {
                if ($i++) {
                    $is->($_[1], "contents:$id", 'memcached get ' . $type);
                    return $retval;
                } else {
                    $is->($_[1], "update_at:$id", 'memcached get update_at');
                    return;
                }
            };

            *{"Test::Memcached::${type}${suffix}::set"} = sub {
                my($self, $key, $value) = @_;
                $is->($key, "update_at:$id", 'memcached set update_at');
                $like->($value, qr/\A[0-9]+\z/, 'update_at value');
            }
        }
    }

    {
        package Test::Memcached::not_create_queue;

        my $json = Hatetter::Model::Queue->TYPE_JSON;
        my $i = 0;
        sub get {
            if ($i++) {
                $is->($_[1], "contents:${json}:example3", 'memcached get json');
                return;
            } else {
                $is->($_[1], "update_at:${json}:example3", 'memcached get update_at');
                return time();
            }
        }
    }
}

use HTTP::Request::Common;
use HTTP::Engine::Test::Request;

use Hatetter::Web;

my $web = Hatetter::Web->new;

no warnings 'once', 'redefine';
*Hatetter::Model::Queue::set = sub { ok(1, 'queue insert' )};

# json cache not found
do {
    local *Hatetter::Model::Memcached::cache = sub { 'Test::Memcached::json_empty' };

    my $req = HTTP::Engine::Test::Request->new(
        GET 'http://example.com/example/statuses/friends_timeline.json',
    );

    my $res = $web->handler($req);
    is($res->body, '[]', 'json empty response body');
    is_deeply([ $res->content_type ], ['application/json', 'charset=UTF-8'], 'response content-type');
};

# json cache hit
do {
    local *Hatetter::Model::Memcached::cache = sub { 'Test::Memcached::json' };

    my $req = HTTP::Engine::Test::Request->new(
        GET 'http://example.com/example/statuses/friends_timeline.json',
    );

    my $res = $web->handler($req);
    is($res->body, '[{"dummy":"data"}]', 'json empty response body');
    is_deeply([ $res->content_type ], ['application/json', 'charset=UTF-8'], 'response content-type');
};

# xml cache not found
do {
    local *Hatetter::Model::Memcached::cache = sub { 'Test::Memcached::xml_empty' };

    my $req = HTTP::Engine::Test::Request->new(
        GET 'http://example.com/example2/statuses/friends_timeline.xml',
    );

    my $res = $web->handler($req);
    is($res->body, '<statuses></statuses>', 'xml empty response body');
    is($res->content_type, 'application/xml', 'response content-type');
};

# xml cache hit
do {
    local *Hatetter::Model::Memcached::cache = sub { 'Test::Memcached::xml' };

    my $req = HTTP::Engine::Test::Request->new(
        GET 'http://example.com/example2/statuses/friends_timeline.xml',
    );

    my $res = $web->handler($req);
    is($res->body, '<dummy></dummy>', 'xml empty response body');
    is($res->content_type, 'application/xml', 'response content-type');
};


# not create queue
do {
    local *Hatetter::Model::Memcached::cache = sub { 'Test::Memcached::not_create_queue' };

    my $req = HTTP::Engine::Test::Request->new(
        GET 'http://example.com/example3/statuses/friends_timeline.json',
    );

    my $res = $web->handler($req);
    is($res->body, '[]', 'json empty response body');
    is_deeply([ $res->content_type ], ['application/json', 'charset=UTF-8'], 'response content-type');
};
