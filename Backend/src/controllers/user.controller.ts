// src/controllers/user.controller.ts
import { Request, Response } from "express";
import { fetchAllUsers } from "../services/user.service";
import { AuthRequest } from "../middlewares/auth.middleware";
import { StatusCodes } from "../constants/statusCodes";

export const getAllUsers = async (req: AuthRequest, res: Response) => {
  try {
    const users = await fetchAllUsers(req.userId!);

    res.status(StatusCodes.OK).json({
      success: true,
      users,
    });
  } catch (error) {
    res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
      success: false,
      message: "Error fetching users",
    });
  }
};
