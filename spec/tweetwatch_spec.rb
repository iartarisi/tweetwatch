require 'tweetwatch'
require 'schema'

require_relative 'spec_helper'

describe '#handle_tweets' do
  before{ Schema.migrate(:setup) }
  after { Schema.migrate(:teardown) }
  let (:status) { instance_double("Twitter::Tweet", text:"Twitter is awesome!",
      id: 123, created_at: Time.now.utc, retweeted_status?: false) }

  it 'creates a tweet when it receives a new status' do
    handle_tweets status

    tweet = Tweet.first
    expect(tweet.id).to eq status.id
    expect(tweet.text).to eq status.text
    expect(tweet.created_at).to be_within(0.000001).of status.created_at
  end

  it 'creates a tweet with the original status' do
    retweet = instance_double("Twitter::Tweet", text:"not the original")

    expect(retweet).to receive(:retweeted_status?).and_return(true)
    expect(retweet).to receive(:retweeted_status).and_return status
    handle_tweets retweet

    expect(Tweet.count).to eq 1
    tweet = Tweet.first
    expect(tweet.id).to eq status.id
    expect(tweet.text).to eq status.text
    expect(tweet.created_at).to be_within(0.000001).of status.created_at
  end
end
