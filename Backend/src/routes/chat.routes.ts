// src/routes/chat.routes.ts
import { Router } from "express";
import { getChatHistory } from "../controllers/chat.controller";
import { Auth } from "../middlewares/auth.middleware";

const router = Router();

router.get("/:receiverId", Auth, getChatHistory);

export default router;
