using Microsoft.UI.Xaml;
using Raven.Helpers;
using Raven.Services;

namespace Raven.Views;

public sealed partial class AppPage
{
    private CancellationTokenSource? _translationCts;

    private async void TranslateDescription_Click(object sender, RoutedEventArgs e)
    {
        if (_translationCts != null || string.IsNullOrWhiteSpace(AppData?.Description)) return;
        using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(90));
        _translationCts = cts;
        TranslateDescriptionButton.IsEnabled = false;
        CancelTranslationButton.Visibility = Visibility.Visible;
        TranslationStatus.Text = "AI_Working".GetLocalized();
        try
        {
            var translated = await App.GetService<DescriptionTranslationService>()
                .TranslateAsync(AppData.Description, _localeService.UiLanguageTag, cts.Token);
            if (cts.IsCancellationRequested || _navigatedAway) return;
            TranslatedDescription.Text = translated;
            TranslatedDescription.Visibility = Visibility.Visible;
            OriginalDescription.Visibility = Visibility.Collapsed;
            ShowOriginalButton.Visibility = Visibility.Visible;
            TranslationStatus.Text = "";
        }
        catch (OperationCanceledException) { TranslationStatus.Text = ""; }
        catch (InvalidOperationException ex) when (ex.Message is "AI_NotConfigured" or "AI_InvalidSettings" or "AI_TooLong")
        { TranslationStatus.Text = ex.Message.GetLocalized(); }
        catch { TranslationStatus.Text = "AI_Failed".GetLocalized(); }
        finally
        {
            _translationCts = null;
            TranslateDescriptionButton.IsEnabled = true;
            CancelTranslationButton.Visibility = Visibility.Collapsed;
        }
    }

    private void CancelTranslation_Click(object sender, RoutedEventArgs e) => _translationCts?.Cancel();

    private void ShowOriginal_Click(object sender, RoutedEventArgs e)
    {
        TranslatedDescription.Visibility = Visibility.Collapsed;
        OriginalDescription.Visibility = Visibility.Visible;
        ShowOriginalButton.Visibility = Visibility.Collapsed;
    }
}
