#encoding: utf-8
require 'sinatra'
require 'rss'
require 'dalli'
require './url'
require './feed'

require 'newrelic_rpm'

set :cache, Dalli::Client.new(ENV['MEMCACHE_SERVERS'],
                    :username => ENV['MEMCACHE_USERNAME'],
                    :password => ENV['MEMCACHE_PASSWORD'],
                    :expires_in => 60 * 30)
# data = settings.cache.get(tag)
# settings.cache.set(tag,data)

def feed_hatena(tag)
  base = 'b.hatena.ne.jp'
  directories = ['search', 'tag']
  queries = [{'key' => 'q', 'value' => tag},
    {'key' => 'of', 'value' => 0},
    {'key' => 'mode', 'value' => 'rss'}]
  url = URL.new(base, directories, queries)
  cached_feed_hatena = Feed.new(url).
    filter({'title' => ['動画', '映像'],
      'link' => ['youtube', 'vimeo', 'nicovideo']}).
    truncate(3)
end

def feed_nico(tag)
  base = 'www.nicovideo.jp'
  directories = ['tag', tag]
  queries = [{'key' => 'rss', 'value' => '2.0'}]
  url = URL.new(base, directories, queries)
  cached_feed_nico = Feed.new(url).regex([
      {:find => /<p class="nico-thumbnail"><img alt=".+" src="(.+)" width="94" height="70" border="0"\/><\/p>/,
      :replace => '"\1"'},
      {:find => /<p class="nico-description">/,
        :replace => ''},
      {:find => /<\/p>/,
        :replace => ''},
      {:find => /<p class="nico-info">.*\n/,
        :replace => ''}
      ]).
      truncate(10)
end

def feed_vimeo(tag)
  base = 'vimeo.com'
  directories = ['tag:' + tag, 'rss']
  url = URL.new(base, directories)
  cached_feed_vimeo = Feed.new(url).
    regex([
      {:find => /<p><a href="http\:\/\/vimeo\.com\/.+"><img src="(.+)" alt="" \/><\/a><\/p><p><p class="first">/,
        :replace => '"\1"'},
      {:find => /<p>/,
        :replace => ''},
      {:find => /<\/p>/,
        :replace => ''},
      {:find => /<br>/,
        :replace => ''},
      {:find => /<strong>/,
        :replace => ''},
      {:find => /<\/strong>/,
        :replace => ''},
      {:find => /<a href="http\:\/\/vimeo.com\/.+">/,
        :replace => ''},
      {:find => /<\/a>/,
        :replace => ''}
    ]).
    truncate(3)
end

def getFeed(tag1, tag2)
  # Thread One
  t1 = Thread.new(tag1) do |param_tag1|
    @feed_nico = feed_nico(param_tag1)
    puts 'nico' if DEBUG_APP
  end
  # Thread Two
  if tag2
    t2 = Thread.new(tag2) do |param_tag2|
      @feed_vimeo = feed_vimeo(param_tag2)
      puts 'vimeo' if DEBUG_APP
    end
  end
  # Main Thread
  feed_hatena1 = feed_hatena(tag1)
  puts 'hatena1' if DEBUG_APP

  t1.join
  t2.join if params[tag2]

  if tag2
    feed = feed_hatena1.append(
      @feed_nico, @feed_vimeo).
      unique
    puts 'append + unique' if DEBUG_APP
  else
    feed = feed_hatena1.append(@feed_nico).unique
  end

  content_type = 'text/xml; charset=utf-8'
  puts "getFeed executed"
  # after do でmemcacheに保存するためにインスタンス変数を使っている
  @output = feed.to_s
end

get '/new_movie' do
  if params['tag2']
    @key = 'tag1=' + params['tag1'] + '&tag2=' + params['tag2']
  else
    @key = 'tag1=' + params['tag1']
  end

  # if cache exists
  if output = settings.cache.get(@key)
    @cache_used = true;
    output
  # if cache does not exists
  else
    getFeed(params['tag1'], params['tag2']);
  end
end

after '/new_movie' do
  if @cache_used
    @output = getFeed(params['tag1'], params['tag2']);
  end
  settings.cache.set(@key, @output)
end

get '/test.html' do
end

get '/index' do
  erb :index
end