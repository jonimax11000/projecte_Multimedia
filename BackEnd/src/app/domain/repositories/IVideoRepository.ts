import { Video } from "../entities/Video";

// Definim el comportament del repositori d'usuaris
export interface IVideoRepository {
  findById(id: string): Promise<Video | null>; // Mètode per buscar un usuari per id. Retorna una promesa amb l'usuari 
  findByThumbnail(thumbnail: string): Promise<Video | null>; 
  findAll(): Promise<Video[]>;
}