import { Server, Socket } from "socket.io";
import { saveMessage } from "../repository/chat.repository";
import { addUserSocket, removeUserSocket, getUserSocket } from "./socketManager";

export const registerMessageHandlers = (io: Server, socket: Socket, userId: string) => {
  addUserSocket(userId, socket);

  socket.on("message:send", async (payload: any) => {
    try {
      const { senderId, receiverId, content } = payload;
      console.log(`Received message:send from ${senderId} to ${receiverId}: ${content}`);

      if (!senderId || !receiverId || !content) {
        socket.emit("error", { message: "Invalid message payload" });
        return;
      }

      const savedMessage = await saveMessage(senderId, receiverId, content);
      console.log(`Emitting message:receive: ${JSON.stringify(savedMessage)}`);

      // Emit to sender
      socket.emit("message:receive", savedMessage);

      // Emit to receiver
      const receiverSocket = getUserSocket(receiverId);
      if (receiverSocket) {
        receiverSocket.emit("message:receive", savedMessage);
        console.log(`📬 Emitted message:receive to ${receiverId}`);
      } else {
        console.log(`Receiver ${receiverId} not connected`);
      }
    } catch (err: any) {
      console.error("Error handling message:", err.message);
      socket.emit("error", { message: "Failed to send message" });
    }
  });

  socket.on("disconnect", (reason) => {
    console.log(`Disconnected: ${userId} (Reason: ${reason})`);
    removeUserSocket(userId);
  });
};
