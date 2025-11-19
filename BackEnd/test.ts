import { carregarVideosDesDeCarpeta } from './src/app/data/videos.js';

async function testVideos() {
  try {
    console.log('🧪 Probando carga de videos...');
    
    const videos = await carregarVideosDesDeCarpeta('./src/app/data/videos');
    console.log('Videos cargados:', videos);
    
    if (videos.length === 0) {
      console.log('❌ No se encontraron videos. Verifica:');
      console.log('   1. Que los archivos estén en src/app/data/videos/');
      console.log('   2. Que tengan extensiones .mp4, .avi, etc.');
      console.log('   3. Que ffmpeg esté instalado correctamente');
    }
  } catch (error) {
    console.error('Error en test:', error);
  }
}

testVideos();