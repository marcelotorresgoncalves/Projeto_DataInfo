program Proj_DataInfo;

uses
  Vcl.Forms,
  Vcl.Dialogs,
  uFrmClassificacao in 'uFrmClassificacao.pas' {frmClassificacao},
  udmConexao in '..\Dao\udmConexao.pas' {dmConexao: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmConexao, dmConexao);
  if dmconexao.Conexao.fncConectar then
  begin
    Application.CreateForm(TfrmClassificacao, frmClassificacao);
    Application.Run;
  end
  else
  begin
    MessageDlg('Falha ao conectar base de dados.',mtInformation,[mbok],0);
    Application.Terminate;
  end;
end.
