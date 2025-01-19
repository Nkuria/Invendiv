require 'faye/websocket'
require 'thread'

class WebSocketPublisher
  API_KEY = ENV['API_KEY'] || 'VKOt9h8xHBsqsHCJ'

  def initialize
    @clients = []
    @ws = Faye::WebSocket::Client.new('ws://localhost:8080')
  end

  def send_message(data)
    EventMachine.run do
      ws_url = "ws://localhost:8080?api_key=#{API_KEY}"
      ws = Faye::WebSocket::Client.new(ws_url)

      ws.on :open do |_event|
        puts 'Connected to WebSocket server'

        ws.send(data.to_json)
        puts "Sent data: #{data.to_json}"
        ws.close
      end

      ws.on :message do |event|
        puts "Received message from server: #{event.data}"
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

  private

  def reconnect
    ws_url = "ws://localhost:8080?api_key=#{API_KEY}"
    @ws = Faye::WebSocket::Client.new(ws_url)
  end
end
