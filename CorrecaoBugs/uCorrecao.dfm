object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Kaw White Corre'#231#245'es BUG'
  ClientHeight = 299
  ClientWidth = 493
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 184
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Corrigir Rede'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 184
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Corrigir Caixa'
    TabOrder = 1
    OnClick = Button2Click
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    VendorLib = 'C:\Gestor\fbclient.dll'
    Left = 96
    Top = 184
  end
  object FDConexao: TFDConnection
    Params.Strings = (
      'Database=c:\gestor\dados\dados.fdb'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'DriverID=FB')
    Left = 208
    Top = 184
  end
  object QryCorrigir: TFDQuery
    Connection = FDConexao
    Left = 304
    Top = 184
  end
end
