import express, { NextFunction, Request, Response } from "express";
import { CreateUserRequest } from "./interfaces/createUserRequest.js";
import { errorHandler } from "./middlewares/errorHandler.js";
import userRouter from "./routes/userRoutes.js";

const app = express();
const port = 3000;

app.use((req: Request, res: Response, next: NextFunction) => {
  const origin = req.headers.origin;
  
  res.setHeader("Access-Control-Allow-Origin", origin || "*");
  res.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, PATCH, DELETE, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization, X-Requested-With");
  res.setHeader("Access-Control-Allow-Credentials", "true");
  res.setHeader("Vary", "Origin");

  if (req.method === "OPTIONS") {
    return res.sendStatus(204);
  }
  next();
});

app.use(express.json());

app.use("/api/usuaris", userRouter);

app.use(errorHandler);

app.listen(port, () => {
  console.log(`🚀 Servidor ejecutándose en http://localhost:${port}`);
});