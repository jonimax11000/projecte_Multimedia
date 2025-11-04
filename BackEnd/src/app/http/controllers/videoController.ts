import { Request, Response } from "express";
import {obtenirVideos,obtenirVideoPerId,obtenirVideoPerThumbnail,carregarVideosDesDeCarpeta} from "../../domain/entities/videos";



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

async function inicialitzarVideos() {
  try {
    await carregarVideosDesDeCarpeta('./src/app/data/videos');
    console.log('Videos carregats:', obtenirVideos());
  } catch (error) {
    console.error('Error carregant videos:', error);
  }
}

// Executar la inicialització
inicialitzarVideos();