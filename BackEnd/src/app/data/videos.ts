import ffmpeg, { FfprobeData } from 'fluent-ffmpeg';
import { Video } from '../domain/entities/Video';
import fs from 'fs';
import path from 'path';

// Inicialització de l'array d'videos
export let videos: Array<Video> = [];

// Funció per carregar videos des d'una carpeta amb metadades reals
export const carregarVideosDesDeCarpeta = async (carpetaPath: string): Promise<Video[]> => {
  const videosTrobats: Video[] = [];
  
  try {
    const arxius = fs.readdirSync(carpetaPath);

    for (const arxiu of arxius) {
      if (esArxiuVideo(arxiu)) {
        try {
          const video = await obtenirMetadadesVideo(arxiu, carpetaPath);
          videosTrobats.push(video);
        } catch (error) {
          console.error(`Error llegint metadades per ${arxiu}:`, error);
          // Afegir video amb informació bàsica
          videosTrobats.push(crearInfoVideoBasica(arxiu));
        }
      }
    }

    // Actualitzar l'array global de videos
    videos = videosTrobats;
    console.log(`📹 Carregats ${videos.length} videos des de la carpeta.`);
    return videos;
    
  } catch (error) {
    console.error('Error llegint carpeta:', error);
    return [];
  }
};

// Funcions auxiliars
function esArxiuVideo(nomArxiu: string): boolean {
  const extensionsVideo = ['.mp4', '.avi', '.mov', '.mkv', '.wmv', '.webm'];
  return extensionsVideo.includes(path.extname(nomArxiu).toLowerCase());
}

function obtenirMetadadesVideo(nomArxiu: string, carpetaPath: string): Promise<Video> {
  return new Promise((resolve, reject) => {
    const pathComplet = path.join(carpetaPath, nomArxiu);

    ffmpeg.ffprobe(pathComplet, (err: Error | null, metadades: FfprobeData) => {
      if (err) {
        reject(err);
        return;
      }

      const durada = Math.floor(metadades.format.duration || 0);
      const streamVideo = metadades.streams.find((stream) => stream.codec_type === 'video');

      const nomVideo = path.parse(nomArxiu).name.toLowerCase();
      const nomSenseEspais = nomVideo.replace(/\s+/g, '');
      
      const video: Video = {
        id: generarId(nomArxiu),
        nom: nomVideo,
        descripcio: generarDescripcio(streamVideo, durada),
        duration: durada,
        thumbnail: `/thumbnails/${nomSenseEspais}.jpg`, // Ruta relativa al thumbnail
        videoUrl: `/videos/${nomSenseEspais}/index.m3u8` // Nueva propiedad: ruta al HLS
      };

      resolve(video);
    });
  });
}

function crearInfoVideoBasica(nomArxiu: string): Video {
  const nomVideo = path.parse(nomArxiu).name;
  const nomSenseEspais = nomVideo.replace(/\s+/g, '');
  
  return {
    id: generarId(nomArxiu),
    nom: nomVideo,
    descripcio: `Video: ${nomArxiu}`,
    duration: 0,
    thumbnail: `/thumbnails/${nomSenseEspais}.jpg`, // Ruta relativa actualizada
    videoUrl: `/videos/${nomSenseEspais}/index.m3u8` // Nueva propiedad
  };
}

function generarId(nomArxiu: string): string {
  // Formato: prefijo-timestamp-random
  const timestamp = Date.now().toString(36); // Base 36 para hacerlo más corto
  const random = Math.random().toString(36).substring(2, 6);
  const prefix = nomArxiu
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-') // Reemplaza espacios y caracteres especiales por guiones
    .replace(/^-+|-+$/g, ''); // Elimina guiones al principio y final
  
  return `${prefix}-${timestamp}-${random}`;
}

function generarDescripcio(streamVideo: any, durada: number): string {
  const parts = [];
  
  if (streamVideo?.width && streamVideo?.height) {
    parts.push(`Resolució: ${streamVideo.width}x${streamVideo.height}`);
  }
  
  if (streamVideo?.codec_name) {
    parts.push(`Còdec: ${streamVideo.codec_name}`);
  }
  
  if (durada > 0) {
    parts.push(`Durada: ${formatarDurada(durada)}`);
  }

  return parts.join(' | ') || 'Video sense metadades completes';
}

function formatarDurada(segons: number): string {
  const hores = Math.floor(segons / 3600);
  const minuts = Math.floor((segons % 3600) / 60);
  const segonsRestants = Math.floor(segons % 60);

  if (hores > 0) {
    return `${hores}h ${minuts}m ${segonsRestants}s`;
  } else if (minuts > 0) {
    return `${minuts}m ${segonsRestants}s`;
  } else {
    return `${segonsRestants}s`;
  }
}