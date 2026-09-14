# AppDepot

<p align="center"><b>面向 Windows 的原生开源 Microsoft Store 客户端</b></p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.zh-TW.md">繁體中文</a> · <a href="README.ja-JP.md">日本語</a> · <a href="README.ko-KR.md">한국어</a> · <a href="README.de-DE.md">Deutsch</a> · <a href="README.es-ES.md">Español</a> · <a href="README.fr-FR.md">Français</a> · <a href="README.pt-BR.md">Português</a> · <a href="README.ru-RU.md">Русский</a> · <a href="README.hu-HU.md">Magyar</a> · <a href="README.ar-SA.md">العربية</a>
</p>

<p align="center"><a href="https://github.com/sdf123098/AppDepot/releases">发布版本</a> · <a href="https://github.com/sdf123098/AppDepot/issues">问题反馈</a> · <a href="https://discord.gg/9eeN2Wve4T">Discord</a></p>

AppDepot 是一款现代化的 Windows 应用，用于发现、下载、安装、导出和更新 Microsoft Store 应用。它还支持旁加载外部 UWP/MSIX 包，以及通过块级差分下载节省更新流量。

AppDepot 基于 **WinUI 3** 和 **.NET 10** 构建，界面适配 Windows 10 和 Windows 11。

<img width="996" height="543" alt="AppDepot 主页" src="docs/screenshots/home.png" />

## 🖼️ 界面截图

<p><img width="700" alt="AppDepot 主页" src="docs/screenshots/home.png" /></p>
<p><img width="700" alt="高级搜索导航菜单" src="docs/screenshots/advanced-search-menu.png" /></p>
<p><img width="700" alt="高级搜索页面" src="docs/screenshots/advanced-search.png" /></p>
<p><img width="700" alt="AppDepot 设置页面" src="docs/screenshots/settings.png" /></p>

## ✨ 功能

### 🔍 浏览与搜索

- 浏览 Microsoft Store 推荐内容，例如 **Top Free** 应用。
- 从标题栏搜索，并获得实时建议、应用图标和标题。
- 在**高级搜索**中按 Store URL、产品 ID 或包系列名称查询。
- 查看包含描述、截图、版本和依赖项的应用详情页。
- 在设置中独立选择 Store 市场和语言。

### ⬇️ 下载与导出

- 直接从 Microsoft 内容分发网络下载 Store 包。
- 使用基于 BlockMap 的差分下载，可能时只获取发生变化的区块。
- 导出 `.appx`、`.msix`、`.appxbundle` 和 `.msixbundle`，用于备份或离线使用。
- 管理下载队列，查看进度并暂停或恢复任务。

### 📦 安装与旁加载

- 直接在 AppDepot 中安装已下载的 Store 包。
- 通过文件选择或拖放，从任意本地路径旁加载安装包。
- 自动检测并安装所需的框架依赖项。
- 已安装版本较新时，可强制重新安装或降级。

### 🔄 应用更新

- 将已安装的 Store 签名包与最新版本进行比较。
- 应用差分更新以减少下载量。
- 支持一键批量更新，也可以单独选择应用。
- 按处理器架构和 Windows 版本比较版本。

### ⚙️ 桌面体验

- 提供两种发行方式：免安装便携版，直接运行独立 `.exe`；以及 Microsoft Store 商店版，由商店负责安装和更新。
- 支持浅色、深色和跟随系统主题。
- 可选择 AppDepot 图标、内置猫头鹰图标或本地 `.ico` 文件。
- 使用基于资源文件的多语言界面。
- 分别查看运行时、安装和崩溃日志。
- 检查 GitHub 上的 AppDepot 更新。

## 🌐 已支持语言

当前随应用提供：英语、阿拉伯语、德语、西班牙语、法语、匈牙利语、日语、韩语、巴西葡萄牙语、俄语、简体中文和繁体中文。

## 🛑 系统要求

- Windows 10 版本 2004，内部版本 19041 或更高
- [.NET 10](https://dotnet.microsoft.com/en-us/download/dotnet/10.0)，使用自包含版本时不需要单独安装
- [Windows App SDK Runtime](https://learn.microsoft.com/en-us/windows/apps/windows-app-sdk/downloads#windows-app-sdk)，使用自包含版本时不需要单独安装

## 🚀 安装与运行

### 发布压缩包

1. 从[发布页面](https://github.com/sdf123098/AppDepot/releases)下载适用于 `x64`、`x86` 或 `arm64` 的最新压缩包。
2. 解压并运行 `AppDepot.exe`。
3. 便携运行时选择对应的 `*-self-contained.zip`，其中已包含 .NET 10 和 Windows App Runtime 组件。

如果 Windows 或杀毒软件误报，请从[发布页面](https://github.com/sdf123098/AppDepot/releases)下载 `raven_cert.zip`，安装 `raven.cer`，或运行 `install_raven_cert.bat`。

### WinGet

安装 [WinGet](https://learn.microsoft.com/en-us/windows/package-manager/winget/) 后运行：

```powershell
winget install sdf123098.AppDepot
```

签名的 MSIX 包会注册到 Windows，并自动出现在开始菜单中。

### Microsoft Store（推荐）

Microsoft Store 发布后，可使用应用的 Store 页面安装。Store 会为 MSIX 包签名，并负责分发与更新。产品 ID 会在 Partner Center 页面建立后确定，不要将 WinGet 社区标识符当作 Store 产品 ID。

### 通过 Microsoft Store 使用 WinGet

```powershell
winget search <Microsoft Store Product ID> --source msstore
winget install <Microsoft Store Product ID> --source msstore
```

### Windows 发布自动化

`Build and Draft Release` 工作流会构建应用、运行本地化冒烟测试、生成 Store 就绪的未签名 MSIX、便携 ZIP 和 `SHA256SUMS.txt`。MSIX 由 Microsoft 在 Store 认证后重新签名，不需要商业代码签名证书。Store 发布默认关闭，只有完成 Partner Center 配置、GitHub Secrets 和明确的发布确认后才会启用。

`Publish Microsoft Store Metadata` 只处理经过开发者审核的 `metadata/metadata.json`；`Verify WinGet Distribution` 会先验证 Store 分发，失败时生成供审核的 GitHub 便携 ZIP 社区清单，不会自动提交 Pull Request。

### 视频指南

[观看 AppDepot 视频指南](https://www.youtube.com/watch?v=ZX__BaD6kr0)

## 🏗️ 项目结构

AppDepot 遵循 **MVVM** 模式，并通过 `Microsoft.Extensions.Hosting` 使用依赖注入。

```text
Raven.sln
├── Raven/                    # WinUI 3 应用
│   ├── Views/                # 外壳、搜索、详情、下载、更新和设置页面
│   ├── ViewModels/           # CommunityToolkit.Mvvm 视图模型
│   ├── Services/             # 导航、下载、安装和更新服务
│   ├── Helpers/              # 差分下载、BlockMap、URL 和版本工具
│   ├── Models/               # AppInfo、DownloadItem、UpdateItem
│   ├── Contracts/            # 服务接口
│   ├── Layouts/              # 自定义 WinUI 布局
│   ├── Styles/               # XAML 资源字典
│   └── Strings/              # 本地化 .resw 资源
├── Raven.Updater/            # 自更新辅助程序
└── StoreListings/            # Store API 包装器子模块
```

## 🧰 从源码构建

需要 .NET 10 SDK、Visual Studio 2026（安装 .NET Desktop Development 和 Windows App SDK/WinUI 工作负载）以及 Windows 10 SDK (26100)。

```bash
git clone --recurse-submodules https://github.com/sdf123098/AppDepot.git
cd AppDepot
dotnet build Raven.sln -c Debug -p:Platform=x64
dotnet run --project Raven -c Debug
```

如果克隆时没有初始化子模块，请运行 `git submodule update --init --recursive`。项目支持 `x64`、`x86` 和 `arm64`。

## 🤝 参与贡献

Fork 项目，创建专注的分支，遵循现有 MVVM 和依赖注入约定；XAML 中面向用户的文字请使用 `x:Uid` 资源本地化，然后提交包含验证步骤的 Pull Request。

## ⭐ 致谢

- [StoreListings](https://github.com/dongle-the-gadget/StoreListings)：Microsoft Store API 包装器。
- [Alt App Installer](https://github.com/mjishnu/alt-app-installer)：本项目的前身。

## 📜 许可证

AppDepot 使用 **Apache License 2.0** 发布，详见 [LICENSE](LICENSE)。
