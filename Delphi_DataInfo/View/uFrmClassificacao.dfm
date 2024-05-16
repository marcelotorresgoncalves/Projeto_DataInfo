object frmClassificacao: TfrmClassificacao
  Left = 0
  Top = 0
  Caption = 'Classifica'#231#227'o das Provas'
  ClientHeight = 322
  ClientWidth = 526
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object BitBtn1: TBitBtn
    Left = 112
    Top = 128
    Width = 265
    Height = 41
    Caption = 'Gerar Arquivo Classifica'#231#227'o das Provas'
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object qryProvas: TADOQuery
    Connection = dmConexao.ADOConexao
    Parameters = <>
    SQL.Strings = (
      'select cod_prova, nom_prova, tip_prova'
      'from provas')
    Left = 432
    Top = 8
  end
  object qryMarcas: TADOQuery
    Connection = dmConexao.ADOConexao
    Parameters = <>
    Left = 432
    Top = 64
  end
  object qryIncClassif: TADOQuery
    Connection = dmConexao.ADOConexao
    Parameters = <>
    Left = 432
    Top = 120
  end
  object qryExcluir: TADOQuery
    Connection = dmConexao.ADOConexao
    Parameters = <>
    SQL.Strings = (
      'delete  from class_prova')
    Left = 432
    Top = 176
  end
  object qryClassCidade: TADOQuery
    Connection = dmConexao.ADOConexao
    Parameters = <>
    SQL.Strings = (
      
        'select cidades.cod_cidade, nom_cidade, ouro, prata, bronze from ' +
        '('
      
        'select cod_cidade, count(1) ouro, 0 prata, 0 bronze from class_p' +
        'rova'
      'where posicao = 1'
      'group by cod_cidade'
      'union'
      
        'select cod_cidade, 0 ouro, count(1) prata, 0 bronze from class_p' +
        'rova'
      'where posicao = 2'
      'group by cod_cidade'
      'union'
      
        'select cod_cidade, 0 ouro, 0 prata, count(1) bronze from class_p' +
        'rova'
      'where posicao = 3'
      'group by cod_cidade'
      ') cl'
      'inner join CIDADES on cidades.cod_cidade = cl.cod_cidade'
      'order by 3 desc,4 desc,5 desc')
    Left = 432
    Top = 264
  end
  object qryClassAtleta: TADOQuery
    Connection = dmConexao.ADOConexao
    Parameters = <>
    SQL.Strings = (
      'select nom_prova, posicao, nom_atleta, marca, nom_cidade'
      'from class_prova cl'
      'inner join provas on provas.cod_prova = cl.cod_prova'
      'inner join cidades on cidades.cod_cidade = cl.cod_cidade'
      'order by nom_prova, posicao')
    Left = 432
    Top = 224
  end
end
