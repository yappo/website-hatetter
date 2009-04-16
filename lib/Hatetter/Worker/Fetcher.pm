package Hatetter::Worker::Fetcher;
use Mouse;

use LWP::UserAgent;

use Hatetter::Model::Feed;
use Hatetter::Model::Memcached;
use Hatetter::Model::Queue;

has 'feed' => (
    is       => 'ro',
    isa      => 'Hatetter::Model::Feed',
    required => 1,
    default  => sub {
        Hatetter::Model::Feed->new;
    },
);

has 'memcached' => (
    is       => 'ro',
    isa      => 'Hatetter::Model::Memcached',
    required => 1,
    default  => sub {
        Hatetter::Model::Memcached->new;
    },
);

has 'queue' => (
    is       => 'ro',
    isa      => 'Hatetter::Model::Queue',
    required => 1,
    default  => sub {
        Hatetter::Model::Queue->new;
    },
);

has 'ua' => (
    is       => 'ro',
    isa      => 'LWP::UserAgent',
    required => 1,
    default  => sub {
        LWP::UserAgent->new;
    },
);

sub running {
    my $self = shift;

    my $retry;
    $self->queue->queue_running(
        'fetch_queue:retry>=3'           => sub {
            # trash for queue
            my $row = shift;
            $retry = $row->retry;
        },
        'fetch_queue:running_at<'.time() => sub {
            my $row = shift;
            $retry = $row->retry;

            my $res = $self->ua->get(sprintf 'http://b.hatena.ne.jp/%s/favorite.rss', $row->id);
            my $success = 0;

            if ($res->is_success) {
                my $method;
                if ($row->type == $self->queue->TYPE_JSON) {
                    $method = 'to_json';
                } elsif ($row->type == $self->queue->TYPE_XML) {
                    $method = 'to_xml';
                } else {
                    return; # wtf?
                }
                my $data = $self->feed->$method($res->content);
                if ($data) {
                    if ($self->memcached->set('contents:' . $row->type . ':' . $row->id, $data)) {
                        $success = 1;
                    }
                }
            }

            unless ($success) {
                $self->queue->set(
                    fetch_queue => {
                        id         => $row->id,
                        retry      => $row->retry + 1,
                        type       => $row->type,
                        running_at => time()+5,
                    },
                );
            }
        },
    );
    $retry;
}


__PACKAGE__->meta->make_immutable;

