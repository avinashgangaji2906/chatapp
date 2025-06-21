import { prisma } from "../config/prisma";

export const getUserById = async (id: string) => {
  try {
    if (!id || typeof id !== "string") {
      throw new Error("Invalid or missing user ID");
    }

    const user = await prisma.user.findUnique({
      where: { id },
      select: {
        id: true,
        username: true,
      },
    });

    if (!user) {
      throw new Error("User not found");
    }

    return user;
  } catch (error) {
    console.error("Error in getUserById:", error);
    throw new Error("Failed to fetch user");
  }
};
