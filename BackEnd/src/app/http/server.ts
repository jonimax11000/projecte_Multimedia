import express, { NextFunction, Request, Response } from "express";
import videolistRoutes from "./routes/videolistRoutes";
import path from "path";
import { fileURLToPath } from "url";

// Solución para __dirname en ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export function buildServer() {
  const app = express();
  app.use(express.json());
  
  // SERVIR ARCHIVOS ESTÁTICOS - Configuración corregida
  const publicPath = path.join(__dirname, '../../app/public');
  app.use('/thumbnails', express.static(path.join(publicPath, 'thumbnails')));
  app.use('/videos', express.static(path.join(publicPath, 'videos')));
  
  // Configuración CORS
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

  // Rutas de la API
  app.use("/api/videolist", videolistRoutes);

  // Manejo de rutas no encontradas
  app.use((req: Request, res: Response) => {
    res.status(404).json({ message: "Resource not found" });
  });

  // Manejo de errores
  app.use((err: any, req: Request, res: Response, next: NextFunction) => {
    console.error(err);
    const status = err.status || 500;
    res.status(status).json({
      error: true,
      message: err.message || "Internal server error",
    });
  });

  return app;
}