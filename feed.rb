#encoding: utf-8
require 'net/http'
require 'rss'
require './const'

class Feed
  def initialize(url)
    host = url.host
    path = url.path
    # proxy_class = Net::HTTP::Proxy('proxy1.screen.co.jp', 8080)
    # feed = proxy_class.get(host, path).force_encoding('utf-8')
    #configure :production do
      feed = Net::HTTP.get(host, path).force_encoding('utf-8')
    #end
    begin
      @feed = RSS::Parser.parse(feed)
    rescue RSS::InvalidRSSError
      @feed = RSS::Parser.parse(feed, false )
    end
  end
  
  def add_new_item(item, output_feed)
    i= output_feed.items.new_item
    i.title       = item.title
    i.link        = item.link
    i.description = item.description
    i.date        = item.date
  end

  def add_new_items(items, output_feed)
    items.each do |feed_item|
      add_new_item(feed_item, output_feed)
    end
  end

  def create_new_feed(feed, about, title, description, link, language = 'ja') 
    feed.channel.about = about
    feed.channel.title = title
    feed.channel.description = description
    feed.channel.link = link
    feed.channel.language = language
  end
  
  def create_sample_feed(output_feed)
    create_new_feed(
      output_feed, 'http://hoge/rss.xml', "hoge", 
      "hoge.description", "http://hoge.link")
  end
  
  def to_s
    @feed.to_s
  end
  
  def items
    @feed.items
  end

  def append(*appended_feeds)
    output_feed= RSS::Maker.make("2.0") do |output_feed|
      create_sample_feed(output_feed)
      output_feed.items.do_sort = true
      add_new_items(@feed.items, output_feed)
    
      appended_feeds.each do |feed|
        add_new_items(feed.items, output_feed)
      end
    end
    @feed = output_feed
    self
  end
  
  # うまく動かない
  def self.union(*appended_feeds)
    output_feed= RSS::Maker.make("2.0") do |output_feed|
      create_sample_feed(output_feed)
      output_feed.items.do_sort = true

      appended_feeds.each do |feed|
        feed.items.each do |feed_item|
          add_new_items(feed.items, output_feed)
        end
      end
    end
    @feed = output_feed
  end
  
  def unique
    output_feed = RSS::Maker.make("2.0") do |output_feed|
      create_sample_feed(output_feed)
      output_feed.items.do_sort = true
      
      feed = @feed
      for m in 0..(feed.items.size - 1) do
        if m == 0
          add_new_item(feed.items[m], output_feed)
          puts "#{feed.items[m].link} を最初に追加しました。" if DEBUG_UNIQUE
        else
          skip_this_feed = false
          for n in 0..(m - 1)
            if feed.items[m].link == feed.items[n].link
              skip_this_feed = true
              puts 'same link was found' if DEBUG_UNIQUE
              break;
            else
              puts 'not same link' if DEBUG_UNIQUE
            end
          end
          puts 'comparison check ended' if DEBUG_UNIQUE
          unless skip_this_feed
            add_new_item(feed.items[m], output_feed)
            puts "m = #{m}: #{feed.items[m].link} を追加しました。" if DEBUG_UNIQUE
          end
        end
      end
    end # RSS::Maker
    @feed = output_feed
    self
  end
  
  def truncate(max_size)
    output_feed = RSS::Maker.make("2.0") do |output_feed|
      create_sample_feed(output_feed)
      output_feed.items.do_sort = true
      output_feed.items.max_size = max_size
      feed = @feed
      add_new_items(feed.items, output_feed)
    end
    
    @feed = output_feed
    self
  end
  
  def regex(arg)
    output_feed = RSS::Maker.make("2.0") do |output_feed|
      create_sample_feed(output_feed)
      output_feed.items.do_sort = true
      feed = @feed
      items.each do |item|
        i= output_feed.items.new_item
        i.title       = item.title
        i.link        = item.link
        desc = item.description
        for j in 0..(arg.size - 1)
          desc = desc.gsub(arg[j][:find], arg[j][:replace])
        end
        i.description = desc
        i.date        = item.date
      end
    end

    @feed = output_feed
    self
  end
  
  def filter(arg)
    output_feed = RSS::Maker.make("2.0") do |output_feed|
      create_sample_feed(output_feed)
      output_feed.items.do_sort = true
      feed = @feed
      items.each do |item|
        if arg['title']
          arg['title'].each do |keyword|
            if item.title.include?(keyword)
              add_new_item(item, output_feed)
              break
            end
          end
        elsif arg['link']
          arg['link'].each do |keyword|
            if item.link.include?(keyword)
              add_new_item(item, output_feed)
              break
            end
          end
        end
      end
    end
    @feed = output_feed
    self
  end
end