using Microsoft.UI.Xaml;
using Raven.Helpers;
using Raven.Services;

namespace Raven.Views;

public sealed partial class SettingsPage
{
    private async void TranslationSettings_Loaded(object sender, RoutedEventArgs e)
    {
        try
        {
            var service = App.GetService<DescriptionTranslationService>();
            var settings = await service.LoadAsync();
            TranslationEndpoint.Text = settings.Endpoint;
            TranslationModel.Text = settings.Model;
            TranslationInstructions.Text = settings.Instructions;
            TranslationKey.Password = service.LoadApiKey();
            TranslationSave.IsEnabled = true;
        }
        catch { TranslationSettingsStatus.Text = "AI_Failed".GetLocalized(); }
    }

    private async void TranslationSave_Click(object sender, RoutedEventArgs e)
    {
        TranslationSave.IsEnabled = false;
        try
        {
            await App.GetService<DescriptionTranslationService>().SaveAsync(
                new(TranslationEndpoint.Text.Trim(), TranslationModel.Text.Trim(), TranslationInstructions.Text),
                TranslationKey.Password);
            TranslationSettingsStatus.Text = "AI_Saved".GetLocalized();
        }
        catch (InvalidOperationException ex) when (ex.Message == "AI_InvalidSettings")
        { TranslationSettingsStatus.Text = ex.Message.GetLocalized(); }
        catch { TranslationSettingsStatus.Text = "AI_Failed".GetLocalized(); }
        finally { TranslationSave.IsEnabled = true; }
    }
}
