require 'test/unit'
require './feed'
require './url'
require './union'

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
    url = URL.new(base, directories, queries)
    feed = Feed.new(url)
    @union = Union.new(feed, feed)
  end
  
  #各テストメソッドが呼ばれた後に呼ばれるメソッド
  def teardown
    puts 'テストを1つ終了しました'
  end
  
  def test_to_s
    actual = @union.to_s
    assert actual.length > 0
  end
end