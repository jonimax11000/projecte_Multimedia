import { IVideoRepository } from "../../repositories/IVideoRepository";

export class GetVideoByIdUseCase {
  // El cas d'ús s'inicialitza amb una interfície del repositori
  constructor(private VideoRepo: IVideoRepository) {}

  async execute(id:string) {
    return this.VideoRepo.findById(id);
  }
}