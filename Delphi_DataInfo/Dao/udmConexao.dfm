object dmConexao: TdmConexao
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 480
  Width = 640
  object ADOConexao: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;User ID=LAPTOP-98V7P5IQ\marc;Initial Catalog=BD_KHIPO;D' +
      'ata Source=LAPTOP-98V7P5IQ;'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 72
    Top = 96
  end
  object ADOLogin: TADOQuery
    Connection = ADOConexao
    Parameters = <
      item
        Name = 'nmeusuario'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 50
        Value = Null
      end
      item
        Name = 'snhusuario'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 20
        Value = Null
      end>
    SQL.Strings = (
      'Select cdgusuario '
      '  from usuario'
      ' where nmeusuario = :nmeusuario'
      '    and  snhusuario = :snhusuario')
    Left = 152
    Top = 96
  end
end
