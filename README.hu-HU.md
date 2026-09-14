# AppDepot

<p align="center"><b>Natív, nyílt forráskódú Microsoft Store-kliens Windowsra</b></p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.zh-TW.md">繁體中文</a> · <a href="README.ja-JP.md">日本語</a> · <a href="README.ko-KR.md">한국어</a> · <a href="README.de-DE.md">Deutsch</a> · <a href="README.es-ES.md">Español</a> · <a href="README.fr-FR.md">Français</a> · <a href="README.pt-BR.md">Português</a> · <a href="README.ru-RU.md">Русский</a> · <a href="README.hu-HU.md">Magyar</a> · <a href="README.ar-SA.md">العربية</a>
</p>

Az AppDepot egy modern Windows-alkalmazás a Microsoft Store-alkalmazások felfedezéséhez, letöltéséhez, telepítéséhez, exportálásához és frissítéséhez. Támogatja a külső UWP/MSIX-csomagok oldalról történő telepítését, valamint a sávszélességet megtakarító blokkszintű differenciális frissítéseket is.

Az alkalmazás **WinUI 3** és **.NET 10** használatával készült, Fluent felülete Windows 10 és Windows 11 rendszerekhez illeszkedik.

<img width="996" height="543" alt="Az AppDepot kezdőlapja" src="docs/screenshots/home.png" />

## 🖼️ Képernyőképek

<p><img width="700" alt="Az AppDepot kezdőlapja" src="docs/screenshots/home.png" /></p>
<p><img width="700" alt="A speciális keresés navigációs menüje" src="docs/screenshots/advanced-search-menu.png" /></p>
<p><img width="700" alt="A speciális keresés oldala" src="docs/screenshots/advanced-search.png" /></p>
<p><img width="700" alt="AppDepot-beállítások" src="docs/screenshots/settings.png" /></p>

## ✨ Funkciók

### 🔍 Felfedezés és keresés

- Microsoft Store-ajánlások, például a **Top Free** alkalmazások böngészése.
- Keresés a címsorból valós idejű javaslatokkal, ikonokkal és címekkel.
- **Advanced Search** használata Store URL, termékazonosító vagy csomagcsalád neve alapján.
- Részletes oldalak leírásokkal, képernyőképekkel, verziókkal és függőségekkel.
- A Store piaca és nyelve külön választható a beállításokban.

### ⬇️ Letöltés és exportálás

- Store-csomagok közvetlen letöltése a Microsoft CDN-jéről.
- BlockMap-alapú differenciális letöltés, amely lehetőség szerint csak a módosult blokkokat tölti le.
- `.appx`, `.msix`, `.appxbundle` és `.msixbundle` csomagok exportálása biztonsági mentéshez vagy offline használathoz.
- Letöltési várólista folyamatjelzővel, szüneteltetéssel és folytatással.

### 📦 Telepítés és oldalról történő telepítés

- A letöltött Store-csomagok közvetlen telepítése az AppDepotból.
- Helyi csomagok telepítése fájlválasztással vagy fogd és vidd módszerrel.
- A szükséges keretrendszer-függőségek automatikus felismerése és telepítése.
- Újratelepítés vagy visszaállítás kényszerítése, ha újabb verzió van telepítve.

### 🔄 Frissítések

- A telepített, Store által aláírt csomagok összevetése a legújabb verziókkal.
- Differenciális frissítések alkalmazása a letöltési méret csökkentéséhez.
- Minden alkalmazás frissítése egyszerre vagy egyes alkalmazások kiválasztása.
- Verziók összehasonlítása architektúra és Windows-build alapján.

### ⚙️ Asztali élmény

- Két terjesztési mód: telepítés nélküli hordozható verzió önálló `.exe` fájllal, valamint Microsoft Store-verzió, amely a Store-on keresztül települ és frissül.
- Világos, sötét és rendszeralapértelmezett téma.
- Az AppDepot ikonja, a beépített bagolyikon vagy helyi `.ico` fájl választható.
- Lokalizált felület erőforrásfájlokkal.
- Külön futásidejű, telepítési és összeomlási naplók.
- AppDepot-frissítések keresése a GitHubon.

## 🌐 Támogatott nyelvek

Az alkalmazás angol, arab, német, spanyol, francia, magyar, japán, koreai, brazil portugál, orosz, egyszerűsített kínai és hagyományos kínai nyelvet tartalmaz.

## 🛑 Rendszerkövetelmények

- Windows 10 2004-es verzió, 19041-es vagy újabb build
- [.NET 10](https://dotnet.microsoft.com/en-us/download/dotnet/10.0), önálló build esetén nem szükséges
- [Windows App SDK Runtime](https://learn.microsoft.com/en-us/windows/apps/windows-app-sdk/downloads#windows-app-sdk), önálló build esetén nem szükséges

## 🚀 Telepítés és futtatás

Töltsd le a `x64`, `x86` vagy `arm64` rendszerhez készült ZIP-et a [Releases](https://github.com/sdf123098/AppDepot/releases) oldalról, csomagold ki, majd futtasd az `AppDepot.exe` fájlt. Hordozható verzióhoz használd a `*-self-contained.zip` archívumot.

A [WinGet](https://learn.microsoft.com/en-us/windows/package-manager/winget/) telepítése után ezt is futtathatod:

```powershell
winget install sdf123098.AppDepot
```

Hamis vírusriasztás esetén töltsd le a `raven_cert.zip` fájlt a Releases oldalról, telepítsd a `raven.cer` tanúsítványt, vagy futtasd az `install_raven_cert.bat` fájlt.

[AppDepot videóútmutató megtekintése](https://www.youtube.com/watch?v=ZX__BaD6kr0)

### Microsoft Store (ajánlott)

A közzététel után az alkalmazás Microsoft Store-oldaláról telepíthető. A Store aláírja az MSIX-csomagot, és kezeli a terjesztést és a frissítéseket. A Product ID a Partner Center-oldal létrehozása után lesz meghatározva.

### WinGet a Microsoft Store-on keresztül

Amikor a Store-listázás kereshetővé válik, ugyanaz a Store-csomag ellenőrizhető és telepíthető:

```powershell
winget search <Microsoft Store Product ID> --source msstore
winget install <Microsoft Store Product ID> --source msstore
```

### Windows-kiadások automatizálása

A `Build and Draft Release` munkafolyamat összeállítja az alkalmazást, lefuttatja a lokalizációs smoke tesztet, Store-ra kész, aláíratlan MSIX-eket, hordozható ZIP-eket és `SHA256SUMS.txt` fájlt készít. A Store-hitelesítés után a Microsoft újra aláírja az MSIX-eket, ezért nincs szükség kereskedelmi tanúsítványra. A Store-közzététel alapértelmezés szerint ki van kapcsolva, és csak a Partner Center, a GitHub Secrets és a kifejezett jóváhagyás beállítása után engedélyezhető.

A `Publish Microsoft Store Metadata` csak fejlesztő által ellenőrzött `metadata/metadata.json` fájlt dolgoz fel. A `Verify WinGet Distribution` először a Store-terjesztést ellenőrzi, sikertelenség esetén pedig ellenőrzésre feltölt egy GitHub hordozható ZIP-manifesztet; Pull Requestet nem küld automatikusan.

## 🏗️ Projektstruktúra

Az AppDepot a **MVVM** mintát és a `Microsoft.Extensions.Hosting` által biztosított függőséginjektálást használja. A fő területek: `Raven/Views`, `Raven/ViewModels`, `Raven/Services`, `Raven/Helpers`, `Raven/Models`, `Raven/Strings`, `Raven.Updater` és a `StoreListings` almodul.

## 🧰 Fordítás forrásból

Szükséges a .NET 10 SDK, a .NET Desktop Development és Windows App SDK/WinUI munkaterheléssel telepített Visual Studio 2026, valamint a Windows 10 SDK (26100).

```bash
git clone --recurse-submodules https://github.com/sdf123098/AppDepot.git
cd AppDepot
dotnet build Raven.sln -c Debug -p:Platform=x64
dotnet run --project Raven -c Debug
```

Ha az almodulok nem kerültek letöltésre, futtasd a `git submodule update --init --recursive` parancsot. A támogatott architektúrák: `x64`, `x86` és `arm64`.

## 🤝 Közreműködés

Forkold a tárolót, hozz létre célzott ágat, kövesd a meglévő MVVM- és függőséginjektálási konvenciókat, a XAML felhasználói szövegeit lokalizáld `x:Uid` erőforrásokkal, majd nyiss Pull Requestet az ellenőrzési lépésekkel.

## 📜 Licenc

Az AppDepot **Apache License 2.0** licenc alatt érhető el. A teljes szöveg a [LICENSE](LICENSE) fájlban található.
