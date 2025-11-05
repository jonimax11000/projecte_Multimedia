import { IVideoRepository } from "../../../domain/repositories/IVideoRepository";
import { Video } from "../../../domain/entities/Video";
import { VideoMapper } from "../../mappers/VideoMapper";
import { VideoRecord } from "./models/VideoRecord";
import { videos } from "../../../data/videos";

export class VideoRepositoryIntern implements IVideoRepository {
  private vids: VideoRecord[] = videos;

  async findById(id: string): Promise<Video | null> {
    const record = this.vids.find(u => u.id === id);
    return record ? VideoMapper.toDomain(record) : null;
  }

  async findByThumbnail(thumbnail: string): Promise<Video | null> {
    const record = this.vids.find(u => u.thumbnail === thumbnail);
    return record ? VideoMapper.toDomain(record) : null;
  }

  async findAll(): Promise<Video[]> {
    return this.vids.map(VideoMapper.toDomain);
  }
}
