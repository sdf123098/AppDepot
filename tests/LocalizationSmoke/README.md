Run on Windows with the same .NET and Windows App SDK runtimes as Raven.
Publish Raven first, then point the regression runner at the publish directory:

```powershell
dotnet run --project tests/LocalizationSmoke/LocalizationSmoke.csproj -p:RavenPublishDir=D:/path/to/publish
```

The runner links the production resource helper and reads the published PRI.

For every language in `Raven/Strings/*/Resources.resw` it checks that the six
sidebar labels resolve to the PRI value, that the brand name is untranslated,
and that sampled keys (`Shell_Settings.Content`, `Shell_SearchBox.PlaceholderText`,
`Settings_Downloads.Text`, `AI_Translate.Content`) are non-empty, equal to the
raw PRI lookup, and different from English. That last check is what catches a
language silently falling back to English instead of shipping. It finishes by
confirming that switching languages repeatedly in one process actually changes
the output.

A failed assertion returns a nonzero exit code. If you add a language, add its
tag to the `languages` array in `Program.cs`; no translated expectation needs to
be hardcoded, because the runner derives "translated" by comparing against the
English value.
