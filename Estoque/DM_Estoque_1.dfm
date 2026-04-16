object DM_Estoque: TDM_Estoque
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object qry_Produtos: TFDQuery
    CachedUpdates = True
    Connection = Frm_Principal.FDConnection1
    SQL.Strings = (
      'Select * from PRODUTOS'
      '')
    Left = 104
    Top = 24
    ParamData = <
      item
        Name = 'ID'
        ParamType = ptInput
      end
      item
        Name = 'DESCRICAO'
        ParamType = ptInput
      end
      item
        Name = 'ESTOQUE_ATUAL'
        ParamType = ptInput
      end>
  end
  object dsr_Produtos: TDataSource
    DataSet = qry_Produtos
    Left = 48
    Top = 24
  end
  object qry_pesquisa: TFDQuery
    Connection = Frm_Principal.FDConnection1
    Left = 256
    Top = 22
  end
  object upt_Produtos: TFDUpdateSQL
    Connection = Frm_Principal.FDConnection1
    ModifySQL.Strings = (
      'update PRODUTOS set '
      'DESCRICAO = :DESCRICAO,'
      'ESTOQUE_ATUAL = :ESTOQUE_ATUAL'
      'WHERE ID = :OLD_ID')
    Left = 168
    Top = 24
  end
end
