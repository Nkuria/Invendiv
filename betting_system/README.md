# Rails API WebSocket Integration

This Rails API serves as the backend for handling WebSocket communications, API requests, and managing client connections.

## Features

- WebSocket server integration to send real-time updates.
- API key authentication for client connections.
- Leaderboard and odds updates broadcasted to connected WebSocket clients.
- Client management through WebSocket connections.

## Setup

### Prerequisites

Ensure you have the following installed:

- Ruby 3.0 or higher
- Rails 6.x or higher
- Bundler (`gem install bundler`)
- Node.js (for WebSocket client-side functionality)
- Redis (optional, for caching and queuing purposes)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/rails-api-websocket.git
   cd rails-api-websocket
   ```
2. Install The gems

  `bundle install`

3. Set up the database:

    `rails db:create`

    `rails db:migrate`

    `rails db:seed`

4. Start the rails server:

    `rails server`

The Rails API is now running, and you can connect to the WebSocket server for real-time updates.

## Websocket Integration

To send data to connected clients via WebSocket, you can use the WebSocketPublisher class. This class connects to a WebSocket server, sends data, and manages the connections.

## API endpoints

 - `POST /api/v1/bets`: Create a new bet (requires API authentication).
 - `GET /api/v1/users/:id`: Fetch user data.
 - `GET /api/v1/:id/bets:` Fetch user bets (authenticated).