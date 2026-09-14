# AppDepot

<p align="center"><b>Ein nativer Open-Source-Client für den Microsoft Store unter Windows</b></p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.zh-TW.md">繁體中文</a> · <a href="README.ja-JP.md">日本語</a> · <a href="README.ko-KR.md">한국어</a> · <a href="README.de-DE.md">Deutsch</a> · <a href="README.es-ES.md">Español</a> · <a href="README.fr-FR.md">Français</a> · <a href="README.pt-BR.md">Português</a> · <a href="README.ru-RU.md">Русский</a> · <a href="README.hu-HU.md">Magyar</a> · <a href="README.ar-SA.md">العربية</a>
</p>

AppDepot ist eine moderne Windows-Anwendung zum Suchen, Herunterladen, Installieren, Exportieren und Aktualisieren von Microsoft-Store-Apps. Sie unterstützt außerdem das Sideloading externer UWP/MSIX-Pakete und blockbasierte Delta-Updates, die Bandbreite sparen.

Die Anwendung basiert auf **WinUI 3** und **.NET 10** und bietet eine Fluent-Oberfläche für Windows 10 und Windows 11.

<img width="996" height="543" alt="AppDepot-Startseite" src="docs/screenshots/home.png" />

## 🖼️ Screenshots

<p><img width="700" alt="AppDepot-Startseite" src="docs/screenshots/home.png" /></p>
<p><img width="700" alt="Navigationsmenü der erweiterten Suche" src="docs/screenshots/advanced-search-menu.png" /></p>
<p><img width="700" alt="Seite der erweiterten Suche" src="docs/screenshots/advanced-search.png" /></p>
<p><img width="700" alt="AppDepot-Einstellungen" src="docs/screenshots/settings.png" /></p>

## ✨ Funktionen

### 🔍 Suchen und entdecken

- Store-Empfehlungen wie **Top Free** durchsuchen.
- Über die Titelleiste mit Echtzeitvorschlägen, App-Symbolen und Titeln suchen.
- Die **Advanced Search** mit Store-URL, Produkt-ID oder Paketfamiliennamen verwenden.
- Detailseiten mit Beschreibung, Screenshots, Versionen und Abhängigkeiten öffnen.
- Store-Markt und Sprache in den Einstellungen unabhängig auswählen.

### ⬇️ Herunterladen und exportieren

- Store-Pakete direkt aus dem Microsoft-CDN herunterladen.
- Mit BlockMap-basierten Delta-Downloads möglichst nur geänderte Blöcke laden.
- `.appx`, `.msix`, `.appxbundle` und `.msixbundle` für Backups oder die Offline-Nutzung exportieren.
- Die Download-Warteschlange mit Fortschritt und Pause/Fortsetzen verwalten.

### 📦 Installieren und sideloaden

- Heruntergeladene Store-Pakete direkt aus AppDepot installieren.
- Lokale Pakete per Dateiauswahl oder Drag-and-drop sideloaden.
- Erforderliche Framework-Abhängigkeiten automatisch erkennen und installieren.
- Eine Neuinstallation oder ein Downgrade erzwingen, wenn bereits eine neuere Version installiert ist.

### 🔄 Aktualisieren

- Installierte, signierte Store-Pakete mit den neuesten Versionen vergleichen.
- Differenzielle Updates anwenden, um Downloads zu verkleinern.
- Alle Apps gesammelt oder einzelne Apps aktualisieren.
- Versionen nach Architektur und Windows-Build vergleichen.

### ⚙️ Desktop-Erlebnis

- Zwei Vertriebsarten: eine portable Version ohne Installation, die als eigenständige `.exe` läuft, und eine Microsoft-Store-Version mit Installation und Updates über den Store.
- Helles, dunkles oder systemabhängiges Design verwenden.
- AppDepot-, Eulen- oder ein lokales `.ico`-Symbol auswählen.
- Lokalisierte Ressourcendateien für die Benutzeroberfläche verwenden.
- Laufzeit-, Installations- und Absturzprotokolle getrennt einsehen.
- Nach AppDepot-Updates auf GitHub suchen.

## 🌐 Unterstützte Sprachen

Enthalten sind Englisch, Arabisch, Deutsch, Spanisch, Französisch, Ungarisch, Japanisch, Koreanisch, brasilianisches Portugiesisch, Russisch sowie vereinfachtes und traditionelles Chinesisch.

## 🛑 Systemanforderungen

- Windows 10 Version 2004, Build 19041 oder höher
- [.NET 10](https://dotnet.microsoft.com/en-us/download/dotnet/10.0), bei einer Self-contained-Version nicht erforderlich
- [Windows App SDK Runtime](https://learn.microsoft.com/en-us/windows/apps/windows-app-sdk/downloads#windows-app-sdk), bei einer Self-contained-Version nicht erforderlich

## 🚀 Installation und Start

Lade das passende ZIP für `x64`, `x86` oder `arm64` von den [Releases](https://github.com/sdf123098/AppDepot/releases) herunter, entpacke es und starte `AppDepot.exe`. Für eine portable Version verwende `*-self-contained.zip`.

Alternativ [WinGet](https://learn.microsoft.com/en-us/windows/package-manager/winget/) installieren und ausführen:

```powershell
winget install sdf123098.AppDepot
```

Bei einer Fehlalarm-Meldung von Windows oder dem Virenschutz `raven_cert.zip` aus den Releases laden, `raven.cer` installieren oder `install_raven_cert.bat` ausführen.

[AppDepot-Videoanleitung ansehen](https://www.youtube.com/watch?v=ZX__BaD6kr0)

### Microsoft Store (empfohlen)

Nach der Veröffentlichung kann die App über ihre Microsoft-Store-Seite installiert werden. Der Store signiert das MSIX-Paket und verwaltet Bereitstellung und Updates. Die Product ID wird erst nach der Einrichtung des Partner-Center-Eintrags festgelegt.

### WinGet über den Microsoft Store

Sobald der Store-Eintrag auffindbar ist, kann dasselbe Store-Paket geprüft und installiert werden:

```powershell
winget search <Microsoft Store Product ID> --source msstore
winget install <Microsoft Store Product ID> --source msstore
```

### Windows-Release-Automatisierung

Der Workflow `Build and Draft Release` erstellt die App, führt den Lokalisierungs-Smoke-Test aus, erzeugt nicht signierte Store-MSIX-Pakete, portable ZIPs und `SHA256SUMS.txt`. Microsoft signiert MSIX nach der Store-Zertifizierung erneut; ein kommerzielles Signaturzertifikat ist nicht erforderlich. Die Store-Veröffentlichung ist standardmäßig deaktiviert und wird erst nach Partner-Center-, GitHub-Secrets- und ausdrücklicher Bestätigung aktiviert.

`Publish Microsoft Store Metadata` verarbeitet nur eine von Entwicklern geprüfte `metadata/metadata.json`. `Verify WinGet Distribution` prüft zuerst die Store-Verteilung und erzeugt bei einem Fehler ein Community-Manifest für das portable GitHub-ZIP zur Prüfung; Pull Requests werden nicht automatisch erstellt.

## 🏗️ Projektstruktur

AppDepot verwendet **MVVM** und Dependency Injection über `Microsoft.Extensions.Hosting`. Die wichtigsten Bereiche sind `Raven/Views`, `Raven/ViewModels`, `Raven/Services`, `Raven/Helpers`, `Raven/Models`, `Raven/Strings`, `Raven.Updater` und das Untermodul `StoreListings`.

## 🧰 Aus dem Quellcode erstellen

Benötigt werden das .NET 10 SDK, Visual Studio 2026 mit den Workloads .NET Desktop Development und Windows App SDK/WinUI sowie das Windows 10 SDK (26100).

```bash
git clone --recurse-submodules https://github.com/sdf123098/AppDepot.git
cd AppDepot
dotnet build Raven.sln -c Debug -p:Platform=x64
dotnet run --project Raven -c Debug
```

Falls die Submodule fehlen, `git submodule update --init --recursive` ausführen. Unterstützt werden `x64`, `x86` und `arm64`.

## 🤝 Mitwirken

Repository forken, einen fokussierten Branch erstellen, die vorhandenen MVVM- und DI-Konventionen befolgen, XAML-Texte mit `x:Uid` lokalisieren und anschließend einen Pull Request mit Prüfschritten öffnen.

## 📜 Lizenz

AppDepot steht unter der **Apache License 2.0**. Der vollständige Text befindet sich in [LICENSE](LICENSE).
