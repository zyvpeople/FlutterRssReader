import 'package:flutter_rss_reader/datasource/remote/FeedParser.dart';
import 'package:flutter_rss_reader/domain/common/Tuple2.dart';
import 'package:flutter_rss_reader/domain/entity/Feed.dart';
import 'package:flutter_rss_reader/domain/entity/FeedItem.dart';
import 'package:test/test.dart';

void main() {
  final parser = FeedParser();

  test("parse returns parsed feed and feedItems", () async {
    final expectedFeed = _expectedFeed();
    final expectedFeedItem1 = _expectedFeedItem1();
    final expectedFeedItem2 = _expectedFeedItem2();
    final expectedFeedItem3 = _expectedFeedItem3();
    final expected = Tuple2(expectedFeed,
        [expectedFeedItem1, expectedFeedItem2, expectedFeedItem3]);
    final actual = await parser.parse(
        Uri.parse("http://feeds.bbci.co.uk/news/rss.xml"),
        _correctXmlWithFeedAndFeedItems());
    expect(actual, expected);
  });

  test("parse returns parsed feed without feedItems", () async {
    final expectedFeed = _expectedFeed();
    final expected = Tuple2(expectedFeed, <FeedItem>[]);
    final actual = await parser.parse(
        Uri.parse("http://feeds.bbci.co.uk/news/rss.xml"),
        _correctXmlWithFeedAndWithoutFeedItems());
    expect(actual, expected);
  });

  test("parse throws error if feed is absent", () async {
    try {
      await parser.parse(Uri.parse("http://feeds.bbci.co.uk/news/rss.xml"),
          _incorrectXmlWithoutFeed());
      fail("Exception is expected");
    } catch (e) {}
  });

  test("parse throws error if feed does not have title", () async {
    try {
      await parser.parse(Uri.parse("http://feeds.bbci.co.uk/news/rss.xml"),
          _incorrectXmlWithoutFeedsTitle());
      fail("Exception is expected");
    } catch (e) {}
  });

  test("parse throws error if feedItem does not have title", () async {
    try {
      await parser.parse(Uri.parse("http://feeds.bbci.co.uk/news/rss.xml"),
          _incorrectXmlWithFeedAndWithoutFeedItemsTitle());
      fail("Exception is expected");
    } catch (e) {}
  });

  test("parse throws error if feedItem does not have description", () async {
    try {
      await parser.parse(Uri.parse("http://feeds.bbci.co.uk/news/rss.xml"),
          _incorrectXmlWithFeedAndWithoutFeedItemsDescription());
      fail("Exception is expected");
    } catch (e) {}
  });

  test("parse throws error if feedItem does not have link", () async {
    try {
      await parser.parse(Uri.parse("http://feeds.bbci.co.uk/news/rss.xml"),
          _incorrectXmlWithFeedAndWithoutFeedItemsLink());
      fail("Exception is expected");
    } catch (e) {}
  });

  test("parse throws error if feedItem does not have guid", () async {
    try {
      await parser.parse(Uri.parse("http://feeds.bbci.co.uk/news/rss.xml"),
          _incorrectXmlWithFeedAndWithoutFeedItemsGuid());
      fail("Exception is expected");
    } catch (e) {}
  });

  test("parse throws error if feedItem does not have pubDate", () async {
    try {
      await parser.parse(Uri.parse("http://feeds.bbci.co.uk/news/rss.xml"),
          _incorrectXmlWithFeedAndWithoutFeedItemsPubDate());
      fail("Exception is expected");
    } catch (e) {}
  });

  test("parse throws error if feedItem does not have thumbnail", () async {
    try {
      await parser.parse(Uri.parse("http://feeds.bbci.co.uk/news/rss.xml"),
          _incorrectXmlWithFeedAndWithoutFeedItemsThumbnail());
      fail("Exception is expected");
    } catch (e) {}
  });

  test("parse throws error if data is empty", () async {
    try {
      await parser.parse(Uri.parse("http://feeds.bbci.co.uk/news/rss.xml"), "");
      fail("Exception is expected");
    } catch (e) {}
  });
}

Feed _expectedFeed() => Feed(
    0, "Test feed title", Uri.parse("http://feeds.bbci.co.uk/news/rss.xml"), Uri.parse("https://www.bbc.co.uk/news/"), Uri.parse("https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif"));

FeedItem _expectedFeedItem1() => FeedItem(
    0,
    "Test server id 1",
    "Test feedItem title 1",
    "Test feedItem description 1",
    DateTime(2019, 5, 23, 6, 41, 4, 0, 0),
    Uri.parse("https://www.bbc.co.uk/news/uk-politics-48372665"),
    Uri.parse(
        "http://c.files.bbci.co.uk/BC81/production/_107075284_polling_station_1_reuters.jpg"),
    0);

FeedItem _expectedFeedItem2() {
  return FeedItem(
      0,
      "Test server id 2",
      "Test feedItem title 2",
      "Test feedItem description 2",
      DateTime(2019, 5, 22, 23, 1, 40, 0, 0),
      Uri.parse("https://www.bbc.co.uk/news/uk-politics-48374841"),
      Uri.parse(
          "http://c.files.bbci.co.uk/B42F/production/_107072164_p07b1qfw.jpg"),
      0);
}

FeedItem _expectedFeedItem3() => FeedItem(
    0,
    "Test server id 3",
    "Test feedItem title 3",
    "Test feedItem description 3",
    DateTime(2019, 5, 23, 8, 9, 8, 0, 0),
    Uri.parse("https://www.bbc.co.uk/news/business-48377232"),
    Uri.parse(
        "http://c.files.bbci.co.uk/179E1/production/_107073769_gettyimages-1049816548.jpg"),
    0);

String _correctXmlWithFeedAndFeedItems() => """
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet title="XSL_formatting" type="text/xsl" href="/shared/bsp/xsl/rss/nolsol.xsl"?>
<rss xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:content="http://purl.org/rss/1.0/modules/content/" 
    xmlns:atom="http://www.w3.org/2005/Atom" 
    version="2.0" 
    xmlns:media="http://search.yahoo.com/mrss/">
    <channel>
        <title>Test feed title</title>
        <description>Test feed description</description>
        <link>https://www.bbc.co.uk/news/</link>
        <image>
            <url>https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif</url>
            <title>BBC News - Home</title>
            <link>https://www.bbc.co.uk/news/</link>
        </image>
        <generator>RSS for Node</generator>
        <item>
            <title>Test feedItem title 1</title>
            <description>Test feedItem description 1</description>
            <link>https://www.bbc.co.uk/news/uk-politics-48372665</link>
            <guid isPermaLink="true">Test server id 1</guid>
            <pubDate>Thu, 23 May 2019 06:41:04 GMT</pubDate>
            <media:thumbnail width="976" height="549" url="http://c.files.bbci.co.uk/BC81/production/_107075284_polling_station_1_reuters.jpg"/>
        </item>
        <item>
            <title>Test feedItem title 2</title>
            <description>Test feedItem description 2</description>
            <link>https://www.bbc.co.uk/news/uk-politics-48374841</link>
            <guid isPermaLink="true">Test server id 2</guid>
            <pubDate>Wed, 22 May 2019 23:01:40 GMT</pubDate>
            <media:thumbnail width="976" height="549" url="http://c.files.bbci.co.uk/B42F/production/_107072164_p07b1qfw.jpg"/>
        </item>
        <item>
            <title>Test feedItem title 3</title>
            <description>Test feedItem description 3</description>
            <link>https://www.bbc.co.uk/news/business-48377232</link>
            <guid isPermaLink="true">Test server id 3</guid>
            <pubDate>Thu, 23 May 2019 08:09:08 GMT</pubDate>
            <media:thumbnail width="2048" height="1152" url="http://c.files.bbci.co.uk/179E1/production/_107073769_gettyimages-1049816548.jpg"/>
        </item>
    </channel>
</rss>
""";

String _correctXmlWithFeedAndWithoutFeedItems() => """
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet title="XSL_formatting" type="text/xsl" href="/shared/bsp/xsl/rss/nolsol.xsl"?>
<rss xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:content="http://purl.org/rss/1.0/modules/content/" 
    xmlns:atom="http://www.w3.org/2005/Atom" 
    version="2.0" 
    xmlns:media="http://search.yahoo.com/mrss/">
    <channel>
        <title>Test feed title</title>
        <description>Test feed description</description>
        <link>https://www.bbc.co.uk/news/</link>
        <image>
            <url>https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif</url>
            <title>BBC News - Home</title>
            <link>https://www.bbc.co.uk/news/</link>
        </image>
        <generator>RSS for Node</generator>
    </channel>
</rss>
""";

String _incorrectXmlWithoutFeed() => """
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet title="XSL_formatting" type="text/xsl" href="/shared/bsp/xsl/rss/nolsol.xsl"?>
<rss xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:content="http://purl.org/rss/1.0/modules/content/" 
    xmlns:atom="http://www.w3.org/2005/Atom" 
    version="2.0" 
    xmlns:media="http://search.yahoo.com/mrss/">
    <channel>
        <item>
            <title>Test feedItem title 1</title>
            <description>Test feedItem description 1</description>
            <link>https://www.bbc.co.uk/news/uk-politics-48372665</link>
            <guid isPermaLink="true">Test server id 1</guid>
            <pubDate>Thu, 23 May 2019 06:41:04 GMT</pubDate>
            <media:thumbnail width="976" height="549" url="http://c.files.bbci.co.uk/BC81/production/_107075284_polling_station_1_reuters.jpg"/>
        </item>
        <item>
            <title>Test feedItem title 2</title>
            <description>Test feedItem description 2</description>
            <link>https://www.bbc.co.uk/news/uk-politics-48374841</link>
            <guid isPermaLink="true">Test server id 2</guid>
            <pubDate>Wed, 22 May 2019 23:01:40 GMT</pubDate>
            <media:thumbnail width="976" height="549" url="http://c.files.bbci.co.uk/B42F/production/_107072164_p07b1qfw.jpg"/>
        </item>
        <item>
            <title>Test feedItem title 3</title>
            <description>Test feedItem description 3</description>
            <link>https://www.bbc.co.uk/news/business-48377232</link>
            <guid isPermaLink="true">Test server id 3</guid>
            <pubDate>Thu, 23 May 2019 08:09:08 GMT</pubDate>
            <media:thumbnail width="2048" height="1152" url="http://c.files.bbci.co.uk/179E1/production/_107073769_gettyimages-1049816548.jpg"/>
        </item>
    </channel>
</rss>
""";

String _incorrectXmlWithoutFeedsTitle() => """
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet title="XSL_formatting" type="text/xsl" href="/shared/bsp/xsl/rss/nolsol.xsl"?>
<rss xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:content="http://purl.org/rss/1.0/modules/content/" 
    xmlns:atom="http://www.w3.org/2005/Atom" 
    version="2.0" 
    xmlns:media="http://search.yahoo.com/mrss/">
    <channel>
        <description>Test feed description</description>
        <link>https://www.bbc.co.uk/news/</link>
        <image>
            <url>https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif</url>
            <title>BBC News - Home</title>
            <link>https://www.bbc.co.uk/news/</link>
        </image>
        <generator>RSS for Node</generator>
    </channel>
</rss>
""";

String _incorrectXmlWithFeedAndWithoutFeedItemsTitle() => """
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet title="XSL_formatting" type="text/xsl" href="/shared/bsp/xsl/rss/nolsol.xsl"?>
<rss xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:content="http://purl.org/rss/1.0/modules/content/" 
    xmlns:atom="http://www.w3.org/2005/Atom" 
    version="2.0" 
    xmlns:media="http://search.yahoo.com/mrss/">
    <channel>
        <title>Test feed title</title>
        <description>Test feed description</description>
        <link>https://www.bbc.co.uk/news/</link>
        <image>
            <url>https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif</url>
            <title>BBC News - Home</title>
            <link>https://www.bbc.co.uk/news/</link>
        </image>
        <generator>RSS for Node</generator>
        <item>
            <title>Test feedItem title 1</title>
            <description>Test feedItem description 1</description>
            <link>https://www.bbc.co.uk/news/uk-politics-48372665</link>
            <guid isPermaLink="true">Test server id 1</guid>
            <pubDate>Thu, 23 May 2019 06:41:04 GMT</pubDate>
            <media:thumbnail width="976" height="549" url="http://c.files.bbci.co.uk/BC81/production/_107075284_polling_station_1_reuters.jpg"/>
        </item>
    </channel>
</rss>
""";

String _incorrectXmlWithFeedAndWithoutFeedItemsDescription() => """
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet title="XSL_formatting" type="text/xsl" href="/shared/bsp/xsl/rss/nolsol.xsl"?>
<rss xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:content="http://purl.org/rss/1.0/modules/content/" 
    xmlns:atom="http://www.w3.org/2005/Atom" 
    version="2.0" 
    xmlns:media="http://search.yahoo.com/mrss/">
    <channel>
        <title>Test feed title</title>
        <description>Test feed description</description>
        <link>https://www.bbc.co.uk/news/</link>
        <image>
            <url>https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif</url>
            <title>BBC News - Home</title>
            <link>https://www.bbc.co.uk/news/</link>
        </image>
        <generator>RSS for Node</generator>
        <item>
            <title>Test feedItem title 1</title>
            <link>https://www.bbc.co.uk/news/uk-politics-48372665</link>
            <guid isPermaLink="true">Test server id 1</guid>
            <pubDate>Thu, 23 May 2019 06:41:04 GMT</pubDate>
            <media:thumbnail width="976" height="549" url="http://c.files.bbci.co.uk/BC81/production/_107075284_polling_station_1_reuters.jpg"/>
        </item>
    </channel>
</rss>
""";

String _incorrectXmlWithFeedAndWithoutFeedItemsLink() => """
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet title="XSL_formatting" type="text/xsl" href="/shared/bsp/xsl/rss/nolsol.xsl"?>
<rss xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:content="http://purl.org/rss/1.0/modules/content/" 
    xmlns:atom="http://www.w3.org/2005/Atom" 
    version="2.0" 
    xmlns:media="http://search.yahoo.com/mrss/">
    <channel>
        <title>Test feed title</title>
        <description>Test feed description</description>
        <link>https://www.bbc.co.uk/news/</link>
        <image>
            <url>https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif</url>
            <title>BBC News - Home</title>
            <link>https://www.bbc.co.uk/news/</link>
        </image>
        <generator>RSS for Node</generator>
        <item>
            <title>Test feedItem title 1</title>
            <description>Test feedItem description 1</description>
            <guid isPermaLink="true">Test server id 1</guid>
            <pubDate>Thu, 23 May 2019 06:41:04 GMT</pubDate>
            <media:thumbnail width="976" height="549" url="http://c.files.bbci.co.uk/BC81/production/_107075284_polling_station_1_reuters.jpg"/>
        </item>
    </channel>
</rss>
""";

String _incorrectXmlWithFeedAndWithoutFeedItemsGuid() => """
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet title="XSL_formatting" type="text/xsl" href="/shared/bsp/xsl/rss/nolsol.xsl"?>
<rss xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:content="http://purl.org/rss/1.0/modules/content/" 
    xmlns:atom="http://www.w3.org/2005/Atom" 
    version="2.0" 
    xmlns:media="http://search.yahoo.com/mrss/">
    <channel>
        <title>Test feed title</title>
        <description>Test feed description</description>
        <link>https://www.bbc.co.uk/news/</link>
        <image>
            <url>https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif</url>
            <title>BBC News - Home</title>
            <link>https://www.bbc.co.uk/news/</link>
        </image>
        <generator>RSS for Node</generator>
        <item>
            <title>Test feedItem title 1</title>
            <description>Test feedItem description 1</description>
            <link>https://www.bbc.co.uk/news/</link>
            <pubDate>Thu, 23 May 2019 06:41:04 GMT</pubDate>
            <media:thumbnail width="976" height="549" url="http://c.files.bbci.co.uk/BC81/production/_107075284_polling_station_1_reuters.jpg"/>
        </item>
    </channel>
</rss>
""";

String _incorrectXmlWithFeedAndWithoutFeedItemsPubDate() => """
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet title="XSL_formatting" type="text/xsl" href="/shared/bsp/xsl/rss/nolsol.xsl"?>
<rss xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:content="http://purl.org/rss/1.0/modules/content/" 
    xmlns:atom="http://www.w3.org/2005/Atom" 
    version="2.0" 
    xmlns:media="http://search.yahoo.com/mrss/">
    <channel>
        <title>Test feed title</title>
        <description>Test feed description</description>
        <link>https://www.bbc.co.uk/news/</link>
        <image>
            <url>https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif</url>
            <title>BBC News - Home</title>
            <link>https://www.bbc.co.uk/news/</link>
        </image>
        <generator>RSS for Node</generator>
        <item>
            <title>Test feedItem title 1</title>
            <description>Test feedItem description 1</description>
            <link>https://www.bbc.co.uk/news/uk-politics-48372665</link>
            <guid isPermaLink="true">Test server id 1</guid>
            <media:thumbnail width="976" height="549" url="http://c.files.bbci.co.uk/BC81/production/_107075284_polling_station_1_reuters.jpg"/>
        </item>
    </channel>
</rss>
""";

String _incorrectXmlWithFeedAndWithoutFeedItemsThumbnail() => """
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet title="XSL_formatting" type="text/xsl" href="/shared/bsp/xsl/rss/nolsol.xsl"?>
<rss xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:content="http://purl.org/rss/1.0/modules/content/" 
    xmlns:atom="http://www.w3.org/2005/Atom" 
    version="2.0" 
    xmlns:media="http://search.yahoo.com/mrss/">
    <channel>
        <title>Test feed title</title>
        <description>Test feed description</description>
        <link>https://www.bbc.co.uk/news/</link>
        <image>
            <url>https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif</url>
            <title>BBC News - Home</title>
            <link>https://www.bbc.co.uk/news/</link>
        </image>
        <generator>RSS for Node</generator>
        <item>
            <title>Test feedItem title 1</title>
            <description>Test feedItem description 1</description>
            <link>https://www.bbc.co.uk/news/uk-politics-48372665</link>
            <guid isPermaLink="true">Test server id 1</guid>
            <pubDate>Thu, 23 May 2019 06:41:04 GMT</pubDate>
        </item>
    </channel>
</rss>
""";
