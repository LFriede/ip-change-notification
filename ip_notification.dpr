program ip_notification;

uses
  Vcl.Forms,
  Windows,
  Unit1 in 'Unit1.pas' {Form1},
  my_iphlpapi in 'my_iphlpapi.pas',
  my_ifdef in 'my_ifdef.pas',
  my_nldef in 'my_nldef.pas',
  my_IPTypes in 'my_IPTypes.pas',
  Form_Popup in 'Form_Popup.pas',
  Form_About in 'Form_About.pas' {FormAbout},
  config in 'config.pas',
  Form_Config in 'Form_Config.pas' {ConfigForm},
  Form_PingGraph in 'Form_PingGraph.pas' {PingGraphForm},
  Form_PWGen in 'Form_PWGen.pas' {PWGenForm},
  my_bcrypt in 'my_bcrypt.pas';

{$R *.res}

begin
  CreateMutex(nil, True, 'IPChangeNotificationStartMutex');
  if (GetLastError = ERROR_ALREADY_EXISTS) then Exit;

  Application.Initialize;

  {$ifdef DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$endif}

  Application.MainFormOnTaskbar := True;
  Application.ShowMainForm := False;
  Application.Title := 'IP Change Notification';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TPopupForm, PopupForm);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.CreateForm(TPWGenForm, PWGenForm);
  Form1.CheckTrayIcon;
  Form1.TrayIcon1.Visible := True;

  // Show settings dialog if no config file exists
  if (globalconfig.InitConfig) then ConfigForm.Show;

  Application.Run;
end.
