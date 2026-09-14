# AppDepot

<p align="center"><b>適用於 Windows 的原生開源 Microsoft Store 用戶端</b></p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.zh-TW.md">繁體中文</a> · <a href="README.ja-JP.md">日本語</a> · <a href="README.ko-KR.md">한국어</a> · <a href="README.de-DE.md">Deutsch</a> · <a href="README.es-ES.md">Español</a> · <a href="README.fr-FR.md">Français</a> · <a href="README.pt-BR.md">Português</a> · <a href="README.ru-RU.md">Русский</a> · <a href="README.hu-HU.md">Magyar</a> · <a href="README.ar-SA.md">العربية</a>
</p>

AppDepot 是一款現代化 Windows 應用程式，用於探索、下載、安裝、匯出及更新 Microsoft Store 應用程式。它也支援旁載外部 UWP/MSIX 套件，以及可節省流量的區塊級差異更新。

AppDepot 使用 **WinUI 3** 與 **.NET 10** 建置，介面適用於 Windows 10 和 Windows 11。

<img width="996" height="543" alt="AppDepot 首頁" src="docs/screenshots/home.png" />

## 🖼️ 介面截圖

<p><img width="700" alt="AppDepot 首頁" src="docs/screenshots/home.png" /></p>
<p><img width="700" alt="進階搜尋導覽選單" src="docs/screenshots/advanced-search-menu.png" /></p>
<p><img width="700" alt="進階搜尋頁面" src="docs/screenshots/advanced-search.png" /></p>
<p><img width="700" alt="AppDepot 設定頁面" src="docs/screenshots/settings.png" /></p>

## ✨ 功能

### 🔍 探索與搜尋

- 瀏覽 Microsoft Store 推薦內容，例如 **Top Free** 應用程式。
- 從標題列搜尋，取得即時建議、應用程式圖示與名稱。
- 在**進階搜尋**中使用 Store URL、產品 ID 或套件系列名稱查詢。
- 開啟包含描述、螢幕截圖、版本及相依項目的詳細資料頁面。
- 在設定中分別選擇 Store 市集與語言。

### ⬇️ 下載與匯出

- 直接從 Microsoft 內容傳遞網路下載 Store 套件。
- 使用以 BlockMap 為基礎的差異下載，只取得可能已變更的區塊。
- 匯出 `.appx`、`.msix`、`.appxbundle` 和 `.msixbundle`，以供備份或離線使用。
- 管理下載佇列、進度，以及暫停/繼續工作。

### 📦 安裝與旁載

- 直接在 AppDepot 安裝已下載的 Store 套件。
- 透過檔案選擇或拖放，從任意本機路徑旁載套件。
- 自動偵測並安裝必要的框架相依項目。
- 已安裝版本較新時，可強制重新安裝或降級。

### 🔄 更新應用程式

- 將已安裝的 Store 簽署套件與最新版本比較。
- 套用差異更新以減少下載量。
- 支援批次更新，也能個別選擇應用程式。
- 依處理器架構與 Windows 組建比較版本。

### ⚙️ 桌面體驗

- 提供兩種發行方式：免安裝攜帶式版本，可直接執行獨立 `.exe`；以及 Microsoft Store 商店版，由商店負責安裝與更新。
- 支援淺色、深色及系統預設主題。
- 可選擇 AppDepot 圖示、內建貓頭鷹圖示或本機 `.ico` 檔案。
- 使用資源檔提供多語言介面。
- 分別檢視執行階段、安裝及當機記錄。
- 檢查 GitHub 上的 AppDepot 更新。

## 🌐 支援的語言

目前提供英文、阿拉伯文、德文、西班牙文、法文、匈牙利文、日文、韓文、巴西葡萄牙文、俄文、簡體中文及繁體中文。

## 🛑 系統需求

- Windows 10 版本 2004，組建 19041 或更新版本
- [.NET 10](https://dotnet.microsoft.com/en-us/download/dotnet/10.0)，自包含版本不需要另行安裝
- [Windows App SDK Runtime](https://learn.microsoft.com/en-us/windows/apps/windows-app-sdk/downloads#windows-app-sdk)，自包含版本不需要另行安裝

## 🚀 安裝與執行

從[發行頁面](https://github.com/sdf123098/AppDepot/releases)下載對應 `x64`、`x86` 或 `arm64` 的壓縮檔，解壓縮後執行 `AppDepot.exe`。若要攜帶式版本，請選擇 `*-self-contained.zip`，其中包含 .NET 10 與 Windows App Runtime。

若 Windows 或防毒軟體誤報，請下載 `raven_cert.zip`，安裝 `raven.cer`，或執行 `install_raven_cert.bat`。

也可以安裝 [WinGet](https://learn.microsoft.com/en-us/windows/package-manager/winget/) 後執行：

```powershell
winget install sdf123098.AppDepot
```

### Microsoft Store（推薦）

Store 發布後，可使用應用程式的 Store 頁面安裝。Store 會替 MSIX 套件簽署，並負責傳遞與更新。產品 ID 會在 Partner Center 頁面建立後確定，請勿將 WinGet 社群識別碼當作 Store 產品 ID。

### 透過 Microsoft Store 使用 WinGet

```powershell
winget search <Microsoft Store Product ID> --source msstore
winget install <Microsoft Store Product ID> --source msstore
```

### Windows 發行自動化

`Build and Draft Release` 工作流程會建置應用程式、執行本地化冒煙測試、產生 Store 就緒的未簽署 MSIX、攜帶式 ZIP 與 `SHA256SUMS.txt`。MSIX 會在 Store 認證後由 Microsoft 重新簽署，不需要商業程式碼簽署憑證。Store 發布預設關閉，只有完成 Partner Center 設定、GitHub Secrets 與明確發布確認後才會啟用。

`Publish Microsoft Store Metadata` 只處理經開發者審核的 `metadata/metadata.json`；`Verify WinGet Distribution` 會先驗證 Store 發行，失敗時產生供審核的 GitHub 攜帶式 ZIP 社群資訊清單，不會自動提交 Pull Request。

### 影片指南

[觀看 AppDepot 影片指南](https://www.youtube.com/watch?v=ZX__BaD6kr0)

## 🏗️ 專案結構

AppDepot 遵循 **MVVM** 模式，並透過 `Microsoft.Extensions.Hosting` 使用相依性注入。主要目錄包括 `Raven/Views`、`Raven/ViewModels`、`Raven/Services`、`Raven/Helpers`、`Raven/Models`、`Raven/Strings`、`Raven.Updater` 及 `StoreListings` 子模組。

## 🧰 從原始碼建置

需要 .NET 10 SDK、Visual Studio 2026（.NET Desktop Development 與 Windows App SDK/WinUI 工作負載）以及 Windows 10 SDK (26100)。

```bash
git clone --recurse-submodules https://github.com/sdf123098/AppDepot.git
cd AppDepot
dotnet build Raven.sln -c Debug -p:Platform=x64
dotnet run --project Raven -c Debug
```

若未初始化子模組，請執行 `git submodule update --init --recursive`。支援 `x64`、`x86` 和 `arm64`。

## 🤝 參與貢獻

請 Fork 專案、建立專注的分支、遵循現有 MVVM 與相依性注入慣例，並使用 `x:Uid` 資源將 XAML 文字本地化，再提交包含驗證步驟的 Pull Request。

## 📜 授權條款

AppDepot 以 **Apache License 2.0** 發布，詳見 [LICENSE](LICENSE)。
