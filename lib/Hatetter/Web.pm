package Hatetter::Web;
use Mouse;
use HTTP::Engine::Response;

use Hatetter::Model::Queue;
use Hatetter::Model::Memcached;
use Hatetter::Web::Controller::FriendsTimeline;


has 'controller_friend_timeline' => (
    is       => 'ro',
    required => 1,
    default  => sub {
        Hatetter::Web::Controller::FriendsTimeline->new
    },
);

has 'model_queue' => (
    is       => 'ro',
    required => 1,
    default  => sub {
        Hatetter::Model::Queue->new
    },
);

has 'model_memcached' => (
    is       => 'ro',
    required => 1,
    default  => sub {
        Hatetter::Model::Memcached->new
    },
);

sub handler {
    my($self, $req) = @_;

    if ($req->path =~ m{\A/([a-zA-Z0-9_-]+)/statuses/friends_timeline\.(json|xml)\z}) {
        return $self->controller_friend_timeline->$2($self, $req, { id => $1 });
    } elsif ($req->path eq '/') {
        return HTTP::Engine::Response->new( body => 'redirect', status => 302, headers => { location => '/index.html' } );
    } else {
        return HTTP::Engine::Response->new( body => 'not_found', status => 404 );
    }

}

__PACKAGE__->meta->make_immutable;

