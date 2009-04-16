package Hatetter::Model::Feed;
use Mouse;

use JSON::XS ();
use XML::Feed;
use XML::Simple ();

sub convert {
    my($class, $xml) = @_;

    my $feed = XML::Feed->parse(\$xml)
        or die XML::Feed->errstr;

    my @timeline;
    for my $entry ($feed->entries) {

        my $time   = $entry->issued->epoch;
        my $author = $entry->author;

        my $timeline = $class->_to_timeline({
            id         => "$author:$time",
            author     => $author,
            created_at => $entry->issued->strftime('%a %b %d %T %z %Y'),
            text       => sprintf('%s %s', $entry->{entry}->{description} || '', $entry->link),
        });

        push @timeline, $timeline;
    }
    \@timeline;
}

sub _to_timeline {
    my($class, $args) = @_;

    my($author_prefix) = $args->{author} =~ /^(..)/;

    my $tmp = {
        created_at            => $args->{created_at},
        id                    => $args->{id},
        text                  => $args->{text},
        source                => 'Hatena::Bookmark',
        truncated             => 'false',
        favorited             => '',
        user => {
            id                => $args->{author},
            name              => $args->{author},
            screen_name       => $args->{author},
            location          => '',
            description       => '',
            profile_image_url => sprintf('http://www.hatena.ne.jp/users/%s/%s/profile.gif', $author_prefix, $args->{author}),
            url               => '',
            protected         => 'false',
            followers_count   => 1,
        },
    };
}

sub to_json {
    my $class = shift;
    my $timeline = $class->convert(@_);
    return '[]' unless @{ $timeline };
    JSON::XS->new->ascii->encode($timeline);
}

sub to_xml {
    my $class = shift;
    my $timeline = $class->convert(@_);
    return '<statuses></statuses>' unless @{ $timeline };
    my $data     = {
        statuses => {
            status => $timeline,
        },
    };

    my $xml = XML::Simple::XMLout($data, NoAttr => 1, KeepRoot => 1, NumericEscape => 3 );
    $xml =~ s/<statuses>/<statuses type="array">/;
    $xml = qq{<?xml version="1.0" encoding="UTF-8"?>\n$xml};
    $xml;
}

__PACKAGE__->meta->make_immutable;

