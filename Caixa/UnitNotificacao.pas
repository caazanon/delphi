unit UnitNotificacao;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, System.Generics.Collections,
  Winapi.Windows, Vcl.Dialogs;

type
  /// <summary>
  /// Interface de notificação para registrar eventos do caixa eletrônico
  /// </summary>
  INotificador = interface
    ['{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}']
    
    /// <summary>
    /// Notifica um evento do sistema
    /// </summary>
    procedure Notificar(const AMensagem: string);
    
    /// <summary>
    /// Retorna o nome do notificador
    /// </summary>
    function Nome: string;
  end;

  /// <summary>
  /// Implementação de notificador que registra eventos em arquivo de texto
  /// </summary>
  TNotificadorArquivo = class(TInterfacedObject, INotificador)
  private
    FArquivoLog: string;
  public
    constructor Create(const AArquivoLog: string = 'log_caixa.txt');
    
    procedure Notificar(const AMensagem: string);
    function Nome: string;
  end;

  /// <summary>
  /// Implementação de notificador que exibe eventos no console
  /// </summary>
  TNotificadorConsole = class(TInterfacedObject, INotificador)
  public
    procedure Notificar(const AMensagem: string);
    function Nome: string;
  end;

  /// <summary>
  /// Gerenciador de notificações que permite registrar múltiplos notificadores
  /// </summary>
  TGerenciadorNotificacoes = class
  private
    FNotificadores: TList<INotificador>;
  public
    constructor Create;
    destructor Destroy; override;
    
    /// <summary>
    /// Adiciona um notificador ao sistema
    /// </summary>
    procedure AdicionarNotificador(ANotificador: INotificador);
    
    /// <summary>
    /// Notifica todos os notificadores registrados
    /// </summary>
    procedure NotificarTodos(const AMensagem: string);
  end;

implementation

{ TNotificadorArquivo }

constructor TNotificadorArquivo.Create(const AArquivoLog: string);
var
  LDiretorio: string;
begin
  inherited Create;
  if AArquivoLog.IsEmpty then
  begin
    // Usa o diretório de trabalho atual
    LDiretorio := GetCurrentDir + '\logs';
    if not TDirectory.Exists(LDiretorio) then
      TDirectory.CreateDirectory(LDiretorio);
    FArquivoLog := LDiretorio + '\log_caixa.txt';
  end
  else
  begin
    FArquivoLog := AArquivoLog;
    // Cria o diretório se não existir
    LDiretorio := ExtractFilePath(FArquivoLog);
    if (LDiretorio <> '') and not TDirectory.Exists(LDiretorio) then
      TDirectory.CreateDirectory(LDiretorio);
  end;
end;

procedure TNotificadorArquivo.Notificar(const AMensagem: string);
var
  LArquivo: TStringList;
  LDataHora: string;
begin
  LArquivo := TStringList.Create;
  try
    LDataHora := FormatDateTime('dd/mm/yyyy hh:nn:ss', Now);
    
    // Se o arquivo já existe, carrega o conteúdo
    if FileExists(FArquivoLog) then
      LArquivo.LoadFromFile(FArquivoLog);
      
    // Adiciona a nova entrada
    LArquivo.Add(Format('[%s] %s', [LDataHora, AMensagem]));
    
    LArquivo.SaveToFile(FArquivoLog);
  finally
    LArquivo.Free;
  end;
end;

function TNotificadorArquivo.Nome: string;
begin
  Result := 'Notificador de Arquivo (' + FArquivoLog + ')';
end;

{ TNotificadorConsole }

procedure TNotificadorConsole.Notificar(const AMensagem: string);
var
  LDataHora: string;
begin
  LDataHora := FormatDateTime('dd/mm/yyyy hh:nn:ss', Now);
  ShowMessage(Format('[%s] %s', [LDataHora, AMensagem]));
end;

function TNotificadorConsole.Nome: string;
begin
  Result := 'Notificador de Console';
end;

{ TGerenciadorNotificacoes }

constructor TGerenciadorNotificacoes.Create;
begin
  inherited Create;
  FNotificadores := TList<INotificador>.Create;
end;

destructor TGerenciadorNotificacoes.Destroy;
begin
  FNotificadores.Free;
  inherited Destroy;
end;

procedure TGerenciadorNotificacoes.AdicionarNotificador(ANotificador: INotificador);
begin
  if ANotificador <> nil then
    FNotificadores.Add(ANotificador);
end;

procedure TGerenciadorNotificacoes.NotificarTodos(const AMensagem: string);
var
  LNotificador: INotificador;
begin
  for LNotificador in FNotificadores do
    LNotificador.Notificar(AMensagem);
end;

end.
