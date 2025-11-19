import { buildServer } from './app/http/server.js';
import { initializeVideos } from './app/infraestructure/services/initVideos.js';
import { carregarVideosDesDeCarpeta } from './app/data/videos.js';

async function startServer() {
  try {
   
  
    //await initializeVideos();
    

    console.log('📹 Cargando videos en memoria...');
    await carregarVideosDesDeCarpeta('./src/app/data/videos');
    
   
    const app = buildServer();
    const PORT = process.env.PORT || 3000;

    app.listen(PORT, () => {
      console.log(`✅ Servidor ejecutándose en http://localhost:${PORT}`);
      console.log(`📸 Thumbnails disponibles en: http://localhost:${PORT}/thumbnails/`);
      console.log(`🎥 Videos HLS disponibles en: http://localhost:${PORT}/videos/`);
      console.log(`🔗 API disponible en: http://localhost:${PORT}/api/videolist`);
      console.log(`🏗️  Arquitectura CLEAN activa`);
    });
  } catch (error) {
    console.error('❌ Error al iniciar el servidor:', error);
    process.exit(1);
  }
}

startServer();