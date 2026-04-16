object Produtos: TProdutos
  Left = 0
  Top = 0
  Caption = 'Cadastro de Produtos'
  ClientHeight = 441
  ClientWidth = 684
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object lblTitulo: TLabel
    Left = 312
    Top = 0
    Width = 150
    Height = 21
    Caption = 'Cadastro de Produtos'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 684
    Height = 441
    ActivePage = PagPesquisa
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    MultiLine = True
    ParentFont = False
    TabOrder = 0
    object PagPesquisa: TTabSheet
      Caption = 'PagPesquisa'
      object Panel1: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 100
        Width = 670
        Height = 284
        Align = alClient
        AutoSize = True
        TabOrder = 0
        ExplicitTop = 105
        ExplicitHeight = 303
        object dbgProdutos: TDBGrid
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 662
          Height = 276
          Align = alClient
          DataSource = DM_Produtos.dsr_Produtos
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'ID'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DESCRICAO'
              Width = 400
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ESTOQUE_ATUAL'
              Width = 100
              Visible = True
            end>
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 676
        Height = 97
        Align = alTop
        TabOrder = 1
        ExplicitTop = 5
        object lblDescricao: TLabel
          Left = 16
          Top = 60
          Width = 114
          Height = 15
          Caption = 'Descri'#231#227'o do Produto'
        end
        object btnIncluir: TBitBtn
          Left = 3
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Incluir'
          TabOrder = 0
          OnClick = btnIncluirClick
        end
        object btnAlterar: TBitBtn
          Left = 84
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Alterar'
          TabOrder = 1
          OnClick = btnAlterarClick
        end
        object edtDescricao: TEdit
          Left = 144
          Top = 57
          Width = 329
          Height = 23
          TabOrder = 2
        end
        object btnPesquisar: TBitBtn
          Left = 479
          Top = 56
          Width = 75
          Height = 25
          Caption = 'Pesquisar'
          TabOrder = 3
          OnClick = btnPesquisarClick
        end
      end
    end
    object PagManutencao: TTabSheet
      Caption = 'PagManutencao'
      ImageIndex = 1
      object lblDescricaoEdit: TLabel
        Left = 46
        Top = 43
        Width = 51
        Height = 15
        Caption = 'Descri'#231#227'o'
      end
      object lblEstqAtual: TLabel
        Left = 24
        Top = 88
        Width = 73
        Height = 15
        Caption = 'Estoque Atual'
      end
      object edtDescricaoEdit: TDBEdit
        Left = 112
        Top = 40
        Width = 409
        Height = 23
        DataField = 'DESCRICAO'
        DataSource = DM_Produtos.dsr_Produtos
        ReadOnly = True
        TabOrder = 0
      end
      object dbEstqAtual: TDBEdit
        Left = 112
        Top = 85
        Width = 73
        Height = 23
        DataField = 'ESTOQUE_ATUAL'
        DataSource = DM_Produtos.dsr_Produtos
        Enabled = False
        TabOrder = 3
      end
      object btnSalvar: TBitBtn
        Left = 24
        Top = 152
        Width = 75
        Height = 25
        Caption = 'Salvar'
        TabOrder = 1
        OnClick = btnSalvarClick
      end
      object btnCancelar: TBitBtn
        Left = 105
        Top = 152
        Width = 75
        Height = 25
        Caption = 'Cancelar'
        TabOrder = 2
        OnClick = btnCancelarClick
      end
    end
  end
end
