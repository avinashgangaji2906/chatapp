import { Request, Response } from "express";
import { createUser, verifyUser } from "../services/auth.service";
import { signupSchema, loginSchema } from "../schemas/auth.schema";
import { StatusCodes } from "../constants/statusCodes";
import { AuthRequest } from "../middlewares/auth.middleware";

export const signupController = async (req: Request, res: Response) => {
  try {
    const parsed = signupSchema.parse(req.body);
    const user = await createUser(parsed);

    res.cookie("session", user.id, {
      httpOnly: true,
      sameSite: "lax",
      secure: process.env.NODE_ENV === "production",
      signed: true,
      maxAge: 1000 * 60 * 60 * 24, // 1 day
    });

    res.status(StatusCodes.CREATED).json({
      success: true,
      user: { id: user.id, username: user.username },
    });
  } catch (error: any) {
    res.status(400).json({ success: false, message: error.message });
  }
};

export const loginController = async (req: Request, res: Response) => {
  try {
    const parsed = loginSchema.parse(req.body);
    const user = await verifyUser(parsed);

    res.cookie("session", user.id, {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "lax",
      signed: true,
      maxAge: 1000 * 60 * 60 * 24, // 1 day
    });

    res.status(StatusCodes.OK).json({
      success: true,
      message: "Logged in",
      user: { id: user.id, username: user.username },
    });
  } catch (error: any) {
    res.status(StatusCodes.BAD_REQUEST).json({ success: false, message: error.message });
  }
};

export const logoutController = async (req: AuthRequest, res: Response) => {
  try {
    res.clearCookie("session", {
      httpOnly: true,
      sameSite: "lax",
      secure: process.env.NODE_ENV === "production",
      signed: true,
    });

    res.status(StatusCodes.OK).json({
      success: true,
      message: "Logged out successfully",
    });
  } catch (error) {
    console.error("Logout error:", error);

    res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
      success: false,
      message: "Failed to log out",
    });
  }
};
