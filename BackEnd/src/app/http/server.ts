import express, { NextFunction, Request, Response } from "express";
import videolistRoutes from "./routes/videolistRoutes";


export function buildServer() {
  const app = express();
  app.use(express.json());
<<<<<<< HEAD
=======
  app.use('/api/videolist/thumbnails', express.static('src/app/data/videos/thumbnails'));
>>>>>>> origin/guillem
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

  

  app.use("/api/videolist", videolistRoutes);

  app.use((req: Request, res: Response) => {
    res.status(404).json({ message: "Resource not found" });
  });

  app.use((err: any, req: Request, res: Response, next: NextFunction) => {
    console.error(err); // Log per consola (o logger a futur)

    // Si ja té codi d'estat assignat; l’utilitzem
    const status = err.status || 500;

    res.status(status).json({
      error: true,
      message: err.message || "Internal server error",
    });
  });


  return app;
}
