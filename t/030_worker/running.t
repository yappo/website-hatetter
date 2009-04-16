use strict;
use warnings;
use Test::More;
use File::Spec;
use DBI;

my $is_running = 0;
plan skip_all => "Set TEST_Q4M environment variable to run this test"
    unless $ENV{TEST_Q4M};
$is_running = 1;
plan  tests => 19;

BEGIN {
    $ENV{Q4M_DSN}     ||= 'dbi:mysql:database=test';
    $ENV{Q4M_TIMEOUT} ||= 2;
}

my $feed = do {
    open my $fh, File::Spec->catfile(qw/ t assets antenna.rss /) or die $!;
    local $/;
    <$fh>
};

my $is = \&is;

use LWP::UserAgent;
use HTTP::Response;

use Hatetter::Model::Memcached;
use Hatetter::Model::Queue;
use Hatetter::Worker::Fetcher;

my $queue = Hatetter::Model::Queue->new;


# teardown db
sub teardown_db {
    my $dbh = DBI->connect($ENV{Q4M_DSN},
                           '', '', { RaiseError => 1, PrintError => 0 });
    for my $sql ($queue->as_sqls) {
        $dbh->do( 'DROP TABLE IF EXISTS fetch_queue' );
    }
    $dbh->disconnect;
}
END {
    teardown_db() if $is_running;
}

# setup db
do {
    teardown_db();
    my $dbh = DBI->connect($ENV{Q4M_DSN},
                           '', '', { RaiseError => 1, PrintError => 0 });
    for my $sql ($queue->as_sqls) {
        $dbh->do( $sql );
    }
    $dbh->disconnect;
};

my $fetcher = Hatetter::Worker::Fetcher->new({ queue => $queue, memcached => Test::Model::Memcached->new });

# success
do {
    no warnings 'redefine';
    *LWP::UserAgent::request = sub {
        my($self, $request, $arg, $size, $previous) = @_;
        is($request->uri, 'http://www.hatena.ne.jp/example/antenna.rss', 'request uri');
        my $res = HTTP::Response->new( 200 );
        $res->content( $feed );
        $res;
    };

    $queue->set(
        fetch_queue => {
            id         => 'example',
            retry      => 0,
            type       => $queue->TYPE_JSON,
            running_at => 0,
        },
    );

    my $ret = $fetcher->running;
    is($ret, 0, 'is not retry');

    my @q = $queue->get( 'fetch_queue' );
    ok(!scalar(@q), 'empty queue');

};

# retry
do {
    no warnings 'redefine';
    *LWP::UserAgent::request = sub {
        my($self, $request, $arg, $size, $previous) = @_;
        is($request->uri, 'http://www.hatena.ne.jp/example/antenna.rss', "request uri: times");
        HTTP::Response->new( 500, '' );
    };

    $queue->set(
        fetch_queue => {
            id         => 'example',
            retry      => 0,
            type       => $queue->TYPE_XML,
            running_at => 0,
        },
    );

    # first running
    my $ret = $fetcher->running;
    is($ret, 0, "first time");
    my @q = $queue->get( 'fetch_queue' );
    ok(scalar(@q), 'exists queue');
    is($q[0]->retry, 1, 'retry on queue');

    # retry loop
    for my $i (2..3) {
        $ret = $fetcher->running; # dummy
        sleep 6; # waiting for next running_at
        $ret = $fetcher->running;
        is($ret, $i - 1, "retry times is $i");

        my @q = $queue->get( 'fetch_queue' );
        ok(scalar(@q), 'exists queue');
        is($q[0]->retry, $i, 'retry on queue');
    }

    # cleanup queue
    $ret = $fetcher->running;
    is($ret, 3, 'cleanup queue');
    @q = $queue->get( 'fetch_queue' );
    ok(!scalar(@q), 'empty queue');
};


{
    package Test::Model::Memcached;
    use strict;
    use warnings;
    use base 'Hatetter::Model::Memcached';

    sub new { bless {},shift }

    sub set {
        my($self, $key, $value) = @_;
        $is->($key, 'contents:'.$queue->TYPE_JSON.':example', 'memcached set key');
        $is->(!!$value, !!1, 'memcached set value');
        1;
    }

}
