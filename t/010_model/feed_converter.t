use strict;
use warnings;
use Test::More tests => 3;
use File::Spec;
use Hatetter::Model::Feed;

my $feed = do {
    open my $fh, File::Spec->catfile(qw/ t assets antenna.rss /) or die $!;
    local $/;
    <$fh>
};

my $timeline = Hatetter::Model::Feed->convert($feed);
is_deeply($timeline, [
    {
        'truncated' => 'false',
        'source' => "\x{306f}\x{3066}\x{306a}\x{30d6}\x{30c3}\x{30af}\x{30de}\x{30fc}\x{30af}",
        'favorited' => '',
        'created_at' => 'Thu Apr 16 14:39:45 +0900 2009',
        'text' => "[\x{30d6}\x{30c3}\x{30af}\x{30de}] http://example.com/2009/04/ssd.html | ssd  - \x{6700}\x{524d}\x{7dda}",
        'user' => {
            'location' => '',
            'followers_count' => 1,
            'protected' => 'false',
            'profile_image_url' => 'http://www.hatena.ne.jp/users/ex/example-1/profile.gif',
            'name' => 'example-1',
            'description' => '',
            'url' => '',
            'id' => 'example-1',
            'screen_name' => 'example-1'
        },
        'id' => 'example-1:1239860385'
    },
    {
        'truncated' => 'false',
        'source' => "\x{306f}\x{3066}\x{306a}\x{30c0}\x{30a4}\x{30a2}\x{30ea}\x{30fc}",
        'favorited' => '',
        'created_at' => 'Thu Apr 16 14:14:35 +0900 2009',
        'text' => "[\x{30c0}\x{30a4}\x{30a2}\x{30ea}] http://d.hatena.ne.jp/example-2/20090416/1239858875 |  \x{65e5}\x{8a18}\x{306e}\x{3088}\x{3046}\x{3084}\x{304f}\x{3060}\x{3088}\x{ff01} -  \x{65e5}\x{8a18}\x{306e}\x{30bf}\x{30a4}\x{30c8}\x{30eb}\x{3060}\x{3088}\x{ff01}",
        'user' => {
            'location' => '',
            'followers_count' => 1,
            'protected' => 'false',
            'profile_image_url' => 'http://www.hatena.ne.jp/users/ex/example-2/profile.gif',
            'name' => 'example-2',
            'description' => '',
            'url' => '',
            'id' => 'example-2',
            'screen_name' => 'example-2'
        },
        'id' => 'example-2:1239858875'
    },
    {
        'truncated' => 'false',
        'source' => "\x{306f}\x{3066}\x{306a}\x{30b0}\x{30eb}\x{30fc}\x{30d7}",
        'favorited' => '',
        'created_at' => 'Thu Apr 16 10:51:55 +0900 2009',
        'text' => "[\x{30b0}\x{30eb}\x{30fc}\x{30d7}] http://example.g.hatena.ne.jp/example-3/20090416/1239846715 |  \x{306a}\x{3093}\x{3067}\x{30b0}\x{30eb}\x{30fc}\x{30d7}\x{306e}description\x{306f} \x{3053}\x{3093}\x{306a}\x{5f62}\x{306b} \x{306a}\x{3063}\x{3066}\x{3093}\x{306d}\x{3093} \x{306a}\x{3093}\x{3067}\x{306a}\x{3093}\x{3067}\x{ff1f} - \x{30b0}\x{30eb}\x{30fc}\x{30d7}\x{306e}\x{65e5}\x{8a18}\x{30bf}\x{30a4}\x{30c8}\x{30eb}",
        'user' => {
            'location' => '',
            'followers_count' => 1,
            'protected' => 'false',
            'profile_image_url' => 'http://www.hatena.ne.jp/users/ex/example-3/profile.gif',
            'name' => 'example-3',
            'description' => '',
            'url' => '',
            'id' => 'example-3',
            'screen_name' => 'example-3'
        },
        'id' => 'example-3:1239846715'
    },
    {
        'truncated' => 'false',
        'source' => "\x{306f}\x{3066}\x{306a}\x{30cf}\x{30a4}\x{30af}",
        'favorited' => '',
        'created_at' => 'Thu Apr 16 08:47:30 +0900 2009',
        'text' => "[\x{30cf}\x{30a4}\x{30af}] http://h.hatena.ne.jp/jkondo/9234279931701694716 |  - id:jkondo",
        'user' => {
            'location' => '',
            'followers_count' => 1,
            'protected' => 'false',
            'profile_image_url' => 'http://www.hatena.ne.jp/users/jk/jkondo/profile.gif',
            'name' => 'jkondo',
            'description' => '',
            'url' => '',
            'id' => 'jkondo',
            'screen_name' => 'jkondo'
        },
        'id' => 'jkondo:1239839250'
    },
    {
        'truncated' => 'false',
        'source' => "\x{306f}\x{3066}\x{306a}\x{30d5}\x{30a9}\x{30c8}\x{30e9}\x{30a4}\x{30d5}",
        'favorited' => '',
        'created_at' => 'Thu Apr 16 00:50:45 +0900 2009',
        'text' => "[\x{30d5}\x{30a9}\x{30c8}\x{30e9}] http://f.hatena.ne.jp/example-4/20090416005045 |  - 20090416005045",
        'user' => {
            'location' => '',
            'followers_count' => 1,
            'protected' => 'false',
            'profile_image_url' => 'http://www.hatena.ne.jp/users/ex/example-4/profile.gif',
            'name' => 'example-4',
            'description' => '',
            'url' => '',
            'id' => 'example-4',
            'screen_name' => 'example-4'
        },
        'id' => 'example-4:1239810645'
    },
    {
        'truncated' => 'false',
        'source' => "My\x{306f}\x{3066}\x{306a}",
        'favorited' => '',
        'created_at' => 'Wed Apr 15 01:38:27 +0900 2009',
        'text' => "[My\x{306f}\x{3066}] http://www.hatena.ne.jp/example-4/ |  example-4\x{3055}\x{3093}\x{304c}\x{30d7}\x{30ed}\x{30d5}\x{30a3}\x{30fc}\x{30eb}\x{3092}\x{66f4}\x{65b0}\x{3057}\x{307e}\x{3057}\x{305f} - example-4\x{3055}\x{3093}\x{304c}\x{30d7}\x{30ed}\x{30d5}\x{30a3}\x{30fc}\x{30eb}\x{3092}\x{66f4}\x{65b0}\x{3057}\x{307e}\x{3057}\x{305f}",
        'user' => {
            'location' => '',
            'followers_count' => 1,
            'protected' => 'false',
            'profile_image_url' => 'http://www.hatena.ne.jp/users/ex/example-4/profile.gif',
            'name' => 'example-4',
            'description' => '',
            'url' => '',
            'id' => 'example-4',
            'screen_name' => 'example-4'
        },
        'id' => 'example-4:1239727107'
    }
], 'twitter convert');

my $json = Hatetter::Model::Feed->to_json($feed);
is("$json\n", <<'END', 'to_json');
[{"truncated":"false","source":"\u306f\u3066\u306a\u30d6\u30c3\u30af\u30de\u30fc\u30af","favorited":"","created_at":"Thu Apr 16 14:39:45 +0900 2009","text":"[\u30d6\u30c3\u30af\u30de] http://example.com/2009/04/ssd.html | ssd  - \u6700\u524d\u7dda","user":{"location":"","followers_count":1,"protected":"false","profile_image_url":"http://www.hatena.ne.jp/users/ex/example-1/profile.gif","name":"example-1","description":"","url":"","id":"example-1","screen_name":"example-1"},"id":"example-1:1239860385"},{"truncated":"false","source":"\u306f\u3066\u306a\u30c0\u30a4\u30a2\u30ea\u30fc","favorited":"","created_at":"Thu Apr 16 14:14:35 +0900 2009","text":"[\u30c0\u30a4\u30a2\u30ea] http://d.hatena.ne.jp/example-2/20090416/1239858875 |  \u65e5\u8a18\u306e\u3088\u3046\u3084\u304f\u3060\u3088\uff01 -  \u65e5\u8a18\u306e\u30bf\u30a4\u30c8\u30eb\u3060\u3088\uff01","user":{"location":"","followers_count":1,"protected":"false","profile_image_url":"http://www.hatena.ne.jp/users/ex/example-2/profile.gif","name":"example-2","description":"","url":"","id":"example-2","screen_name":"example-2"},"id":"example-2:1239858875"},{"truncated":"false","source":"\u306f\u3066\u306a\u30b0\u30eb\u30fc\u30d7","favorited":"","created_at":"Thu Apr 16 10:51:55 +0900 2009","text":"[\u30b0\u30eb\u30fc\u30d7] http://example.g.hatena.ne.jp/example-3/20090416/1239846715 |  \u306a\u3093\u3067\u30b0\u30eb\u30fc\u30d7\u306edescription\u306f \u3053\u3093\u306a\u5f62\u306b \u306a\u3063\u3066\u3093\u306d\u3093 \u306a\u3093\u3067\u306a\u3093\u3067\uff1f - \u30b0\u30eb\u30fc\u30d7\u306e\u65e5\u8a18\u30bf\u30a4\u30c8\u30eb","user":{"location":"","followers_count":1,"protected":"false","profile_image_url":"http://www.hatena.ne.jp/users/ex/example-3/profile.gif","name":"example-3","description":"","url":"","id":"example-3","screen_name":"example-3"},"id":"example-3:1239846715"},{"truncated":"false","source":"\u306f\u3066\u306a\u30cf\u30a4\u30af","favorited":"","created_at":"Thu Apr 16 08:47:30 +0900 2009","text":"[\u30cf\u30a4\u30af] http://h.hatena.ne.jp/jkondo/9234279931701694716 |  - id:jkondo","user":{"location":"","followers_count":1,"protected":"false","profile_image_url":"http://www.hatena.ne.jp/users/jk/jkondo/profile.gif","name":"jkondo","description":"","url":"","id":"jkondo","screen_name":"jkondo"},"id":"jkondo:1239839250"},{"truncated":"false","source":"\u306f\u3066\u306a\u30d5\u30a9\u30c8\u30e9\u30a4\u30d5","favorited":"","created_at":"Thu Apr 16 00:50:45 +0900 2009","text":"[\u30d5\u30a9\u30c8\u30e9] http://f.hatena.ne.jp/example-4/20090416005045 |  - 20090416005045","user":{"location":"","followers_count":1,"protected":"false","profile_image_url":"http://www.hatena.ne.jp/users/ex/example-4/profile.gif","name":"example-4","description":"","url":"","id":"example-4","screen_name":"example-4"},"id":"example-4:1239810645"},{"truncated":"false","source":"My\u306f\u3066\u306a","favorited":"","created_at":"Wed Apr 15 01:38:27 +0900 2009","text":"[My\u306f\u3066] http://www.hatena.ne.jp/example-4/ |  example-4\u3055\u3093\u304c\u30d7\u30ed\u30d5\u30a3\u30fc\u30eb\u3092\u66f4\u65b0\u3057\u307e\u3057\u305f - example-4\u3055\u3093\u304c\u30d7\u30ed\u30d5\u30a3\u30fc\u30eb\u3092\u66f4\u65b0\u3057\u307e\u3057\u305f","user":{"location":"","followers_count":1,"protected":"false","profile_image_url":"http://www.hatena.ne.jp/users/ex/example-4/profile.gif","name":"example-4","description":"","url":"","id":"example-4","screen_name":"example-4"},"id":"example-4:1239727107"}]
END

my $xml = Hatetter::Model::Feed->to_xml($feed);
is($xml, <<'END', 'to_xml');
<?xml version="1.0" encoding="UTF-8"?>
<statuses type="array">
  <status>
    <id>example-1:1239860385</id>
    <created_at>Thu Apr 16 14:39:45 +0900 2009</created_at>
    <favorited></favorited>
    <source>&#12399;&#12390;&#12394;&#12502;&#12483;&#12463;&#12510;&#12540;&#12463;</source>
    <text>[&#12502;&#12483;&#12463;&#12510;] http://example.com/2009/04/ssd.html | ssd  - &#26368;&#21069;&#32218;</text>
    <truncated>false</truncated>
    <user>
      <name>example-1</name>
      <description></description>
      <followers_count>1</followers_count>
      <id>example-1</id>
      <location></location>
      <profile_image_url>http://www.hatena.ne.jp/users/ex/example-1/profile.gif</profile_image_url>
      <protected>false</protected>
      <screen_name>example-1</screen_name>
      <url></url>
    </user>
  </status>
  <status>
    <id>example-2:1239858875</id>
    <created_at>Thu Apr 16 14:14:35 +0900 2009</created_at>
    <favorited></favorited>
    <source>&#12399;&#12390;&#12394;&#12480;&#12452;&#12450;&#12522;&#12540;</source>
    <text>[&#12480;&#12452;&#12450;&#12522;] http://d.hatena.ne.jp/example-2/20090416/1239858875 |  &#26085;&#35352;&#12398;&#12424;&#12358;&#12420;&#12367;&#12384;&#12424;&#65281; -  &#26085;&#35352;&#12398;&#12479;&#12452;&#12488;&#12523;&#12384;&#12424;&#65281;</text>
    <truncated>false</truncated>
    <user>
      <name>example-2</name>
      <description></description>
      <followers_count>1</followers_count>
      <id>example-2</id>
      <location></location>
      <profile_image_url>http://www.hatena.ne.jp/users/ex/example-2/profile.gif</profile_image_url>
      <protected>false</protected>
      <screen_name>example-2</screen_name>
      <url></url>
    </user>
  </status>
  <status>
    <id>example-3:1239846715</id>
    <created_at>Thu Apr 16 10:51:55 +0900 2009</created_at>
    <favorited></favorited>
    <source>&#12399;&#12390;&#12394;&#12464;&#12523;&#12540;&#12503;</source>
    <text>[&#12464;&#12523;&#12540;&#12503;] http://example.g.hatena.ne.jp/example-3/20090416/1239846715 |  &#12394;&#12435;&#12391;&#12464;&#12523;&#12540;&#12503;&#12398;description&#12399; &#12371;&#12435;&#12394;&#24418;&#12395; &#12394;&#12387;&#12390;&#12435;&#12397;&#12435; &#12394;&#12435;&#12391;&#12394;&#12435;&#12391;&#65311; - &#12464;&#12523;&#12540;&#12503;&#12398;&#26085;&#35352;&#12479;&#12452;&#12488;&#12523;</text>
    <truncated>false</truncated>
    <user>
      <name>example-3</name>
      <description></description>
      <followers_count>1</followers_count>
      <id>example-3</id>
      <location></location>
      <profile_image_url>http://www.hatena.ne.jp/users/ex/example-3/profile.gif</profile_image_url>
      <protected>false</protected>
      <screen_name>example-3</screen_name>
      <url></url>
    </user>
  </status>
  <status>
    <id>jkondo:1239839250</id>
    <created_at>Thu Apr 16 08:47:30 +0900 2009</created_at>
    <favorited></favorited>
    <source>&#12399;&#12390;&#12394;&#12495;&#12452;&#12463;</source>
    <text>[&#12495;&#12452;&#12463;] http://h.hatena.ne.jp/jkondo/9234279931701694716 |  - id:jkondo</text>
    <truncated>false</truncated>
    <user>
      <name>jkondo</name>
      <description></description>
      <followers_count>1</followers_count>
      <id>jkondo</id>
      <location></location>
      <profile_image_url>http://www.hatena.ne.jp/users/jk/jkondo/profile.gif</profile_image_url>
      <protected>false</protected>
      <screen_name>jkondo</screen_name>
      <url></url>
    </user>
  </status>
  <status>
    <id>example-4:1239810645</id>
    <created_at>Thu Apr 16 00:50:45 +0900 2009</created_at>
    <favorited></favorited>
    <source>&#12399;&#12390;&#12394;&#12501;&#12457;&#12488;&#12521;&#12452;&#12501;</source>
    <text>[&#12501;&#12457;&#12488;&#12521;] http://f.hatena.ne.jp/example-4/20090416005045 |  - 20090416005045</text>
    <truncated>false</truncated>
    <user>
      <name>example-4</name>
      <description></description>
      <followers_count>1</followers_count>
      <id>example-4</id>
      <location></location>
      <profile_image_url>http://www.hatena.ne.jp/users/ex/example-4/profile.gif</profile_image_url>
      <protected>false</protected>
      <screen_name>example-4</screen_name>
      <url></url>
    </user>
  </status>
  <status>
    <id>example-4:1239727107</id>
    <created_at>Wed Apr 15 01:38:27 +0900 2009</created_at>
    <favorited></favorited>
    <source>My&#12399;&#12390;&#12394;</source>
    <text>[My&#12399;&#12390;] http://www.hatena.ne.jp/example-4/ |  example-4&#12373;&#12435;&#12364;&#12503;&#12525;&#12501;&#12451;&#12540;&#12523;&#12434;&#26356;&#26032;&#12375;&#12414;&#12375;&#12383; - example-4&#12373;&#12435;&#12364;&#12503;&#12525;&#12501;&#12451;&#12540;&#12523;&#12434;&#26356;&#26032;&#12375;&#12414;&#12375;&#12383;</text>
    <truncated>false</truncated>
    <user>
      <name>example-4</name>
      <description></description>
      <followers_count>1</followers_count>
      <id>example-4</id>
      <location></location>
      <profile_image_url>http://www.hatena.ne.jp/users/ex/example-4/profile.gif</profile_image_url>
      <protected>false</protected>
      <screen_name>example-4</screen_name>
      <url></url>
    </user>
  </status>
</statuses>
END
