# encoding: utf-8

DEBUG = false

require File.dirname(__FILE__) + '/spec_helper'
require 'feed_spec_helper'
require "webmock/rspec"
WebMock.allow_net_connect!

describe "Feed" do
  before(:each) {
    @feed1 = setup_feed1
    @feed2 = setup_feed2
    @feed3 = setup_feed3
    @feed4 = setup_feed_vimeo
  }

  context "サンプルフィードを取得するとき" do
    before {
      @feed1_length = @feed1.items.length
      @feed2_length = @feed2.items.length
      @feed3_length = @feed3.items.length
      @feed4_length = @feed4.items.length
    }

    it "1つ以上の要素を持った配列オブジェクトが生成されること" do
      debug 1
      @feed1_length.should > 0
      @feed2_length.should > 0
      @feed3_length.should > 0
      @feed4_length.should > 0
    end

    it "配列オブジェクトの要素数は5であること" do
      debug 2
      @feed1_length.should == 5
      @feed2_length.should == 5
      @feed3_length.should == 5
      @feed4_length.should == 5
    end
  end

  describe "#append" do
    context "長さ5の@feed1に長さ5の@feed3を#appendしたとき" do
      subject {@result = @feed1.append(@feed3)}
      it{
        debug 3
        should have(10).items
      }
    end
  end

  describe "#unique" do
    context "@feed1に@feed1を#appendしたあと#uniqueしたとき" do
      subject {@result = @feed1.append(@feed1).unique}
      it{
        debug 4
        should have(5).items
      }
    end
  end

  describe "#truncate" do
    context "@feed1に@feed2を#appendしたあと#truncate(5)したとき" do
      subject {@result = @feed1.append(@feed2).truncate(5)}
      it{
        debug 5
        should have(5).items
      }
    end
  end

  describe "#regex" do
    context "@feed2の中身を#regexしたとき" do
      subject {
        @result = @feed2.regex([
          {:find => /<p class="nico-thumbnail"><img alt=".*\n/, :replace => ''},
          {:find => /<p class="nico-description">/, :replace => ''},
          {:find => /<\/p>/, :replace => ''},
          {:find => /<p class="nico-info">.*\n/, :replace => ''}
        ])
      }
      it{
        debug 6
        should have(5).items
      }
    end
  end

  describe "#filter" do
    context "@feed3の内、指定のキーワードを含むものを抽出したとき" do
      before {
        @result_length = @feed3.filter({
          'title' => ["プロジェクト", "IT", "ニュース"],
          'link' => ["itmedia", "yomiuri", "mainichi"]
        }).items.length
      }
      it "1つ以上の要素を持つこと" do
        debug 7
        @result_length.should > 0
      end
    end
  end
end

def debug id
  if DEBUG
    puts "example_" + id.to_s
    puts [@feed1, @feed2, @feed3, @feed4].map{|f| f.items.length}
  end
end
