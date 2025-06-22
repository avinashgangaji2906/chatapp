import http from "http";
import { Server as SocketIOServer } from "socket.io";
import app from "./app";
import { connectToDatabase } from "./config/db";
import "./config/redis";
import { setupSocket } from "./sockets/socketServer";

const PORT = process.env.PORT || 3000;

async function startServer() {
  await connectToDatabase();

  const server = http.createServer(app);

  const io = new SocketIOServer(server, {
    cors: {
      origin: "http://localhost:3000",
      credentials: true,
    },
  });

  setupSocket(io); // Register socket event handlers

  server.listen(PORT, () => {
    console.log(`🚀 Server running at http://localhost:${PORT}`);
  });
}

startServer();
