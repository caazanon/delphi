unit unitOperacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UnitInventario, UnitEstrategiaSaque, UnitNotificacao,
  UnitConta;

type
  TfrmOperacao = class(TForm)
    btnAdicionar: TButton;
    btnRemover: TButton;
    btnConsultar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
  private
    FInventario: TInventario;
    FEstrategia: IEstrategiaComposicao;
    FNotificadores: TGerenciadorNotificacoes;
    FConta: TConta;
  public
    property Conta: TConta read FConta write FConta;
  end;

implementation

{$R *.dfm}

procedure TfrmOperacao.FormCreate(Sender: TObject);
begin
  FInventario := TInventario.Create;
  // Estratégia configurada externamente (padrão: Menor Quantidade)
  FEstrategia := TEstrategiaMenorQuantidade.Create;
  // Registra os notificadores uma única vez
  FNotificadores := TGerenciadorNotificacoes.Create;
  FNotificadores.AdicionarNotificador(TNotificadorArquivo.Create);
  FNotificadores.AdicionarNotificador(TNotificadorConsole.Create);
end;

procedure TfrmOperacao.FormDestroy(Sender: TObject);
begin
  FNotificadores.Free;
  FInventario.Free;
end;

procedure TfrmOperacao.btnAdicionarClick(Sender: TObject);
var
  LValor: Currency;
  LQuantidade: Integer;
  LInput: string;
begin
  // Solicita o tipo da cédula
  LInput := InputBox('Adicionar', 'Digite o tipo da Cédula (notas/centávos) ex: 5, 10, 50, 100:', '');
  if not TryStrToCurr(LInput, LValor) then
  begin
    ShowMessage('Valor inválido!');
    Exit;
  end;

  // Solicita a quantidade
  LInput := InputBox('Digite a quantidade: ', 'Quantidade:', '1');
  if not TryStrToInt(LInput, LQuantidade) then
  begin
    ShowMessage('Quantidade inválida!');
    Exit;
  end;

  try
    FInventario.AdicionarCaixa(LValor, LQuantidade);
    FNotificadores.NotificarTodos(Format('Adicionado: %d unidade(s) de R$ %s', [LQuantidade, FormatFloat('0.00', LValor)]));
    FConta.Creditar(FInventario.ValorTotal);
  except
    on E: Exception do
      ShowMessage('Erro: ' + E.Message);
  end;
end;

procedure TfrmOperacao.btnRemoverClick(Sender: TObject);
var
  LValor: Currency;
  LInput: string;
  LResultado: TResultadoSaque;
  I: Integer;
  LMensagem: string;
begin
  // Verifica se há saldo
  if FInventario.ValorTotal = 0 then
  begin
    ShowMessage('O caixa está vazio. Não é possível realizar saque.');
    Exit;
  end;

  // Solicita o valor do saque
  LInput := InputBox('Saque', 'Digite o valor do saque:', '');
  if not TryStrToCurr(LInput, LValor) then
  begin
    ShowMessage('Valor inválido!');
    Exit;
  end;

  if LValor <= 0 then
  begin
    ShowMessage('Valor deve ser maior que zero!');
    Exit;
  end;

  // Executa o saque usando a estratégia configurada
  // O usuário não sabe qual estratégia está sendo usada
  LResultado := FEstrategia.ComporValor(LValor, FInventario);

  if LResultado.Sucesso then
  begin
    LMensagem := 'Saque realizado com sucesso!' + #13#10 +
                'Cédulas entregues:' + #13#10;

    for I := 0 to Length(LResultado.Cedulas) - 1 do
      LMensagem := LMensagem + '  ' + LResultado.Cedulas[I].ToString + #13#10;

    LMensagem := LMensagem + 'Total: R$ ' + FormatFloat('0.00', LResultado.ValorTotal);

    FNotificadores.NotificarTodos(LMensagem);
    FConta.Debitar(LResultado.ValorTotal);
  end
  else
  begin
    FNotificadores.NotificarTodos('Falha no saque: ' + LResultado.Mensagem);
  end;
end;

procedure TfrmOperacao.btnConsultarClick(Sender: TObject);
var
  LCaixa: TArray<TCaixa>;
  I: Integer;
  LMensagem: string;
begin
  LCaixa := FInventario.ObterCaixa;

  // Cabeçalho com informações da conta
  if FConta <> nil then
    LMensagem := 'Conta: ' + FConta.Identificador + #13#10 +
                 'Saldo: R$ ' + FormatFloat('0.00', FConta.Saldo) + #13#10 +
                 '----------------------------------------' + #13#10
  else
    LMensagem := 'Conta: Não vinculada' + #13#10 +
                 '----------------------------------------' + #13#10;

  if Length(LCaixa) = 0 then
  begin
    LMensagem := LMensagem + 'Não há lançamentos recentes';
    FNotificadores.NotificarTodos(LMensagem);
    Exit;
  end;

  LMensagem := LMensagem + 'Últimos lançamentos:' + #13#10;
  for I := 0 to Length(LCaixa) - 1 do
    LMensagem := LMensagem + '  ' + LCaixa[I].ToString + #13#10;

  LMensagem := LMensagem + '----------------------------------------' + #13#10 +
               'Valor Total em Caixa: R$ ' + FormatFloat('0.00', FConta.Saldo);

  FNotificadores.NotificarTodos(LMensagem);
end;

end.
