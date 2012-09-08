require './url.rb'
require './feed.rb'

tag = 'technology'
base = 'b.hatena.ne.jp'
directories = ['search', 'tag']
queries = [{'key' => 'q', 'value' => tag},
  {'key' => 'of', 'value' => 40}]
url = URL.new(base, directories, queries)
puts Feed.new(url.host, url.path).to_s