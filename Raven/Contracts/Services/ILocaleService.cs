using StoreListings.Library;

namespace Raven.Contracts.Services;

public interface ILocaleService
{
    Market Market { get; }

    Lang Language { get; }
    string UiLanguageTag { get; }

    event EventHandler? LocaleChanged;

    Task InitializeAsync();

    Task SetMarketAsync(Market market);

    Task SetLanguageAsync(Lang language);
    Task SetUiLanguageAsync(string languageTag);

    Task ResetToDefaultAsync();
}
