require 'faye/websocket'
require 'thread'

class WebSocketPublisher
  API_KEY = ENV['API_KEY'] || 'VKOt9h8xHBsqsHCJ'

  def initialize
    @clients = []
    @ping_interval = 30 # Ping every 30 seconds
    @pong_received = true
  end

  def send_message(data)
    EventMachine.run do
      ws_url = "ws://localhost:8080?api_key=#{API_KEY}"
      ws = Faye::WebSocket::Client.new(ws_url)

      ws.on :open do |_event|
        puts 'Connected to WebSocket server'
        ws.send(data.to_json)
        puts "Sent data: #{data.to_json}"

        # Start sending heartbeats
        send_heartbeat(ws)
      end

      ws.on :message do |event|
        puts "Received message from server: #{event.data}"

        # If pong message received, reset the pong check
        @pong_received = true if event.data == 'pong'
      end

      ws.on :close do |_event|
        puts 'Connection closed'
        EventMachine.stop
      end

      ws.on :error do |event|
        puts "Error: #{event.message}"
      end
    end
  end

  def send_heartbeat(ws)
    EventMachine.add_periodic_timer(@ping_interval) do
      if @pong_received
        @pong_received = false
        ws.send({ event: 'ping' }) # Send ping message
        puts 'Sent ping message to server'
      else
        puts 'No pong received. Closing connection.'
        ws.close
      end
    end
  end

  private

  def reconnect
    ws_url = "ws://localhost:8080?api_key=#{API_KEY}"
    @ws = Faye::WebSocket::Client.new(ws_url)
  end
end
