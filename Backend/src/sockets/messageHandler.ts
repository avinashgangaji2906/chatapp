// // src/sockets/messageHandler.ts
// import { Socket, Server } from "socket.io";
// import { handleSendMessage } from "../services/chat.service";
// import { addUserSocket, getUserSocket, removeUserSocket } from "./socketManager";

// // export const registerMessageHandlers = (io: Server, socket: Socket, userId: string) => {

// //   socket.on("message:send", async (data) => {
// //     try {
// //       const { receiverId, content } = data;

// //       if (!receiverId || !content) return;

// //       const message = await handleSendMessage(userId, receiverId, content);

// //       // Emit to receiver if connected
// //       io.sockets.sockets.forEach((s) => {
// //         if ((s.data as any).userId === receiverId) {
// //           console.log(`Message Received from ${userId}, ${message.content}`);
// //           s.emit("message:receive", message);
// //         }
// //       });

// //       // Emit back to sender (confirmation)
// //       socket.emit("message:sent", message);
// //       console.log(`Emitted back to sender : ${userId}`);
// //     } catch (error: any) {
// //       console.error("Error handling message:", error.message);
// //       socket.emit("error", { message: "Failed to send message" });
// //     }
// //   });
// // };

// export const registerMessageHandlers = (io: Server, socket: Socket, userId: string) => {
//   // Store the user's socket
//   addUserSocket(userId, socket);

//   socket.on("message:send", async (payload: any) => {
//     try {
//       const { senderId, receiverId, content } = payload;

//       if (!senderId || !receiverId || !content) {
//         socket.emit("error", { message: "Invalid message payload" });
//         return;
//       }

//       // Save message to database
//       const savedMessage = await handleSendMessage(senderId, receiverId, content);
//       console.log(`Message saved: ${JSON.stringify(savedMessage)}`);

//       // Emit to sender (for confirmation)
//       socket.emit("message:receive", savedMessage);

//       // Emit to receiver
//       const receiverSocket = getUserSocket(receiverId);
//       if (receiverSocket) {
//         receiverSocket.emit("message:receive", savedMessage);
//       } else {
//         console.log(`Receiver ${receiverId} not connected`);
//       }
//     } catch (err: any) {
//       console.error("Error handling message:", err.message);
//       socket.emit("error", { message: "Failed to send message" });
//     }
//   });

//   socket.on("disconnect", () => {
//     removeUserSocket(userId);
//   });
// };

// ------------------

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
