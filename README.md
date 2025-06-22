# ChatApp

A full-stack real-time chat application with secure authentication using HTTP-only cookies. Built with a clean architecture for both frontend (Flutter) and backend (Node.js + TypeScript).

---

## 🚀 Features

- Secure HTTP-only cookie-based authentication (Login, Signup, Logout)
- Real-time chat support (planned)
- Clean Architecture with Bloc (Flutter)
- Scalable RESTful API (Node.js + Express)
- Persistent cookie storage in mobile app using `dio_cookie_manager`
- Modern UI/UX with Flutter + custom theming
- Docker-ready backend (optional)

---

## 🛠️ Tech Stack

### 🔹 Frontend (Flutter)

- Flutter (Clean Architecture)
- BLoC + Cubit for state management
- Dio (with CookieManager) for networking
- GetIt for dependency injection
- PathProvider + PersistCookieJar for secure cookie handling

### 🔹 Backend (Node.js)

- Node.js with Express.js
- TypeScript
- PostgreSQL + Prisma ORM
- Redis (for sessions, caching)
- HTTP-only cookie authentication
- Zod (for schema validation)

---

## 📁 Folder Structure

chatapp/
│
├── backend/ # Node.js + TypeScript backend
│ ├── src/
│ ├── prisma/
│ └── .env
│
├── frontend/ # Flutter mobile app
│ ├── lib/
│ ├── android/
│ ├── ios/
│ └── pubspec.yaml
│
└── README.md

---

## 🧾 Prerequisites

- Flutter (v3.0+)
- Node.js (v18+)
- PostgreSQL
- Redis
- Git

---

## ⚙️ Backend Setup

### 1. Go to backend folder

```bash
cd backend

npm install

## Flutter Run
cd frontend
```
