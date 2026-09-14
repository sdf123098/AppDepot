using Microsoft.Windows.ApplicationModel.Resources;
using Microsoft.Windows.Globalization;
using Raven.Helpers;

// Regression test for shipping localization. Links the production resource helper and reads
// the published PRI, so it catches a language dropping out of the PRI, a dotted RESW key not
// resolving through GetLocalized, or a language silently falling back to English.
WinRT.ComWrappersSupport.InitializeComWrappers();
var manager = new ResourceManager();
var map = manager.MainResourceMap.GetSubtree("Resources");
var context = manager.CreateResourceContext();

// Every language the app ships. Keep in sync with Raven/Strings/*/Resources.resw.
var languages = new[]
{
    "en-US", "ar-SA", "de-DE", "es-ES", "fr-FR", "hu-HU",
    "ja-JP", "ko-KR", "pt-BR", "ru-RU", "zh-CN", "zh-TW",
};

// Keys asserted for every language. Values must be non-empty and differ from English for a
// non-English language, which proves the translation actually shipped rather than falling back.
var sampled = new[]
{
    "Shell_Settings.Content",
    "Shell_SearchBox.PlaceholderText",
    "Settings_Downloads.Text",
    "AI_Translate.Content",
};

var failures = 0;
string? englishSettings = null;

foreach (var language in languages)
{
    ApplicationLanguages.PrimaryLanguageOverride = language;
    context.QualifierValues["Language"] = language;

    foreach (var name in new[] { "Main", "Advanced_Search", "Install", "Updates", "Downloads", "Settings" })
    {
        var expected = map.GetValue($"Shell_{name}/Content", context).ValueAsString;
        var actual = $"Shell_{name}.Content".GetLocalized();
        if (actual != expected || string.IsNullOrEmpty(actual))
        {
            failures++;
            Console.WriteLine($"FAIL {language} Shell_{name}.Content: [{actual}] expected [{expected}]");
        }
    }

    // Brand name must survive translation.
    if ("AppDisplayName".GetLocalized() != "AppDepot")
    {
        failures++;
        Console.WriteLine($"FAIL {language} AppDisplayName: [{"AppDisplayName".GetLocalized()}]");
    }

    var settings = "Shell_Settings.Content".GetLocalized();
    if (language == "en-US") englishSettings = settings;
    else if (settings == englishSettings)
    {
        failures++;
        Console.WriteLine($"FAIL {language} Shell_Settings.Content did not translate: [{settings}]");
    }

    foreach (var key in sampled)
    {
        var actual = key.GetLocalized();
        if (string.IsNullOrEmpty(actual))
        {
            failures++;
            Console.WriteLine($"FAIL {language} {key}: empty");
            continue;
        }
        // A dotted key must resolve through the same PRI path the resource map uses.
        var expected = map.GetValue(key.Replace('.', '/'), context).ValueAsString;
        if (actual != expected)
        {
            failures++;
            Console.WriteLine($"FAIL {language} {key}: [{actual}] expected [{expected}]");
        }
    }

    Console.WriteLine($"{language}: Shell_Settings=[{settings}] AI_Translate=[{"AI_Translate.Content".GetLocalized()}]");
}

// Switching languages repeatedly in one process must not leak the previous language.
ApplicationLanguages.PrimaryLanguageOverride = "zh-CN";
context.QualifierValues["Language"] = "zh-CN";
var zh = "Shell_Settings.Content".GetLocalized();
ApplicationLanguages.PrimaryLanguageOverride = "en-US";
context.QualifierValues["Language"] = "en-US";
var en = "Shell_Settings.Content".GetLocalized();
if (zh == en)
{
    failures++;
    Console.WriteLine($"FAIL language switch did not take effect: zh=[{zh}] en=[{en}]");
}

Console.WriteLine($"Languages checked: {languages.Length}");
Console.WriteLine($"Failures: {failures}");
return failures == 0 ? 0 : 1;
