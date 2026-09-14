# AppDepot

<p align="center"><b>Нативный клиент Microsoft Store с открытым исходным кодом для Windows</b></p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.zh-TW.md">繁體中文</a> · <a href="README.ja-JP.md">日本語</a> · <a href="README.ko-KR.md">한국어</a> · <a href="README.de-DE.md">Deutsch</a> · <a href="README.es-ES.md">Español</a> · <a href="README.fr-FR.md">Français</a> · <a href="README.pt-BR.md">Português</a> · <a href="README.ru-RU.md">Русский</a> · <a href="README.hu-HU.md">Magyar</a> · <a href="README.ar-SA.md">العربية</a>
</p>

AppDepot — современное приложение для Windows, предназначенное для поиска, загрузки, установки, экспорта и обновления приложений Microsoft Store. Оно также поддерживает установку внешних пакетов UWP/MSIX и блочные дельта-обновления для экономии трафика.

Приложение создано на **WinUI 3** и **.NET 10** и имеет интерфейс Fluent для Windows 10 и Windows 11.

<img width="996" height="543" alt="Главная страница AppDepot" src="docs/screenshots/home.png" />

## 🖼️ Скриншоты

<p><img width="700" alt="Главная страница AppDepot" src="docs/screenshots/home.png" /></p>
<p><img width="700" alt="Меню навигации расширенного поиска" src="docs/screenshots/advanced-search-menu.png" /></p>
<p><img width="700" alt="Страница расширенного поиска" src="docs/screenshots/advanced-search.png" /></p>
<p><img width="700" alt="Настройки AppDepot" src="docs/screenshots/settings.png" /></p>

## ✨ Возможности

### 🔍 Поиск и обзор

- Просмотр рекомендаций Microsoft Store, включая приложения **Top Free**.
- Поиск из строки заголовка с подсказками, значками и названиями в реальном времени.
- **Advanced Search** по URL Store, идентификатору продукта или имени семейства пакетов.
- Страницы сведений с описанием, снимками экрана, версиями и зависимостями.
- Независимый выбор рынка и языка Store в настройках.

### ⬇️ Загрузка и экспорт

- Прямая загрузка пакетов Store из CDN Microsoft.
- Дельта-загрузка на основе BlockMap: по возможности загружаются только изменившиеся блоки.
- Экспорт `.appx`, `.msix`, `.appxbundle` и `.msixbundle` для резервного копирования или работы без сети.
- Очередь загрузок с отображением прогресса, паузой и возобновлением.

### 📦 Установка и sideload

- Установка загруженных пакетов Store прямо из AppDepot.
- Установка локальных пакетов через выбор файла или перетаскивание.
- Автоматическое обнаружение и установка необходимых зависимостей framework.
- Принудительная переустановка или откат, если уже установлена более новая версия.

### 🔄 Обновления

- Сравнение установленных подписанных пакетов Store с последними доступными версиями.
- Дифференциальные обновления для уменьшения объёма загрузки.
- Обновление всех приложений сразу или выбор отдельных приложений.
- Сравнение версий с учётом архитектуры и сборки Windows.

### ⚙️ Возможности рабочего стола

- Два варианта распространения: переносная версия без установки, запускаемая как отдельный `.exe`, и версия Microsoft Store, устанавливаемая и обновляемая через Store.
- Светлая, тёмная тема и тема по умолчанию системы.
- Выбор значка AppDepot, встроенного значка совы или локального файла `.ico`.
- Локализованный интерфейс на основе файлов ресурсов.
- Отдельные журналы выполнения, установки и сбоев.
- Проверка обновлений AppDepot на GitHub.

## 🌐 Поддерживаемые языки

В приложение включены английский, арабский, немецкий, испанский, французский, венгерский, японский, корейский, бразильский португальский, русский, упрощённый и традиционный китайский языки.

## 🛑 Системные требования

- Windows 10 версии 2004, сборка 19041 или новее
- [.NET 10](https://dotnet.microsoft.com/en-us/download/dotnet/10.0), не требуется для автономной сборки
- [Windows App SDK Runtime](https://learn.microsoft.com/en-us/windows/apps/windows-app-sdk/downloads#windows-app-sdk), не требуется для автономной сборки

## 🚀 Установка и запуск

Скачайте с [Releases](https://github.com/sdf123098/AppDepot/releases) архив для `x64`, `x86` или `arm64`, распакуйте его и запустите `AppDepot.exe`. Для переносной версии используйте `*-self-contained.zip`.

Также можно установить [WinGet](https://learn.microsoft.com/en-us/windows/package-manager/winget/) и выполнить:

```powershell
winget install sdf123098.AppDepot
```

При ложном срабатывании Windows или антивируса скачайте из Releases файл `raven_cert.zip`, установите `raven.cer` или запустите `install_raven_cert.bat`.

[Смотреть видеоинструкцию AppDepot](https://www.youtube.com/watch?v=ZX__BaD6kr0)

### Microsoft Store (рекомендуется)

После публикации приложение можно установить со страницы Microsoft Store. Store подписывает пакет MSIX и управляет его доставкой и обновлениями. Product ID будет определён после создания страницы в Partner Center.

### WinGet через Microsoft Store

После появления записи в Store можно проверить и установить тот же пакет:

```powershell
winget search <Microsoft Store Product ID> --source msstore
winget install <Microsoft Store Product ID> --source msstore
```

### Автоматизация релизов Windows

Workflow `Build and Draft Release` собирает приложение, запускает тест локализации, создаёт неподписанные MSIX для Store, переносные ZIP и `SHA256SUMS.txt`. После сертификации Store Microsoft повторно подписывает MSIX, поэтому коммерческий сертификат подписи не нужен. Публикация в Store отключена по умолчанию и включается только после настройки Partner Center, GitHub Secrets и явного подтверждения.

`Publish Microsoft Store Metadata` обрабатывает только проверенный разработчиком `metadata/metadata.json`. `Verify WinGet Distribution` сначала проверяет распространение через Store, а при ошибке создаёт для проверки community-манифест переносного GitHub ZIP; Pull Request автоматически не отправляется.

## 🏗️ Структура проекта

AppDepot использует архитектуру **MVVM** и внедрение зависимостей через `Microsoft.Extensions.Hosting`. Основные каталоги: `Raven/Views`, `Raven/ViewModels`, `Raven/Services`, `Raven/Helpers`, `Raven/Models`, `Raven/Strings`, `Raven.Updater` и подмодуль `StoreListings`.

## 🧰 Сборка из исходного кода

Потребуются .NET 10 SDK, Visual Studio 2026 с рабочими нагрузками .NET Desktop Development и Windows App SDK/WinUI, а также Windows 10 SDK (26100).

```bash
git clone --recurse-submodules https://github.com/sdf123098/AppDepot.git
cd AppDepot
dotnet build Raven.sln -c Debug -p:Platform=x64
dotnet run --project Raven -c Debug
```

Если подмодули не были загружены, выполните `git submodule update --init --recursive`. Поддерживаются `x64`, `x86` и `arm64`.

## 🤝 Участие в разработке

Сделайте fork, создайте отдельную ветку, соблюдайте существующие соглашения MVVM и внедрения зависимостей, локализуйте пользовательские строки XAML через ресурсы `x:Uid` и откройте Pull Request с шагами проверки.

## 📜 Лицензия

AppDepot распространяется по **Apache License 2.0**. Полный текст находится в файле [LICENSE](LICENSE).
