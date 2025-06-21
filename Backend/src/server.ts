import app from "./app";
import { connectToDatabase } from "./config/db";
import "./config/redis";

const PORT = process.env.PORT || 3000;

async function startServer() {
  await connectToDatabase();

  app.listen(PORT, () => {
    console.log(`🚀 Server running at http://localhost:${PORT}`);
  });
}

startServer();
