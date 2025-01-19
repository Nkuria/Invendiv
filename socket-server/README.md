#  Node.js WebSocket Server

This Node.js WebSocket server handles real-time communication with clients for events like leaderboard updates and odds updates.

## Features
- WebSocket server to manage multiple client connections.
- Authentication via API key for clients to establish connections.
- Heartbeat mechanism (ping-pong) to keep connections alive.
- Broadcast functionality for leaderboard and odds updates.

## Setup

### Prerequisites

Ensure you have the following installed:

- Node.js 14.x or higher
- npm or yarn

### Installation

#### Clone the repository:
 `git clone https://github.com/yourusername/node-websocket-server.git`

 `cd node-websocket-server`


 #### Install the dependencies:

 `npm install`

  #### Start the WebSocket server:
   `npm run dev`