#!/usr/bin/env ruby

require 'logger'

require 'tweetstream'
require 'active_record'


TOPICS = ['Foo', 'Bar Baz']
ActiveRecord::Base.logger = Logger.new('debug.log')
ActiveRecord::Base.configurations = YAML::load(IO.read('database.yml'))
ActiveRecord::Base.establish_connection :development

TweetStream.configure do |config|
  config.consumer_key       = 'wwwwwwwww'
  config.consumer_secret    = 'xxxxxxxxx'
  config.oauth_token        = 'yyyyyyyyy'
  config.oauth_token_secret = 'zzzzzzzzz'
  config.auth_method        = :oauth
end


class Tweet < ActiveRecord::Base
end

TweetStream::Client.new.track(*TOPICS) do |status|
  # only care about original tweets; we will have our own concept of
  # what a retweet means since we are only interested in retweets in a
  # specific time interval
  original = status.retweeted_status? ? status.retweeted_status : status

  Tweet.create(id: original.id, text: original.text,
    created_at: original.created_at)

  puts "#{status.text}"
end
