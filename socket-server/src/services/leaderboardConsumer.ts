import * as WebSocketClientManager from './clientManager';

export const broadcastLeaderboard = () => {
  // In a real implementation, this data would come from Rails via WebSocket or an API call.
  const leaderboardData = [
    { user_id: 1, first_name: 'John', surname: 'Doe', wins: 10 },
    { user_id: 2, first_name: 'Jane', surname: 'Smith', wins: 8 },
    { user_id: 3, first_name: 'Alice', surname: 'Johnson', wins: 5 },
  ];

  console.log('Broadcasting leaderboard:', leaderboardData);

  // Send leaderboard data to all connected clients
  WebSocketClientManager.broadcastToClients({
    event: 'leaderboardUpdate',
    data: leaderboardData,
  });
};