import { Request, Response } from "express";
import {obtenirVideos,obtenirVideoPerId,obtenirVideoPerThumbnail} from "../model/videos.js";



export const getVideos=(req: Request, res:Response) =>{ res.json(obtenirVideos()); };

interface UserParams {
  id: string;
  thumbnail: string;
}

export const getVideosPerId = (req: Request<UserParams>, res: Response) => {
  const id = req.params.id;
  const video = obtenirVideoPerId(id);

  if (!video) {
    return res.status(404).json({ error: "Video no trobat" });
  }

  res.json(video);
};

export const getVideosPerThumbnail = (req: Request<UserParams>, res: Response) => {
  const thumbnail = req.params.thumbnail;
  const video = obtenirVideoPerThumbnail(thumbnail);

  if (!video) {
    return res.status(404).json({ error: "Video no trobat" });
  }

  res.json(video);
};