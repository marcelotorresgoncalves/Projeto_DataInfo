unit uFrmClassificacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Data.DB,
  Data.Win.ADODB;

type
  TfrmClassificacao = class(TForm)
    BitBtn1: TBitBtn;
    qryProvas: TADOQuery;
    qryMarcas: TADOQuery;
    qryIncClassif: TADOQuery;
    qryExcluir: TADOQuery;
    qryClassCidade: TADOQuery;
    qryClassAtleta: TADOQuery;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    Posicao : Integer;
    MarcaAnt : Double;
    procedure PGerarClassificacao;
    procedure PClassifica( vCodProva : Integer );
    procedure PGravaClassificacao( vPosicao : Integer; vCodProva : Integer );
    procedure PExcluirClassificacao;
    procedure PGerarArquivo;
  public
    { Public declarations }
  end;

var
  frmClassificacao: TfrmClassificacao;

implementation

{$R *.dfm}

uses udmConexao;

{ TfrmClassificacao }

procedure TfrmClassificacao.BitBtn1Click(Sender: TObject);
begin
  PGerarClassificacao;
  PGerarArquivo;
  messagedlg( 'Classificação Concluída.',mtInformation,[mbok],0 );
end;

procedure TfrmClassificacao.PClassifica( vCodProva : Integer );
begin
  Inc( Posicao );
  if ( MarcaAnt <> 0 ) and ( MarcaAnt = qryMarcas.FieldByName('marca').AsFloat ) then
    dec( Posicao );

  if ( qryMarcas.FieldByName('proximo').AsInteger = 0 ) or ( qryMarcas.FieldByName('anterior').AsInteger = 0 ) then
    posicao := 1;

  PGravaClassificacao( Posicao, vCodProva );

  MarcaAnt := qryMarcas.FieldByName('marca').AsFloat;
end;

procedure TfrmClassificacao.PExcluirClassificacao;
begin
  qryExcluir.ExecSQL;
end;

procedure TfrmClassificacao.PGerarArquivo;
var tf:TextFile; sArq, slinha:String; vInd : Integer;
begin
  sArq := ExtractFilePath( ParamStr(0) ) + 'ClassProva.txt';
  if fileexists( sArq ) then
    deleteFile( sArq );

  AssignFile( tf, sArq );
  try
    ReWrite( tf );
    writeln( tf, 'Nome da prova; Posição; Nome do Atleta; Marca; Cidade' );
    qryClassAtleta.Close;
    qryClassAtleta.Open;
    while not qryClassAtleta.EOF do
    begin
      slinha := qryClassAtleta.FieldByName('nom_prova').AsString+ ';'+
        qryClassAtleta.FieldByName('posicao').AsString+ ';'+
        qryClassAtleta.FieldByName('nom_atleta').AsString+ ';'+
        qryClassAtleta.FieldByName('marca').AsString+ ';'+
        qryClassAtleta.FieldByName('nom_cidade').AsString;
      writeln( tf, slinha );
      qryClassAtleta.Next;
    end;
    writeln( tf, 'Colocação;Nome da Cidade; Número de medalhas de Ouro; Número de medalhas de Prata; Número de medalhas de Bronze' );
    qryClassCidade.Close;
    qryClassCidade.Open;
    vInd := 1;
    while not qryClassCidade.EOF do
    begin
      slinha := vInd.ToString + ';'+ qryClassCidade.FieldByName('nom_cidade').AsString+ ';'+
        qryClassCidade.FieldByName('ouro').AsString+ ';'+
        qryClassCidade.FieldByName('prata').AsString+';'+
        qryClassCidade.FieldByName('bronze').AsString;
      writeln( tf, slinha );
      inc( vInd );
      qryClassCidade.Next;
    end;
  finally
    CloseFile( tf );
  end;
end;

procedure TfrmClassificacao.PGerarClassificacao;
begin
   PExcluirClassificacao;

   qryProvas.Close;
   qryProvas.Open;
   while not qryProvas.EOF do
   begin
     qryMarcas.Close;
     qryMarcas.SQL.Text := 'select TOP 20 COD_ATLETA,NOM_ATLETA,COD_CIDADE,MARCA,'+
        ' LEAD(marca, 1,0) OVER (ORDER BY marca ) proximo, lag(marca, 1,0) OVER (ORDER BY marca ) anterior'+
        ' from marcas '+
        ' where cod_prova = '+ qryProvas.FieldByName('cod_prova').AsString +
        ' order by marca';
     if qryProvas.FieldByName('tip_prova').AsString = '+' then
        qryMarcas.SQL.Text :=     qryMarcas.SQL.Text + ' desc';
     MarcaAnt := 0;
     qryMarcas.Open;
     while not qryMarcas.EOF do
     begin
       PClassifica( qryProvas.FieldByName('cod_prova').AsInteger );
       if Posicao = 3 then
         Break;
       qryMarcas.Next;
     end;
     qryProvas.Next;
   end;
end;

procedure TfrmClassificacao.PGravaClassificacao( vPosicao : Integer; vCodProva : Integer );
begin
  qryIncClassif.Close;
  qryIncClassif.SQL.Text:= 'Insert Into class_prova ( cod_prova, cod_atleta, nom_atleta, cod_cidade, marca , posicao)' +
    ' values ( :cod_prova, :cod_atleta, :nom_atleta, :cod_cidade, :marca, :posicao )';
  qryIncClassif.Parameters[0].Value := vCodProva;
  qryIncClassif.Parameters[1].Value := qryMarcas.FieldByName('cod_atleta').AsString;
  qryIncClassif.Parameters[2].Value := qryMarcas.FieldByName('nom_atleta').AsString;
  qryIncClassif.Parameters[3].Value := qryMarcas.FieldByName('cod_cidade').AsString;
  qryIncClassif.Parameters[4].Value := qryMarcas.FieldByName('marca').AsFloat;
  qryIncClassif.Parameters[5].Value := vPosicao;
  qryIncClassif.ExecSQL;
end;

end.
