// src/repositories/chat.repository.ts
import { prisma } from "../config/prisma";

export const saveMessage = async (senderId: string, receiverId: string, content: string) => {
  try {
    if (!senderId || !receiverId || !content) {
      throw new Error("Missing required fields to save message");
    }
    const message = await prisma.message.create({
      data: { senderId, receiverId, content },
    });
    console.log(`Message Saved in DB with SenderId : ${senderId} & ReceiverId : ${receiverId} & content: ${content}`);
    return message;
  } catch (error: any) {
    console.error(" Error saving message:", error.message);
    throw new Error("Failed to save message. Please try again.");
  }
};

export const getMessagesBetweenUsers = async (userId: string, receiverId: string) => {
  try {
    if (!userId || !receiverId) {
      throw new Error("Missing user identifiers to fetch messages");
    }

    return await prisma.message.findMany({
      where: {
        OR: [
          { senderId: userId, receiverId: receiverId },
          { senderId: receiverId, receiverId: userId },
        ],
      },
      orderBy: { createdAt: "asc" },
    });
  } catch (error: any) {
    console.error(" Error fetching chat history:", error.message);
    throw new Error("Failed to fetch messages. Please try again.");
  }
};
