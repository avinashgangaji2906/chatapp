// src/services/user.service.ts
import { getAllUsersExcept } from "../repository/user.repository";

export const fetchAllUsers = async (currentUserId: string) => {
  return getAllUsersExcept(currentUserId);
};
