#encoding: utf-8
require 'test/unit'
require './feed'
require './url'
require './const'

class FeedTest < Test::Unit::TestCase
  # 各テストケースが呼ばれる前に呼ばれるメソッド
  def setup
#    puts '新しいテストを開始します'
    tag = 'technology'
    base = 'b.hatena.ne.jp'
    directories = ['search', 'tag']
    queries = [{'key' => 'q', 'value' => tag},
      {'key' => 'of', 'value' => 40},
      {'key' => 'mode', 'value' => 'rss'}]
    url = URL.new(base, directories, queries)
    @feed1 = Feed.new(url)
    @feed1 = @feed1.truncate(5)
    
    tag = '技術'
    base = 'www.nicovideo.jp'
    directories = ['tag', tag]
    queries = [{'key' => 'rss', 'value' => '2.0'}]
    url = URL.new(base, directories, queries)
    @feed2 = Feed.new(url)
    @feed2 = @feed2.truncate(5)
  end
  
  #各テストメソッドが呼ばれた後に呼ばれるメソッド
  def teardown
#    puts 'テストを1つ終了しました'
  end
  
  def test_initialize
    actual = @feed1.to_s
    assert actual.length > 0, "length = #{actual.length}"
  end
  
  def test_items
    actual = @feed1.items
    assert actual.size == 5
  end
  
  def test_append
    actual = @feed1.append(@feed2)
    for i in 0..9 do
      puts actual.items[i].date
    end
    assert actual.items.size == 10
  end
  
  # def test_unique
  #   actual = @feed.append(@feed).unique
  #   assert actual.items.size > 0
  # end
  
  # def test_truncate
  #   actual = @feed1.append(@feed2).truncate(5)
  #   assert actual.items.size == 5
  # end
end