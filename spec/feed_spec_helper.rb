# coding: utf-8

def setup_feed1
  tag = 'technology'
  base = 'b.hatena.ne.jp'
  directories = ['search', 'tag']
  queries = [{'key' => 'q', 'value' => tag},
    {'key' => 'of', 'value' => 40},
    {'key' => 'mode', 'value' => 'rss'}]
  url = URL.new(base, directories, queries)
  Feed.new(url).truncate(5)
end

def setup_feed2
  tag = '技術'
  base = 'www.nicovideo.jp'
  directories = ['tag', tag]
  queries = [{'key' => 'rss', 'value' => '2.0'}]
  url = URL.new(base, directories, queries)
  nico_url = 'www.nicovideo.jp/tag/技術?rss=2.0'
  nico_body = read_nicovideo_webmock_contents
  stub_request(:get, nico_url).to_return({:body => nico_body,:status => 200})
  Feed.new(url).truncate(5)
end

def setup_feed3
  tag = '技術'
  base = 'b.hatena.ne.jp'
  directories = ['search', 'tag']
  queries = [{'key' => 'q', 'value' => tag},
    {'key' => 'of', 'value' => 40},
    {'key' => 'mode', 'value' => 'rss'}]
  url = URL.new(base, directories, queries)
  Feed.new(url).truncate(5)
end

def setup_feed_vimeo
  tag = 'military'
  base = 'vimeo.com'
  directories = ['tag:' + tag, 'rss']
  url = URL.new(base, directories)
  Feed.new(url).truncate(5)
end

def read_nicovideo_webmock_contents
  File.read('a.txt')
end
