#!/usr/bin/env ruby

require 'tweetstream'

TOPICS = ['Foo', 'Bar Baz']

TweetStream.configure do |config|
  config.consumer_key       = 'wwwwwwwww'
  config.consumer_secret    = 'xxxxxxxxx'
  config.oauth_token        = 'yyyyyyyyy'
  config.oauth_token_secret = 'zzzzzzzzz'
  config.auth_method        = :oauth
end


TweetStream::Client.new.track(*TOPICS) do |status|
  # The status object is a special Hash with
  # method access to its keys.
  puts "#{status.text}"
end
