<p align="center">
  <img src="Raven/Assets/AppDepot.ico" alt="AppDepot logo" width="128" height="128">
</p>

<h1 align="center">AppDepot</h1>

<p align="center">
  <b>A native, open-source Microsoft Store client for Windows</b>
</p>

<p align="center">
  <a href="https://github.com/sdf123098/AppDepot/releases"><img src="https://img.shields.io/github/v/release/sdf123098/AppDepot?style=flat-square&color=blue" alt="GitHub Release"></a>
  <a href="https://github.com/sdf123098/AppDepot/blob/main/LICENSE"><img src="https://img.shields.io/github/license/sdf123098/AppDepot?style=flat-square&color=green" alt="License"></a>
  <a href="https://github.com/sdf123098/AppDepot/stargazers"><img src="https://img.shields.io/github/stars/sdf123098/AppDepot?style=flat-square" alt="Stars"></a>
  <a href="https://github.com/sdf123098/AppDepot/issues"><img src="https://img.shields.io/github/issues/sdf123098/AppDepot?style=flat-square" alt="Issues"></a>
  <a href="https://discord.gg/9eeN2Wve4T"><img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Fv10%2Finvites%2F9eeN2Wve4T%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&label=Discord&logo=discord&logoColor=white&color=5865F2&style=flat-square&suffix=%20members&cacheSeconds=3600" alt="Discord"></a>
</p>

<p align="center">
  <a href="README.md">English</a> ·
  <a href="README.zh-CN.md">简体中文</a> ·
  <a href="README.zh-TW.md">繁體中文</a> ·
  <a href="README.ja-JP.md">日本語</a> ·
  <a href="README.ko-KR.md">한국어</a> ·
  <a href="README.de-DE.md">Deutsch</a> ·
  <a href="README.es-ES.md">Español</a> ·
  <a href="README.fr-FR.md">Français</a> ·
  <a href="README.pt-BR.md">Português</a> ·
  <a href="README.ru-RU.md">Русский</a> ·
  <a href="README.hu-HU.md">Magyar</a> ·
  <a href="README.ar-SA.md">العربية</a>
</p>

---

AppDepot is a modern Windows application for discovering, downloading, installing, exporting, and updating Microsoft Store apps. It also supports sideloading external UWP/MSIX packages and bandwidth-saving block-level delta updates.

The app is built with **WinUI 3** and **.NET 10**, with a fluent interface designed for Windows 10 and Windows 11.

<img width="996" height="543" alt="AppDepot home page" src="docs/screenshots/home.png" />

## 🖼️ Screenshots

<p><img width="700" alt="AppDepot home page" src="docs/screenshots/home.png" /></p>
<p><img width="700" alt="Advanced Search navigation menu" src="docs/screenshots/advanced-search-menu.png" /></p>
<p><img width="700" alt="Advanced Search page" src="docs/screenshots/advanced-search.png" /></p>
<p><img width="700" alt="AppDepot settings" src="docs/screenshots/settings.png" /></p>

## ✨ Features

### 🔍 Discover and search

- Browse Microsoft Store recommendations such as **Top Free** apps.
- Search from the title bar with real-time suggestions, app icons, and titles.
- Use **Advanced Search** with a Store URL, product ID, or package family name.
- Open detail pages with descriptions, screenshots, versions, and dependencies.
- Select a Store market and language independently in Settings.

### ⬇️ Download and export

- Download Store packages directly from Microsoft's content delivery network.
- Use BlockMap-based delta downloads to fetch only changed blocks when possible.
- Export `.appx`, `.msix`, `.appxbundle`, and `.msixbundle` packages for backup or offline use.
- Manage queued downloads with progress, pause/resume, and status information.

### 📦 Install and sideload

- Install downloaded Store packages directly from AppDepot.
- Sideload packages from any local path by browsing or dragging and dropping.
- Detect and install required framework dependencies automatically.
- Force a reinstall or downgrade when the installed package is newer.

### 🔄 Keep apps updated

- Compare installed Store-signed packages with the latest available versions.
- Apply differential updates to reduce download size.
- Update everything in one batch or choose individual apps.
- Compare versions by architecture and Windows build.

### ⚙️ Comfortable desktop experience

- Choose between two distribution options: a no-install portable build that runs as a standalone `.exe`, or a Microsoft Store version installed and updated through the Store.
- Switch between light, dark, and system-default themes.
- Choose the AppDepot icon, the bundled owl icon, or a local `.ico` file.
- Use localized resource strings across the UI.
- Review separate runtime, installation, and crash logs.
- Check GitHub for AppDepot updates.

## 🌐 Supported languages

The application currently ships with: English (`en-us`), Arabic (`ar-SA`), German (`de-DE`), Spanish (`es-ES`), French (`fr-FR`), Hungarian (`hu-HU`), Japanese (`ja-JP`), Korean (`ko-kr`), Brazilian Portuguese (`pt-BR`), Russian (`ru-RU`), Simplified Chinese (`zh-cn`), and Traditional Chinese (`zh-TW`).

## 🛑 System requirements

- Windows 10 version 2004, build 19041 or later
- [.NET 10](https://dotnet.microsoft.com/en-us/download/dotnet/10.0), unless using a self-contained build
- [Windows App SDK Runtime](https://learn.microsoft.com/en-us/windows/apps/windows-app-sdk/downloads#windows-app-sdk), unless using a self-contained build

## 🚀 Install and run

### Microsoft Store (recommended)

After publication, use the app's Microsoft Store listing. The Store signs the MSIX package and manages delivery and updates:

```text
https://apps.microsoft.com/detail/9P15TS1PG7J8
```

The reserved Microsoft Store Product ID is `9P15TS1PG7J8`. Do not replace it with the WinGet community identifier.

### WinGet via Microsoft Store

Once the Store listing is discoverable, verify and install the same Store package:

```powershell
winget search 9P15TS1PG7J8 --source msstore
winget install 9P15TS1PG7J8 --source msstore
```

WinGet's `msstore` source is preferred. The community source is only a fallback if the Store listing cannot be found there.

### Portable GitHub Release

Download `AppDepot-<version>-windows-<architecture>.zip` from [Releases](https://github.com/sdf123098/AppDepot/releases), verify it with `SHA256SUMS.txt`, extract it, and run `AppDepot.exe`. The ZIP is self-contained for `win-x64`, `win-x86`, and `win-arm64`; no commercial code-signing certificate is required.

## 📦 Windows release automation

The `Build and Draft Release` workflow builds the app, runs the localization smoke test, creates unsigned Store-ready MSIX files and a combined `Store-MSIXBundle` artifact, creates portable ZIPs, and writes `SHA256SUMS.txt`. Microsoft re-signs MSIX packages after Store certification; no commercial certificate is used or required.

Store publishing is opt-in. After Partner Center registration, app-name reservation, identity verification, and GitHub Secrets setup, run the release workflow with `publish_store=true`, the exact Store Product ID, and `confirm_store_publish=PUBLISH`. The workflow prints the version, Product ID, package, and metadata scope before calling the official `msstore` CLI. The `microsoft-store-production` environment can add a second GitHub approval gate.

Required Store publishing secrets are `AZURE_AD_TENANT_ID`, `SELLER_ID`, `AZURE_AD_APPLICATION_CLIENT_ID`, and `AZURE_AD_APPLICATION_SECRET`. Store identity values used inside the MSIX manifest are repository Variables (`STORE_IDENTITY_NAME`, `STORE_PUBLISHER`, and `STORE_PUBLISHER_DISPLAY_NAME`), not guessed credentials. The current Partner Center values are `Micafic.AppDepot`, `CN=0FC149E9-04DE-4659-A0F2-E17CB3171973`, and `Micafic`, respectively.

The `Publish Microsoft Store Metadata` workflow only operates when a developer-reviewed `metadata/metadata.json` exists. Obtain the base metadata with `msstore submission get`, review legal/listing fields yourself, then commit it. The workflow never invents privacy, age-rating, legal, or account information.

The read-only `Export Microsoft Store Base Metadata` workflow can download that starting JSON as a short-lived Artifact. Run it with `confirm_metadata_export=EXPORT`, review the downloaded file, and only then add it as `metadata/metadata.json`.

The `Verify WinGet Distribution` workflow first tests `msstore` discovery and installation. If that fails, it generates and validates a multi-file community manifest for the GitHub portable ZIP (`InstallerType: zip` plus `NestedInstallerType: portable`) and uploads it as an artifact for review. It does not submit pull requests automatically. If a checked-in community manifest is added later, the workflow can use Microsoft's `wingetcreate` locally to update it before validation.

### Video guide

[Watch the AppDepot video guide](https://www.youtube.com/watch?v=ZX__BaD6kr0)

## 🏗️ Project structure

AppDepot follows **MVVM** and uses dependency injection through `Microsoft.Extensions.Hosting`.

```text
Raven.sln
├── Raven/                    # WinUI 3 application
│   ├── Views/                # Shell, search, details, downloads, updates, settings
│   ├── ViewModels/           # CommunityToolkit.Mvvm view models
│   ├── Services/             # Navigation, download, install, and update services
│   ├── Helpers/              # Delta downloads, BlockMap, URLs, and version helpers
│   ├── Models/               # AppInfo, DownloadItem, and UpdateItem
│   ├── Contracts/            # Service interfaces
│   ├── Layouts/              # Custom WinUI layouts
│   ├── Styles/               # XAML resource dictionaries
│   └── Strings/              # Localized .resw resources
├── Raven.Updater/            # Self-update helper
└── StoreListings/            # Store API wrapper submodule
```

### Main dependencies

| Package | Purpose |
|---|---|
| [Microsoft.WindowsAppSDK](https://github.com/microsoft/WindowsAppSDK) | WinUI 3 framework |
| [CommunityToolkit.Mvvm](https://github.com/CommunityToolkit/dotnet) | MVVM helpers and source generators |
| [CommunityToolkit.WinUI](https://github.com/CommunityToolkit/Windows) | WinUI controls and effects |
| [Downloader](https://github.com/bezzad/Downloader) | Multi-part downloads |
| [WinUIEx](https://github.com/dotMorten/WinUIEx) | Window management |
| [Serilog](https://serilog.net/) | Structured logging |
| [StoreListings](https://github.com/mjishnu/StoreListings) | Microsoft Store API wrapper |

## 🧰 Build from source

### Prerequisites

- .NET 10 SDK
- Visual Studio 2026 with .NET Desktop Development and Windows App SDK/WinUI workloads
- Windows 10 SDK (26100)

### Clone

```bash
git clone --recurse-submodules https://github.com/sdf123098/AppDepot.git
cd AppDepot
```

If the repository was cloned without submodules:

```bash
git submodule update --init --recursive
```

### Build and run

From Visual Studio, open `Raven.sln`, set `AppDepot` as the startup project, choose `x64`, `x86`, or `arm64`, and press **F5**.

From a terminal:

```bash
dotnet build Raven.sln -c Debug -p:Platform=x64
dotnet run --project Raven -c Debug
```

All three architectures are supported: `x64`, `x86`, and `arm64`.

## 🤝 Contributing

1. Fork the repository.
2. Create a focused branch for your change.
3. Follow the existing MVVM and dependency-injection conventions.
4. Keep user-facing XAML text localized with `x:Uid` resources.
5. Open a pull request with a clear description and validation steps.

## ⭐ Acknowledgements

- [StoreListings](https://github.com/dongle-the-gadget/StoreListings) for the Microsoft Store API wrapper.
- [Alt App Installer](https://github.com/mjishnu/alt-app-installer), the predecessor to this project.

## 📜 License

AppDepot is released under the **Apache License 2.0**. See [LICENSE](LICENSE) for the full text.
