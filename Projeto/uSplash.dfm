object frmSplash: TfrmSplash
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = 'Update Gestor'
  ClientHeight = 222
  ClientWidth = 666
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 150
    Top = 100
    Width = 370
    Height = 23
    Alignment = taCenter
    Caption = 'D'#202' UM DUPLO CLIQUE E COLOQUE SUA LOGO AQUI'
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    GlowSize = 1
    ParentFont = False
    WordWrap = True
    OnDblClick = Image1DblClick
  end
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 666
    Height = 222
    Align = alClient
    AutoSize = True
    Center = True
    Proportional = True
    OnDblClick = Image1DblClick
    ExplicitLeft = -8
  end
  object Timer1: TTimer
    Interval = 3000
    OnTimer = Timer1Timer
    Left = 88
    Top = 120
  end
  object OpenPicture: TOpenPictureDialog
    Filter = 
      'JPEG Image File (*.jpg)|*.jpg|JPEG Image File (*.jpeg)|*.jpeg|Po' +
      'rtable Network Graphics (*.png)|*.png|Bitmaps (*.bmp)|*.bmp'
    Left = 88
    Top = 68
  end
end
