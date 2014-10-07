require 'faye/websocket'

require 'tweetwatch'
require 'tweetwatch/schema'

LAST_N = 10
LAST_X_MINUTES = 10
REFRESH = 1


App = lambda do |env|
  if Faye::EventSource.eventsource?(env)
    es = Faye::EventSource.new(env)

    loop = EM.add_periodic_timer(REFRESH) do
      es.send(bestof.to_json)
    end

    es.on :close do |event|
      es.cancel_timer(loop)
      es = nil
    end

    # Return async Rack response
    es.rack_response

  else
    # Normal HTTP request
    [200, {'Content-Type' => 'text/html,application'}, [IO.read('static/index.html')]]
  end
end


def bestof
  tweets = Tweet.find_by_sql(<<-SQL)
    SELECT DISTINCT tweet_id, text,
       COUNT(created_at) OVER (PARTITION BY tweet_id) AS retweeted
    FROM tweets
    WHERE AGE(NOW() AT TIME ZONE 'UTC', created_at)
          < INTERVAL '#{LAST_X_MINUTES} MINUTES'
    ORDER BY retweeted DESC
    LIMIT #{LAST_N}
SQL
  tweets.map { |t| { id: t.tweet_id, text: t.text, retweeted: t.retweeted - 1} }
end
