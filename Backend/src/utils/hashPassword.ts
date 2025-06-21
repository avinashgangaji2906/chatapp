import bcrypt from "bcrypt";

export const hashPassword = (password: string) => bcrypt.hash(password, 10);
export const verifyPassword = (password: string, hashed: string) => bcrypt.compare(password, hashed);
