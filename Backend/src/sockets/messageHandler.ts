// src/sockets/messageHandler.ts
import { Socket, Server } from "socket.io";
import { handleSendMessage } from "../services/chat.service";

export const registerMessageHandlers = (io: Server, socket: Socket, userId: string) => {
  socket.on("message:send", async (data) => {
    const { receiverId, content } = data;

    if (!receiverId || !content) return;

    const message = await handleSendMessage(userId, receiverId, content);

    // Emit to receiver if connected
    io.sockets.sockets.forEach((s) => {
      if ((s.data as any).userId === receiverId) {
        console.log(`Message Received from ${userId}, ${message}`);
        s.emit("message:receive", message);
      }
    });

    // Emit back to sender (confirmation)
    socket.emit("message:sent", message);
  });
};
