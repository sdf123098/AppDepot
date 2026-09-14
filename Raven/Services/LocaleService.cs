using System.Globalization;
using StoreListings.Library;
using Raven.Contracts.Services;
using Raven.Helpers;

namespace Raven.Services;

public class LocaleService : ILocaleService
{
    private const string MarketSettingsKey = "AppMarket";
    private const string LanguageSettingsKey = "AppLanguage";
    private const string UiLanguageSettingsKey = "AppUiLanguage";

    private readonly ILocalSettingsService _localSettingsService;

    public Market Market { get; private set; } = Market.US;

    public Lang Language { get; private set; } = Lang.en;
    public string UiLanguageTag { get; private set; } = "en-US";

    public event EventHandler? LocaleChanged;

    public LocaleService(ILocalSettingsService localSettingsService)
    {
        _localSettingsService = localSettingsService;
    }

    public async Task InitializeAsync()
    {
        var savedMarket = await _localSettingsService.ReadSettingAsync<string>(MarketSettingsKey);
        var savedLang = await _localSettingsService.ReadSettingAsync<string>(LanguageSettingsKey);
        var savedUiLanguage = await _localSettingsService.ReadSettingAsync<string>(UiLanguageSettingsKey);

        var hasExistingSettings = savedMarket != null || savedLang != null;

        if (savedMarket != null && Enum.TryParse<Market>(savedMarket, out var market))
            Market = market;
        else if (!hasExistingSettings)
            Market = DetectMarketFromSystem();

        if (savedLang != null && Enum.TryParse<Lang>(savedLang, out var lang))
            Language = LanguageCatalog.Resolve(lang).Language;
        else if (!hasExistingSettings)
            Language = DetectLanguageFromSystem();

        var entry = savedUiLanguage != null ? LanguageCatalog.Resolve(savedUiLanguage)
            : !hasExistingSettings ? DetectUiLanguageFromSystem() : LanguageCatalog.Resolve(Language);
        Language = entry.Language;
        UiLanguageTag = entry.Tag;
        ApplyLanguageOverride();
    }

    public async Task SetMarketAsync(Market market)
    {
        Market = market;
        await _localSettingsService.SaveSettingAsync(MarketSettingsKey, market.ToString());
        ApplyLanguageOverride();
        LocaleChanged?.Invoke(this, EventArgs.Empty);
    }

    public async Task SetLanguageAsync(Lang language)
    {
        await SetUiLanguageAsync(LanguageCatalog.Resolve(language).Tag);
    }

    public async Task SetUiLanguageAsync(string languageTag)
    {
        var entry = LanguageCatalog.Resolve(languageTag);
        Language = entry.Language;
        UiLanguageTag = entry.Tag;
        await _localSettingsService.SaveSettingAsync(LanguageSettingsKey, Language.ToString());
        await _localSettingsService.SaveSettingAsync(UiLanguageSettingsKey, UiLanguageTag);
        ApplyLanguageOverride();
        LocaleChanged?.Invoke(this, EventArgs.Empty);
    }

    public async Task ResetToDefaultAsync()
    {
        Market = DetectMarketFromSystem();
        var entry = DetectUiLanguageFromSystem();
        Language = entry.Language;
        UiLanguageTag = entry.Tag;

        await _localSettingsService.SaveSettingAsync(MarketSettingsKey, Market.ToString());
        await _localSettingsService.SaveSettingAsync(LanguageSettingsKey, Language.ToString());
        await _localSettingsService.SaveSettingAsync(UiLanguageSettingsKey, UiLanguageTag);

        ApplyLanguageOverride();
        LocaleChanged?.Invoke(this, EventArgs.Empty);
    }

    /// <summary>
    /// Overrides the app's preferred language so WinUI 3's <c>ResourceLoader</c> loads the
    /// correct <c>Resources.resw</c> file. The UI resource language is deliberately independent
    /// from the Store market: changing the market must not change the app language. For
    /// languages with a shipped regional resource, use that stable resource tag; otherwise
    /// fall back to the PRI's default language (<c>en-US</c>).
    /// </summary>
    private void ApplyLanguageOverride()
    {
        try
        {
            Microsoft.Windows.Globalization.ApplicationLanguages.PrimaryLanguageOverride =
                UiLanguageTag;
            var culture = CultureInfo.GetCultureInfo(UiLanguageTag);
            CultureInfo.CurrentUICulture = culture;
            CultureInfo.DefaultThreadCurrentUICulture = culture;
        }
        catch { }
    }

    private static Market DetectMarketFromSystem()
    {
        try
        {
            var region = Windows.System.UserProfile.GlobalizationPreferences.HomeGeographicRegion;
            if (!string.IsNullOrEmpty(region) && Enum.TryParse<Market>(region, true, out var market))
                return market;
        }
        catch { }
        return Market.US;
    }

    private static Lang DetectLanguageFromSystem()
    {
        try
        {
            var languages = Windows.System.UserProfile.GlobalizationPreferences.Languages;
            if (languages?.Count > 0)
            {
                var tag = languages[0];
                var code = tag.Contains('-') ? tag.Split('-')[0].ToLowerInvariant() : tag.ToLowerInvariant();
                if (Enum.TryParse<Lang>(code, true, out var lang))
                    return LanguageCatalog.Resolve(lang).Language;
            }
        }
        catch { }
        return Lang.en;
    }

    private static LanguageCatalog.Entry DetectUiLanguageFromSystem()
    {
        try
        {
            var tag = Windows.System.UserProfile.GlobalizationPreferences.Languages.FirstOrDefault();
            if (tag != null) return LanguageCatalog.Resolve(tag);
        }
        catch { }
        return LanguageCatalog.Resolve(Lang.en);
    }
}
