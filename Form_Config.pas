unit Form_Config;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, config,
  Vcl.Samples.Spin, ShlObj, Winapi.KnownFolders, ActiveX;

type
  TConfigForm = class(TForm)
    memoFilter: TMemo;
    grpFilter: TGroupBox;
    lblFilter: TLabel;
    btnSave: TButton;
    btnDefault: TButton;
    lblPopupTime: TLabel;
    spnPopupTime: TSpinEdit;
    grpTools: TGroupBox;
    memoTools: TMemo;
    lblTools: TLabel;
    btnAutostart: TButton;
    procedure FormShow(Sender: TObject);
    procedure LoadCfgValues;
    procedure btnDefaultClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnAutostartClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  ConfigForm: TConfigForm;

implementation

uses
  Unit1;

{$R *.dfm}

function CreateShellLink(LinkPath, StorePath:string):Boolean;
var
 psl:IShellLink;
 ppf:IPersistFile;
begin
  Result := False;

  if Succeeded(CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_inPROC_SERVER, IID_IShellLinkW, psl)) then begin
    psl.SetPath(PWideChar(LinkPath));
    psl.SetWorkingDirectory(PWideChar(ExtractFilePath(LinkPath)));

    if Succeeded(psl.QueryInterface(IPersistFile, ppf)) then begin
      ppf.Save(PWideChar(StorePath), True);
      Result := True;
    end;
  end;
end;

procedure TConfigForm.btnAutostartClick(Sender: TObject);
var
  startmenu:PWideChar;
  path:string;
  res:Integer;
begin
  res := MessageBox(
    Handle,
    'This will create a *.lnk file to this executable in the "Start Menu\Startup" folder. Delete the link manually to disable autostart.',
    'Continue?',
    MB_ICONQUESTION OR MB_YESNO
  );
  if (res = IDNO) then Exit;


  // Find autostart directory and create link
  path := '';
  if (SHGetKnownFolderPath(FOLDERID_StartMenu, 0, 0, startmenu) = S_OK) then begin
    path := startmenu;
    CoTaskMemFree(startmenu);

    path := path + '\Programs\Startup\ip_notification.lnk';
    if (CreateShellLink(Application.ExeName, path) = False) then begin
      MessageBox(Handle, 'Error at creating *.lnk file!', 'Error', MB_ICONERROR OR MB_OK);
    end;
  end;
end;

procedure TConfigForm.btnDefaultClick(Sender: TObject);
begin
  globalconfig.ResetDefaults;
  LoadCfgValues;
end;

procedure TConfigForm.btnSaveClick(Sender: TObject);
var
  tmpTools:TStringList;
begin
  globalConfig.FilterRegexes.SetStrings(memoFilter.Lines);
  globalConfig.PopupTime := spnPopupTime.Value;

  tmpTools := TStringList.Create;
  tmpTools.SetStrings(memoTools.Lines);
  globalConfig.SetTools(tmpTools);
  tmpTools.Free;

  globalConfig.SaveConfig;

  // Reload tools and connection properties in tray menu
  Form1.ReloadTools;
  Form1.ReloadConnectionProperties;

  Close;
end;

procedure TConfigForm.FormShow(Sender: TObject);
begin
  LoadCfgValues;
end;

procedure TConfigForm.LoadCfgValues;
begin
  memoFilter.Lines := globalConfig.FilterRegexes;
  spnPopupTime.Value := globalConfig.PopupTime;

  memoTools.Clear;
  memoTools.Lines.AddStrings(globalConfig.ConfiguredTools);
end;

end.
