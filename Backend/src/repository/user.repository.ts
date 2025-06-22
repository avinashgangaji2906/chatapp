// src/repositories/user.repository.ts
import { prisma } from "../config/prisma";

export const getAllUsersExcept = async (currentUserId: string) => {
  try {
    return await prisma.user.findMany({
      where: {
        id: {
          not: currentUserId,
        },
      },
      select: {
        id: true,
        username: true,
      },
    });
  } catch (err) {
    console.error(" Error fetching users:", err);
    throw err;
  }
};
