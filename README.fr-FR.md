# AppDepot

<p align="center"><b>Client Microsoft Store natif et open source pour Windows</b></p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.zh-TW.md">繁體中文</a> · <a href="README.ja-JP.md">日本語</a> · <a href="README.ko-KR.md">한국어</a> · <a href="README.de-DE.md">Deutsch</a> · <a href="README.es-ES.md">Español</a> · <a href="README.fr-FR.md">Français</a> · <a href="README.pt-BR.md">Português</a> · <a href="README.ru-RU.md">Русский</a> · <a href="README.hu-HU.md">Magyar</a> · <a href="README.ar-SA.md">العربية</a>
</p>

AppDepot est une application Windows moderne qui permet de découvrir, télécharger, installer, exporter et mettre à jour les applications Microsoft Store. Elle prend également en charge le sideload de packages UWP/MSIX externes et les mises à jour différentielles par blocs pour économiser la bande passante.

Construite avec **WinUI 3** et **.NET 10**, elle offre une interface Fluent conçue pour Windows 10 et Windows 11.

<img width="996" height="543" alt="Page d’accueil AppDepot" src="docs/screenshots/home.png" />

## 🖼️ Captures d’écran

<p><img width="700" alt="Page d’accueil AppDepot" src="docs/screenshots/home.png" /></p>
<p><img width="700" alt="Menu de navigation de la recherche avancée" src="docs/screenshots/advanced-search-menu.png" /></p>
<p><img width="700" alt="Page de recherche avancée" src="docs/screenshots/advanced-search.png" /></p>
<p><img width="700" alt="Paramètres AppDepot" src="docs/screenshots/settings.png" /></p>

## ✨ Fonctionnalités

### 🔍 Découvrir et rechercher

- Parcourir les recommandations du Store, comme les applications **Top Free**.
- Rechercher depuis la barre de titre avec suggestions, icônes et titres en temps réel.
- Utiliser **Advanced Search** avec une URL Store, un ID produit ou un nom de famille de packages.
- Ouvrir des pages détaillées avec descriptions, captures, versions et dépendances.
- Choisir séparément le marché et la langue du Store dans les paramètres.

### ⬇️ Télécharger et exporter

- Télécharger les packages Store directement depuis le CDN de Microsoft.
- Utiliser les téléchargements différentiels fondés sur BlockMap pour récupérer uniquement les blocs modifiés lorsque c’est possible.
- Exporter les packages `.appx`, `.msix`, `.appxbundle` et `.msixbundle` pour la sauvegarde ou l’utilisation hors ligne.
- Gérer la file de téléchargements avec progression, pause et reprise.

### 📦 Installer et sideloader

- Installer directement depuis AppDepot les packages Store téléchargés.
- Installer des packages locaux via le sélecteur de fichiers ou le glisser-déposer.
- Détecter et installer automatiquement les dépendances de framework requises.
- Forcer la réinstallation ou la rétrogradation lorsqu’une version plus récente est déjà présente.

### 🔄 Mettre à jour

- Comparer les packages Store signés installés avec les dernières versions disponibles.
- Appliquer des mises à jour différentielles pour réduire les téléchargements.
- Tout mettre à jour en une fois ou sélectionner des applications individuellement.
- Comparer les versions selon l’architecture et la build Windows.

### ⚙️ Expérience de bureau

- Deux modes de distribution : une version portable sans installation qui s’exécute comme un `.exe` autonome, et une version Microsoft Store installée et mise à jour par le Store.
- Choisir un thème clair, sombre ou celui du système.
- Utiliser l’icône AppDepot, l’icône hibou fournie ou un fichier `.ico` local.
- Profiter d’une interface localisée à l’aide de fichiers de ressources.
- Consulter séparément les journaux d’exécution, d’installation et de plantage.
- Rechercher les mises à jour d’AppDepot sur GitHub.

## 🌐 Langues prises en charge

L’application inclut l’anglais, l’arabe, l’allemand, l’espagnol, le français, le hongrois, le japonais, le coréen, le portugais brésilien, le russe, le chinois simplifié et le chinois traditionnel.

## 🛑 Configuration requise

- Windows 10 version 2004, build 19041 ou ultérieure
- [.NET 10](https://dotnet.microsoft.com/en-us/download/dotnet/10.0), sauf pour une version autonome
- [Windows App SDK Runtime](https://learn.microsoft.com/en-us/windows/apps/windows-app-sdk/downloads#windows-app-sdk), sauf pour une version autonome

## 🚀 Installer et lancer

Téléchargez depuis les [Releases](https://github.com/sdf123098/AppDepot/releases) l’archive adaptée à `x64`, `x86` ou `arm64`, décompressez-la et lancez `AppDepot.exe`. Pour une version portable, choisissez `*-self-contained.zip`.

Vous pouvez aussi installer [WinGet](https://learn.microsoft.com/en-us/windows/package-manager/winget/) et exécuter :

```powershell
winget install sdf123098.AppDepot
```

En cas de faux positif de Windows ou de l’antivirus, téléchargez `raven_cert.zip` depuis les Releases, installez `raven.cer` ou lancez `install_raven_cert.bat`.

[Voir le guide vidéo AppDepot](https://www.youtube.com/watch?v=ZX__BaD6kr0)

### Microsoft Store (recommandé)

Après publication, installez l’application depuis sa page Microsoft Store. Le Store signe le package MSIX et gère sa distribution et ses mises à jour. L’ID produit sera défini lorsque la fiche Partner Center existera.

### WinGet via Microsoft Store

Une fois la fiche Store trouvable, vérifiez et installez le même package :

```powershell
winget search <Microsoft Store Product ID> --source msstore
winget install <Microsoft Store Product ID> --source msstore
```

### Automatisation des releases Windows

Le workflow `Build and Draft Release` compile l’application, exécute le test de localisation, génère des MSIX Store non signés, des ZIP portables et `SHA256SUMS.txt`. Microsoft re-signe les MSIX après la certification Store ; aucun certificat commercial n’est nécessaire. La publication Store est désactivée par défaut et ne peut être activée qu’après configuration de Partner Center, des GitHub Secrets et d’une confirmation explicite.

`Publish Microsoft Store Metadata` ne traite qu’un `metadata/metadata.json` vérifié par un développeur. `Verify WinGet Distribution` vérifie d’abord la distribution Store et génère, en cas d’échec, un manifeste communautaire du ZIP portable GitHub à examiner ; il ne crée pas automatiquement de Pull Request.

## 🏗️ Structure du projet

AppDepot suit le modèle **MVVM** et utilise l’injection de dépendances via `Microsoft.Extensions.Hosting`. Les principaux répertoires sont `Raven/Views`, `Raven/ViewModels`, `Raven/Services`, `Raven/Helpers`, `Raven/Models`, `Raven/Strings`, `Raven.Updater` et le sous-module `StoreListings`.

## 🧰 Compiler depuis les sources

Il faut le SDK .NET 10, Visual Studio 2026 avec les workloads .NET Desktop Development et Windows App SDK/WinUI, ainsi que le Windows 10 SDK (26100).

```bash
git clone --recurse-submodules https://github.com/sdf123098/AppDepot.git
cd AppDepot
dotnet build Raven.sln -c Debug -p:Platform=x64
dotnet run --project Raven -c Debug
```

Si les sous-modules n’ont pas été récupérés, exécutez `git submodule update --init --recursive`. Les architectures `x64`, `x86` et `arm64` sont prises en charge.

## 🤝 Contribuer

Forkez le dépôt, créez une branche ciblée, respectez les conventions MVVM et d’injection de dépendances, localisez les textes XAML avec les ressources `x:Uid`, puis ouvrez une Pull Request avec les étapes de validation.

## 📜 Licence

AppDepot est distribué sous **Apache License 2.0**. Consultez le texte complet dans [LICENSE](LICENSE).
