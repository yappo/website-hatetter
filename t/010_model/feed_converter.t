use strict;
use warnings;
use Test::More tests => 3;
use File::Spec;
use Hatetter::Model::Feed;

my $feed = do {
    open my $fh, File::Spec->catfile(qw/ t assets test.rss /) or die $!;
    local $/;
    <$fh>
};

my $timeline = Hatetter::Model::Feed->convert($feed);
is_deeply($timeline, [
    {
        'source' => 'Hatena::Bookmark',
        'favorited' => '',
        'truncated' => 'false',
        'created_at' => 'Wed Apr 15 08:55:02 +0900 2009',
        'text' => "\x{3059}\x{3070}\x{3089}\x{3057}\x{3044}\x{3002}\x{79c1}\x{306f}\x{3053}\x{3046}\x{3044}\x{3046}\x{306e}\x{3092}\x{5f85}\x{3063}\x{3066}\x{3044}\x{305f}\x{3002} http://www.example.com/",
        'user' => {
            'location' => '',
            'followers_count' => 1,
            'protected' => 'false',
            'profile_image_url' => 'http://www.hatena.ne.jp/users/ex/example/profile.gif',
            'name' => 'example',
            'description' => '',
            'url' => '',
            'id' => 'example',
            'screen_name' => 'example'
        },
        'id' => 'example:1239753302',
    },
    {
        'source' => 'Hatena::Bookmark',
        'favorited' => '',
        'truncated' => 'false',
        'created_at' => 'Wed Apr 15 08:50:44 +0900 2009',
        'text' => ' http://internet.watch.example.co.jp/',
        'user' => {
            'location' => '',
            'followers_count' => 1,
            'protected' => 'false',
            'profile_image_url' => 'http://www.hatena.ne.jp/users/ex/example2/profile.gif',
            'name' => 'example2',
            'description' => '',
            'url' => '',
            'id' => 'example2',
            'screen_name' => 'example2'
        },
        'id' => 'example2:1239753044',
    },
    {
        'source' => 'Hatena::Bookmark',
        'favorited' => '',
        'truncated' => 'false',
        'created_at' => 'Wed Apr 15 08:36:12 +0900 2009',
        'text' => ' http://www.nntp.perl.example.org/group/perl.moose/2009/04/msg683.html',
        'user' => {
            'location' => '',
            'followers_count' => 1,
            'protected' => 'false',
            'profile_image_url' => 'http://www.hatena.ne.jp/users/ex/example3/profile.gif',
            'name' => 'example3',
            'description' => '',
            'url' => '',
            'id' => 'example3',
            'screen_name' => 'example3'
        },
        'id' => 'example3:1239752172',
    }
], 'twitter convert');


my $json = Hatetter::Model::Feed->to_json($feed);
is("$json\n", <<'END', 'to_json');
[{"truncated":"false","source":"Hatena::Bookmark","favorited":"","created_at":"Wed Apr 15 08:55:02 +0900 2009","text":"\u3059\u3070\u3089\u3057\u3044\u3002\u79c1\u306f\u3053\u3046\u3044\u3046\u306e\u3092\u5f85\u3063\u3066\u3044\u305f\u3002 http://www.example.com/","user":{"location":"","followers_count":1,"protected":"false","profile_image_url":"http://www.hatena.ne.jp/users/ex/example/profile.gif","name":"example","description":"","url":"","id":"example","screen_name":"example"},"id":"example:1239753302"},{"truncated":"false","source":"Hatena::Bookmark","favorited":"","created_at":"Wed Apr 15 08:50:44 +0900 2009","text":" http://internet.watch.example.co.jp/","user":{"location":"","followers_count":1,"protected":"false","profile_image_url":"http://www.hatena.ne.jp/users/ex/example2/profile.gif","name":"example2","description":"","url":"","id":"example2","screen_name":"example2"},"id":"example2:1239753044"},{"truncated":"false","source":"Hatena::Bookmark","favorited":"","created_at":"Wed Apr 15 08:36:12 +0900 2009","text":" http://www.nntp.perl.example.org/group/perl.moose/2009/04/msg683.html","user":{"location":"","followers_count":1,"protected":"false","profile_image_url":"http://www.hatena.ne.jp/users/ex/example3/profile.gif","name":"example3","description":"","url":"","id":"example3","screen_name":"example3"},"id":"example3:1239752172"}]
END

my $xml = Hatetter::Model::Feed->to_xml($feed);
is($xml, <<'END', 'to_xml');
<?xml version="1.0" encoding="UTF-8"?>
<statuses type="array">
  <status>
    <id>example:1239753302</id>
    <created_at>Wed Apr 15 08:55:02 +0900 2009</created_at>
    <favorited></favorited>
    <source>Hatena::Bookmark</source>
    <text>&#12377;&#12400;&#12425;&#12375;&#12356;&#12290;&#31169;&#12399;&#12371;&#12358;&#12356;&#12358;&#12398;&#12434;&#24453;&#12387;&#12390;&#12356;&#12383;&#12290; http://www.example.com/</text>
    <truncated>false</truncated>
    <user>
      <name>example</name>
      <description></description>
      <followers_count>1</followers_count>
      <id>example</id>
      <location></location>
      <profile_image_url>http://www.hatena.ne.jp/users/ex/example/profile.gif</profile_image_url>
      <protected>false</protected>
      <screen_name>example</screen_name>
      <url></url>
    </user>
  </status>
  <status>
    <id>example2:1239753044</id>
    <created_at>Wed Apr 15 08:50:44 +0900 2009</created_at>
    <favorited></favorited>
    <source>Hatena::Bookmark</source>
    <text> http://internet.watch.example.co.jp/</text>
    <truncated>false</truncated>
    <user>
      <name>example2</name>
      <description></description>
      <followers_count>1</followers_count>
      <id>example2</id>
      <location></location>
      <profile_image_url>http://www.hatena.ne.jp/users/ex/example2/profile.gif</profile_image_url>
      <protected>false</protected>
      <screen_name>example2</screen_name>
      <url></url>
    </user>
  </status>
  <status>
    <id>example3:1239752172</id>
    <created_at>Wed Apr 15 08:36:12 +0900 2009</created_at>
    <favorited></favorited>
    <source>Hatena::Bookmark</source>
    <text> http://www.nntp.perl.example.org/group/perl.moose/2009/04/msg683.html</text>
    <truncated>false</truncated>
    <user>
      <name>example3</name>
      <description></description>
      <followers_count>1</followers_count>
      <id>example3</id>
      <location></location>
      <profile_image_url>http://www.hatena.ne.jp/users/ex/example3/profile.gif</profile_image_url>
      <protected>false</protected>
      <screen_name>example3</screen_name>
      <url></url>
    </user>
  </status>
</statuses>
END
