import { WebSocket } from 'ws';

// Array to track connected WebSocket clients
let clients: WebSocket[] = [];

export const addClient = (ws: WebSocket) => {
  clients.push(ws);
};

export const removeClient = (ws: WebSocket) => {
  clients = clients.filter(client => client !== ws);
};

export const broadcastToClients = (message: object) => {
  clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(JSON.stringify(message));
    }
  });
};