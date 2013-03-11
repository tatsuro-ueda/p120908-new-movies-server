# coding: utf-8

def setup_feed1
  tag = 'technology'
  base = 'b.hatena.ne.jp'
  directories = ['search', 'tag']
  queries = [{'key' => 'q', 'value' => tag},
    {'key' => 'of', 'value' => 40},
    {'key' => 'mode', 'value' => 'rss'}]
  url = URL.new(base, directories, queries)
  hatena_technology_url = 'b.hatena.ne.jp/search/tag?q=technology&of=40&mode=rss'
  hatena_technology_body = read_webmock_contents 'hatena_technology.txt'
  stub_request(:get, hatena_technology_url).to_return({:body => hatena_technology_body, :status => 200})
  Feed.new(url).truncate(5)
end

def setup_feed2
  tag = '技術'
  base = 'www.nicovideo.jp'
  directories = ['tag', tag]
  queries = [{'key' => 'rss', 'value' => '2.0'}]
  url = URL.new(base, directories, queries)
  nico_url = 'www.nicovideo.jp/tag/技術?rss=2.0'
  nico_body = read_webmock_contents 'nicovideo.txt'
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
  hatena_gijutsu_url = 'http://b.hatena.ne.jp/search/tag?q=%E6%8A%80%E8%A1%93&of=40&mode=rss'
  hatena_gijutsu_body = read_webmock_contents 'hatena_gijutsu.txt'
  stub_request(:get, hatena_gijutsu_url).to_return({:body => hatena_gijutsu_body, :status => 200})
  Feed.new(url).truncate(5)
end

def setup_feed_vimeo
  tag = 'military'
  base = 'vimeo.com'
  directories = ['tag:' + tag, 'rss']
  url = URL.new(base, directories)
  vimeo_url = 'vimeo.com/tag:military/rss'
  vimeo_body = read_webmock_contents 'vimeo.txt'
  stub_request(:get, vimeo_url).to_return({:body => vimeo_body, :status => 200})
  Feed.new(url).truncate(5)
end

def read_webmock_contents filename
   File.read filename
end
