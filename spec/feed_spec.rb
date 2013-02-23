# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'
require 'feed_spec_helper'
require "webmock/rspec"
WebMock.allow_net_connect!

describe "Feedクラス" do
  before(:each) {
    @feed1 = setup_feed1
    @feed2 = setup_feed2
    @feed3 = setup_feed3
    @feed4 = setup_feed_vimeo
  }
  context "サンプルフィードを取得するとき" do
    it "1つ以上の要素を持った配列オブジェクトが生成される" do
      @feed1.items.length.should > 0
      @feed2.items.length.should > 0
      @feed3.items.length.should > 0
      @feed4.items.length.should > 0
    end
    it "配列オブジェクトの要素数は5である" do
      @feed1.items.length.should == 5
      @feed2.items.length.should == 5
      @feed3.items.length.should == 5
      @feed4.items.length.should == 5
    end
  end
  describe "#append" do
    context "@feed1の長さは5、@feed3の長さは2のとき、それらをappendしたfeedの長さ" do
      before {@result = @feed1.append(@feed3)}
      subject {@result}
      it{should have(10).items}
#        subject.items.length.should == 7
#      end
    end
  end
  describe "#unique" do
    before {
      p @feed1.items.length
    }
    it "#unique：重複する項目を除去する" do
      @feed1.append(@feed1).unique.items.length.should == 5
    end
  end
  it "#truncate：項目数を制限する" do
    @feed1.append(@feed2).truncate(5).items.length.should == 5
  end
  it "#regex：内容を置換する" do
    @feed2.regex([
      {:find => /<p class="nico-thumbnail"><img alt=".*\n/,
      :replace => ''},
      {:find => /<p class="nico-description">/,
      :replace => ''},
      {:find => /<\/p>/,
      :replace => ''},
      {:find => /<p class="nico-info">.*\n/,
      :replace => ''}
    ]).items.length.should == 5
  end
  it "#filter：キーワードを含むフィードを返す" do
    @feed3.filter({
      'title' => ["プロジェクト", "IT", "ニュース"],
      'link' => ["itmedia", "yomiuri", "mainichi"]
    }).items.length.should > 0
  end
end
