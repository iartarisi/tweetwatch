require 'logger'

require 'active_record'


ActiveRecord::Base.logger = Logger.new('debug.log')
ActiveRecord::Base.configurations = YAML::load(IO.read('database.yml'))
ActiveRecord::Base.establish_connection :development


class Tweet < ActiveRecord::Base
end

def handle_tweets(status)
  # only care about original tweets; we will have our own concept of
  # what a retweet means since we are only interested in retweets in a
  # specific time interval
  original = status.retweeted_status? ? status.retweeted_status : status

  Tweet.create(id: original.id, text: original.text,
    created_at: original.created_at)

  puts "#{status.text}"
end
