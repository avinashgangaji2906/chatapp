import { Server } from "socket.io";
import * as cookie from "cookie";
import * as signature from "cookie-signature";
import { registerMessageHandlers } from "./messageHandler";
import { addUserSocket, removeUserSocket } from "./socketManager";

export const setupSocket = (io: Server) => {
  io.on("connection", (socket) => {
    try {
      const rawCookie = socket.handshake.headers.cookie || "";

      const cookies = cookie.parse(rawCookie);
      const signedSession = cookies["session"];

      if (!signedSession?.startsWith("s:")) return socket.disconnect();

      const userId = signature.unsign(signedSession.slice(2), process.env.COOKIE_SECRET!);

      if (!userId) return socket.disconnect();

      (socket.data as any).userId = userId;

      // console.log(`✅ Socket connected: ${userId}`);

      registerMessageHandlers(io, socket, userId);

      // socket.on("disconnect", () => {
      //   console.log(`❌ Disconnected: ${userId}`);
      // });
    } catch (err) {
      console.error("Socket Error:", err);
      socket.disconnect();
    }
  });
};
