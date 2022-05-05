unit Form_PingGraph;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, System.Math, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdEcho, IdIcmpClient, IdRawBase, IdRawClient,
  Winapi.MMSystem, System.Win.TaskbarCore, Vcl.Taskbar;

type
  TPingThread = class(TThread)
  private
    FHost:string;
    FParentForm:TForm;
    procedure OnReply(ASender: TComponent; const AReplyStatus: TReplyStatus);
  public
    constructor Create(ParentForm:TForm; Host:string); overload;
    procedure Execute; override;
  end;

  TPingGraphForm = class(TForm)
    lbl_Xms: TLabel;
    lbl_0ms: TLabel;
    memoLog: TMemo;
    lblStats: TLabel;
    edtHostname: TEdit;
    lblHostname: TLabel;
    btnStartStop: TButton;
    cbSound: TCheckBox;
    pnlStatus: TPanel;
    pntGraph: TPaintBox;
    pnlGraph: TPanel; // PaintBox draws on parent, having a doublebuffered panel under it = no flicker ;)
    TaskbarStatus: TTaskbar;
    procedure pntGraphPaint(Sender: TObject);
    function pntGraphMaxVisibleValue:Cardinal;
    procedure PingThreadReply(const AReplyStatus: TReplyStatus; thread:TThread);
    procedure PingThreadException(log:string; thread:TThread);
    procedure btnStartStopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure StatusChange;
    procedure FormDestroy(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private
    { Private-Deklarationen }
    pingRecord:Array of Cardinal;
    pingIndex:Integer;
    pingAlternate:Boolean;
    pingStatus:Integer;
    pingThread:TPingThread;
    pingThreadRunning:Boolean;
    procedure StartPingThread(Host:string);
    procedure StopPingThread(wait:Boolean);
  public
    { Public-Deklarationen }
  end;

implementation

{$R *.dfm}

constructor TPingThread.Create(ParentForm:TForm; Host:string);
begin
  Create;
  FParentForm := ParentForm;
  FHost := Host;
end;

procedure TPingThread.Execute;
var
  IcmpClient:TIdIcmpClient;
begin
  IcmpClient := TIdIcmpClient.Create;
  IcmpClient.Host := FHost;
  IcmpClient.OnReply := OnReply;

  while (Terminated = False) do begin
    try
      IcmpClient.Ping;
    except
      on E:Exception do begin
        Synchronize(procedure begin
          (FParentForm as TPingGraphForm).PingThreadException(E.Message, Self);
        end);
      end;
    end;

    Sleep(1000);
  end;

  IcmpClient.Free;
end;

procedure TPingThread.OnReply(ASender: TComponent; const AReplyStatus: TReplyStatus);
begin
  Synchronize(procedure begin
    (FParentForm as TPingGraphForm).PingThreadReply(AReplyStatus, Self);
  end);
end;

procedure TPingGraphForm.btnStartStopClick(Sender: TObject);
begin
  pnlStatus.Color := clBtnFace;
  TaskbarStatus.ProgressState := TTaskBarProgressState.None;

  if (pingThreadRunning) then begin
    StopPingThread(False);
    btnStartStop.Caption := 'Start';
  end else begin
    btnStartStop.Caption := 'Stop';
    FillChar(pingRecord[0], sizeof(pingRecord[0]) * Length(pingRecord), #0);
    pingIndex := 0;
    memoLog.Clear;
    Caption := edtHostname.Text + ' - Ping graph';
    pingStatus := -1;
    StartPingThread(edtHostname.Text);
  end;
end;

procedure TPingGraphForm.CreateParams(var Params: TCreateParams) ;
begin
  inherited;

  // Show form on taskbar
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure TPingGraphForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Free form on close
  Action := caFree;
end;

procedure TPingGraphForm.FormCreate(Sender: TObject);
begin
  SetLength(pingRecord, Screen.DesktopWidth); // DesktopWidth = all screens
end;

procedure TPingGraphForm.FormDestroy(Sender: TObject);
begin
  if (pingThreadRunning) then StopPingThread(True); // Wait for graceful termination
end;

procedure TPingGraphForm.PingThreadReply(const AReplyStatus: TReplyStatus; thread:TThread);
var
  s:string;
begin
  // Drop information from stopped threads
  if (thread <> pingThread) then Exit;

  pingRecord[pingIndex] := AReplyStatus.MsRoundTripTime;
  Inc(pingIndex);
  if (pingIndex = Length(pingRecord)) then pingIndex := 0;

  s := IntToStr(AReplyStatus.MsRoundTripTime);
  lblStats.Caption := 'Current: ' + s + ' ms';
  pingAlternate := not pingAlternate;
  if (pingAlternate) then begin
    s := ':) ' + s + ' ms';
  end else begin
    s := ':D ' + s + ' ms';
  end;
  if (AReplyStatus.ReplyStatusType = rsTimeOut) then s := s + ' (timeout)';
  if (AReplyStatus.ReplyStatusType = rsErrorUnreachable) then s := s + ' (unreachable)';

  memoLog.Lines.Add(s);

  if (pingStatus <> Integer(AReplyStatus.ReplyStatusType)) then begin
    pingStatus := Integer(AReplyStatus.ReplyStatusType);
    StatusChange;
  end;


  pntGraph.Repaint;
end;

procedure TPingGraphForm.PingThreadException(log: string; thread:TThread);
begin
  // Drop information from stopped threads
  if (thread <> pingThread) then Exit;

  if (pingStatus <> -2) then begin
    pingStatus := -2;
    StatusChange;
  end;

  // Cut newline
  if (log[Length(log) - 1] = #$0d) then log[Length(log) - 1] := #0;

  pingAlternate := not pingAlternate;
  if (pingAlternate) then begin
    log := ':) Exception: ' + log;
  end else begin
    log := ':D Exception: ' + log;
  end;

  memoLog.Lines.Add(log);
end;

procedure TPingGraphForm.pntGraphPaint(Sender: TObject);
var
  drawIndex, I:Integer;
  scaleVal:Cardinal;
begin
  // Draw border and background
  pntGraph.Canvas.Pen.Color := $00c7d7e0;
  pntGraph.Canvas.Brush.Color := $00ecf1f4;
  pntGraph.Canvas.Rectangle(0, 0, pntGraph.Width, pntGraph.Height);

  // Calculate scaling
  scaleVal := pntGraphMaxVisibleValue;
  if (scaleVal < 1000) then begin
    scaleVal := ceil(scaleVal / 100) * 100;
  end else begin
    scaleVal := ceil(scaleVal / 1000) * 1000;
  end;
  if (scaleVal = 0) then scaleVal := 100;

  lbl_Xms.Caption := IntToStr(scaleVal) + ' ms';

  // Draw graph
  pntGraph.Canvas.Pen.Color := $005a5dde;

  drawIndex := pingIndex - 1;
  if (drawIndex < 0) then drawIndex := Length(pingRecord);

  pntGraph.Canvas.MoveTo(1, 100 - Round(100 / scaleVal * pingRecord[drawIndex]));

  for I := 0 to Min(Length(pingRecord), pntGraph.Width-2) do begin
    Dec(drawIndex);
    if (drawIndex < 0) then drawIndex := Length(pingRecord);

    pntGraph.Canvas.LineTo(I + 1, 100 - Round(100 / scaleVal * pingRecord[drawIndex]));
  end;
end;

// Iterates the visible area of the graph and returns the highest value
function TPingGraphForm.pntGraphMaxVisibleValue:Cardinal;
var
  drawIndex, I:Integer;
begin
  Result := 0;

  drawIndex := pingIndex;
  for I := 0 to Min(Length(pingRecord), pntGraph.Width-2) do begin
    Dec(drawIndex);
    if (drawIndex < 0) then drawIndex := Length(pingRecord);

    Result := Max(Result, pingRecord[drawIndex]);
  end;
end;

procedure TPingGraphForm.StartPingThread(Host:string);
begin
  pingThread := TPingThread.Create(Self, Host);
  pingThreadRunning := True;
end;

procedure TPingGraphForm.StopPingThread(wait:Boolean);
begin
  pingThreadRunning := False;
  pingThread.Terminate;
  if (wait) then pingThread.WaitFor;
  pingThread.Free;
  pingThread := nil;
end;

procedure TPingGraphForm.StatusChange;
begin
  if (pingThreadRunning = False) then Exit;

  if (pingStatus = 0) then begin
    pnlStatus.Color := $002da800;
    TaskbarStatus.ProgressState := TTaskBarProgressState.Normal;
    if (cbSound.Checked) then PlaySound('connect.wav', 0, SND_ASYNC);
  end else begin
    pnlStatus.Color := $00223cd2;
    TaskbarStatus.ProgressState := TTaskBarProgressState.Error;
    if (cbSound.Checked) then PlaySound('disconnect.wav', 0, SND_ASYNC);
  end;
end;

end.
