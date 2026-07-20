object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Sincronizador - White PDV'
  ClientHeight = 417
  ClientWidth = 817
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 817
    Height = 417
    Align = alClient
    BevelOuter = bvNone
    Color = 16119285
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      817
      417)
    object imageAcerto: TImage
      Left = -31
      Top = 27
      Width = 23
      Height = 25
      Transparent = True
      Visible = False
    end
    object imageErro: TImage
      Left = -27
      Top = 76
      Width = 23
      Height = 25
      Transparent = True
      Visible = False
    end
    object GroupBox_log: TGroupBox
      Left = 374
      Top = 19
      Width = 432
      Height = 390
      Anchors = [akLeft, akTop, akRight]
      Caption = 'LOG'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      DesignSize = (
        432
        390)
      object Memo_log: TMemo
        Left = 9
        Top = 17
        Width = 416
        Height = 363
        TabStop = False
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        PopupMenu = PopupMenu1
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object PageControl1: TPageControl
    Left = 13
    Top = 19
    Width = 355
    Height = 390
    ActivePage = TabSheet1
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Configura'#231#245'es'
      object lb_email: TLabel
        Left = 11
        Top = 99
        Width = 34
        Height = 15
        Caption = 'E-mail'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Visible = False
        StyleElements = [seClient, seBorder]
      end
      object lb_api: TLabel
        Left = 11
        Top = 81
        Width = 58
        Height = 15
        Caption = 'URL da API'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Visible = False
        StyleElements = [seClient, seBorder]
      end
      object pnEmail: TEdit
        Left = 11
        Top = 117
        Width = 318
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Visible = False
      end
      object chkIniciarWindows: TCheckBox
        Left = 11
        Top = 17
        Width = 144
        Height = 17
        Caption = 'Iniciar com Windows '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object chkSincVendas: TCheckBox
        Left = 11
        Top = 44
        Width = 138
        Height = 17
        Caption = 'Sincronizar vendas'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object chkSincFiscal: TCheckBox
        Left = 171
        Top = 44
        Width = 120
        Height = 17
        Caption = 'Sincronizar fiscal'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
      object GroupBox2: TGroupBox
        Left = 11
        Top = 146
        Width = 318
        Height = 83
        Caption = 'Sincronizar'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Label2: TLabel
          Left = 251
          Top = 40
          Width = 44
          Height = 15
          Caption = 'minutos'
        end
        object Label1: TLabel
          Left = 151
          Top = 40
          Width = 34
          Height = 15
          Caption = 'a cada'
        end
        object editMinutos: TEdit
          Left = 196
          Top = 37
          Width = 44
          Height = 23
          Alignment = taCenter
          BevelOuter = bvNone
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          Font.Quality = fqProof
          MaxLength = 3
          NumbersOnly = True
          ParentFont = False
          TabOrder = 1
          Text = '10'
        end
        object btn_ligar: TButton
          Left = 17
          Top = 30
          Width = 117
          Height = 39
          Caption = 'LIGAR'
          ImageIndex = 1
          ImageMargins.Left = 10
          Images = ImageList1
          TabOrder = 0
          Visible = False
          OnClick = btn_ligarClick
        end
        object btnDesligar: TButton
          Left = 17
          Top = 30
          Width = 117
          Height = 39
          Caption = 'DESLIGAR'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ImageIndex = 0
          ImageMargins.Left = 10
          Images = ImageList1
          ParentFont = False
          TabOrder = 2
          Visible = False
          OnClick = btnDesligarClick
        end
      end
      object edt_api: TEdit
        Left = 11
        Top = 99
        Width = 318
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        Visible = False
      end
      object chk_notificacao: TCheckBox
        Left = 171
        Top = 17
        Width = 141
        Height = 17
        Caption = 'Exibir notifica'#231#227'o'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
      end
      object cxBtn_sync: TButton
        Left = 11
        Top = 308
        Width = 318
        Height = 39
        Caption = 'SINCRONIZAR'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ImageIndex = 1
        ImageMargins.Left = 10
        ParentFont = False
        TabOrder = 7
        OnClick = cxBtn_syncClick
      end
      object CheckBox1: TCheckBox
        Left = 297
        Top = 17
        Width = 138
        Height = 17
        Caption = 'Sincronizar cadastros'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
        Visible = False
      end
      object GroupBox1: TGroupBox
        Left = 11
        Top = 236
        Width = 318
        Height = 66
        Caption = 'Filtrar '
        TabOrder = 9
        object LblPeriodo: TLabel
          Left = 17
          Top = 18
          Width = 91
          Height = 15
          Caption = 'Per'#237'odo de      at'#233
        end
        object maskInicio: TMaskEdit
          Left = 17
          Top = 35
          Width = 68
          Height = 21
          Color = clWhite
          Ctl3D = False
          EditMask = '!99/99/0000;1;_'
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          MaxLength = 10
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          Text = '  /  /    '
        end
        object maskFim: TMaskEdit
          Left = 91
          Top = 35
          Width = 70
          Height = 21
          Color = clWhite
          Ctl3D = False
          EditMask = '!99/99/0000;1;_'
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          MaxLength = 10
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 1
          Text = '  /  /    '
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'JSON'
      ImageIndex = 2
      TabVisible = False
      object Memo1: TMemo
        Left = 4
        Top = 3
        Width = 337
        Height = 351
        Lines.Strings = (
          '{'
          '  "notasFiscais": {'
          '    "TotalEnviadas": {'
          '      "janeiro": 3,'
          '      "feveiro": 0,'
          '      "marco": 0,'
          '      "abril": 0,'
          '      "maio": 0,'
          '      "junho": 0,'
          '      "julho": 0,'
          '      "agosto": 0,'
          '      "setembro": 0,'
          '      "outubro": 0,'
          '      "novembro": 0,'
          '      "dezembro": 0'
          '    },'
          '    "TotalCanceladas": {'
          '      "janeiro": 0,'
          '      "feveiro": 0,'
          '      "marco": 0,'
          '      "abril": 0,'
          '      "maio": 0,'
          '      "junho": 0,'
          '      "julho": 0,'
          '      "agosto": 0,'
          '      "setembro": 0,'
          '      "outubro": 0,'
          '      "novembro": 0,'
          '      "dezembro": 0'
          '    },'
          '    "TotalContigencia": {'
          '      "janeiro": 0,'
          '      "feveiro": 0,'
          '      "marco": 0,'
          '      "abril": 0,'
          '      "maio": 0,'
          '      "junho": 0,'
          '      "julho": 0,'
          '      "agosto": 0,'
          '      "setembro": 0,'
          '      "outubro": 0,'
          '      "novembro": 0,'
          '      "dezembro": 0'
          '    }'
          '  },'
          '  "vendas": {'
          '    "canceladas": {'
          '      "janeiro": 0,'
          '      "feveiro": 0,'
          '      "marco": 0,'
          '      "abril": 0,'
          '      "maio": 0,'
          '      "junho": 0,'
          '      "julho": 0,'
          '      "agosto": 0,'
          '      "setembro": 0,'
          '      "outubro": 0,'
          '      "novembro": 0,'
          '      "dezembro": 0'
          '    },'
          '    "concluidas": {'
          '      "janeiro": 3,'
          '      "feveiro": 0,'
          '      "marco": 0,'
          '      "abril": 0,'
          '      "maio": 0,'
          '      "junho": 0,'
          '      "julho": 0,'
          '      "agosto": 0,'
          '      "setembro": 0,'
          '      "outubro": 0,'
          '      "novembro": 0,'
          '      "dezembro": 0'
          '    }'
          '  },'
          '  "f_pagamentos": {'
          '    "dinheiro": 6465,'
          '    "credito": 0,'
          '    "debito": 0,'
          '    "pix": 0,'
          '    "prazo": 0'
          '  },'
          '  "caixa": {'
          '    "saldo": {'
          '      "janeiro": 6465,'
          '      "feveiro": 0,'
          '      "marco": 0,'
          '      "abril": 0,'
          '      "maio": 0,'
          '      "junho": 0,'
          '      "julho": 0,'
          '      "agosto": 0,'
          '      "setembro": 0,'
          '      "outubro": 0,'
          '      "novembro": 0,'
          '      "dezembro": 0'
          '    },'
          '    "entradas": {'
          '      "janeiro": 6465,'
          '      "feveiro": 0,'
          '      "marco": 0,'
          '      "abril": 0,'
          '      "maio": 0,'
          '      "junho": 0,'
          '      "julho": 0,'
          '      "agosto": 0,'
          '      "setembro": 0,'
          '      "outubro": 0,'
          '      "novembro": 0,'
          '      "dezembro": 0'
          '    },'
          '    "saidas": {'
          '      "janeiro": 0,'
          '      "feveiro": 0,'
          '      "marco": 0,'
          '      "abril": 0,'
          '      "maio": 0,'
          '      "junho": 0,'
          '      "julho": 0,'
          '      "agosto": 0,'
          '      "setembro": 0,'
          '      "outubro": 0,'
          '      "novembro": 0,'
          '      "dezembro": 0'
          '    },'
          '    "saldoAtual": 6465,'
          '    "EntradaAtual": 6465,'
          '    "SaidaAtual": 0'
          '  },'
          '  "cadastros": {'
          '    "produtos": "8560",'
          '    "clientes": "602",'
          '    "usuarios": "1",'
          '    "fornecedores": "40"'
          '  },'
          '  "contasReceber": {'
          '    "receber": {'
          '      "janeiro": 10.99,'
          '      "feveiro": 20.99,'
          '      "marco": 30.99,'
          '      "abril": 40.99,'
          '      "maio": 0,'
          '      "junho": 0,'
          '      "julho": 0,'
          '      "agosto": 0,'
          '      "setembro": 0,'
          '      "outubro": 0,'
          '      "novembro": 0,'
          '      "dezembro": 0'
          '    },'
          '    "recebidas": {'
          '      "janeiro": 0,'
          '      "feveiro": 0,'
          '      "marco": 0,'
          '      "abril": 0,'
          '      "maio": 0,'
          '      "junho": 0,'
          '      "julho": 0,'
          '      "agosto": 0,'
          '      "setembro": 0,'
          '      "outubro": 0,'
          '      "novembro": 0,'
          '      "dezembro": 0'
          '    },'
          '    "vencidasAtual": 1.99,'
          '    "pendentesAtual": 2.99,'
          '    "pagasAtual": 3.99'
          '  },'
          '  "contasPagar": {'
          '    "pagas": {'
          '      "janeiro": 0,'
          '      "feveiro": 0,'
          '      "marco": 0,'
          '      "abril": 0,'
          '      "maio": 0,'
          '      "junho": 0,'
          '      "julho": 0,'
          '      "agosto": 0,'
          '      "setembro": 0,'
          '      "outubro": 0,'
          '      "novembro": 0,'
          '      "dezembro": 0'
          '    },'
          '    "pendendentes": {'
          '      "janeiro": 0,'
          '      "feveiro": 0,'
          '      "marco": 0,'
          '      "abril": 0,'
          '      "maio": 0,'
          '      "junho": 0,'
          '      "julho": 0,'
          '      "agosto": 0,'
          '      "setembro": 0,'
          '      "outubro": 0,'
          '      "novembro": 0,'
          '      "dezembro": 0'
          '    },'
          '    "vencidasAtual": 0,'
          '    "pendentesAtual": 0,'
          '    "pagasAtual": 0'
          '  },'
          '  "caixasAbertos": ['
          '    {'
          '      "usuario": "admin",'
          '      "horaAbertura": "10:34:31",'
          '      "dataAbertura": "20/10/2021",'
          '      "saldoInicial": 0,'
          '      "saldoAtual": 83935.68,'
          '      "Entradas": 83935.68,'
          '      "saidas": 0,'
          '      "dinheiro": 83935.68,'
          '      "credito": 0,'
          '      "debito": 0,'
          '      "cheque": 0,'
          '      "convenio": 0,'
          '      "vRefeicao": 0,'
          '      "vCombustivel": 0'
          '    }'
          '  ],'
          '  "topProdutos": ['
          '    {'
          '      "produto": "ARROZ PARBOLIZADO '
          'CAICARA",'
          '      "quantidade": "750"'
          '    },'
          '    {'
          '      "produto": "FD DE ARROZ CAICARA C '
          '10 '
          'K",'
          '      "quantidade": "120"'
          '    }'
          '  ],'
          '  "lucrosPresumidos": {'
          '    "ganhos": {'
          '      "janeiro": 2497.5,'
          '      "feveiro": 0,'
          '      "marco": 0,'
          '      "abril": 0,'
          '      "maio": 0,'
          '      "junho": 0,'
          '      "julho": 0,'
          '      "agosto": 0,'
          '      "setembro": 0,'
          '      "outubro": 0,'
          '      "novembro": 0,'
          '      "dezembro": 0'
          '    },'
          '    "perdidos": {'
          '      "janeiro": 0,'
          '      "feveiro": 0,'
          '      "marco": 0,'
          '      "abril": 0,'
          '      "maio": 0,'
          '      "junho": 0,'
          '      "julho": 0,'
          '      "agosto": 0,'
          '      "setembro": 0,'
          '      "outubro": 0,'
          '      "novembro": 0,'
          '      "dezembro": 0'
          '    },'
          '    "relatorioVendas": {'
          '      "concluidas": {'
          '        "valorVendas": 6465,'
          '        "quantidadeVendas": 3,'
          '        "totalDescontos": 0,'
          '        "totalLucros": 2497.5,'
          '        "TicketMedio": 2155,'
          '        "TempoMedioAtendimento": '
          '"00:00:42",'
          '        "QuantidadeProdutosVendidos": 870'
          '      },'
          '      "canceladas": {'
          '        "valorVendas": 0,'
          '        "LurosPerdidos": 0,'
          '        "QuantidadeProdutosPerdidos": 0,'
          '        "QuantidadeVendasPerdidas": 0'
          '      },'
          '      "vendasUsuarios": ['
          '        {'
          '          "usuario": "admin",'
          '          "totalVendas": "6465",'
          '          "comissoes": "0",'
          '          "quantidadeVendas": 3,'
          '          "quantidadeProdutos": 870,'
          '          "tempoAtendimento": "00:00:42"'
          '        }'
          '      ]'
          '    }'
          '  }'
          '}')
        PopupMenu = PopupMenu1
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Empresa'
      ImageIndex = 4
      object GroupBox3: TGroupBox
        Left = 11
        Top = 3
        Width = 325
        Height = 350
        Caption = 'Dados da Empresa'
        TabOrder = 0
        object Label5: TLabel
          Left = 19
          Top = 24
          Width = 79
          Height = 15
          Caption = 'Nome Fantasia'
          FocusControl = DBEdit_fantasia
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          StyleElements = [seClient, seBorder]
        end
        object Label6: TLabel
          Left = 19
          Top = 66
          Width = 65
          Height = 15
          Caption = 'Raz'#227'o Social'
          FocusControl = DBEdit_razao
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          StyleElements = [seClient, seBorder]
        end
        object Label7: TLabel
          Left = 19
          Top = 108
          Width = 27
          Height = 15
          Caption = 'CNPJ'
          FocusControl = DBEdit_cnpj
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          StyleElements = [seClient, seBorder]
        end
        object Label8: TLabel
          Left = 19
          Top = 150
          Width = 138
          Height = 15
          Caption = 'Respons'#225'vel pela Empresa'
          FocusControl = DBEdit_responsavel
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          StyleElements = [seClient, seBorder]
        end
        object Label9: TLabel
          Left = 19
          Top = 194
          Width = 34
          Height = 15
          Caption = 'E-mail'
          FocusControl = DBEdit_email
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          StyleElements = [seClient, seBorder]
        end
        object Label4: TLabel
          Left = 19
          Top = 237
          Width = 58
          Height = 15
          Caption = 'URL da API'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          Visible = False
          StyleElements = [seClient, seBorder]
        end
        object DBEdit_fantasia: TDBEdit
          Left = 19
          Top = 40
          Width = 289
          Height = 23
          DataField = 'FANTASIA'
          DataSource = dsEmpresa
          TabOrder = 0
        end
        object DBEdit_razao: TDBEdit
          Left = 19
          Top = 82
          Width = 289
          Height = 23
          DataField = 'RAZAO'
          DataSource = dsEmpresa
          TabOrder = 1
        end
        object DBEdit_cnpj: TDBEdit
          Left = 19
          Top = 124
          Width = 289
          Height = 23
          CharCase = ecLowerCase
          DataField = 'CNPJ'
          DataSource = dsEmpresa
          TabOrder = 2
        end
        object DBEdit_responsavel: TDBEdit
          Left = 19
          Top = 167
          Width = 289
          Height = 23
          DataField = 'RESPONSAVEL_EMPRESA'
          DataSource = dsEmpresa
          TabOrder = 3
        end
        object DBEdit_email: TDBEdit
          Left = 19
          Top = 209
          Width = 289
          Height = 23
          CharCase = ecLowerCase
          DataField = 'EMAIL'
          DataSource = dsEmpresa
          TabOrder = 4
        end
        object edt_api2: TEdit
          Left = 19
          Top = 256
          Width = 289
          Height = 23
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          Visible = False
        end
        object cxButton_enviar_empresa: TButton
          Left = 19
          Top = 297
          Width = 289
          Height = 39
          Caption = 'SINCRONIZAR'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ImageIndex = 1
          ImageMargins.Left = 10
          ParentFont = False
          TabOrder = 6
          OnClick = cxButton_enviar_empresaClick
        end
      end
    end
  end
  object banco: TFDConnection
    Params.Strings = (
      'Server='
      'DriverID=MySQL')
    LoginPrompt = False
    OnError = bancoError
    Left = 576
    Top = 312
  end
  object FDQuery1: TFDQuery
    Connection = banco
    Left = 488
    Top = 176
    ParamData = <
      item
        Name = 'json'
        DataType = ftWideString
        FDDataType = dtWideString
      end>
  end
  object TrayIcon1: TTrayIcon
    AnimateInterval = 2
    Hint = 'Sincronizado'
    BalloonHint = 'Iniciando..'
    BalloonTimeout = 2
    PopupMenu = pmMenu
    OnDblClick = TrayIcon1DblClick
    Left = 618
    Top = 25
  end
  object ApplicationEvents1: TApplicationEvents
    OnMinimize = ApplicationEvents1Minimize
    Left = 626
    Top = 104
  end
  object TimeGo: TTimer
    Enabled = False
    OnTimer = TimeGoTimer
    Left = 456
    Top = 88
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'C:\Sistema\libmySQL.dll'
    Left = 616
    Top = 176
  end
  object Conexao: TFDConnection
    Params.Strings = (
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Protocol=TCPIP'
      'Server=localhost'
      'Port=3050'
      'Database=C:\Sistema\Dados\DADOS.FDB'
      'DriverID=FB')
    LoginPrompt = False
    Left = 800
    Top = 64
  end
  object qryAux: TFDQuery
    Connection = Conexao
    Left = 520
    Top = 56
  end
  object Transacao: TFDTransaction
    Connection = Conexao
    Left = 640
    Top = 352
  end
  object WaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 488
    Top = 312
  end
  object FBDriver: TFDPhysFBDriverLink
    VendorLib = 'C:\Sistema\fbclient.dll'
    Left = 648
    Top = 264
  end
  object IdHTTP1: TIdHTTP
    IOHandler = IdSSLIOHandlerSocketOpenSSL1
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoInProcessAuth, hoKeepOrigProtocol, hoForceEncodeParams]
    Left = 832
    Top = 208
  end
  object pmMenu: TPopupMenu
    Left = 578
    Top = 248
    object RestaurarAplicao1: TMenuItem
      Caption = 'Restaurar'
      OnClick = RestaurarAplicao1Click
    end
    object SairdaAplicao1: TMenuItem
      Caption = 'Sair'
      OnClick = SairdaAplicao1Click
    end
  end
  object tmrIniciar: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrIniciarTimer
    Left = 528
    Top = 104
  end
  object qryEmpresa: TFDQuery
    Connection = Conexao
    SQL.Strings = (
      
        'Select emp.*, cid.coduf VIRTUAL_ID_UF, cid.uf VIRTUAL_UF from em' +
        'presa emp'
      'left join cidade cid on cid.codigo=emp.id_cidade'
      '/*where*/'
      '/*ordem*/')
    Left = 425
    Top = 176
    object qryEmpresaCODIGO: TIntegerField
      FieldName = 'CODIGO'
      Origin = 'CODIGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryEmpresaFANTASIA: TStringField
      FieldName = 'FANTASIA'
      Origin = 'FANTASIA'
      Required = True
      Size = 50
    end
    object qryEmpresaRAZAO: TStringField
      FieldName = 'RAZAO'
      Origin = 'RAZAO'
      Required = True
      Size = 50
    end
    object qryEmpresaCNPJ: TStringField
      FieldName = 'CNPJ'
      Origin = 'CNPJ'
      Required = True
    end
    object qryEmpresaRESPONSAVEL_EMPRESA: TStringField
      FieldName = 'RESPONSAVEL_EMPRESA'
      Origin = 'RESPONSAVEL_EMPRESA'
      Size = 50
    end
    object qryEmpresaEMAIL: TStringField
      FieldName = 'EMAIL'
      Origin = 'EMAIL'
      Size = 100
    end
  end
  object dsEmpresa: TDataSource
    DataSet = qryEmpresa
    Left = 428
    Top = 248
  end
  object PopupMenu1: TPopupMenu
    Left = 424
    Top = 56
    object Copiar1: TMenuItem
      Caption = 'Copiar'
      OnClick = Copiar1Click
    end
  end
  object ImageList1: TImageList
    Height = 24
    Width = 24
    Left = 398
    Top = 131
    Bitmap = {
      494C010102000800040018001800FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000600000001800000001002000000000000024
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FBFBFF05D7DBFD31AEB4
      FB65AEB4FB65D7DBFD31FBFBFF05000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFFFE00F5FAF400EAF5
      E900EAF5E900F5FAF400FEFFFE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D4D6FD37656FF7C33B48F4F83643F4FF3643
      F4FF3643F4FF3643F4FF3B48F4F8656FF7C3D4D6FD3700000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F3FAF300D6ECD500CAE7CA00C9E6C800C9E6
      C800C9E6C800C9E6C800CAE7CA00D6ECD500F3FAF30000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F8FAFF079399F9893845F4FC3643F4FF3643F4FF3643F4FF3643
      F4FF3643F4FF3643F4FF3643F4FF3643F4FF3845F4FC9399F989F8FAFF070000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FEFEFD00E2F2E100CAE6C900C9E6C800C9E6C800C9E6C800C9E6
      C800C9E6C800C9E6C800C9E6C800C9E6C800CAE6C900E2F2E100FEFEFD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F8FAFF075C67F6CD3643F4FF3643F4FF3643F4FF3643F4FF3643F4FF3643
      F4FF3643F4FF3643F4FF3643F4FF3643F4FF3643F4FF3643F4FF5C67F6CDF8FA
      FF07000000000000000000000000000000000000000000000000000000000000
      0000FEFEFD00D4EBD300C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6
      C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800D4EBD300FEFE
      FD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009399F9893643F4FF3643F4FF3643F4FF3643F4FF3643F4FF3643F4FF3643
      F4FF3643F4FF3643F4FF3643F4FF3643F4FF3643F4FF3643F4FF3643F4FF9399
      F989000000000000000000000000000000000000000000000000000000000000
      0000E2F2E100C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6
      C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800E2F2
      E100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D4D6
      FD373845F4FC3643F4FF3643F4FF3643F4FF3744F4FF414DF5FF3643F4FF3643
      F4FF3643F4FF3643F4FF414DF5FF3744F4FF3643F4FF3643F4FF3643F4FF3845
      F4FCD4D6FD37000000000000000000000000000000000000000000000000F3FA
      F300CAE6C900C9E6C800C9E6C800C9E6C800C9E6C800BFE1BE0079C27600BFE1
      BE00C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800CAE6
      C900F3FAF3000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000656F
      F7C33643F4FF3643F4FF3643F4FF3744F4FFACB2FAFFDCDEFDFF4752F5FF3643
      F4FF3643F4FF4752F5FFDCDEFDFFACB2FAFF3744F4FF3643F4FF3643F4FF3643
      F4FF656FF7C3000000000000000000000000000000000000000000000000D6EC
      D500C9E6C800C9E6C800C9E6C800C9E6C800BFE1BD0064B8610050AF4C0065B8
      6100BFE1BE00C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6
      C800D6ECD5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FBFBFF053B48
      F4F83643F4FF3643F4FF3643F4FF414DF5FFDCDEFDFFFFFFFFFFDCDEFDFF4752
      F5FF4752F5FFDCDEFDFFFFFFFFFFDCDEFDFF414DF5FF3643F4FF3643F4FF3643
      F4FF3B48F4F8FBFBFF0500000000000000000000000000000000FEFFFE00CAE7
      CA00C9E6C800C9E6C800C9E6C800BEE1BD0064B8600050AF4C0051AF4D0050AF
      4C0064B86100BFE1BD00C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6
      C800CAE7CA00FEFFFE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D7DBFD313643
      F4FF3643F4FF3643F4FF3643F4FF3643F4FF4752F5FFDCDEFDFFFFFFFFFFDFE1
      FDFFDFE0FDFFFFFFFFFFDCDEFDFF4752F5FF3643F4FF3643F4FF3643F4FF3643
      F4FF3643F4FFD7DBFD3100000000000000000000000000000000F5FAF400C9E6
      C800C9E6C800C9E6C800BEE1BC0063B8600050AF4C0064B86100B5DDB40065B8
      610050AF4C0064B86100BFE1BD00C9E6C800C9E6C800C9E6C800C9E6C800C9E6
      C800C9E6C800F5FAF40000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000AEB4FB653643
      F4FF3643F4FF3643F4FF3643F4FF3643F4FF3643F4FF4752F5FFDFE1FDFFFFFF
      FFFFFFFFFFFFDFE0FDFF4752F5FF3643F4FF3643F4FF3643F4FF3643F4FF3643
      F4FF3643F4FFAEB4FB6500000000000000000000000000000000EAF5E900C9E6
      C800C9E6C800C9E6C80096CF940050AF4C0064B86000BFE1BD00C9E6C800BFE1
      BE0064B8610050AF4C0064B86000BEE1BD00C9E6C800C9E6C800C9E6C800C9E6
      C800C9E6C800EAF5E90000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000AEB4FB653643
      F4FF3643F4FF3643F4FF3643F4FF3643F4FF3643F4FF4752F5FFDFE0FDFFFFFF
      FFFFFFFFFFFFDFE1FDFF4752F5FF3643F4FF3643F4FF3643F4FF3643F4FF3643
      F4FF3643F4FFAEB4FB6500000000000000000000000000000000EAF5E900C9E6
      C800C9E6C800C9E6C800C9E6C80096CF9400BEE1BD00C9E6C800C9E6C800C9E6
      C800BFE1BD0064B8610050AF4C0064B86000BEE1BD00C9E6C800C9E6C800C9E6
      C800C9E6C800EAF5E90000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D7DBFD313643
      F4FF3643F4FF3643F4FF3643F4FF3643F4FF4752F5FFDCDEFDFFFFFFFFFFDFE0
      FDFFDFE1FDFFFFFFFFFFDCDEFDFF4752F5FF3643F4FF3643F4FF3643F4FF3643
      F4FF3643F4FFD7DBFD3100000000000000000000000000000000F5FAF400C9E6
      C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6
      C800C9E6C800BFE1BD0064B8600050AF4C0063B86000BEE1BD00C9E6C800C9E6
      C800C9E6C800F5FAF40000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FBFBFF053B48
      F4F83643F4FF3643F4FF3643F4FF414DF5FFDCDEFDFFFFFFFFFFDCDEFDFF4752
      F5FF4752F5FFDCDEFDFFFFFFFFFFDCDEFDFF414DF5FF3643F4FF3643F4FF3643
      F4FF3B48F4F8FBFBFF0500000000000000000000000000000000FEFFFE00CAE7
      CA00C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6
      C800C9E6C800C9E6C800BEE1BD0063B8600050AF4C0063B86000BEE1BC00C9E6
      C800CAE7CA00FEFFFE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000656F
      F7C33643F4FF3643F4FF3643F4FF3744F4FFACB2FAFFDCDEFDFF4752F5FF3643
      F4FF3643F4FF4752F5FFDCDEFDFFACB2FAFF3744F4FF3643F4FF3643F4FF3643
      F4FF656FF7C3000000000000000000000000000000000000000000000000D6EC
      D500C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6
      C800C9E6C800C9E6C800C9E6C800BEE1BD0063B8600050AF4C0096CF9400C9E6
      C800D6ECD5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D4D6
      FD373845F4FC3643F4FF3643F4FF3643F4FF3744F4FF414DF5FF3643F4FF3643
      F4FF3643F4FF3643F4FF414DF5FF3744F4FF3643F4FF3643F4FF3643F4FF3845
      F4FCD4D6FD37000000000000000000000000000000000000000000000000F3FA
      F300CAE6C900C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6
      C800C9E6C800C9E6C800C9E6C800C9E6C800BEE1BC0096CF9400C9E6C800CAE6
      C900F3FAF3000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009399F9893643F4FF3643F4FF3643F4FF3643F4FF3643F4FF3643F4FF3643
      F4FF3643F4FF3643F4FF3643F4FF3643F4FF3643F4FF3643F4FF3643F4FF9399
      F989000000000000000000000000000000000000000000000000000000000000
      0000E2F2E100C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6
      C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800E2F2
      E100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F8FAFF075C67F6CD3643F4FF3643F4FF3643F4FF3643F4FF3643F4FF3643
      F4FF3643F4FF3643F4FF3643F4FF3643F4FF3643F4FF3643F4FF5C67F6CDF8FA
      FF07000000000000000000000000000000000000000000000000000000000000
      0000FEFEFD00D4EBD300C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6
      C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800C9E6C800D4EBD300FEFE
      FD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000009399F9893845F4FC3643F4FF3643F4FF3643F4FF3643
      F4FF3643F4FF3643F4FF3643F4FF3643F4FF3845F4FC9399F989F8FAFF070000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FEFEFD00E2F2E100CAE6C900C9E6C800C9E6C800C9E6C800C9E6
      C800C9E6C800C9E6C800C9E6C800C9E6C800CAE6C900E2F2E100FEFEFD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D4D6FD37656FF7C33B48F4F83643F4FF3643
      F4FF3643F4FF3643F4FF3B48F4F8656FF7C3D4D6FD3700000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F3FAF300D6ECD500CAE7CA00C9E6C800C9E6
      C800C9E6C800C9E6C800CAE7CA00D6ECD500F3FAF30000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FBFBFF05D7DBFD31AEB4
      FB65AEB4FB65D7DBFD31FBFBFF05000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFFFE00F5FAF400EAF5
      E900EAF5E900F5FAF400FEFFFE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      2800000060000000180000000100010000000000200100000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF000000000000FFFFFFFF
      FFFF000000000000FF81FFFF81FF000000000000FE007FFE007F000000000000
      F8001FF8001F000000000000F0000FF0000F000000000000F0000FF0000F0000
      00000000E00007E00007000000000000E00007E00007000000000000C00003C0
      0003000000000000C00003C00003000000000000C00003C00003000000000000
      C00003C00003000000000000C00003C00003000000000000C00003C000030000
      00000000E00007E00007000000000000E00007E00007000000000000F0000FF0
      000F000000000000F0000FF0000F000000000000FC001FF8001F000000000000
      FE007FFE007F000000000000FF81FFFF81FF000000000000FFFFFFFFFFFF0000
      00000000FFFFFFFFFFFF00000000000000000000000000000000000000000000
      000000000000}
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Method = sslvSSLv23
    SSLOptions.SSLVersions = [sslvTLSv1_1, sslvTLSv1_2]
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 473
    Top = 317
  end
end
