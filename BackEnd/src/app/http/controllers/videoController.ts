import { Request, Response, NextFunction } from "express";
import { GetVideosUseCase } from "../../domain/usecases/vdeo/GetVideosUseCase";
import { GetVideoByIdUseCase } from "../../domain/usecases/vdeo/GetUserByIdUseCase";
import { GetVideoByThumbnailUseCase } from "../../domain/usecases/vdeo/GetUserByThmbnailUseCase";



export class VideoController {
  constructor(
        private getVideos: GetVideosUseCase,
        private getVideoById: GetVideoByIdUseCase,
        private getVideoByThumbnail: GetVideoByThumbnailUseCase
    ) { }

  getAll = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const videos = await this.getVideos.execute();
        console.log(`🎬 Controller: devolviendo ${videos.length} videos`);
        res.json(videos);
    } catch (err) { next(err); }
  }

    getById = async (req: Request, res: Response, next: NextFunction) => {
      console.log("Entro al controller de getById");
      try {
        const id = req.params.id || "";
        const video = await this.getVideoById.execute(id);
        if (!video) return res.status(404).json({ message: "Video not found" });
        res.json(video);
      } catch (err) { next(err); }
    }

    getByThumbnail = async (req: Request, res: Response, next: NextFunction) => {
      console.log("Entro al controller de getByThumbnail");
      try {
        const thumbnail = req.params.topic || "";
        const video = await this.getVideoByThumbnail.execute(thumbnail);
        if (!video) return res.status(404).json({ message: "Video not found" });
        res.json(video);
      } catch (err) { next(err); }
    }
}