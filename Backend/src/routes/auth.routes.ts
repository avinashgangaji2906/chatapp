import { Router } from "express";
import { loginController, logoutController, signupController } from "../controllers/auth.controller";
import { Auth } from "../middlewares/auth.middleware";

const router = Router();

router.post("/signup", signupController);
router.post("/login", loginController);
router.post("/logout", Auth, logoutController);

export default router;
