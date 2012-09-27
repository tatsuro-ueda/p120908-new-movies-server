#encoding: utf-8
require 'sinatra'
require 'rss'
require 'Dalli'
require './url'
require './feed'

configure :production do
	require 'newrelic_rpm'
end

set :cache, Dalli::Client.new(ENV['MEMCACHE_SERVERS'],
                    :username => ENV['MEMCACHE_USERNAME'],
                    :password => ENV['MEMCACHE_PASSWORD'],
                    :expires_in => 60 * 30)
# data = settings.cache.get(tag)
# settings.cache.set(tag,data)

def feed_hatena(tag)
  if cached_feed_hatena = settings.cache.get('hatena' + tag)
    puts 'hatena cache used'
    Feed.new(cached_feed_hatena)
  else
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
    
    puts 'new hatena cache'
    settings.cache.set('hatena' + tag, cached_feed_hatena)
    cached_feed_hatena
  end
end

def feed_nico(tag)
  if cached_feed_nico = settings.cache.get('nico' + tag)
    puts 'nico cache used'
    Feed.new(cached_feed_nico)
  else
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
        truncate(5)
    
    puts 'new nico cache'
    settings.cache.set('nico' + tag, cached_feed_nico)
  end
end

def feed_vimeo(tag)
  if cached_feed_vimeo = settings.cache.get('vimeo' + tag)
    puts 'vimeo cache used'
    Feed.new(cached_feed_vimeo)
  else
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
    
    puts 'new vimeo cache'
    settings.cache.set('vimeo' + tag, cached_feed_vimeo)
  end
end

get '/new_movie' do
  # Thread One
  t1 = Thread.new(params['tag1']) do |param_tag1|
    @feed_nico = feed_nico(param_tag1)
    puts 'nico' if DEBUG_APP
  end 
  # Thread Two
  if params['tag2']
    t2 = Thread.new(params['tag2']) do |param_tag2|
      @feed_vimeo = feed_vimeo(param_tag2)
      puts 'vimeo' if DEBUG_APP     
    end
  end
  # Main Thread
  feed_hatena1 = feed_hatena(params['tag1'])
  puts 'hatena1' if DEBUG_APP
  
  t1.join
  t2.join if params['tag2']
  
  if params['tag2']
    feed = feed_hatena1.append(
      @feed_nico, @feed_vimeo).
      unique
    puts 'append + unique' if DEBUG_APP
  else
    feed = feed_hatena1.append(feed_nico).unique
  end
  content_type = 'text/xml; charset=utf-8'
  feed.to_s
end

get '/test.html' do
end

get '/index' do
  erb :index
end