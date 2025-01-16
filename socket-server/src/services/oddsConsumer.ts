import * as WebSocketClientManager from './clientManager';

export const broadcastOdds = (data: any) => {


   if (!data) {
     console.log('No odds data provided');
     return;
   }
 
   console.log(data)
 
  // Send odds data to all connected clients
  WebSocketClientManager.broadcastToClients({
    event: 'oddsUpdate',
    data: data,
  });
};

