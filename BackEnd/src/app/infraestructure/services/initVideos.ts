import { VideoProcessor } from './videoProcessor';

export async function initializeVideos(): Promise<void> {
  const processor = new VideoProcessor();
  
  if (processor.needsProcessing()) {
    console.log('🔄 Procesando videos...');
    await processor.processAllVideos();
    console.log('🎉 Todos los videos procesados correctamente!');
  } else {
    console.log('✅ Videos ya procesados, continuando...');
  }
}