<div dir="rtl">

# AppDepot

<p align="center"><b>عميل أصلي مفتوح المصدر لـ Microsoft Store على Windows</b></p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.zh-TW.md">繁體中文</a> · <a href="README.ja-JP.md">日本語</a> · <a href="README.ko-KR.md">한국어</a> · <a href="README.de-DE.md">Deutsch</a> · <a href="README.es-ES.md">Español</a> · <a href="README.fr-FR.md">Français</a> · <a href="README.pt-BR.md">Português</a> · <a href="README.ru-RU.md">Русский</a> · <a href="README.hu-HU.md">Magyar</a> · <a href="README.ar-SA.md">العربية</a>
</p>

AppDepot هو تطبيق حديث لنظام Windows يتيح استكشاف تطبيقات Microsoft Store وتنزيلها وتثبيتها وتصديرها وتحديثها. كما يدعم التثبيت الجانبي لحزم UWP/MSIX الخارجية والتحديثات التفاضلية على مستوى الكتل لتوفير النطاق الترددي.

تم إنشاء التطبيق باستخدام **WinUI 3** و **.NET 10**، ويوفر واجهة Fluent مناسبة لنظامي Windows 10 وWindows 11.

<img width="996" height="543" alt="الصفحة الرئيسية لـ AppDepot" src="docs/screenshots/home.png" />

## 🖼️ لقطات الشاشة

<p><img width="700" alt="الصفحة الرئيسية لـ AppDepot" src="docs/screenshots/home.png" /></p>
<p><img width="700" alt="قائمة التنقل للبحث المتقدم" src="docs/screenshots/advanced-search-menu.png" /></p>
<p><img width="700" alt="صفحة البحث المتقدم" src="docs/screenshots/advanced-search.png" /></p>
<p><img width="700" alt="إعدادات AppDepot" src="docs/screenshots/settings.png" /></p>

## ✨ الميزات

### 🔍 الاستكشاف والبحث

- تصفح توصيات Microsoft Store مثل تطبيقات **Top Free**.
- البحث من شريط العنوان مع اقتراحات وأيقونات وعناوين فورية.
- استخدام **Advanced Search** عبر عنوان Store أو معرّف المنتج أو اسم عائلة الحزمة.
- فتح صفحات تفاصيل تتضمن الوصف ولقطات الشاشة والإصدارات والتبعيات.
- اختيار سوق Store واللغة بشكل مستقل من الإعدادات.

### ⬇️ التنزيل والتصدير

- تنزيل حزم Store مباشرة من شبكة توصيل المحتوى التابعة لـ Microsoft.
- استخدام تنزيلات تفاضلية مبنية على BlockMap لتنزيل الكتل المتغيرة فقط عند الإمكان.
- تصدير حزم `.appx` و`.msix` و`.appxbundle` و`.msixbundle` للنسخ الاحتياطي أو الاستخدام دون اتصال.
- إدارة قائمة التنزيلات مع عرض التقدم والإيقاف المؤقت والاستئناف.

### 📦 التثبيت والتثبيت الجانبي

- تثبيت حزم Store التي تم تنزيلها مباشرة من AppDepot.
- تثبيت الحزم المحلية عبر اختيار ملف أو السحب والإفلات.
- اكتشاف تبعيات الأطر المطلوبة وتثبيتها تلقائياً.
- فرض إعادة التثبيت أو الرجوع إلى إصدار أقدم عند وجود إصدار أحدث مثبت.

### 🔄 التحديثات

- مقارنة الحزم الموقعة من Store والمثبتة بأحدث الإصدارات المتاحة.
- تطبيق تحديثات تفاضلية لتقليل حجم التنزيل.
- تحديث جميع التطبيقات دفعة واحدة أو اختيار تطبيقات محددة.
- مقارنة الإصدارات وفق البنية ومعمارية النظام وإصدار Windows.

### ⚙️ تجربة سطح المكتب

- يتوفر خياران للتوزيع: إصدار محمول لا يحتاج إلى تثبيت ويعمل كملف `.exe` مستقل، وإصدار Microsoft Store يتم تثبيته وتحديثه عبر Store.
- دعم السمات الفاتحة والداكنة والافتراضية للنظام.
- اختيار أيقونة AppDepot أو أيقونة البومة المضمنة أو ملف `.ico` محلي.
- واجهة مترجمة باستخدام ملفات الموارد.
- عرض سجلات التشغيل والتثبيت والأعطال بشكل منفصل.
- التحقق من تحديثات AppDepot على GitHub.

## 🌐 اللغات المدعومة

يتضمن التطبيق الإنجليزية والعربية والألمانية والإسبانية والفرنسية والمجرية واليابانية والكورية والبرتغالية البرازيلية والروسية والصينية المبسطة والصينية التقليدية.

## 🛑 متطلبات النظام

- Windows 10 الإصدار 2004، الإصدار 19041 أو أحدث
- [.NET 10](https://dotnet.microsoft.com/en-us/download/dotnet/10.0)، غير مطلوب في الإصدار المستقل
- [Windows App SDK Runtime](https://learn.microsoft.com/en-us/windows/apps/windows-app-sdk/downloads#windows-app-sdk)، غير مطلوب في الإصدار المستقل

## 🚀 التثبيت والتشغيل

نزّل من صفحة [Releases](https://github.com/sdf123098/AppDepot/releases) أرشيف `x64` أو `x86` أو `arm64` المناسب، ثم فك الضغط وشغّل `AppDepot.exe`. للحصول على نسخة محمولة استخدم `*-self-contained.zip`.

يمكنك أيضاً تثبيت [WinGet](https://learn.microsoft.com/en-us/windows/package-manager/winget/) وتشغيل:

```powershell
winget install sdf123098.AppDepot
```

إذا أبلغ Windows أو برنامج مكافحة الفيروسات عن إنذار خاطئ، نزّل `raven_cert.zip` من Releases وثبّت `raven.cer` أو شغّل `install_raven_cert.bat`.

[مشاهدة دليل فيديو AppDepot](https://www.youtube.com/watch?v=ZX__BaD6kr0)

### Microsoft Store (موصى به)

بعد النشر، يمكن تثبيت التطبيق من صفحة Microsoft Store الخاصة به. يتولى Store توقيع حزمة MSIX وإدارة التوزيع والتحديثات. سيتم تحديد معرّف المنتج بعد إنشاء صفحة Partner Center.

### WinGet عبر Microsoft Store

بعد ظهور التطبيق في Store، يمكن التحقق من الحزمة نفسها وتثبيتها:

```powershell
winget search <Microsoft Store Product ID> --source msstore
winget install <Microsoft Store Product ID> --source msstore
```

### أتمتة إصدارات Windows

تقوم `Build and Draft Release` ببناء التطبيق وتشغيل اختبار الترجمة وإنشاء حزم MSIX غير الموقعة الجاهزة لـ Store وملفات ZIP محمولة و`SHA256SUMS.txt`. تعيد Microsoft توقيع MSIX بعد اعتماد Store، لذلك لا توجد حاجة إلى شهادة توقيع تجارية. النشر في Store معطّل افتراضياً ولا يُفعّل إلا بعد إعداد Partner Center وGitHub Secrets والتأكيد الصريح.

تعالج `Publish Microsoft Store Metadata` ملف `metadata/metadata.json` الذي راجعه المطور فقط. تتحقق `Verify WinGet Distribution` أولاً من توزيع Store، وعند الفشل تنشئ بياناً لمراجعة ملف GitHub ZIP المحمول، ولا ترسل Pull Request تلقائياً.

## 🏗️ بنية المشروع

يتبع AppDepot نمط **MVVM** ويستخدم حقن الاعتماديات عبر `Microsoft.Extensions.Hosting`. وتشمل المجلدات الرئيسية `Raven/Views` و`Raven/ViewModels` و`Raven/Services` و`Raven/Helpers` و`Raven/Models` و`Raven/Strings` و`Raven.Updater` والوحدة الفرعية `StoreListings`.

## 🧰 البناء من المصدر

يلزم توفر .NET 10 SDK وVisual Studio 2026 مع أحمال .NET Desktop Development وWindows App SDK/WinUI، بالإضافة إلى Windows 10 SDK (26100).

```bash
git clone --recurse-submodules https://github.com/sdf123098/AppDepot.git
cd AppDepot
dotnet build Raven.sln -c Debug -p:Platform=x64
dotnet run --project Raven -c Debug
```

إذا لم تُنسخ الوحدات الفرعية، شغّل `git submodule update --init --recursive`. البنى المدعومة هي `x64` و`x86` و`arm64`.

## 🤝 المساهمة

أنشئ Fork للمستودع وفرعاً مخصصاً لتغييرك، واتبع اصطلاحات MVVM وحقن الاعتماديات الحالية، واستخدم موارد `x:Uid` لترجمة نصوص XAML، ثم افتح Pull Request يتضمن خطوات التحقق.

## 📜 الترخيص

يتم توزيع AppDepot بموجب **Apache License 2.0**. راجع النص الكامل في ملف [LICENSE](LICENSE).

</div>
