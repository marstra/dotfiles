winget install -e --id Microsoft.VisualStudioCode --override '/SILENT /mergetasks="!runcode,addcontextmenufiles,addcontextmenufolders,addtopath"'
winget install -e --id Git.Git
winget install -e --id M2Team.NanaZip
winget install -e --id Microsoft.Office

set hackDownloadUrl "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Hack.zip"
Invoke-WebRequest $hackDownloadUrl -OutFile hack.zip
Expand-Archive -LiteralPath hack.zip -DestinationPath hack
cd hack
cp "HackNerdFontMono-Regular.ttf" C:\Windows\Fonts
cd ..
rm hack
rm hack.zip