import { IVideoRepository } from "../../repositories/IVideoRepository";

export class GetVideosUseCase {
  // El cas d'ús s'inicialitza amb una interfície del repositori
  constructor(private VideoRepo: IVideoRepository) {}

  async execute() {
    return this.VideoRepo.findAll();
  }
}