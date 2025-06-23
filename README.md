# 💬 Realtime Chat App

A full-stack realtime chat application built with **Flutter** for the frontend and **Node.js (Express + TypeScript)** for the backend. It supports:

- ✅ Authentication using session cookies
- ✅ Realtime messaging using WebSocket (Socket.IO)
- ✅ Secure cookie-based session handling
- ✅ Chat history retrieval from PostgreSQL
- ✅ Clean architecture (Frontend) and layered architecture (Backend)

---

## 🛠 Tech Stack

### 🚀 Frontend (Flutter)

- **Flutter** with Dart
- **BLoC** for state management
- **Dio** for HTTP networking
- **Socket.IO Client**
- **Equatable**, **GetIt** for DI

### 🛡 Backend (Node.js)

- **Node.js + Express + TypeScript**
- **Socket.IO** for websocket communication
- **PostgreSQL** with **Prisma ORM**
- **Redis** (optional, used in caching/session/job queues)
- **JWT** (optional, not currently used)
- **Cookie-based HTTP-only authentication**
- **Docker (optional)** for containerization

---

## ⚙️ Features

- 👤 **User Authentication** (Login, Signup, Logout)
- 🔐 **Secure session cookies** with Redis-backed sessions
- 🗨 **Realtime chat** using WebSockets (Socket.IO)
- 💾 **Chat history** stored in PostgreSQL
- 🚦 **Message delivery acknowledgment** and syncing
- 📱 Responsive mobile UI using Flutter

---

## 📁 Project Structure

project-root/
├── Backend/
│ ├── src/
│ │ ├── auth/ # Auth APIs
│ │ ├── chat/ # Chat APIs & message services
│ │ ├── config/ # DB, Redis, environment setup
│ │ ├── sockets/ # Socket.IO handlers
│ │ ├── app.ts
│ │ ├── server.ts
│ └── .env # Environment variables
│
├── Frontend/
│ └── lib/
│ ├── core/
│ ├── features/
│ │ ├── auth/
│ │ ├── chat/
│ │ ├── users/
│ └── main.dart

---

## 📦 Getting Started

### 🔁 Clone the Repository

```bash
git clone https://github.com/your-username/chatapp.git
cd chatapp


## Running Server
cd Backend
npm install

PORT=3000
DATABASE_URL=postgresql://<username>:<password>@localhost:5432/<dbname>?schema=public
COOKIE_SECRET=developer
REDIS_URL=redis://localhost:6379


npx prisma generate
npx prisma migrate dev

npm run dev

## Running Flutter App

cd Frontend
cd chatapp

flutter pub get

flutter run

## Update the BaseUrl in `dio_client` and `chat_socket_client` with ip of machine on which the backend is running. App internet connection should also be connected with same internet on which backend is running.

baseUrl: "http://<local-ip-address>:3000/api"



```
