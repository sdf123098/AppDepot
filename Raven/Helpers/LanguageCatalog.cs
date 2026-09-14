using System.Globalization;
using System.Reflection;
using StoreListings.Library;

namespace Raven.Helpers;

/// <summary>Languages supplied by Strings/*/Resources.resw at build time.</summary>
public static class LanguageCatalog
{
    public sealed record Entry(Lang Language, string Tag, string NativeName);

    public static IReadOnlyList<Entry> Entries { get; } = Array.AsReadOnly(
        typeof(LanguageCatalog).Assembly.GetCustomAttributes<AssemblyMetadataAttribute>()
            .Where(a => a.Key == "Raven.LanguageDirectory")
            .Select(a => a.Value!.Split(new[] { '/', '\\' }, StringSplitOptions.RemoveEmptyEntries))
            .Where(parts => parts.Length >= 2)
            .Select(parts => parts[^2])
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .Select(TryCreate)
            .Where(e => e is not null)
            .Select(e => e!)
            .OrderBy(e => e.NativeName, StringComparer.OrdinalIgnoreCase)
            .ToArray());

    /// <summary>
    /// A language directory only becomes a selectable option when its tag is both a valid
    /// culture and one the Store API understands, so dropping in a file for an unsupported
    /// language hides it instead of crashing the catalog.
    /// </summary>
    private static Entry? TryCreate(string tag)
    {
        try
        {
            var culture = CultureInfo.GetCultureInfo(tag);
            if (!Enum.TryParse<Lang>(culture.TwoLetterISOLanguageName, true, out var language))
                return null;
            return new Entry(language, culture.Name, culture.NativeName);
        }
        catch (CultureNotFoundException) { return null; }
    }

    // Prefer the simplified tag for Chinese when only a language (not a region) is known,
    // matching the previous default for saved settings that predate UI-language tags.
    public static Entry Resolve(Lang language) =>
        Entries.FirstOrDefault(e => e.Language == language && e.Tag.Equals("zh-CN", StringComparison.OrdinalIgnoreCase))
        ?? Entries.FirstOrDefault(e => e.Language == language)
        ?? Entries.First(e => e.Language == Lang.en);

    public static Entry Resolve(string tag)
    {
        var exact = Entries.FirstOrDefault(e => e.Tag.Equals(tag, StringComparison.OrdinalIgnoreCase));
        if (exact != null) return exact;
        // Use the shared Traditional Chinese translation for Taiwan, Hong Kong and Macao.
        if (tag.StartsWith("zh", StringComparison.OrdinalIgnoreCase)
            && (tag.Contains("Hant", StringComparison.OrdinalIgnoreCase)
                || tag.EndsWith("-HK", StringComparison.OrdinalIgnoreCase)
                || tag.EndsWith("-MO", StringComparison.OrdinalIgnoreCase)
                || tag.EndsWith("-TW", StringComparison.OrdinalIgnoreCase)))
        {
            var traditional = Entries.FirstOrDefault(e => e.Tag == "zh-TW");
            if (traditional != null) return traditional;
        }
        return Enum.TryParse<Lang>(tag.Split('-')[0], true, out var language)
            ? Resolve(language) : Resolve(Lang.en);
    }
}
