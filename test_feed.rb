#encoding: utf-8
require 'test/unit'
require './feed'
require './url'
require './const'

class FeedTest < Test::Unit::TestCase
  # 各テストケースが呼ばれる前に呼ばれるメソッド
  def setup
    puts '新しいテストを開始します'
    tag = 'technology'
    base = 'b.hatena.ne.jp'
    directories = ['search', 'tag']
    queries = [{'key' => 'q', 'value' => tag},
      {'key' => 'of', 'value' => 40},
      {'key' => 'mode', 'value' => 'rss'}]
    @url = URL.new(base, directories, queries)
  end
  
  #各テストメソッドが呼ばれた後に呼ばれるメソッド
  def teardown
    puts 'テストを1つ終了しました'
  end
  
  def test_initialize
    actual = Feed.new(@url).to_s
    assert actual.length > 0, "length = #{actual.length}"
  end
  
  def test_items
    feed = Feed.new(@url)
    actual = feed.items
    assert actual.size > 0
  end
  
  def test_append
    feed = Feed.new(@url)
    actual = feed.append(feed)
    assert actual.items.size > 0
  end
  
  def test_unique
    feed = Feed.new(@url)
    actual = feed.append(feed).unique
    assert actual.items.size > 0
  end
end