// src/routes/user.routes.ts
import { Router } from "express";
import { getAllUsers } from "../controllers/user.controller";
import { Auth } from "../middlewares/auth.middleware";

const router = Router();

router.get("/all", Auth, getAllUsers);

export default router;
