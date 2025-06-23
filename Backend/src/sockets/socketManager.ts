import { Socket } from "socket.io";

const userSockets = new Map<string, Socket>();

export const addUserSocket = (userId: string, socket: Socket) => {
  userSockets.set(userId, socket);
  console.log(`✅ Added socket for user ${userId}. Total users: ${userSockets.size}`);
};

export const removeUserSocket = (userId: string) => {
  userSockets.delete(userId);
  console.log(`❌ Removed socket for user ${userId}. Total users: ${userSockets.size}`);
};

export const getUserSocket = (userId: string): Socket | undefined => {
  return userSockets.get(userId);
};
