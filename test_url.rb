require 'test/unit'
require './url'

class URLTest < Test::Unit::TestCase
  # 各テストケースが呼ばれる前に呼ばれるメソッド
  def setup
    puts '新しいテストを開始します'
    tag = 'technology'
    base = 'http://b.hatena.ne.jp'
    directories = ['search', 'tag']
    queries = [{'key' => 'q', 'value' => tag},
      {'key' => 'of', 'value' => 40}]
    @url = URL.new(base, directories, queries)
  end
  
  #各テストメソッドが呼ばれた後に呼ばれるメソッド
  def teardown
    puts 'テストを1つ終了しました'
  end
  
  def test_fetch
    expected = 'http://b.hatena.ne.jp/search/tag?q=technology&of=40'
    actual = @url.to_s
    assert expected == actual, "actual = #{actual}"
  end
  
  def test_host
    expected = 'b.hatena.ne.jp'
    actual = @url.host
    assert expected == actual, "actual = #{actual}"

    expected = 'b.hatena.ne.jp'
    actual = URL.new('https://b.hatena.ne.jp').host
    assert expected == actual, "actual = #{actual}"
  end
  
  def test_path
    expected = '/search/tag?q=technology&of=40'
    actual = @url.path
    assert expected == actual, "actual = #{actual}"
    
    expected = '/search/tag?q=%E6%8A%80%E8%A1%93&of=40&mode=rss'
    tag = '技術'
    base = 'b.hatena.ne.jp'
    directories = ['search', 'tag']
    queries = [{'key' => 'q', 'value' => tag},
      {'key' => 'of', 'value' => 40},
      {'key' => 'mode', 'value' => 'rss'}]
    url = URL.new(base, directories, queries)
    puts url.path
    actual = url.path
  end   
end