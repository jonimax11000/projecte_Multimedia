# Projecte Multimèdia

Aquest projecte consisteix en una aplicació mòbil desenvolupada amb Flutter que es comunica amb un backend en Node.js per a la gestió i reproducció de contingut multimèdia (vídeos).

## Estructura del Projecte

El projecte està dividit en dues parts principals:

- **FrontEnd**: Conté tota la lògica de l'aplicació mòbil. El codi font de Flutter es troba dins de la carpeta `lib`.
- **BackEnd**: Conté el servidor, l'API i la lògica de processament de vídeos.

## Requisits Previs

Per a que el backend funcione correctament, és **imprescindible** tenir instal·lat `ffmpeg` al sistema, ja que s'utilitza per a generar les miniatures i processar els vídeos.

### Instal·lació de FFmpeg

- **Ubuntu/Debian**:
  ```bash
  sudo apt update
  sudo apt install ffmpeg
  ```
- **Windows**: Descarregar des de la web oficial i afegir al PATH.
- **macOS**:
  ```bash
  brew install ffmpeg
  ```

## Funcionalitats

### Frontend (Flutter)
- **Llistat de Vídeos**: Mostra una llista de vídeos disponibles amb les seues miniatures i informació bàsica.
- **Reproductor de Vídeo**: Permet reproduir vídeos amb controls de reproducció (play, pause, barra de progrés, volum).
- **Pantalla Completa**: Suport per a visualitzar els vídeos en mode pantalla completa.
- **Disseny Responsiu**: La interfície s'adapta tant a l'orientació vertical com a l'horitzontal.
- **Gestió d'Errors**: Mostra missatges d'error si no es poden carregar els vídeos.

### Backend (Node.js)
- **API REST**: Proporciona endpoints per a obtenir la llista de vídeos i les seues metadades.
- **Servidor d'Arxius**: Serveix els arxius de vídeo i les imatges de les miniatures.
- **Processament de Vídeos**: Inclou scripts per a processar vídeos utilitzant `ffmpeg`.

## Llibreries i Dependències

### Frontend (Flutter)
Les principals llibreries utilitzades al `pubspec.yaml` són:
- **flutter**: SDK principal per al desenvolupament de l'aplicació.
- **cupertino_icons**: Conjunt d'icones d'estil iOS.
- **get_it**: Utilitzat per a la injecció de dependències (Service Locator).
- **http**: Per a realitzar peticions HTTP a l'API del backend.
- **video_player**: Plugin oficial per a la reproducció de vídeos en Flutter.

### Backend (Node.js)
Les principals dependències al `package.json` són:
- **express**: Framework web ràpid i minimalista per a Node.js.
- **fluent-ffmpeg**: Abstracció per a utilitzar FFmpeg de manera senzilla per al processament de vídeos.
- **typescript**: Llenguatge de programació que afegeix tipus estàtics a JavaScript.
- **ts-node / tsx**: Eines per a executar codi TypeScript directament.

## Configuració Específica

### Android
Per a permetre la comunicació amb el backend local (que utilitza HTTP en lloc d'HTTPS), s'ha realitzat una modificació important a l'arxiu `AndroidManifest.xml`. S'ha afegit l'atribut:

```xml
android:usesCleartextTraffic="true"
```

Aquesta línia permet que l'aplicació realitze peticions de text clar (HTTP) al servidor local (generalment accessible via `10.0.2.2` des de l'emulador d'Android).

## Explicació Detallada del Codi

### Flux de Dades (Data Flow)
El flux de la informació en l'aplicació segueix el següent camí:

1.  **Backend (Disc)**: Els vídeos originals es troben a `src/app/data/videos`.
2.  **Backend (Processament)**: En iniciar, el servidor llegeix aquests arxius, extreu metadades (durada, resolució) amb `ffprobe` i genera miniatures i versions HLS (`.m3u8`) si cal.
3.  **Backend (API)**: Quan el frontend demana `/api/videolist`, el `VideoController` retorna un JSON amb la llista d'objectes `Video`.
4.  **Frontend (Data Source)**: `VideosApi` rep el JSON i el passa al `VideosRepository`.
5.  **Frontend (Repository)**: `VideosRepositoryImpl` converteix el JSON cru en objectes de domini `Video` (Dart).
6.  **Frontend (UI)**: `HomeScreen` rep la llista de vídeos i els mostra utilitzant `MyListWidget`. Quan es prem un vídeo, s'inicialitza el `VideoPlayerController` amb la URL proporcionada pel backend.

### Frontend (Flutter) - Detalls Tècnics
El codi del frontend segueix els principis de **Clean Architecture** per a mantenir el codi organitzat, testejable i escalable.

1.  **Presentation (`lib/features/presentation`)**:
    -   **Gestió d'Estat**: `HomeScreen` utilitza `setState` per a gestionar canvis en la UI. Variables com `_isVideoInitialized` controlen si mostrar el reproductor o un indicador de càrrega.
    -   **Reproductor**: S'utilitza `VideoPlayerController.networkUrl` per a carregar el vídeo. És crucial cridar a `dispose()` quan es tanca la pantalla per a alliberar recursos.
    -   **Orientació**: S'utilitza `OrientationBuilder` per a detectar si el dispositiu està en horitzontal o vertical i canviar el layout dinàmicament (`_buildLandscapeLayout` vs `_buildPortraitLayout`).

2.  **Domain (`lib/features/domain`)**:
    -   Capa pura de Dart sense dependències de Flutter o llibreries externes (excepte definicions bàsiques).
    -   Defineix el *què* fa l'aplicació (entitats i interfícies) però no el *com*.

3.  **Data (`lib/features/data`)**:
    -   **VideosApi**: Configurada per defecte per a apuntar a `http://10.0.2.2:3000`, que és l'adreça especial de l'emulador d'Android per a accedir al `localhost` de la màquina host.
    -   **Mappers**: S'encarreguen de la "traducció" de dades. Si l'API canvia el nom d'un camp, només cal canviar el mapper, no tota l'aplicació.

### Backend (Node.js) - Detalls Tècnics
El backend no només serveix dades, sinó que actua com un servidor de streaming i processament.

1.  **Servidor HTTP (`server.ts`)**:
    -   Utilitza `express.static` per a exposar les carpetes `thumbnails` i `videos` públicament. Això permet que el frontend carregue les imatges i els vídeos directament via URL.
    -   Configura **CORS** manualment per a permetre peticions des de qualsevol origen, evitant problemes de bloqueig quan es desenvolupa amb l'emulador.

2.  **Processament de Vídeo (`videoProcessor.ts`)**:
    -   **HLS (HTTP Live Streaming)**: El backend converteix els vídeos a format HLS (`.m3u8`). Aquest protocol divideix el vídeo en petits fragments (`.ts`). Això permet:
        -   Càrrega més ràpida (només es descarrega el que es veu).
        -   Adaptabilitat a diferents amples de banda (encara que en aquest exemple bàsic s'utilitza un sol perfil).
    -   **Parallelisme**: Utilitza `Promise.all` per a generar la miniatura i el HLS simultàniament, aprofitant la asincronia de Node.js.

3.  **Lectura de Metadades (`videos.ts`)**:
    -   Utilitza `fluent-ffmpeg` (que per sota crida a `ffprobe`) per a analitzar els arxius de vídeo i obtenir la durada exacta i les dimensions, informació que després es mostra a la UI del mòbil.