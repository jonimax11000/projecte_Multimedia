import { Request, Response, NextFunction } from "express";

export const authMiddleware = (req: Request, res: Response, next: NextFunction) => {
  const token = req.headers["authorization"];
  if (!token) {
    return res.status(401).json({ error: "No autenticat" });
  }

  // Verifica el token (exemple bàsic, pots usar JWT)
  if (token !== "token_valid") {
    return res.status(403).json({ error: "Token invàlid" });
  }

  next(); // Si el token és vàlid, passa al següent middleware o ruta
};