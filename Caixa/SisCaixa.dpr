program SisCaixa;

uses
  Vcl.Forms,
  System.UITypes,
  unitOperacao in 'unitOperacao.pas',
  UnitEstrategiaSaque in 'UnitEstrategiaSaque.pas',
  UnitInventario in 'UnitInventario.pas',
  unitLogin in 'unitLogin.pas' {frmLogin},
  UnitConta in 'UnitConta.pas',
  UnitNotificacao in 'UnitNotificacao.pas';

{$R *.res}

var
  LoginForm: TfrmLogin;
  OperacaoForm: TfrmOperacao;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  LoginForm := TfrmLogin.Create(nil);
  try
    if LoginForm.ShowModal = mrOk then
    begin
      OperacaoForm := TfrmOperacao.Create(nil);
      try
        OperacaoForm.Conta := LoginForm.ContaAutenticada;
        OperacaoForm.ShowModal;
      finally
        OperacaoForm.Free;
      end;
    end;
  finally
    LoginForm.Free;
  end;
end.
