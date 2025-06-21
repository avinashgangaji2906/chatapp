import express from "express";
import cookieParser from "cookie-parser";
import dotenv from "dotenv";
import cors from "cors";

import authRoutes from "./routes/auth.routes";
import profileRoutes from "./routes/profile.routes";

dotenv.config();

const app = express();

app.use(express.json());
app.use(cookieParser(process.env.COOKIE_SECRET));
app.use("/api/auth", authRoutes);
app.use("/api/profile", profileRoutes);
app.use(
  cors({
    origin: "http://localhost:3000",
    credentials: true, // allows cookies
  })
);

export default app;
