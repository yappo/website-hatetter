use strict;
use warnings;
use lib 'lib';
use File::Spec;

use HTTP::Engine;
use HTTP::Engine::Middleware;
use Hatetter::Web;


my $mw = HTTP::Engine::Middleware->new;
$mw->install(
    'HTTP::Engine::Middleware::Static' => {
        regexp  => qr{\A/(favicon.ico|robots.txt|index.html)\z},
        docroot => File::Spec->catfile('htdocs'),
    },
);
my $web = Hatetter::Web->new;

HTTP::Engine->new(
    interface => {
        module          => 'ServerSimple',
        args            => { host => '0.0.0.0', port => '8107' },
        request_handler => $mw->handler(sub {
            my $req = shift;
            $web->handler($req);
        }),
    },
)->run;
