require 'sinatra'
require 'rss'
require './url.rb'
require './feed.rb'

def '/' do
  tag = 'technology'
  base = 'b.hatena.ne.jp'
  directories = ['search', 'tag']
  queries = [{'key' => 'q', 'value' => tag},
    {'key' => 'of', 'value' => 40}]
  url = URL.new(base, directories, queries)
  Feed.new(url).append(Feed.new(url)).sort.to_s
end