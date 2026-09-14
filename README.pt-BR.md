# AppDepot

<p align="center"><b>Cliente nativo e de código aberto da Microsoft Store para Windows</b></p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.zh-TW.md">繁體中文</a> · <a href="README.ja-JP.md">日本語</a> · <a href="README.ko-KR.md">한국어</a> · <a href="README.de-DE.md">Deutsch</a> · <a href="README.es-ES.md">Español</a> · <a href="README.fr-FR.md">Français</a> · <a href="README.pt-BR.md">Português</a> · <a href="README.ru-RU.md">Русский</a> · <a href="README.hu-HU.md">Magyar</a> · <a href="README.ar-SA.md">العربية</a>
</p>

O AppDepot é um aplicativo moderno para Windows que permite descobrir, baixar, instalar, exportar e atualizar aplicativos da Microsoft Store. Ele também oferece sideload de pacotes UWP/MSIX externos e atualizações diferenciais por blocos para economizar banda.

Criado com **WinUI 3** e **.NET 10**, o aplicativo tem uma interface Fluent projetada para o Windows 10 e o Windows 11.

<img width="996" height="543" alt="Página inicial do AppDepot" src="docs/screenshots/home.png" />

## 🖼️ Capturas de tela

<p><img width="700" alt="Página inicial do AppDepot" src="docs/screenshots/home.png" /></p>
<p><img width="700" alt="Menu de navegação da pesquisa avançada" src="docs/screenshots/advanced-search-menu.png" /></p>
<p><img width="700" alt="Página de pesquisa avançada" src="docs/screenshots/advanced-search.png" /></p>
<p><img width="700" alt="Configurações do AppDepot" src="docs/screenshots/settings.png" /></p>

## ✨ Recursos

### 🔍 Descoberta e pesquisa

- Navegue pelas recomendações da Microsoft Store, como os aplicativos **Top Free**.
- Pesquise pela barra de título com sugestões, ícones e títulos em tempo real.
- Use a **Advanced Search** com URL da Store, ID do produto ou nome da família de pacotes.
- Abra páginas detalhadas com descrição, capturas de tela, versões e dependências.
- Escolha o mercado e o idioma da Store separadamente nas configurações.

### ⬇️ Download e exportação

- Baixe pacotes da Store diretamente da CDN da Microsoft.
- Use downloads diferenciais baseados em BlockMap para baixar apenas blocos alterados quando possível.
- Exporte pacotes `.appx`, `.msix`, `.appxbundle` e `.msixbundle` para backup ou uso offline.
- Gerencie a fila com progresso, pausa e retomada.

### 📦 Instalação e sideload

- Instale pacotes baixados diretamente pelo AppDepot.
- Instale pacotes locais pelo seletor de arquivos ou arrastando e soltando.
- Detecte e instale automaticamente as dependências de framework necessárias.
- Force a reinstalação ou o downgrade quando já houver uma versão mais recente.

### 🔄 Atualizações

- Compare pacotes assinados pela Store com as versões mais recentes disponíveis.
- Aplique atualizações diferenciais para reduzir o tamanho dos downloads.
- Atualize tudo em lote ou escolha aplicativos individuais.
- Compare versões por arquitetura e build do Windows.

### ⚙️ Experiência no desktop

- Duas opções de distribuição: uma versão portátil sem instalação, executada como `.exe` independente, e uma versão da Microsoft Store, instalada e atualizada pela Store.
- Use os temas claro, escuro ou padrão do sistema.
- Escolha o ícone do AppDepot, o ícone de coruja incluído ou um arquivo `.ico` local.
- Use uma interface localizada por arquivos de recursos.
- Consulte separadamente os logs de execução, instalação e falhas.
- Verifique atualizações do AppDepot no GitHub.

## 🌐 Idiomas disponíveis

O aplicativo inclui inglês, árabe, alemão, espanhol, francês, húngaro, japonês, coreano, português do Brasil, russo, chinês simplificado e chinês tradicional.

## 🛑 Requisitos do sistema

- Windows 10 versão 2004, build 19041 ou posterior
- [.NET 10](https://dotnet.microsoft.com/en-us/download/dotnet/10.0), exceto em uma versão autocontida
- [Windows App SDK Runtime](https://learn.microsoft.com/en-us/windows/apps/windows-app-sdk/downloads#windows-app-sdk), exceto em uma versão autocontida

## 🚀 Instalação e execução

Baixe em [Releases](https://github.com/sdf123098/AppDepot/releases) o ZIP para `x64`, `x86` ou `arm64`, extraia-o e execute `AppDepot.exe`. Para uma versão portátil, use `*-self-contained.zip`.

Como alternativa, instale o [WinGet](https://learn.microsoft.com/en-us/windows/package-manager/winget/) e execute:

```powershell
winget install sdf123098.AppDepot
```

Se o Windows ou o antivírus acusar um falso positivo, baixe `raven_cert.zip` nas Releases, instale `raven.cer` ou execute `install_raven_cert.bat`.

[Ver o guia em vídeo do AppDepot](https://www.youtube.com/watch?v=ZX__BaD6kr0)

### Microsoft Store (recomendado)

Após a publicação, instale o aplicativo pela página da Microsoft Store. A Store assina o pacote MSIX e gerencia a distribuição e as atualizações. O Product ID será definido quando o cadastro no Partner Center existir.

### WinGet pela Microsoft Store

Quando a listagem da Store estiver disponível, verifique e instale o mesmo pacote:

```powershell
winget search <Microsoft Store Product ID> --source msstore
winget install <Microsoft Store Product ID> --source msstore
```

### Automação de releases do Windows

O workflow `Build and Draft Release` compila o aplicativo, executa o teste de localização, cria MSIX prontos para a Store sem assinatura, ZIPs portáteis e `SHA256SUMS.txt`. A Microsoft assina novamente os MSIX após a certificação da Store; não é necessário certificado comercial. A publicação na Store fica desativada por padrão e só é ativada depois da configuração do Partner Center, dos GitHub Secrets e de uma confirmação explícita.

`Publish Microsoft Store Metadata` processa apenas um `metadata/metadata.json` revisado por um desenvolvedor. `Verify WinGet Distribution` testa primeiro a distribuição pela Store e, se falhar, gera um manifesto comunitário do ZIP portátil do GitHub para revisão; não envia Pull Requests automaticamente.

## 🏗️ Estrutura do projeto

O AppDepot segue o padrão **MVVM** e usa injeção de dependências por meio de `Microsoft.Extensions.Hosting`. As áreas principais são `Raven/Views`, `Raven/ViewModels`, `Raven/Services`, `Raven/Helpers`, `Raven/Models`, `Raven/Strings`, `Raven.Updater` e o submódulo `StoreListings`.

## 🧰 Compilação a partir do código-fonte

São necessários o .NET 10 SDK, o Visual Studio 2026 com as cargas .NET Desktop Development e Windows App SDK/WinUI e o Windows 10 SDK (26100).

```bash
git clone --recurse-submodules https://github.com/sdf123098/AppDepot.git
cd AppDepot
dotnet build Raven.sln -c Debug -p:Platform=x64
dotnet run --project Raven -c Debug
```

Se os submódulos não tiverem sido clonados, execute `git submodule update --init --recursive`. As arquiteturas `x64`, `x86` e `arm64` são compatíveis.

## 🤝 Contribuição

Faça um fork, crie uma branch específica, siga as convenções existentes de MVVM e injeção de dependências, localize os textos XAML usando recursos `x:Uid` e abra um Pull Request com as etapas de validação.

## 📜 Licença

O AppDepot é distribuído sob a **Apache License 2.0**. Consulte o texto completo em [LICENSE](LICENSE).
