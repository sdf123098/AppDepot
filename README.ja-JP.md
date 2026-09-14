# AppDepot

<p align="center"><b>Windows 向けのネイティブなオープンソース Microsoft Store クライアント</b></p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.zh-TW.md">繁體中文</a> · <a href="README.ja-JP.md">日本語</a> · <a href="README.ko-KR.md">한국어</a> · <a href="README.de-DE.md">Deutsch</a> · <a href="README.es-ES.md">Español</a> · <a href="README.fr-FR.md">Français</a> · <a href="README.pt-BR.md">Português</a> · <a href="README.ru-RU.md">Русский</a> · <a href="README.hu-HU.md">Magyar</a> · <a href="README.ar-SA.md">العربية</a>
</p>

AppDepot は、Microsoft Store アプリの検索、ダウンロード、インストール、エクスポート、更新を行う Windows 向けアプリです。外部 UWP/MSIX パッケージのサイドロードと、帯域幅を節約できるブロック単位の差分更新にも対応しています。

**WinUI 3** と **.NET 10** で構築され、Windows 10 と Windows 11 に馴染む Fluent UI を採用しています。

<img width="996" height="543" alt="AppDepot ホーム" src="docs/screenshots/home.png" />

## 🖼️ スクリーンショット

<p><img width="700" alt="AppDepot ホーム" src="docs/screenshots/home.png" /></p>
<p><img width="700" alt="Advanced Search ナビゲーションメニュー" src="docs/screenshots/advanced-search-menu.png" /></p>
<p><img width="700" alt="Advanced Search ページ" src="docs/screenshots/advanced-search.png" /></p>
<p><img width="700" alt="AppDepot 設定" src="docs/screenshots/settings.png" /></p>

## ✨ 主な機能

### 🔍 検索と探索

- **Top Free** など Microsoft Store のおすすめを閲覧。
- タイトルバーからリアルタイム候補付きで検索。
- **Advanced Search** で Store URL、製品 ID、パッケージ ファミリ名を検索。
- 説明、スクリーンショット、バージョン、依存関係を含む詳細ページ。
- 設定から Store の市場と表示言語を個別に選択。

### ⬇️ ダウンロードとエクスポート

- Microsoft の CDN から Store パッケージを直接ダウンロード。
- BlockMap に基づく差分ダウンロードで変更ブロックだけを取得。
- `.appx`、`.msix`、`.appxbundle`、`.msixbundle` をバックアップ用にエクスポート。
- 進捗表示、停止/再開に対応したダウンロード キュー。

### 📦 インストールとサイドロード

- ダウンロードした Store パッケージを AppDepot から直接インストール。
- ファイル選択またはドラッグ＆ドロップでローカル パッケージをサイドロード。
- 必要なフレームワーク依存関係を自動検出・インストール。
- 新しいバージョンが入っている場合も強制再インストールまたはダウングレード。

### 🔄 更新

- インストール済みの Store 署名パッケージと最新バージョンを比較。
- 差分更新でダウンロード量を削減。
- すべてを一括更新、またはアプリごとに更新。
- アーキテクチャと Windows ビルドを考慮したバージョン比較。

### ⚙️ デスクトップ向け機能

- 2 つの配布方式に対応：インストール不要で単体 `.exe` を直接実行するポータブル版と、Store からインストールして更新できる Microsoft Store 版。
- ライト、ダーク、システム既定テーマを切り替え。
- AppDepot アイコン、内蔵フクロウ アイコン、任意の `.ico` を選択。
- リソース ファイルによる多言語 UI。
- 実行時、インストール、クラッシュのログを確認。
- GitHub から AppDepot の更新を確認。

## 🌐 対応言語

英語、アラビア語、ドイツ語、スペイン語、フランス語、ハンガリー語、日本語、韓国語、ブラジル ポルトガル語、ロシア語、中国語（簡体字）、中国語（繁体字）を収録しています。

## 🛑 システム要件

- Windows 10 version 2004、ビルド 19041 以降
- [.NET 10](https://dotnet.microsoft.com/en-us/download/dotnet/10.0)（自己完結版では不要）
- [Windows App SDK Runtime](https://learn.microsoft.com/en-us/windows/apps/windows-app-sdk/downloads#windows-app-sdk)（自己完結版では不要）

## 🚀 インストールと実行

[Releases](https://github.com/sdf123098/AppDepot/releases) から `x64`、`x86`、`arm64` 用の ZIP をダウンロードし、展開して `AppDepot.exe` を実行します。ポータブル版は `*-self-contained.zip` を使用してください。

WinGet を使う場合は [WinGet](https://learn.microsoft.com/en-us/windows/package-manager/winget/) をインストールして、次を実行します。

```powershell
winget install sdf123098.AppDepot
```

誤検知が発生した場合は Releases から `raven_cert.zip` を取得し、`raven.cer` をインストールするか `install_raven_cert.bat` を実行してください。

[AppDepot ビデオガイドを見る](https://www.youtube.com/watch?v=ZX__BaD6kr0)

### Microsoft Store（推奨）

Store 公開後はアプリの Microsoft Store ページからインストールできます。Store が MSIX パッケージに署名し、配信と更新を管理します。Product ID は Partner Center の掲載ページが作成されるまで固定しません。

### Microsoft Store 経由の WinGet

Store の掲載が検索可能になったら、同じ Store パッケージを検証してインストールできます。

```powershell
winget search <Microsoft Store Product ID> --source msstore
winget install <Microsoft Store Product ID> --source msstore
```

### Windows リリース自動化

`Build and Draft Release` ワークフローはアプリのビルド、ローカライズのスモークテスト、Store 用の未署名 MSIX、ポータブル ZIP、`SHA256SUMS.txt` の生成を行います。MSIX は Store の認証後に Microsoft が再署名するため、商用コード署名証明書は不要です。Store 公開は既定で無効で、Partner Center、GitHub Secrets、明示的な公開確認を設定した場合だけ有効にできます。

`Publish Microsoft Store Metadata` は開発者が確認した `metadata/metadata.json` のみを処理します。`Verify WinGet Distribution` は Store 配信を検証し、失敗時には確認用の GitHub ポータブル ZIP マニフェストを生成します。Pull Request は自動送信しません。

## 🏗️ プロジェクト構成

AppDepot は **MVVM** と `Microsoft.Extensions.Hosting` による依存性注入を使用します。主な構成要素は `Raven/Views`、`Raven/ViewModels`、`Raven/Services`、`Raven/Helpers`、`Raven/Models`、`Raven/Strings`、`Raven.Updater`、`StoreListings` サブモジュールです。

## 🧰 ソースからビルド

.NET 10 SDK、Visual Studio 2026（.NET Desktop Development と Windows App SDK/WinUI ワークロード）、Windows 10 SDK (26100) が必要です。

```bash
git clone --recurse-submodules https://github.com/sdf123098/AppDepot.git
cd AppDepot
dotnet build Raven.sln -c Debug -p:Platform=x64
dotnet run --project Raven -c Debug
```

## 🤝 コントリビューション

Fork、専用ブランチの作成、既存の MVVM/依存性注入規約への準拠、`x:Uid` リソースによる XAML のローカライズを行い、検証手順を含む Pull Request を送ってください。

## 📜 ライセンス

AppDepot は **Apache License 2.0** で公開されています。全文は [LICENSE](LICENSE) を参照してください。
