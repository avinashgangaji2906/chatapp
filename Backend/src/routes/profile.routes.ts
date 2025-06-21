import { Router } from "express";
import { getUserProfileController } from "../controllers/profile.controller";
import { Auth } from "../middlewares/auth.middleware";

const router = Router();

router.get("/me", Auth, getUserProfileController);

export default router;
