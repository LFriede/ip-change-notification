object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'IP Change Notification 0.1'
  ClientHeight = 641
  ClientWidth = 624
  Color = clBtnFace
  Constraints.MinHeight = 350
  Constraints.MinWidth = 350
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = Refresh1Click
  PixelsPerInch = 96
  TextHeight = 13
  object tvInterfaces: TTreeView
    Left = 0
    Top = 0
    Width = 624
    Height = 641
    Align = alClient
    Indent = 19
    TabOrder = 0
  end
  object TrayIcon1: TTrayIcon
    PopupMenu = pmTrayIcon
    OnClick = TrayIcon1Click
    Left = 24
    Top = 24
  end
  object pmTrayIcon: TPopupMenu
    AutoHotkeys = maManual
    Images = imgTrayMenuIcons
    Left = 96
    Top = 24
    object NetworkConnections1: TMenuItem
      Caption = 'Network Connections...'
      OnClick = NetworkConnections1Click
    end
    object Connectionproperties1: TMenuItem
      Caption = 'Connection properties'
      Visible = False
    end
    object SwissArmyKnive1: TMenuItem
      Caption = 'Swiss Army Knive'
      object menuReleaseRenew: TMenuItem
        Caption = 'ipconfig release / renew'
        OnClick = menuReleaseRenewClick
      end
      object Pinggraph1: TMenuItem
        Caption = 'Ping graph...'
        OnClick = Pinggraph1Click
      end
      object menuPWGen: TMenuItem
        Caption = 'Password generator...'
        OnClick = menuPWGenClick
      end
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Settings2: TMenuItem
      Caption = 'Settings...'
      OnClick = Settings1Click
    end
    object Exit1: TMenuItem
      Caption = 'Exit'
      OnClick = Exit1Click
    end
  end
  object imgTrayIcons: TImageList
    ColorDepth = cd32Bit
    Left = 176
    Top = 24
    Bitmap = {
      494C010103000800040010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000FF000000FF000000FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000003C3D40405F6B7C805F6A78803C3D3E40000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFFFF000000000000000000000000FFFFFFFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000FF000000000000000000000000000000FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000003C3D4040687994946A8CBBC06A8AB7C068758A943C3D3E400000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF000000000000000000000000FFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF000000000000000000000000000000FF000000FF0000
      00FF000000FF000000FF000000000000000000000000000000FF000000FF0000
      00FF000000FF000000FF00000000000000003E3E3E40555555605F5F5F805F5F
      5F805F5F5F80647387A06F8FC0C05399FFFF5399FFFF6A8AB7C0606C7EA05F5F
      5F805F5F5F805F5F5F80555555603E3E3E400000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFFFF000000000000000000000000FFFFFFFF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000FF000000000000000000000000000000FF000000000000
      0000000000000000000000000000000000003E3E3E40555555605F5F5F805F5F
      5F805F5F5F80697487A07391C0C05399FFFF5399FFFF6A8CBBC0606E82A05F5F
      5F805F5F5F805F5F5F80555555603E3E3E400000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000FF000000FF000000FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000003D3E4040727F94947391C0C06F8FC0C0687994943C3D40400000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000003D3E404067708080636F80803C3D4040000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000808080FF808080FF8080
      80FF808080FF808080FF808080FF808080FF808080FF808080FF808080FF8080
      80FF808080FF808080FF808080FF0000000000000000808080FF808080FF8080
      80FF808080FF808080FF808080FF808080FF808080FF808080FF808080FF8080
      80FF808080FF808080FF808080FF000000003E3E3E40969696C0969696C09595
      95C0949494C0939393C0919191C0909090C0909090C08F8F8FC08D8D8DC08C8C
      8CC08C8C8CC08A8A8AC08A8A8AC03D3D3D400000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000808080FFFFFFFFFFFFFFFFFFFFFF
      FFFF0000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF00000000808080FF808080FF000000FF000000FF0000
      00FF0000000000000000000000FF000000FF0000000000000000000000FF0000
      00FF000000FF000000FF00000000808080FF70707080717171FF373737FF3737
      37FF717171FFE6E6E6FF717171FF373737FF717171FFE6E6E6FF717171FF3737
      37FF373737FF373737FF717171FF6A6A6A800000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000808080FF00000000FFFFFFFF0000
      000000000000FFFFFFFF0000000000000000FFFFFFFF00000000FFFFFFFF0000
      0000000000000000000000000000808080FF808080FF00000000000000FF0000
      000000000000000000FF0000000000000000000000FF00000000000000FF0000
      0000000000000000000000000000808080FF71717180E6E6E6FF717171FF7171
      71FFE6E6E6FF717171FF717171FFE6E6E6FF717171FF717171FF717171FF7171
      71FFE6E6E6FFE6E6E6FFE6E6E6FF6B6B6B800000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000808080FF00000000FFFFFFFF0000
      000000000000000000000000000000000000FFFFFFFF0000000000000000FFFF
      FFFF000000000000000000000000808080FF808080FF00000000000000FF0000
      000000000000000000000000000000000000000000FF00000000000000000000
      00FF000000000000000000000000808080FF72727280E6E6E6FF717171FF7171
      71FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FF717171FF717171FFE6E6E6FF7171
      71FF717171FFE6E6E6FFE6E6E6FF6C6C6C800000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000808080FF00000000FFFFFFFF0000
      00000000000000000000FFFFFFFFFFFFFFFF0000000000000000000000000000
      0000FFFFFFFF0000000000000000808080FF808080FF00000000000000FF0000
      00000000000000000000000000FF000000FF0000000000000000000000000000
      0000000000FF0000000000000000808080FF73737380E6E6E6FF717171FF7171
      71FFE6E6E6FFE6E6E6FF717171FF373737FF373737FF717171FFE6E6E6FFE6E6
      E6FF717171FF717171FFE6E6E6FF6C6C6C800000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000808080FF00000000FFFFFFFF0000
      000000000000FFFFFFFF0000000000000000FFFFFFFF00000000000000000000
      000000000000FFFFFFFF00000000808080FF808080FF00000000000000FF0000
      000000000000000000FF0000000000000000000000FF00000000000000000000
      000000000000000000FF00000000808080FF73737380E6E6E6FF717171FF7171
      71FFE6E6E6FF717171FF717171FFE6E6E6FF717171FF717171FFE6E6E6FFE6E6
      E6FFE6E6E6FF717171FF717171FF6D6D6D800000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000808080FFFFFFFFFFFFFFFFFF0000
      000000000000FFFFFFFF0000000000000000FFFFFFFF00000000FFFFFFFF0000
      000000000000FFFFFFFF00000000808080FF808080FF000000FF000000FF0000
      000000000000000000FF0000000000000000000000FF00000000000000FF0000
      000000000000000000FF00000000808080FF74747480717171FF373737FF7171
      71FFE6E6E6FF717171FF717171FFE6E6E6FF717171FF717171FF717171FF7171
      71FFE6E6E6FF717171FF717171FF6E6E6E800000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000808080FF00000000FFFFFFFF0000
      00000000000000000000FFFFFFFFFFFFFFFF000000000000000000000000FFFF
      FFFFFFFFFFFF0000000000000000808080FF808080FF00000000000000FF0000
      00000000000000000000000000FF000000FF0000000000000000000000000000
      00FF000000FF0000000000000000808080FF75757580E6E6E6FF717171FF7171
      71FFE6E6E6FFE6E6E6FF717171FF373737FF717171FFE6E6E6FFE6E6E6FF7171
      71FF373737FF717171FFE6E6E6FF6F6F6F800000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000808080FF808080FF8080
      80FF808080FF808080FF808080FF808080FF808080FF808080FF808080FF8080
      80FF808080FF808080FF808080FF0000000000000000808080FF808080FF8080
      80FF808080FF808080FF808080FF808080FF808080FF808080FF808080FF8080
      80FF808080FF808080FF808080FF000000003E3E3E40A5A5A5C0A4A4A4C0A3A3
      A3C0A2A2A2C0A2A2A2C0A0A0A0C09F9F9FC09E9E9EC09D9D9DC09C9C9CC09C9C
      9CC0999999C0999999C0979797C03E3E3E400000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FC7FFC7FFC3F0000FBBFFBBFF81F0000
      8383838300000000FBBFFBBF00000000FC7FFC7FF81F0000FFFFFFFFFC3F0000
      80018001000000000CC20CC2000000005B5E5B5E000000005F6E5F6E00000000
      5CF65CF6000000005B7A5B7A000000001B5A1B5A000000005CE65CE600000000
      8001800100000000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
  object MainMenu1: TMainMenu
    Left = 240
    Top = 24
    object Menu1: TMenuItem
      Caption = 'Menu'
      object Refresh1: TMenuItem
        Caption = 'Refresh'
        OnClick = Refresh1Click
      end
      object Networkconnections2: TMenuItem
        Caption = 'Network Connections...'
        OnClick = NetworkConnections1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Settings1: TMenuItem
        Caption = 'Settings...'
        OnClick = Settings1Click
      end
      object Exit2: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object N1: TMenuItem
      Caption = '?'
      object About1: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
    end
  end
  object imgTrayMenuIcons: TImageList
    ColorDepth = cd32Bit
    Left = 320
    Top = 24
  end
end
