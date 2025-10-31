// src/middlewares/errorHandler.ts
import { Request, Response, NextFunction } from "express";

export const errorHandler = (err: any, req: Request, res: Response, next: NextFunction) => {
  console.error(err.stack);

  const status = err.status || 500; // Establir l'estat de la resposta
  const message = err.message || "Error intern del servidor";

  res.status(status).json({ error: message });
};