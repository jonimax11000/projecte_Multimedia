import { Router } from "express";
import { VideoRepositoryIntern } from "../../infraestructure/datasorces/intern/VideoRepositoryIntern"
import { GetVideosUseCase } from "../../domain/usecases/vdeo/GetVideosUseCase";
import { GetVideoByIdUseCase } from "../../domain/usecases/vdeo/GetUserByIdUseCase";
import { GetVideoByThumbnailUseCase } from "../../domain/usecases/vdeo/GetUserByThmbnailUseCase";
import { VideoController } from "../controllers/videoController";


const repo = new VideoRepositoryIntern();

// Creem el Controlador per als usuaris, proporcionant-li
// instàncies dels casos d'ús, que al seu temps hem inicialitzat
// amb el repositori (injecció de dependències)
const controller = new VideoController(
  new GetVideosUseCase(repo),
  new GetVideoByIdUseCase(repo),
  new GetVideoByThumbnailUseCase(repo)
);

const videolistRoutes = Router();


videolistRoutes.get("/", controller.getAll); 
videolistRoutes.get("/:id", controller.getById);
videolistRoutes.get("/byTopic/:topic", controller.getByThumbnail);


// Protegim la ruta per 
//userRouter.post("/create", authMiddleware, createUser);

export default videolistRoutes;