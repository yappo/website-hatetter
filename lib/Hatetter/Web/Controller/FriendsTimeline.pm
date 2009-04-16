package Hatetter::Web::Controller::FriendsTimeline;
use Mouse;

use HTTP::Engine::Response;

sub create_queue {
    my($self, $c, $id, $type) = @_;
    my $update_at = $c->model_memcached->get("update_at:${type}:$id");
    return if $update_at && $update_at > time() - 300;

    $c->model_queue->set(
        fetch_queue => {
            id         => $id,
            retry      => 0,
            type       => $type,
        },
    );
    $c->model_memcached->set("update_at:${type}:$id", time());
}

sub _generator {
    my($self, $c, $id, $type) = @_;

    $self->create_queue($c, $id, $type);
    my $body = $c->model_memcached->get("contents:${type}:${id}");
    HTTP::Engine::Response->new(
        body         => $body,
        code         => 200,
    );
}

sub json {
    my($self, $c, $req, $args) = @_;
    my $res = $self->_generator($c, $args->{id}, $c->model_queue->TYPE_JSON);
    $res->body('[]') unless $res->body;
    $res->content_type('application/json; charset=UTF-8');

    # for josnp
    if (my $callback = $req->param('callback')) {
        if ($callback =~ /^[a-zA-Z0-9\.\_\[\]]+$/) {
            $res->body(sprintf '%s(%s);', $callback, $res->body);
        }
    }
    $res;
}

sub xml {
    my($self, $c, $req, $args) = @_;
    my $res = $self->_generator($c, $args->{id}, $c->model_queue->TYPE_XML);
    $res->body('<statuses></statuses>') unless $res->body;
    $res->content_type('application/xml');
    $res;
}

__PACKAGE__->meta->make_immutable;
