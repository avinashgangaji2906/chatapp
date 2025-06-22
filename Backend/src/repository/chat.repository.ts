// src/repositories/chat.repository.ts
import { prisma } from "../config/prisma";

export const saveMessage = async (senderId: string, receiverId: string, content: string) => {
  try {
    if (!senderId || !receiverId || !content) {
      throw new Error("Missing required fields to save message");
    }
    console.log(`Message Saved in DB with SenderId : ${senderId}, and content ${content}`);
    return await prisma.message.create({
      data: { senderId, receiverId, content },
    });
  } catch (error: any) {
    console.error(" Error saving message:", error.message);
    throw new Error("Failed to save message. Please try again.");
  }
};

export const getMessagesBetweenUsers = async (user1: string, user2: string) => {
  try {
    if (!user1 || !user2) {
      throw new Error("Missing user identifiers to fetch messages");
    }

    return await prisma.message.findMany({
      where: {
        OR: [
          { senderId: user1, receiverId: user2 },
          { senderId: user2, receiverId: user1 },
        ],
      },
      orderBy: { createdAt: "asc" },
    });
  } catch (error: any) {
    console.error(" Error fetching chat history:", error.message);
    throw new Error("Failed to fetch messages. Please try again.");
  }
};
