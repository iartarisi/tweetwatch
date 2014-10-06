require 'faye/websocket'

require 'tweetwatch'

App = lambda do |env|
  if Faye::EventSource.eventsource?(env)
    es = Faye::EventSource.new(env)

    loop = EM.add_periodic_timer(1) do
      ts = Tweet.order(created_at: :desc).limit(10).map {|t| [t.id, t.text]}
      es.send(ts.to_json)
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
