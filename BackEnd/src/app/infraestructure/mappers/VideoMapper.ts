// Mapper. Mapeja la representació de la capa de persistència a la capa de domini.

import { Video } from "../../domain/entities/Video";
import { VideoRecord } from "../datasorces/intern/models/VideoRecord";

export class VideoMapper {
    static toDomain(record: VideoRecord): Video {
        return {
            ...record
        };
    }

    // Quan trobem Omit<T, k>
    // El que fa és, a partir de ltipus T, elimina les propietats indicades en K
    // Omit<User, "createdAt" | "id">: Vol dir Agafa User, i lleva-li els paràmetres createdAt i id
    static toRecord(video: Video): VideoRecord {
        return {
            ...video
        };
    }
}
