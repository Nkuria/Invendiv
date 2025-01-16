import { Server, WebSocket } from 'ws';
import * as WebSocketClientManager from './clientManager';
import * as LeaderboardConsumer from './leaderboardConsumer';
import * as OddsConsumer from './oddsConsumer';

// WebSocket server setup
const wss = new Server({ port: 8080 });

wss.on('connection', (ws: WebSocket) => {
  console.log('New client connected');
  WebSocketClientManager.addClient(ws);

  // Handle incoming messages
  ws.on('message', (message: string) => {
    console.log('Received message from client:', message);

    const data = JSON.parse(message);
    switch (data.event) {
      case 'requestLeaderboard':
        // Broadcast the leaderboard to the client
        LeaderboardConsumer.broadcastLeaderboard();
        break;
      case 'requestOdds':
        // Broadcast the odds to the client
        OddsConsumer.broadcastOdds();
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
});

export const startWebSocketServer = () => {
  console.log('WebSocket server started on ws://localhost:8080');
};
