#encoding: utf-8
require 'net/http'
require 'rss'
require './const'

class Feed
  @feed
  
  def initialize(url)
    host = url.host
    path = url.path
    feed = Net::HTTP.get(host, path).force_encoding('utf-8')
    @feed = RSS::Parser.parse(feed)
    self
  end
  
  def to_s
    @feed.to_s
  end
  
  def items
    @feed.items
  end

  def append(*appended_feeds)
    output_feed= RSS::Maker.make("2.0") do |output_feed|
      output_feed.channel.about = 'http://hoge/rss.xml'
      output_feed.channel.title = "hoge"
      output_feed.channel.description = "hoge.description"
      output_feed.channel.link = "http://hoge.link"
      output_feed.channel.language = "ja"
      
      output_feed.items.do_sort = true

      @feed.items.each do |feed_item|
        i= output_feed.items.new_item            
        i.title = feed_item.title
        puts "#{i.title}を追加しました" if DEBUG_UNION
        i.link = feed_item.link
        i.description = feed_item.description
        i.date = feed_item.date
      end
    
      appended_feeds.each do |feed|
        feed.items.each do |feed_item|
          i= output_feed.items.new_item            
          i.title = feed_item.title
          puts "#{i.title}を追加しました" if DEBUG_UNION
          i.link = feed_item.link
          i.description = feed_item.description
          i.date = feed_item.date
        end
      end
    end
    @feed = output_feed
    self
  end
  
  # うまく動かない
  def Feed.union(*appended_feeds)
    output_feed= RSS::Maker.make("2.0") do |output_feed|
      output_feed.channel.about = 'http://hoge/rss.xml'
      output_feed.channel.title = "hoge"
      output_feed.channel.description = "hoge.description"
      output_feed.channel.link = "http://hoge.link"
      output_feed.channel.language = "ja"
      
      output_feed.items.do_sort = true

      appended_feeds.each do |feed|
        feed.items.each do |feed_item|
          i= output_feed.items.new_item            
          i.title = feed_item.title
          puts "#{i.title}を追加しました" if DEBUG_UNION
          i.link = feed_item.link
          i.description = feed_item.description
          i.date = feed_item.date
        end
      end
    end
    @feed = output_feed
  end
  
  def unique
    output_feed = RSS::Maker.make("2.0") do |output_feed|
      output_feed.channel.about = 'http://hoge/rss.xml'
      output_feed.channel.title = "hoge"
      output_feed.channel.description = "hoge.description"
      output_feed.channel.link = "http://hoge.link"
      output_feed.channel.language = "ja"
      
      output_feed.items.do_sort = true
      
      feed = @feed
      for i in 0...(feed.items.size - 1) do
        for j in 0...(i - 1)
          if feed.items[j].link == feed.items[i].link
            break;
          end
        end
        feed.items.each do |feed_item|
          i= output_feed.items.new_item
          i.title       = feed_item.title
          i.link        = feed_item.link
          i.description = feed_item.description
          i.date        = feed_item.date
        end
      end
    end
    
    @feed = output_feed
    self
  end
  
  def truncate(max_size)
    output_feed = RSS::Maker.make("2.0") do |output_feed|
      output_feed.channel.about = 'http://hoge/rss.xml'
      output_feed.channel.title = "hoge"
      output_feed.channel.description = "hoge.description"
      output_feed.channel.link = "http://hoge.link"
      output_feed.channel.language = "ja"
      
      output_feed.items.do_sort = true
      output_feed.items.max_size = max_size
      
      feed = @feed
      feed.items.each do |feed_item|
        i= output_feed.items.new_item
        i.title       = feed_item.title
        i.link        = feed_item.link
        i.description = feed_item.description
        i.date        = feed_item.date
      end
    end
    
    @feed = output_feed
    self
  end
    
end