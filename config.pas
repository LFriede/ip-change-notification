unit config;

interface

uses
  Vcl.Forms, System.Classes, System.RegularExpressions, System.SysUtils, System.IniFiles,
  Winapi.Windows, System.Win.Registry, System.Generics.Collections, Winapi.ShellAPI;

type
  TExternalTool = record
    Name:string;
    Path:string;
    Icon:HICON;
  end;
  PExternalTool = ^TExternalTool;

  TConfig = class
  private
    FConfigPath:string;
    FInitConfig:Boolean;
    procedure FreeToolIcons;
    procedure IniReadSectionOnlyValues(ini:TIniFile; section:string; results:TStrings);
    procedure IniWriteTools(ini:TIniFile);
    procedure IniWriteSectionOnlyValues(ini:TIniFile; section:string; values:TStrings);
  public
    FilterRegexes:TStringList;
    PopupTime:Integer;
    ConfiguredTools:TStringList;
    InstalledTools:TList<TExternalTool>;
    PWGenUpper, PWGenLower, PWGenNumbers, PWGenCustom, PWGenAlphanum:Boolean;
    PWGenChars:string;
    PWGenLength: Integer;
    constructor Create(filename:string);
    destructor Destroy; override;
    function TestInterfaceRegex(name:string):Boolean;
    procedure ResetDefaults;
    procedure SetTools(values:TStringList);
    procedure SaveConfig;
    property InitConfig:Boolean read FInitConfig;
  end;

const
  defaultPWChars = '°^!"§$%&/()=?²³{[]}@µ-_#+*\';

var
  globalConfig:TConfig;

implementation

constructor TConfig.Create(filename:string);
var
  ini:TIniFile;
  tmpTools:TStringList;
begin
  inherited Create;

  FConfigPath := filename;
  FilterRegexes := TStringList.Create;
  InstalledTools := TList<TExternalTool>.Create;
  ConfiguredTools := TStringList.Create;

  // Try to open config file. Set FInitConfig if the file doesn't exists.
  // Promt user for cfg if InitConfig is true
  FInitConfig := not FileExists(filename, false);
  if (FInitConfig) then begin
    ResetDefaults;
  end else begin
    ini := TIniFile.Create(filename);
    IniReadSectionOnlyValues(ini, 'FilterRegexes', FilterRegexes);
    PopupTime := ini.ReadInteger('Settings', 'PopupTime', 7000);
    tmpTools := TStringList.Create;
    ini.ReadSectionValues('ExternalTools', tmpTools);
    SetTools(tmpTools);
    tmpTools.Free;

    PWGenUpper := ini.ReadBool('PasswordGenerator', 'Upper', True);
    PWGenLower := ini.ReadBool('PasswordGenerator', 'Lower', True);
    PWGenNumbers := ini.ReadBool('PasswordGenerator', 'Numbers', True);
    PWGenCustom := ini.ReadBool('PasswordGenerator', 'Custom', True);
    PWGenAlphanum := ini.ReadBool('PasswordGenerator', 'Alphanum', False);
    PWGenChars := ini.ReadString('PasswordGenerator', 'Chars', defaultPWChars);
    PWGenLength := ini.ReadInteger('PasswordGenerator', 'Length', 10);
    if (PWGenLength < 1) then PWGenLength := 1;
    if (PWGenLength > 999) then PWGenLength := 999;

    ini.Free;
  end;
end;

destructor TConfig.Destroy;
begin
  FilterRegexes.Free;
  FreeToolIcons;
  InstalledTools.Free;
  ConfiguredTools.Free;

  inherited;
end;

procedure TConfig.FreeToolIcons;
var
  tool:TExternalTool;
begin
  for tool in InstalledTools do begin
    if (tool.Icon <> 0) then DestroyIcon(tool.Icon);
  end;
end;

procedure TConfig.IniReadSectionOnlyValues(ini: TIniFile; section: string; results: TStrings);
var
  strs:TStringList;
  s, s2:string;
begin
  strs := TStringList.Create;
  ini.ReadSection(section, strs);
  for s in strs do begin
    s2 := ini.ReadString(section, s, '');
    results.Add(s2);
  end;
  strs.Free;
end;

procedure TConfig.IniWriteTools(ini: TIniFile);
var
  val, name, tool:string;
begin
  ini.EraseSection('ExternalTools');

  for val in ConfiguredTools do begin
    name := Copy(val, 0, Pos('=', val)-1);
    tool := val;
    Delete(tool, 1, Pos('=', tool));

    ini.WriteString('ExternalTools', name, tool);
  end;
end;

procedure TConfig.IniWriteSectionOnlyValues(ini: TIniFile; section: string; values: TStrings);
var
  I:Integer;
begin
  ini.EraseSection(section);

  for I := 0 to values.Count-1 do begin
    ini.WriteString(section, section + IntToStr(I), values[I]);
  end;
end;

function TConfig.TestInterfaceRegex(name: string):Boolean;
var
  s:string;
begin
  Result := False;

  for s in FilterRegexes do begin
    if (TRegEx.IsMatch(name, s)) then begin
      Result := True;
      Exit;
    end;
  end;
end;

procedure TConfig.ResetDefaults;
var
  tmpTools:TStringList;
begin
  FilterRegexes.Clear;
  FilterRegexes.Add('LAN-Verbindung\* \d+');
  FilterRegexes.Add('Loopback Pseudo-Interface \d+');
  FilterRegexes.Add('VirtualBox Host-Only Network');
  FilterRegexes.Add('vEthernet \(.+\)');
  FilterRegexes.Add('LAN-Verbindung');
  FilterRegexes.Add('OpenVPN Connect DCO Adapter');

  tmpTools := TStringList.Create;
  tmpTools.AddPair('Wireshark', 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Wireshark\InstallLocation?Wireshark.exe');
  tmpTools.AddPair('NS Unified Web-MC', 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{541219A3-4BA3-4AC3-B645-DEDEC5A56973}\InstallLocation?KX-NS Unified Web Maintenance Console\launcher\WebMaintenance.exe');
  tmpTools.AddPair('PBX Unified MC', 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{1F507073-75D3-4900-9200-9973517FC57A}\InstallLocation?PBX Unified Maintenance Console\PBXUnified.exe');
  tmpTools.AddPair('Advanced IP Scanner', 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{CB67C185-D2DF-455E-B9B7-00C8E505186F}\InstallLocation?advanced_ip_scanner.exe');
  tmpTools.AddPair('LANconfig', 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\LANconfig\DisplayIcon');
  tmpTools.AddPair('LANmonitor', 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\LANmonitor\DisplayIcon');
  SetTools(tmpTools);
  tmpTools.Free;

  PopupTime := 7000;

  PWGenUpper := True;
  PWGenLower := True;
  PWGenNumbers := True;
  PWGenCustom := True;
  PWGenAlphanum := False;
  PWGenChars := defaultPWChars;
  PWGenLength := 10;
end;

procedure TConfig.SetTools(values:TStringList);
var
  I:Integer;
  reg:TRegistry;
  s, hkey, key, valuename, filename:string;
  tool:TExternalTool;
  icon:HICON;
begin
  FreeToolIcons;
  InstalledTools.Clear;
  reg := TRegistry.Create;

  ConfiguredTools.Clear;
  ConfiguredTools.AddStrings(values);

  for I := 0 to values.Count-1 do begin
    tool.Name := values.KeyNames[I];
    s := values.ValueFromIndex[I];

    // Seperate root key
    hkey := Copy(s, 0, Pos('\', s)-1);
    Delete(s, 1, Pos('\', s));

    // Seperate optional filename
    if (Pos('?', s) > 0) then begin
      filename := s.Substring(Pos('?', s));
      s := Copy(s, 0, Pos('?', s)-1);
    end else begin
      filename := '';
    end;

    // Seperate key / valuename
    key := Copy(s, 0, LastDelimiter('\', s)-1);
    Delete(s, 1, LastDelimiter('\', s));
    valuename := s;

    if (hkey = 'HKEY_LOCAL_MACHINE') then begin
      reg.RootKey := HKEY_LOCAL_MACHINE;
    end else begin
      if (hkey = 'HKEY_CURRENT_USER') then begin
        reg.RootKey := HKEY_CURRENT_USER;
      end else begin
        continue;
      end;
    end;

    if (reg.OpenKeyReadOnly(key)) then begin
      s := reg.ReadString(valuename);

      // Remove quotes
      if (Length(s) = 0) then continue;
      if (s[1] = '"') then Delete(s, 1, 1);
      if (s[Length(s)] = '"') then Delete(s, Length(s), 1);

      if (filename <> '') then begin
        if ((s[Length(s)] <> '\') and (s[Length(s)] <> '/')) then s := s + '\';
        s := s + filename;
      end;

      if (FileExists(s)) then begin
        tool.Path := s;

        icon := ExtractIcon(hInstance, PChar(tool.Path), 0);
        if (icon > 1) then begin
          tool.Icon := icon;
        end else begin
          tool.Icon := 0;
        end;

        InstalledTools.Add(tool);
      end;

      reg.CloseKey;
    end;
  end;

  reg.Free;
end;

procedure TConfig.SaveConfig;
var
  ini:TIniFile;
begin
  ini := TIniFile.Create(FConfigPath);
  try
    try
      iniWriteSectionOnlyValues(ini, 'FilterRegexes', FilterRegexes);
      ini.WriteInteger('Settings', 'PopupTime', PopupTime);
      IniWriteTools(ini);
      ini.WriteBool('PasswordGenerator', 'Upper', PWGenUpper);
      ini.WriteBool('PasswordGenerator', 'Lower', PWGenLower);
      ini.WriteBool('PasswordGenerator', 'Numbers', PWGenNumbers);
      ini.WriteBool('PasswordGenerator', 'Custom', PWGenCustom);
      ini.WriteBool('PasswordGenerator', 'Alphanum', PWGenAlphanum);
      ini.WriteString('PasswordGenerator', 'Chars', PWGenChars);
      ini.WriteInteger('PasswordGenerator', 'Length', PWGenLength);
    except
      on e: Exception do begin
        MessageBox(0, PChar(e.Message), 'Error saving config', MB_ICONERROR);
      end;
    end;
  finally
    Ini.Free;
  end;
end;

initialization

globalConfig := TConfig.Create(ExtractFilePath(Application.ExeName) + 'ip_notification.ini');

finalization

globalConfig.Free;

end.
