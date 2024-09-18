object PWGenForm: TPWGenForm
  Left = 0
  Top = 0
  Caption = 'Password generator'
  ClientHeight = 259
  ClientWidth = 236
  Color = clBtnFace
  Constraints.MinHeight = 298
  Constraints.MinWidth = 225
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnShow = FormShow
  DesignSize = (
    236
    259)
  TextHeight = 13
  object lblHint: TLabel
    Left = 8
    Top = 218
    Width = 170
    Height = 26
    Anchors = [akLeft, akRight, akBottom]
    Caption = '* Password generation is based on BCryptGenRandom Winapi.'
    WordWrap = True
  end
  object edtOutput: TEdit
    Left = 8
    Top = 8
    Width = 220
    Height = 21
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    ReadOnly = True
    TabOrder = 0
  end
  object grpSettings: TGroupBox
    Left = 8
    Top = 35
    Width = 220
    Height = 136
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Settings'
    TabOrder = 1
    DesignSize = (
      220
      136)
    object lblCharCount: TLabel
      Left = 3
      Top = 113
      Width = 78
      Height = 13
      Caption = 'Character count'
    end
    object cbLower: TCheckBox
      Left = 3
      Top = 16
      Width = 102
      Height = 17
      Caption = 'a-z'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbClick
    end
    object cbUpper: TCheckBox
      Left = 3
      Top = 39
      Width = 97
      Height = 17
      Caption = 'A-Z'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = cbClick
    end
    object cbNumbers: TCheckBox
      Left = 3
      Top = 62
      Width = 97
      Height = 17
      Caption = '0-9'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = cbClick
    end
    object cbCustom: TCheckBox
      Left = 3
      Top = 85
      Width = 18
      Height = 17
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = cbClick
    end
    object edtCustomChars: TEdit
      Left = 27
      Top = 83
      Width = 190
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
      OnChange = edtCustomCharsChange
    end
    object spnCount: TSpinEdit
      Left = 123
      Top = 110
      Width = 94
      Height = 22
      Anchors = [akTop, akRight]
      MaxValue = 999
      MinValue = 1
      TabOrder = 5
      Value = 10
      OnChange = spnCountChange
    end
    object cbAlphanum: TCheckBox
      Left = 73
      Top = 16
      Width = 144
      Height = 25
      Caption = 'Alphanumeric without l, I, 0, and O'
      TabOrder = 6
      WordWrap = True
      OnClick = cbAlphanumClick
    end
  end
  object btnGenerate: TButton
    Left = 128
    Top = 177
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Generate + copy'
    TabOrder = 2
    OnClick = btnGenerateClick
  end
end
