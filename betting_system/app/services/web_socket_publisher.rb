require 'faye/websocket'
require 'thread'

class WebSocketPublisher
  def initialize
    @clients = []
    @ws = Faye::WebSocket::Client.new('ws://localhost:8080')
  end

  def send_message(data)
    EventMachine.run do
      ws = Faye::WebSocket::Client.new('ws://localhost:8080')

      ws.on :open do |_event|
        puts 'Connected to WebSocket server'

        # Send the data after the connection is open
        ws.send(data.to_json)
        puts "Sent data: #{data.to_json}"
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
    @ws = Faye::WebSocket::Client.new('ws://localhost:8080')
  end
end
