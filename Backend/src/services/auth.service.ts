import { prisma } from "../config/prisma";
import { LoginInput, SignupInput } from "../schemas/auth.schema";
import { hashPassword, verifyPassword } from "../utils/hashPassword";

export const createUser = async ({ username, password }: SignupInput) => {
  try {
    const existingUser = await prisma.user.findUnique({ where: { username } });
    if (existingUser) {
      throw new Error("Username is already taken");
    }

    const hashedPassword = await hashPassword(password);

    const user = await prisma.user.create({
      data: {
        username,
        password: hashedPassword,
      },
      select: {
        id: true,
        username: true,
        createdAt: true,
      },
    });

    console.log(`New User created with userId ${user.id}`);

    return user;
  } catch (error) {
    console.error("Error in createUser:", error);
    throw error;
  }
};

export const verifyUser = async ({ username, password }: LoginInput) => {
  try {
    const user = await prisma.user.findUnique({
      where: { username },
    });

    const isValid = user && (await verifyPassword(password, user.password));

    if (!isValid) {
      throw new Error("Invalid credentials");
    }

    console.log(`User Verified with userId ${user.id}`);

    return {
      id: user.id,
      username: user.username,
      createdAt: user.createdAt,
    };
  } catch (error) {
    console.error("Error in verifyUser:", error);
    throw error;
  }
};
