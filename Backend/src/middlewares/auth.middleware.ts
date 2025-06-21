import { Request, Response, NextFunction } from "express";
import { StatusCodes } from "../constants/statusCodes";

export interface AuthRequest extends Request {
  userId?: string;
}

export const Auth = (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const userId = req.signedCookies?.session;

    if (!userId || typeof userId !== "string") {
      res.status(StatusCodes.UNAUTHORIZED).json({
        success: false,
        message: "Unauthorized: Invalid or missing session cookie",
      });
      return;
    }

    req.userId = userId; // Set UserId to next request
    next();
  } catch (error) {
    console.error("Auth Middleware Error:", error);
    res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
      success: false,
      message: "Internal server error while validating authentication",
    });
  }
};
