import * as WebSocketClientManager from './clientManager';

export const broadcastOdds = () => {
  // Example odds data (would come from Rails in a real implementation)
  const oddsData = [
    { game_id: 1, home_team: 'Arsenal', away_team: 'Chelsea', home_odds: 1.5, away_odds: 2.5 },
    { game_id: 2, home_team: 'Liverpool', away_team: 'Manchester City', home_odds: 2.0, away_odds: 2.2 },
  ];

  console.log('Broadcasting odds:', oddsData);

  // Send odds data to all connected clients
  WebSocketClientManager.broadcastToClients({
    event: 'oddsUpdate',
    data: oddsData,
  });
};