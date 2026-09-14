using Microsoft.Extensions.Options;
using Raven.Contracts.Services;
using Raven.Models;

namespace Raven.Services;

/// <summary>
/// Owns the AppDepot icon choice and keeps it available to the window and title bar.
/// Window icons must be ICO files, so user-provided icons are intentionally filtered to
/// that format by the settings picker.
/// </summary>
public sealed class AppIconService
{
    public const string DefaultIconFileName = "AppDepot.ico";
    public const string OwlIconFileName = "AppDepot-Owl.ico";

    private const string IconChoiceKey = "AppIconChoice";
    private const string DefaultChoice = "default";
    private const string OwlChoice = "owl";
    private const string CustomChoice = "custom";

    private readonly ILocalSettingsService _localSettingsService;
    private readonly string _applicationDataDirectory;

    public AppIconService(
        ILocalSettingsService localSettingsService,
        IOptions<LocalSettingsOptions> options
    )
    {
        _localSettingsService = localSettingsService;

        var localAppData = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
        var configuredFolder = options.Value.ApplicationDataFolder ?? "AppDepot/ApplicationData";
        _applicationDataDirectory = Path.Combine(localAppData, configuredFolder);
        CurrentIconPath = GetBuiltInIconPath(DefaultIconFileName);
    }

    public string CurrentIconPath { get; private set; }

    public string CustomIconPath => Path.Combine(_applicationDataDirectory, "CustomAppIcon.ico");

    public event EventHandler? IconChanged;

    public async Task InitializeAsync()
    {
        var choice = await _localSettingsService.ReadSettingAsync<string>(IconChoiceKey);
        var iconPath = choice?.ToLowerInvariant() switch
        {
            OwlChoice => GetBuiltInIconPath(OwlIconFileName),
            CustomChoice when File.Exists(CustomIconPath) => CustomIconPath,
            _ => GetBuiltInIconPath(DefaultIconFileName),
        };

        ApplyIcon(iconPath);
    }

    public Task UseDefaultIconAsync() => UseBuiltInIconAsync(DefaultIconFileName, DefaultChoice);

    public Task UseOwlIconAsync() => UseBuiltInIconAsync(OwlIconFileName, OwlChoice);

    public async Task<bool> SetCustomIconAsync(string sourcePath)
    {
        if (!IsValidIconFile(sourcePath)
            || !string.Equals(Path.GetExtension(sourcePath), ".ico", StringComparison.OrdinalIgnoreCase))
        {
            return false;
        }

        Directory.CreateDirectory(_applicationDataDirectory);

        var temporaryPath = Path.Combine(
            _applicationDataDirectory,
            $"CustomAppIcon.{Guid.NewGuid():N}.tmp"
        );

        try
        {
            File.Copy(sourcePath, temporaryPath, overwrite: true);
            File.Move(temporaryPath, CustomIconPath, overwrite: true);
            await _localSettingsService.SaveSettingAsync(IconChoiceKey, CustomChoice);
            ApplyIcon(CustomIconPath);
            return true;
        }
        finally
        {
            try
            {
                if (File.Exists(temporaryPath))
                    File.Delete(temporaryPath);
            }
            catch
            {
                // The completed custom icon remains usable even if cleanup fails.
            }
        }
    }

    public static string GetBuiltInIconPath(string fileName) =>
        Path.Combine(AppContext.BaseDirectory, "Assets", fileName);

    private async Task UseBuiltInIconAsync(string fileName, string choice)
    {
        await _localSettingsService.SaveSettingAsync(IconChoiceKey, choice);
        ApplyIcon(GetBuiltInIconPath(fileName));
    }

    private void ApplyIcon(string iconPath)
    {
        if (!File.Exists(iconPath))
            iconPath = GetBuiltInIconPath(DefaultIconFileName);

        CurrentIconPath = iconPath;

        if (App.MainWindow is { } mainWindow)
        {
            try
            {
                mainWindow.AppWindow.SetIcon(iconPath);
            }
            catch
            {
                // Keep the previous window icon if a malformed custom ICO is selected.
            }
        }

        IconChanged?.Invoke(this, EventArgs.Empty);
    }

    private static bool IsValidIconFile(string path)
    {
        try
        {
            using var stream = File.OpenRead(path);
            Span<byte> header = stackalloc byte[6];
            if (stream.Read(header) != header.Length)
                return false;

            return header[0] == 0
                && header[1] == 0
                && header[2] == 1
                && header[3] == 0
                && header[4] != 0
                && header[5] != 0;
        }
        catch
        {
            return false;
        }
    }
}
