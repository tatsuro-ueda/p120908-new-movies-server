require './feed'
require 'rss'

class Union < Feed
  def initialize(*feeds)
    @feed
    
    unioned_feed = RSS::Maker.make("2.0") do |unioned_feed|
      unioned_feed.channel.about = 'http://hoge/rss.xml'
      unioned_feed.channel.title = "hoge"
      unioned_feed.channel.description = "hoge.description"
      unioned_feed.channel.link = "http://hoge.link"
      unioned_feed.channel.language = "ja"
      
      unioned_feed.items.do_sort = true

      feeds.each do |feed|
        feed.items.each do |feed_item|
          i= unioned_feed.items.new_item            
          i.title = feed_item.title
          puts "#{i.title}を追加しました"
          i.link = feed_item.link
          i.description = feed_item.description
          i.date = feed_item.date
        end
      end
    end
    @feed = RSS::Parser.parse(unioned_feed)
  end
end