import { IVideoRepository } from "../../repositories/IVideoRepository";

export class GetVideoByThumbnailUseCase {
  // El cas d'ús s'inicialitza amb una interfície del repositori
  constructor(private VideoRepo: IVideoRepository) {}

  async execute(thumbnail:string) {
    return this.VideoRepo.findByThumbnail(thumbnail);
  }
}