import { Video } from "../../domain/entities/Video";
import { VideoRecord } from "../datasorces/intern/models/VideoRecord";

export class VideoMapper {
  static toDomain(record: VideoRecord): Video {
    return {
      id: record.id,
      nom: record.nom,
      descripcio: record.descripcio,
      duration: record.duration,
      thumbnail: record.thumbnail,
      videoUrl: record.videoUrl
    };
  }

  static toRecord(domain: Video): VideoRecord {
    return {
      id: domain.id,
      nom: domain.nom,
      descripcio: domain.descripcio,
      duration: domain.duration,
      thumbnail: domain.thumbnail,
      videoUrl: domain.videoUrl 
    };
  }
}