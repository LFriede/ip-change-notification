object ConfigForm: TConfigForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Configuration'
  ClientHeight = 314
  ClientWidth = 687
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 13
  object lblPopupTime: TLabel
    Left = 8
    Top = 11
    Width = 167
    Height = 13
    Caption = 'Popup visibility timer (milliseconds):'
  end
  object grpFilter: TGroupBox
    Left = 8
    Top = 36
    Width = 329
    Height = 239
    Caption = 'Interface filter regexes'
    TabOrder = 0
    object lblFilter: TLabel
      Left = 3
      Top = 167
      Width = 323
      Height = 69
      AutoSize = False
      Caption = 
        'You can filter uninteresting interfaces by regular expressions. ' +
        'Filtered interfaces will show no popup and are collapsed in the ' +
        'list on the main window.'#13#10'There are some predefined default valu' +
        'es, remove them to include all interfaces.'
      WordWrap = True
    end
    object memoFilter: TMemo
      Left = 3
      Top = 19
      Width = 323
      Height = 142
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
  end
  object btnSave: TButton
    Left = 604
    Top = 281
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object btnDefault: TButton
    Left = 510
    Top = 281
    Width = 88
    Height = 25
    Caption = 'Reset defaults'
    TabOrder = 2
    OnClick = btnDefaultClick
  end
  object spnPopupTime: TSpinEdit
    Left = 192
    Top = 8
    Width = 145
    Height = 22
    Increment = 500
    MaxValue = 0
    MinValue = 0
    TabOrder = 3
    Value = 0
  end
  object grpTools: TGroupBox
    Left = 343
    Top = 8
    Width = 336
    Height = 267
    Caption = 'External tools'
    TabOrder = 4
    object lblTools: TLabel
      Left = 3
      Top = 195
      Width = 330
      Height = 69
      AutoSize = False
      Caption = 
        'You can add external tools to the "Swiss Army Knife" submenu in ' +
        'the tray icons popup menu. Write the tools name followed by "=" ' +
        'and a registry key containing the executable path. If a filename' +
        ' needs to be appended to the path you can add it after a "?" sig' +
        'n. Tools will only be displayed in the menu if they exist.'
      WordWrap = True
    end
    object memoTools: TMemo
      Left = 3
      Top = 19
      Width = 330
      Height = 170
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
  end
  object btnAutostart: TButton
    Left = 8
    Top = 281
    Width = 97
    Height = 25
    Caption = 'Enable autostart'
    TabOrder = 5
    OnClick = btnAutostartClick
  end
end
