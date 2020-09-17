unit Form_About;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Winapi.ShellAPI,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TFormAbout = class(TForm)
    lblText: TLabel;
    lblGitHub: TLabel;
    imgIcon: TImage;
    lblIcon: TLabel;
    lblYusuke: TLabel;
    procedure lblGitHubClick(Sender: TObject);
    procedure LinkLabelMouseEnter(Sender: TObject);
    procedure LinkLabelMouseLeave(Sender: TObject);
    procedure lblYusukeClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.dfm}

procedure TFormAbout.lblGitHubClick(Sender: TObject);
begin
  ShellExecute(0, 'open', 'https://github.com/LFriede/ip-change-notification', nil, nil, SW_SHOWNORMAL);
end;

procedure TFormAbout.lblYusukeClick(Sender: TObject);
begin
  ShellExecute(0, 'open', 'https://p.yusukekamiyamane.com', nil, nil, SW_SHOWNORMAL);
end;

procedure TFormAbout.LinkLabelMouseEnter(Sender: TObject);
begin
  TLabel(Sender).Font.Style := [];
end;

procedure TFormAbout.LinkLabelMouseLeave(Sender: TObject);
begin
  TLabel(Sender).Font.Style := [fsUnderline];
end;

end.
