# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "Urlクラス" do
  before {
    tag = 'technology'
    base = 'http://b.hatena.ne.jp'
    directories = ['search', 'tag']
    queries = [{'key' => 'q', 'value' => tag},
               {'key' => 'of', 'value' => 40}]
    @url = URL.new(base, directories, queries)
  }
  subject { @url }
  it "#to_s：URL文字列を返す" do
    subject.to_s.should == 'http://b.hatena.ne.jp/search/tag?q=technology&of=40'
  end
  it "#host：ホスト名を返す" do
    subject.host.should == 'b.hatena.ne.jp'
  end
  it "#path：パスを返す" do
    subject.path.should == '/search/tag?q=technology&of=40'
  end
end