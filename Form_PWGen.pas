unit Form_PWGen;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin, my_bcrypt, ClipBrd, config;

type
  TPWGenForm = class(TForm)
    edtOutput: TEdit;
    grpSettings: TGroupBox;
    cbLower: TCheckBox;
    cbUpper: TCheckBox;
    cbNumbers: TCheckBox;
    cbCustom: TCheckBox;
    edtCustomChars: TEdit;
    lblCharCount: TLabel;
    spnCount: TSpinEdit;
    btnGenerate: TButton;
    lblHint: TLabel;
    cbAlphanum: TCheckBox;
    procedure btnGenerateClick(Sender: TObject);
    procedure edtCustomCharsChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbClick(Sender: TObject);
    procedure cbAlphanumClick(Sender: TObject);
    procedure SaveSettings;
    procedure SetAlphanumState;
  private
    { Private-Deklarationen }
    FSettingsChanged:Boolean;
  public
    { Public-Deklarationen }
  end;

const
  BCRYPT_USE_SYSTEM_PREFERRED_RNG = $00000002;
  STATUS_SUCCESS = 0;

var
  PWGenForm: TPWGenForm;

implementation

{$R *.dfm}

procedure TPWGenForm.btnGenerateClick(Sender: TObject);
var
  charSet, res:string;
  b:Array Of Byte;
  len, I, len2:Integer;
begin
  charSet := '';
  res := '';

  // Seperate alphanum checkboxes can be disabled by cbAlphanum and should not
  // be used if they are.
  if (cbLower.Checked and cbLower.Enabled) then charSet := charSet + 'abcdefghijklmnopqrstuvwxyz';
  if (cbUpper.Checked and cbUpper.Enabled) then charSet := charSet + 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  if (cbNumbers.Checked and cbNumbers.Enabled) then charSet := charSet + '0123456789';

  if (cbAlphanum.Checked) then begin
    charSet := charSet +
      'abcdefghijkmnopqrstuvwxyz' + // Without lowercase L
      'ABCDEFGHJKLMNPQRSTUVWXYZ'  + // Without uppercase i and o
      '123456789';                  // Without zero
  end;

  if cbCustom.Checked then charSet := charSet + edtCustomChars.Text;

  if (Length(charSet) = 0) then begin
    MessageBox(Handle, 'Please select a charset.', 'Meh...', MB_OK OR MB_ICONERROR);
    Exit;
  end;

  len := spnCount.Value;
  SetLength(b, len);
  if (BCryptGenRandom(nil, @b[0], len, BCRYPT_USE_SYSTEM_PREFERRED_RNG) <> STATUS_SUCCESS) then begin
    Exit;
  end;

  len2 := Length(charSet);
  for I := 0 to len-1 do begin
    res := res + charSet[(b[I] mod len2) + 1];
  end;

  edtOutput.Text := res;
  Clipboard.AsText := res;

  // Save settings if changed
  if (FSettingsChanged) then SaveSettings;
end;

procedure TPWGenForm.cbAlphanumClick(Sender: TObject);
begin
  SetAlphanumState;

  FSettingsChanged := True;
end;

procedure TPWGenForm.cbClick(Sender: TObject);
begin
  FSettingsChanged := True;
end;

procedure TPWGenForm.edtCustomCharsChange(Sender: TObject);
begin
  cbCustom.Checked := Length(edtCustomChars.Text) > 0;
  FSettingsChanged := True;
end;

procedure TPWGenForm.FormShow(Sender: TObject);
begin
  cbLower.Checked := globalconfig.PWGenLower;
  cbUpper.Checked := globalconfig.PWGenUpper;
  cbNumbers.Checked := globalconfig.PWGenNumbers;
  cbCustom.Checked := globalconfig.PWGenCustom;
  cbAlphanum.Checked := globalconfig.PWGenAlphanum;
  SetAlphanumState;
  edtCustomChars.Text := globalconfig.PWGenChars;
  FSettingsChanged := False;
end;

procedure TPWGenForm.SaveSettings;
begin
  globalconfig.PWGenLower := cbLower.Checked;
  globalconfig.PWGenUpper := cbUpper.Checked;
  globalconfig.PWGenNumbers := cbNumbers.Checked;
  globalconfig.PWGenCustom := cbCustom.Checked;
  globalconfig.PWGenAlphanum := cbAlphanum.Checked;
  globalconfig.PWGenChars := edtCustomChars.Text;

  globalconfig.SaveConfig;
end;

// Sets enabled state on other checkboxes depeding on alphanum checkbox state.
// Should be executed on click or after changing checkbox manually (settings load)
procedure TPWGenForm.SetAlphanumState;
var
  flag: Boolean;
begin
  flag := not cbAlphanum.Checked;

  cbLower.Enabled := flag;
  cbUpper.Enabled := flag;
  cbNumbers.Enabled := flag;
end;

end.
