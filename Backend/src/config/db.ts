// src/config/db.ts
import { prisma } from "./prisma";

export const connectToDatabase = async () => {
  try {
    await prisma.$connect();
    console.log("✅ Connected to PostgreSQL");
  } catch (error) {
    console.error("❌ Failed to connect to PostgreSQL:", error);
    process.exit(1);
  }
};
