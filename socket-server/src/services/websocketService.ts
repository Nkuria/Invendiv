import { Server, WebSocket } from 'ws';
import * as WebSocketClientManager from './clientManager';
import * as LeaderboardConsumer from './leaderboardConsumer';
import * as OddsConsumer from './oddsConsumer';

// WebSocket server setup
const wss = new Server({ port: 8080 });
const API_KEY = process.env.API_KEY || 'VKOt9h8xHBsqsHCJ';

wss.on('connection', (ws: WebSocket, req: any) => {

  const urlParams = new URLSearchParams(req.url.split('?')[1]);
  const apiKey = urlParams.get('api_key');
  console.log(apiKey)
  console.log(API_KEY)
  console.log(apiKey != API_KEY)

  if (!apiKey || apiKey !== API_KEY) {
    console.log('Unauthorized connection attempt');
    ws.close(4001, 'Unauthorized');
    return;
  }

  console.log('New client connected');
  WebSocketClientManager.addClient(ws);

  // Handle incoming messages
  ws.on('message', (message: string) => {

    // Prevent Dos attacks
    if (message.length > 1024) { // 1 KB limit
      ws.close(4003, 'Payload too large');
      return;
    }
    console.log('Received message from client:', message);

    const data = JSON.parse(message);
    switch (data.event) {
      case 'ping':
        // Respond with pong to keep the connection alive
        ws.send('pong');
        console.log('Sent pong message');
        break;
        
      case 'requestLeaderboard':
        // Broadcast the leaderboard to the client
        LeaderboardConsumer.broadcastLeaderboard(data);
        break;
      case 'requestOdds':
        // Broadcast the odds to the client
        OddsConsumer.broadcastOdds(data);
        break;
      default:
        console.log('Unknown event received:', data.event);
    }
  });

  // Handle WebSocket disconnection
  ws.on('close', () => {
    console.log('Client disconnected');
    WebSocketClientManager.removeClient(ws);
  });

  // Handle errors / unexpected disconnects
  ws.on('error', (err) => {
    console.error('WebSocket error:', err.message);
    WebSocketClientManager.removeClient(ws);
  });
});

export const startWebSocketServer = () => {
  console.log('WebSocket server started on ws://localhost:8080');
};
