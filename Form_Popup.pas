unit Form_Popup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Math, config;

type
  TPopupForm = class(TForm)
    ContentLabel: TLabel;
    PopupTimer: TTimer;
    TitleLabel: TLabel;
    procedure PopupTimerTimer(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    FBorderColor:TColor;
    FDarkMode:Boolean;
    FShown:Boolean;
    procedure DoPopup;
    procedure SetDarkMode(Dark:Boolean);
  public
    { Public-Deklarationen }
    property DarkMode:Boolean read FDarkMode write SetDarkMode;
    procedure Popup(title, hint:string);
    procedure ShowAgain;
  end;

var
  PopupForm: TPopupForm;

implementation

{$R *.dfm}

procedure TPopupForm.DoPopup;
begin
  FShown := True;

  PopupTimer.Interval := globalconfig.PopupTime;

  Show;
  PopupTimer.Enabled := False; // Resets the Timer if enabled
  PopupTimer.Enabled := True;
end;

procedure TPopupForm.FormCreate(Sender: TObject);
begin
  DarkMode := False;
  FShown := False;
end;

procedure TPopupForm.FormPaint(Sender: TObject);
begin
  Canvas.Pen.Color := FBorderColor;
  Canvas.Rectangle(0, 0, Width, Height);
end;

procedure TPopupForm.FormResize(Sender: TObject);
begin
  // Workaround for incomplete border if window is resized while visible
  Repaint;
end;

procedure TPopupForm.Popup(title, hint: string);
begin
  ContentLabel.Caption := hint;
  TitleLabel.Caption := title;

  Width := Max(ContentLabel.Width, TitleLabel.Width) + 16;
  Height := TitleLabel.Height + ContentLabel.Height + 20;
  Left := Screen.WorkAreaWidth - Width - 8;
  Top := Screen.WorkAreaHeight - Height - 8;

  DoPopup;
end;

procedure TPopupForm.PopupTimerTimer(Sender: TObject);
begin
  PopupTimer.Enabled := False;
  Hide;
end;

procedure TPopupForm.SetDarkMode(Dark: Boolean);
begin
  if (Dark) then begin
    Color := $002B2B2B;
    FBorderColor := $00A0A0A0;
    ContentLabel.Font.Color := $00FFFFFF;
    TitleLabel.Font.Color := $00FFFFFF;
  end else begin
    Color := clBtnFace;
    FBorderColor := clWindowText;
    ContentLabel.Font.Color := clWindowText;
    TitleLabel.Font.Color := clWindowText;
  end;
end;

procedure TPopupForm.ShowAgain;
begin
  if (FShown = False) then Exit;
  DoPopup;
end;

end.
