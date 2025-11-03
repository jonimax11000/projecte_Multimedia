// src/models/videos.ts

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

// Funció pero obtenir tots els videos
export const obtenirVideos = () =>{
    return videos;
} 

// Funció per obtenir un usuari per id
export const obtenirVideoPerId = (id: string): Video | undefined => {
  return videos.find(u => u.id === id);
};

// Funció per obtenir un usuari per id
export const obtenirVideoPerThumbnail = (thumbnail: string): Video | undefined => {
  return videos.find(u => u.thumbnail === thumbnail);
};
