# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "App" do
  include Rack::Test::Methods
  def app
    @app ||= Sinatra::Application
  end

  describe "レスポンスの精査" do
    describe "/へのアクセス" do
      before { get '/new_movie?tag1=%E6%8A%80%E8%A1%93&tag2=technology' }
      subject { last_response }
      it "正常なレスポンスが返ること" do
        should be_ok
      end
      # it "Helloと出力されること" do
      #   subject.body.should == "Hello"
      # end
    end
  end
end
