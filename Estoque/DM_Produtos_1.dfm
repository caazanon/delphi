object DM_Produtos: TDM_Produtos
  Height = 480
  Width = 640
  object dsr_Produtos: TDataSource
    DataSet = qry_Produtos
    Left = 48
    Top = 24
  end
  object qry_Produtos: TFDQuery
    Connection = Frm_Principal.FDConnection1
    SQL.Strings = (
      'Select * from PRODUTOS'
      '')
    Left = 104
    Top = 24
    ParamData = <
      item
        Name = 'DESCRICAO'
        ParamType = ptInput
      end
      item
        Name = 'ESTOQUE_ATUAL'
        ParamType = ptInput
      end>
    object qry_ProdutosID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object qry_ProdutosDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Origin = 'DESCRICAO'
      Required = True
      Size = 100
    end
    object qry_ProdutosESTOQUE_ATUAL: TIntegerField
      FieldName = 'ESTOQUE_ATUAL'
      Origin = 'ESTOQUE_ATUAL'
      Required = True
    end
  end
  object upt_Produtos: TFDUpdateSQL
    Connection = Frm_Principal.FDConnection1
    InsertSQL.Strings = (
      'INSERT INTO PRODUTOS (DESCRICAO, ESTOQUE_ATUAL)'
      'VALUES (:Descricao, 0)')
    ModifySQL.Strings = (
      'update PRODUTOS set '
      'DESCRICAO = :DESCRICAO,'
      'ESTOQUE_ATUAL = :ESTOQUE_ATUAL'
      'WHERE ID = :OLD_ID')
    Left = 168
    Top = 24
  end
end
