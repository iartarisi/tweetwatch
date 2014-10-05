require 'tweetwatch'
require 'schema'

ActiveRecord::Base.establish_connection :development

describe '#handle_tweets' do
  before{ Schema.migrate(:setup) }

  after { Schema.migrate(:teardown) }

  it 'creates a tweet when it receives a new status' do
    status = instance_double("Twitter::Tweet", text:"Twitter is awesome!",
      id: 123, created_at: Time.now.utc)

    expect(status).to receive(:retweeted_status?).and_return(false)
    handle_tweets status

    tweet = Tweet.first
    expect(tweet.id).to eq status.id
    expect(tweet.text).to eq status.text
    expect(tweet.created_at).to be_within(0.000001).of status.created_at
  end

  it 'creates a tweet with the original status' do
    original = instance_double("Twitter::Tweet", text: "original",
      id: 123, created_at: Time.now.utc)
    status = instance_double("Twitter::Tweet", text:"not the original")

    expect(status).to receive(:retweeted_status?).and_return(true)
    expect(status).to receive(:retweeted_status).and_return original
    handle_tweets status

    expect(Tweet.count).to eq 1
    tweet = Tweet.first
    expect(tweet.id).to eq original.id
    expect(tweet.text).to eq original.text
    expect(tweet.created_at).to be_within(0.000001).of original.created_at
  end
end
