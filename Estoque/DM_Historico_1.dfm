object DM_Historico: TDM_Historico
  Height = 480
  Width = 640
  object dsr_historico: TDataSource
    DataSet = qry_historico
    Left = 40
    Top = 24
  end
  object qry_historico: TFDQuery
    Connection = Frm_Principal.FDConnection1
    SQL.Strings = (
      'Select * From MOVIMENTACOES_ESTOQUE Where ID_PRODUTO = :ID')
    Left = 80
    Top = 24
    ParamData = <
      item
        Name = 'ID'
        ParamType = ptInput
      end>
  end
end
