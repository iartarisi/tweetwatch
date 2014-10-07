require 'eventsource'
require 'schema'

require_relative 'spec_helper'

describe '#bestof' do
  before { Schema.migrate(:setup) }
  after { Schema.migrate(:teardown) }

  subject { bestof }

  it 'returns the most retweeted N items in the last N minutes' do
    # ignores one tweet that is too old
    Tweet.create(tweet_id: 0, text: 'old',
      created_at: Time.now.utc - LAST_X_MINUTES * 60 - 1)

    Tweet.create(tweet_id: 1, text: 'foo', created_at: Time.now.utc)
    Tweet.create(tweet_id: 1, text: 'foo', created_at: Time.now.utc)
    Tweet.create(tweet_id: 2, text: 'qux', created_at: Time.now.utc)
    Tweet.create(tweet_id: 3, text: 'bar', created_at: Time.now.utc)
    Tweet.create(tweet_id: 3, text: 'bar', created_at: Time.now.utc)
    Tweet.create(tweet_id: 3, text: 'bar', created_at: Time.now.utc)

    Tweet.create(tweet_id: 4, text: 'baz', created_at: Time.now.utc)
    Tweet.create(tweet_id: 5, text: 'foo', created_at: Time.now.utc)

    # ignores retweets that are too old
    Tweet.create(tweet_id: 6, text: 'old',
      created_at: Time.now.utc - LAST_X_MINUTES * 60 - 1)
    Tweet.create(tweet_id: 6, text: 'old',
      created_at: Time.now.utc - LAST_X_MINUTES * 60 - 1)

    Tweet.create(tweet_id: 7, text: 'baz', created_at: Time.now.utc)
    Tweet.create(tweet_id: 8, text: 'baz', created_at: Time.now.utc)
    Tweet.create(tweet_id: 9, text: 'baz', created_at: Time.now.utc)
    Tweet.create(tweet_id: 10, text: 'baz', created_at: Time.now.utc)
    Tweet.create(tweet_id: 11, text: 'baz', created_at: Time.now.utc)

    expect(subject.length).to eq(LAST_N)
    is_expected.to eq [
      {id: 3, text: 'bar', retweeted: 2},
      {id: 1, text: 'foo', retweeted: 1},
      {id: 2, text: 'qux', retweeted: 0},
      {id: 4, text: 'baz', retweeted: 0},
      {id: 5, text: 'foo', retweeted: 0},
      {id: 7, text: 'baz', retweeted: 0},
      {id: 8, text: 'baz', retweeted: 0},
      {id: 9, text: 'baz', retweeted: 0},
      {id: 10, text: 'baz', retweeted: 0},
      {id: 11, text: 'baz', retweeted: 0}
    ]
  end
end
