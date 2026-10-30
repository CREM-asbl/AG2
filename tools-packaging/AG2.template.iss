; AG2 Inno Setup — genere par package-windows.ps1 (AppId fixe, lzma2/max, SignedUninstaller)
#define MyAppVersion "{{VERSION}}"
#define MyArch "{{ARCH}}"
#define SrcDir "{{SRCDIR}}"

[Setup]
AppId={{APPID}}
AppName=Apprenti Geometre 2
AppVersion={#MyAppVersion}
AppVerName=Apprenti Geometre 2 {#MyAppVersion} ({#MyArch})
AppPublisher=CREM
AppPublisherURL=https://www.crem.be
DefaultDirName={autopf}\CREM\AG2
DefaultGroupName=Apprenti Geometre 2
OutputDir={{OUTDIR}}
OutputBaseFilename=AG2-{#MyAppVersion}-windows-{#MyArch}
Compression=lzma2/max
SolidCompression=yes
SignedUninstaller=no
; Prod avec certificat: SignedUninstaller=yes + SignTool configure
ChangesAssociations=yes
ArchitecturesAllowed={#MyArch}
ArchitecturesInstallIn64BitMode={#MyArch}
WizardStyle=modern
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog

[Files]
Source: "{#SrcDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Apprenti Geometre 2"; Filename: "{app}\AG2.exe"
Name: "{autodesktop}\Apprenti Geometre 2"; Filename: "{app}\AG2.exe"; Tasks: desktopicon

[Tasks]
Name: desktopicon; Description: "Icone bureau"; GroupDescription: "Options:"

[Registry]
Root: HKLM64; Subkey: "Software\Classes\.fag"; ValueType: string; ValueName: ""; ValueData: "AG2.Figure"; Flags: uninsdeletekey; Check: IsAdminInstallMode
Root: HKCU; Subkey: "Software\Classes\.fag"; ValueType: string; ValueName: ""; ValueData: "AG2.Figure"; Flags: uninsdeletekey; Check: not IsAdminInstallMode
Root: HKLM64; Subkey: "Software\Classes\.hag"; ValueType: string; ValueName: ""; ValueData: "AG2.Historique"; Flags: uninsdeletekey; Check: IsAdminInstallMode
Root: HKCU; Subkey: "Software\Classes\.hag"; ValueType: string; ValueName: ""; ValueData: "AG2.Historique"; Flags: uninsdeletekey; Check: not IsAdminInstallMode
Root: HKLM64; Subkey: "Software\Classes\AG2.Figure\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\AG2.exe"" ""%1"""; Check: IsAdminInstallMode
Root: HKCU; Subkey: "Software\Classes\AG2.Figure\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\AG2.exe"" ""%1"""; Check: not IsAdminInstallMode
Root: HKLM64; Subkey: "Software\Classes\AG2.Historique\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\AG2.exe"" ""%1"""; Check: IsAdminInstallMode
Root: HKCU; Subkey: "Software\Classes\AG2.Historique\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\AG2.exe"" ""%1"""; Check: not IsAdminInstallMode
