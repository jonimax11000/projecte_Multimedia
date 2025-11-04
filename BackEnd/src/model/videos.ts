import ffmpeg, { FfprobeData } from 'fluent-ffmpeg';
import fs from 'fs';
import path from 'path';

// Tipus de video (interfície-entitat)
export interface Video {
  id: string;
  nom: string;
  descripcio: string;
  duration: number;
  thumbnail: string;
}

// Inicialització de l'array d'videos
export let videos: Array<Video> = [];

// Funció per obtenir tots els videos
export const obtenirVideos = () => {
  return videos;
};

// Funció per obtenir un video per id
export const obtenirVideoPerId = (id: string): Video | undefined => {
  return videos.find(u => u.id === id);
};

// Funció per obtenir un video per thumbnail
export const obtenirVideoPerThumbnail = (thumbnail: string): Video | undefined => {
  return videos.find(u => u.thumbnail === thumbnail);
};

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

      const nomVideo = path.parse(nomArxiu).name;
      const nomSenseEspais = nomVideo.replace(/\s+/g, '');
      const video: Video = {
        id: generarId(nomArxiu),
        nom: nomVideo,
        descripcio: generarDescripcio(streamVideo, durada),
        duration: durada,
        thumbnail: `${nomSenseEspais}.jpg`
      };

      resolve(video);
    });
  });
}

function crearInfoVideoBasica(nomArxiu: string): Video {
  const nomVideo = path.parse(nomArxiu).name;
  return {
    id: generarId(nomArxiu),
    nom: nomVideo,
    descripcio: `Video: ${nomArxiu}`,
    duration: 0,
    thumbnail: `${nomVideo}.jpg`
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

async function generarThumbnail(videoPath: string, thumbnailPath: string): Promise<void> {
  return new Promise((resolve, reject) => {
    ffmpeg(videoPath)
      .screenshots({
        timestamps: ['00:00:01'],
        filename: path.basename(thumbnailPath),
        folder: path.dirname(thumbnailPath),
        size: '320x180'
      })
      .on('end', () => resolve())
      .on('error', (err: Error) => reject(err));
  });
}

// Retorna la ruta física donde guardar el thumbnail
function obtenirPathThumbnail(nomArxiu: string): string {
  const nomSenseExtensio = path.parse(nomArxiu).name;
  return path.join(process.cwd(), 'src', 'videos', 'thumbnails', `${nomSenseExtensio}.jpg`);
}

// Retorna solo el nombre del archivo thumbnail
function obtenirPathThumbnailApi(nomArxiu: string): string {
  const nomSenseExtensio = path.parse(nomArxiu).name;
  return `${nomSenseExtensio}.jpg`;
}

// Funció per afegir un video manualment (si es necessari)
export const afegirVideo = (video: Video): void => {
  videos.push(video);
};

// Funció per esborrar un video per ID
export const esborrarVideoPerId = (id: string): boolean => {
  const index = videos.findIndex(video => video.id === id);
  if (index !== -1) {
    videos.splice(index, 1);
    return true;
  }
  return false;
};