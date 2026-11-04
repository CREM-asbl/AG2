; Template AG2 - Inno Setup 6 (aligne origine Builds - AG/tools)
; Usage: ISCC.exe /DMyAppVersion=2.7.2 /DMyAppArch=x64 /DSrcDir="..." /DOutDir="..." /DLogoIco="..." AG2.template.iss
#ifndef MyAppVersion
  #define MyAppVersion "2.7.2"
#endif
#ifndef MyAppArch
  #define MyAppArch "x64"
#endif
#ifndef SrcDir
  #define SrcDir "."
#endif
#ifndef OutDir
  #define OutDir "."
#endif
#ifndef LogoIco
  #define LogoIco "LogoAG.ico"
#endif
#ifndef AppBaseName
  #if MyAppArch == "x86"
    #define AppBaseName "AG2-" + MyAppVersion + "-windows-x86"
  #else
    #define AppBaseName "AG2-" + MyAppVersion + "-windows-x64"
  #endif
#endif

[Setup]
AppName=Apprenti Geometre 2
AppVerName=Apprenti Geometre 2 {#MyAppVersion} ({#MyAppArch})
AppPublisher=CREM asbl
AppPublisherURL=https://www.crem.be/
AppSupportURL=https://www.crem.be/
AppUpdatesURL=https://www.crem.be/
DefaultDirName={pf}\Apprenti Geometre 2
DefaultGroupName=Apprenti Geometre 2
OutputDir={#OutDir}
OutputBaseFilename={#AppBaseName}
Compression=lzma2/max
SolidCompression=yes
SignedUninstaller=no
AppCopyright=CREM
AppVersion={#MyAppVersion}
LicenseFile={#SrcDir}\COPY.rtf
SetupIconFile={#LogoIco}
UninstallDisplayIcon={app}\AG2.exe
ChangesAssociations=yes
WizardStyle=modern
PrivilegesRequired=admin

[Languages]
Name: english; MessagesFile: compiler:Default.isl
Name: french; MessagesFile: compiler:Languages\French.isl
Name: dutch; MessagesFile: compiler:Languages\Dutch.isl
Name: german; MessagesFile: compiler:Languages\German.isl
Name: spanish; MessagesFile: compiler:Languages\Spanish.isl
Name: italian; MessagesFile: compiler:Languages\Italian.isl
Name: portuguese; MessagesFile: compiler:Languages\Portuguese.isl

[Tasks]
Name: desktopicon; Description: {cm:CreateDesktopIcon}; GroupDescription: {cm:AdditionalIcons}; Flags: unchecked

[Files]
Source: {#SrcDir}\*; DestDir: {app}; Flags: recursesubdirs

[Icons]
Name: {group}\Apprenti Geometre 2; Filename: {app}\AG2.exe
Name: {group}\{cm:UninstallProgram,Apprenti Geometre 2}; Filename: {uninstallexe}
Name: {commondesktop}\Apprenti Geometre 2; Filename: {app}\AG2.exe; Tasks: desktopicon

[Run]
Filename: {app}\AG2.exe; Description: {cm:LaunchProgram,Apprenti Geometre 2}; Flags: nowait postinstall skipifsilent

[Registry]
Root: HKLM; Subkey: SOFTWARE\AG; ValueType: string; ValueName: path; ValueData: {uninstallexe}; Flags: createvalueifdoesntexist uninsdeletekey
Root: HKCR; Subkey: AG.CREM; ValueType: string; ValueData: Apprenti geometre 2; Flags: createvalueifdoesntexist uninsdeletekey
Root: HKCR; Subkey: AG.CREM\DefaultIcon; ValueType: string; ValueData: {app}\AG2.exe,0; Flags: createvalueifdoesntexist uninsdeletekey
Root: HKCR; Subkey: AG.CREM\shell\open\command; ValueType: string; ValueData: """{app}\AG2.exe"" ""%1"""; Flags: createvalueifdoesntexist uninsdeletekey
Root: HKCR; Subkey: .fag; ValueType: string; ValueData: AG.CREM; Flags: createvalueifdoesntexist uninsdeletekey
Root: HKCR; Subkey: .hag; ValueType: string; ValueData: AG.CREM; Flags: createvalueifdoesntexist uninsdeletekey

[Code]
const
  OldVersionRegKey = 'Software\AG';
var
  HasOldVersion: Boolean;
  Path: String;
  ResultCode: Integer;
function InitializeSetup(): Boolean;
begin
  HasOldVersion := RegKeyExists(HKLM, OldVersionRegKey);
  if HasOldVersion then
  begin
    if RegQueryStringValue(HKEY_LOCAL_MACHINE, OldVersionRegKey, 'path', Path) = true then
    begin
      MsgBox('Desinstallation de la version precedente', mbInformation, MB_OK);
      Exec(ExpandConstant(Path), '/SILENT', '', SW_SHOW, ewWaitUntilTerminated, ResultCode);
      Result := True;
    end else begin
      MsgBox('Impossible de desinstaller la version precedente', mbInformation, MB_OK);
      Result := False;
    end;
  end else Result := True;
end;