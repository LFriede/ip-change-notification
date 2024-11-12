object PingGraphForm: TPingGraphForm
  Left = 0
  Top = 0
  Caption = 'Ping graph'
  ClientHeight = 371
  ClientWidth = 547
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    547
    371)
  TextHeight = 13
  object lbl_Xms: TLabel
    Left = 423
    Top = 8
    Width = 34
    Height = 13
    Anchors = [akTop, akRight]
    Caption = '100 ms'
  end
  object lbl_0ms: TLabel
    Left = 423
    Top = 95
    Width = 22
    Height = 13
    Anchors = [akTop, akRight]
    Caption = '0 ms'
  end
  object lblStats: TLabel
    Left = 8
    Top = 116
    Width = 41
    Height = 13
    Caption = 'Current:'
  end
  object lblHostname: TLabel
    Left = 8
    Top = 322
    Width = 72
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'IP / Hostname:'
  end
  object memoLog: TMemo
    Left = 8
    Top = 135
    Width = 531
    Height = 178
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object edtHostname: TEdit
    Left = 86
    Top = 319
    Width = 372
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
  end
  object btnStartStop: TButton
    Left = 464
    Top = 319
    Width = 75
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'Start'
    TabOrder = 2
    OnClick = btnStartStopClick
  end
  object cbSound: TCheckBox
    Left = 8
    Top = 346
    Width = 97
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Enable sound'
    TabOrder = 3
  end
  object pnlStatus: TPanel
    Left = 472
    Top = 8
    Width = 67
    Height = 100
    Anchors = [akTop, akRight]
    Caption = 'Status'
    ParentBackground = False
    TabOrder = 4
  end
  object pnlGraph: TPanel
    Left = 8
    Top = 8
    Width = 409
    Height = 102
    Anchors = [akLeft, akTop, akRight]
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 5
    DesignSize = (
      409
      102)
    object pntGraph: TPaintBox
      Left = 0
      Top = 0
      Width = 409
      Height = 102
      Anchors = [akLeft, akTop, akRight]
      OnPaint = pntGraphPaint
    end
  end
  object TaskbarStatus: TTaskbar
    TaskBarButtons = <>
    ProgressMaxValue = 1
    ProgressValue = 1
    TabProperties = []
    Left = 40
    Top = 144
  end
end
