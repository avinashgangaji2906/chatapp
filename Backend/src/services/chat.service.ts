// src/services/chat.service.ts
import { saveMessage, getMessagesBetweenUsers } from "../repository/chat.repository";

export const handleSendMessage = async (senderId: string, receiverId: string, content: string) => {
  return saveMessage(senderId, receiverId, content);
};

export const fetchChatHistory = async (user1: string, user2: string) => {
  return getMessagesBetweenUsers(user1, user2);
};
