#encoding: utf-8
require 'test/unit'
require './feed'
require './url'
require './const'

class FeedTest < Test::Unit::TestCase
  def setup_feed1
    tag = 'technology'
    base = 'b.hatena.ne.jp'
    directories = ['search', 'tag']
    queries = [{'key' => 'q', 'value' => tag},
      {'key' => 'of', 'value' => 40},
      {'key' => 'mode', 'value' => 'rss'}]
    url = URL.new(base, directories, queries)
    @feed1 = Feed.new(url)
    @feed1 = @feed1.truncate(5)
  end    
  
  def setup_feed2
    tag = '技術'
    base = 'www.nicovideo.jp'
    directories = ['tag', tag]
    queries = [{'key' => 'rss', 'value' => '2.0'}]
    url = URL.new(base, directories, queries)
    @feed2 = Feed.new(url)
    @feed2 = @feed2.truncate(5)
  end
  
  def setup_feed3
    tag = '技術'
    base = 'b.hatena.ne.jp'
    directories = ['search', 'tag']
    queries = [{'key' => 'q', 'value' => tag},
      {'key' => 'of', 'value' => 40},
      {'key' => 'mode', 'value' => 'rss'}]
    url = URL.new(base, directories, queries)
    @feed4 = Feed.new(url)
    @feed3 = @feed4.truncate(5)
  end
  
  def setup_feed_vimeo
    tag = 'military'
    base = 'vimeo.com'
    directories = ['tag:' + tag, 'rss']
    url = URL.new(base, directories)
    @feed_vimeo = Feed.new(url).truncate(5)
  end
    
  
  # 各テストケースが呼ばれる前に呼ばれるメソッド
  def setup
    setup_feed1
    setup_feed2
    setup_feed3
    setup_feed_vimeo
#    puts '新しいテストを開始します'
  end
  
  #各テストメソッドが呼ばれた後に呼ばれるメソッド
  def teardown
#    puts 'テストを1つ終了しました'
  end
  
  def test_initialize
    actual = @feed4
    assert actual.items.length > 0
    
    actual = @feed_vimeo
    assert actual.items.length > 0
  end
  
  def test_items
    actual = @feed1.items
    puts actual.to_s if DEBUG_UNIQUE
    assert actual.size == 5
  end
  
  def test_append
    actual = @feed1.append(@feed3)
    if DEBUG_APPEND
      for i in 0..9 do
        puts actual.items[i].title
      end
    end
    assert actual.items.size == 10
  end
  
  def test_unique
    actual = @feed1.append(@feed3).unique
    puts actual.to_s if DEBUG_UNIQUE
    assert actual.items.size > 0
  end
  
  def test_truncate
    actual = @feed1.append(@feed2).truncate(5)
    assert actual.items.size == 5
  end
  
  def test_regex
    actual = @feed2.regex([
      {:find => /<p class="nico-thumbnail"><img alt=".*\n/, 
        :replace => ''},
      {:find => /<p class="nico-description">/,
        :replace => ''},
      {:find => /<\/p>/,
        :replace => ''},
      {:find => /<p class="nico-info">.*\n/,
        :replace => ''}
      ])
    if DEBUG_REGEX
      for i in 0..4 do
        puts actual.items[i].description
      end
    end
    assert actual.items.size == 5
  end
  
  def test_filter
    setup_feed3
    actual = @feed3.filter({
      'title' => ["プロジェクト", "IT", "ニュース"], 
      'link' => ["itmedia", "yomiuri", "mainichi"]})
    if DEBUG_FILTER
      for i in 0..(actual.items.size - 1)
        puts actual.items[i].title + ': ' + actual.items[i].link
      end
    end
    assert actual.items.size > 0
  end
end