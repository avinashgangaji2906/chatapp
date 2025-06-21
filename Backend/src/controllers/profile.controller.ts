import { Request, Response, NextFunction } from "express";
import { getUserById } from "../services/profile.service";
import { StatusCodes } from "../constants/statusCodes";
import { AuthRequest } from "../middlewares/auth.middleware";

export const getUserProfileController = async (req: AuthRequest, res: Response) => {
  try {
    const userId = req.userId;

    if (!userId || typeof userId !== "string") {
      res.status(StatusCodes.UNAUTHORIZED).json({
        success: false,
        message: "Unauthorized access. User ID missing or invalid.",
      });
      return;
    }

    const user = await getUserById(userId);

    if (!user) {
      res.status(StatusCodes.NOT_FOUND).json({
        success: false,
        message: `User not found with userId ${userId}`,
      });
      return;
    }

    res.status(StatusCodes.OK).json({
      success: true,
      user,
    });
  } catch (error) {
    console.error("Error fetching user profile:", error);
    res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
      success: false,
      message: "Internal server error while fetching user profile.",
    });
  }
};
