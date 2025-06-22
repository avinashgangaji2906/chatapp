// src/controllers/chat.controller.ts
import { Request, Response } from "express";
import { fetchChatHistory } from "../services/chat.service";
import { StatusCodes } from "../constants/statusCodes";
import { AuthRequest } from "../middlewares/auth.middleware";

export const getChatHistory = async (req: AuthRequest, res: Response) => {
  try {
    const userId = req.userId!;
    const { receiverId } = req.params;

    const messages = await fetchChatHistory(userId, receiverId);

    res.status(StatusCodes.OK).json({
      success: true,
      messages,
    });
  } catch (err: any) {
    console.error("Fetch Chat History Error:", err);
    res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
      success: false,
      message: "Failed to fetch chat history",
    });
  }
};
