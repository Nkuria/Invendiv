
import * as WebSocketClientManager from './clientManager';

export const broadcastLeaderboard = (data: any) => {
  if (!data) {
    console.log('No leaderboard data provided');
    return;
  }

  console.log(data)

  WebSocketClientManager.broadcastToClients({
    event: 'leaderboardUpdate',
    data: data
  });
};