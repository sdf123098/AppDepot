# AppDepot

<p align="center"><b>Cliente nativo y de código abierto de Microsoft Store para Windows</b></p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.zh-TW.md">繁體中文</a> · <a href="README.ja-JP.md">日本語</a> · <a href="README.ko-KR.md">한국어</a> · <a href="README.de-DE.md">Deutsch</a> · <a href="README.es-ES.md">Español</a> · <a href="README.fr-FR.md">Français</a> · <a href="README.pt-BR.md">Português</a> · <a href="README.ru-RU.md">Русский</a> · <a href="README.hu-HU.md">Magyar</a> · <a href="README.ar-SA.md">العربية</a>
</p>

AppDepot es una aplicación moderna para Windows que permite descubrir, descargar, instalar, exportar y actualizar aplicaciones de Microsoft Store. También admite la instalación lateral de paquetes UWP/MSIX externos y actualizaciones diferenciales por bloques para ahorrar ancho de banda.

Está creada con **WinUI 3** y **.NET 10**, con una interfaz Fluent diseñada para Windows 10 y Windows 11.

<img width="996" height="543" alt="Página principal de AppDepot" src="docs/screenshots/home.png" />

## 🖼️ Capturas de pantalla

<p><img width="700" alt="Página principal de AppDepot" src="docs/screenshots/home.png" /></p>
<p><img width="700" alt="Menú de navegación de búsqueda avanzada" src="docs/screenshots/advanced-search-menu.png" /></p>
<p><img width="700" alt="Página de búsqueda avanzada" src="docs/screenshots/advanced-search.png" /></p>
<p><img width="700" alt="Configuración de AppDepot" src="docs/screenshots/settings.png" /></p>

## ✨ Funciones

### 🔍 Explorar y buscar

- Explora recomendaciones de Microsoft Store como las aplicaciones **Top Free**.
- Busca desde la barra de título con sugerencias, iconos y nombres en tiempo real.
- Usa **Advanced Search** con una URL de Store, un ID de producto o un nombre de familia de paquetes.
- Consulta páginas de detalles con descripciones, capturas, versiones y dependencias.
- Selecciona por separado el mercado y el idioma de Store en Configuración.

### ⬇️ Descargar y exportar

- Descarga paquetes de Store directamente desde la CDN de Microsoft.
- Usa descargas diferenciales basadas en BlockMap para obtener solo los bloques modificados cuando sea posible.
- Exporta paquetes `.appx`, `.msix`, `.appxbundle` y `.msixbundle` para copias de seguridad o uso sin conexión.
- Gestiona la cola con progreso, pausa y reanudación.

### 📦 Instalar y realizar sideload

- Instala paquetes descargados directamente desde AppDepot.
- Instala paquetes locales mediante el selector de archivos o arrastrar y soltar.
- Detecta e instala automáticamente las dependencias de framework necesarias.
- Fuerza la reinstalación o la degradación cuando ya hay una versión más reciente.

### 🔄 Actualizar aplicaciones

- Compara los paquetes firmados de Store instalados con las versiones disponibles más recientes.
- Aplica actualizaciones diferenciales para reducir el tamaño de la descarga.
- Actualiza todo en bloque o selecciona aplicaciones individuales.
- Compara versiones según la arquitectura y la compilación de Windows.

### ⚙️ Experiencia de escritorio

- Dos formas de distribución: una versión portátil sin instalación que ejecuta una `.exe` independiente y una versión de Microsoft Store que se instala y actualiza desde Store.
- Usa temas claro, oscuro o predeterminado del sistema.
- Elige el icono de AppDepot, el icono de búho incluido o un archivo `.ico` local.
- Disfruta de una interfaz localizada mediante archivos de recursos.
- Consulta por separado los registros de ejecución, instalación y errores.
- Busca actualizaciones de AppDepot en GitHub.

## 🌐 Idiomas disponibles

Se incluyen inglés, árabe, alemán, español, francés, húngaro, japonés, coreano, portugués de Brasil, ruso, chino simplificado y chino tradicional.

## 🛑 Requisitos del sistema

- Windows 10 versión 2004, compilación 19041 o posterior
- [.NET 10](https://dotnet.microsoft.com/en-us/download/dotnet/10.0), salvo en versiones autocontenidas
- [Windows App SDK Runtime](https://learn.microsoft.com/en-us/windows/apps/windows-app-sdk/downloads#windows-app-sdk), salvo en versiones autocontenidas

## 🚀 Instalar y ejecutar

Descarga desde [Releases](https://github.com/sdf123098/AppDepot/releases) el ZIP para `x64`, `x86` o `arm64`, extráelo y ejecuta `AppDepot.exe`. Para una versión portátil, usa `*-self-contained.zip`.

También puedes instalar [WinGet](https://learn.microsoft.com/en-us/windows/package-manager/winget/) y ejecutar:

```powershell
winget install sdf123098.AppDepot
```

Si Windows o el antivirus muestra un falso positivo, descarga `raven_cert.zip` desde Releases, instala `raven.cer` o ejecuta `install_raven_cert.bat`.

[Ver la guía en vídeo de AppDepot](https://www.youtube.com/watch?v=ZX__BaD6kr0)

### Microsoft Store (recomendado)

Tras la publicación, instala la aplicación desde su página de Microsoft Store. Store firma el paquete MSIX y gestiona su distribución y actualizaciones. El ID de producto se definirá cuando exista la página de Partner Center.

### WinGet mediante Microsoft Store

Cuando el listado de Store sea visible, verifica e instala el mismo paquete:

```powershell
winget search <Microsoft Store Product ID> --source msstore
winget install <Microsoft Store Product ID> --source msstore
```

### Automatización de versiones de Windows

El flujo `Build and Draft Release` compila la aplicación, ejecuta la prueba de localización, genera MSIX de Store sin firmar, ZIP portátiles y `SHA256SUMS.txt`. Microsoft vuelve a firmar los MSIX tras la certificación de Store, por lo que no se necesita un certificado comercial. La publicación en Store está desactivada de forma predeterminada y solo se activa tras configurar Partner Center, GitHub Secrets y una confirmación explícita.

`Publish Microsoft Store Metadata` solo procesa un `metadata/metadata.json` revisado por un desarrollador. `Verify WinGet Distribution` verifica primero la distribución de Store y, si falla, genera un manifiesto comunitario del ZIP portátil de GitHub para su revisión; no crea Pull Requests automáticamente.

## 🏗️ Estructura del proyecto

AppDepot sigue el patrón **MVVM** y utiliza inyección de dependencias mediante `Microsoft.Extensions.Hosting`. Las áreas principales son `Raven/Views`, `Raven/ViewModels`, `Raven/Services`, `Raven/Helpers`, `Raven/Models`, `Raven/Strings`, `Raven.Updater` y el submódulo `StoreListings`.

## 🧰 Compilar desde el código fuente

Se necesitan .NET 10 SDK, Visual Studio 2026 con las cargas de trabajo .NET Desktop Development y Windows App SDK/WinUI, y Windows 10 SDK (26100).

```bash
git clone --recurse-submodules https://github.com/sdf123098/AppDepot.git
cd AppDepot
dotnet build Raven.sln -c Debug -p:Platform=x64
dotnet run --project Raven -c Debug
```

Si no se clonaron los submódulos, ejecuta `git submodule update --init --recursive`. Se admiten `x64`, `x86` y `arm64`.

## 🤝 Contribuir

Haz un fork, crea una rama específica, sigue las convenciones MVVM y de inyección de dependencias, localiza los textos XAML con recursos `x:Uid` y abre un Pull Request con los pasos de validación.

## 📜 Licencia

AppDepot se distribuye bajo la **Apache License 2.0**. Consulta el texto completo en [LICENSE](LICENSE).
