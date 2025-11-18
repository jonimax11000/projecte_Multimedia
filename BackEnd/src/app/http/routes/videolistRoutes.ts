import { Router } from "express";
import { VideoRepositoryIntern } from "../../infraestructure/datasorces/intern/VideoRepositoryIntern";
import { GetVideosUseCase } from "../../domain/usecases/vdeo/GetVideosUseCase";
import { GetVideoByIdUseCase } from "../../domain/usecases/vdeo/GetUserByIdUseCase";
import { GetVideoByThumbnailUseCase } from "../../domain/usecases/vdeo/GetUserByThmbnailUseCase";
import { VideoController } from "../controllers/videoController";

const createController = () => {
  const repo = new VideoRepositoryIntern();  // ← Se crea CUANDO SE USA la ruta
  return new VideoController(
    new GetVideosUseCase(repo),
    new GetVideoByIdUseCase(repo),
    new GetVideoByThumbnailUseCase(repo)
  );
};

const videolistRoutes = Router();

videolistRoutes.get("/", (req, res, next) => {
  createController().getAll(req, res, next);  // ← Repository se crea aquí
});

videolistRoutes.get("/:id", (req, res, next) => {
  createController().getById(req, res, next);  // ← Repository se crea aquí
});

videolistRoutes.get("/byTopic/:topic", (req, res, next) => {
  createController().getByThumbnail(req, res, next);  // ← Repository se crea aquí
});

export default videolistRoutes;