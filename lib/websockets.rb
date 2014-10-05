require 'faye/websocket'

require 'tweetwatch'

App = lambda do |env|
  if Faye::WebSocket.websocket?(env)
    ws = Faye::WebSocket.new(env)

    ws.on :open do |event|
      ts = Tweet.limit(10).map {|t| [t.id, t.text]}
      ws.send(ts.to_json)
    end
      
    ws.on :close do |event|
      p [:close, event.code, event.reason]
      ws = nil
    end

    # Return async Rack response
    ws.rack_response

  else
    # Normal HTTP request
    [200, {'Content-Type' => 'text/html,application'}, [IO.read('static/index.html')]]
  end
end
