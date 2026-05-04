unit UnitConta;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.IniFiles;

type
  /// <summary>
  /// Representa uma conta de usuário do caixa eletrônico
  /// </summary>
  TConta = class
  private
    FIdentificador: string;
    FSaldo: Currency;
    FArquivoIni: string;
    procedure SalvarNoIni;
  public
    constructor Create(const AIdentificador: string; ASaldoInicial: Currency = 0;
      const AArquivoIni: string = '');
    
    /// <summary>
    /// Identificador único para autenticação
    /// </summary>
    property Identificador: string read FIdentificador;
    
    /// <summary>
    /// Saldo atual da conta
    /// </summary>
    property Saldo: Currency read FSaldo;
    
    /// <summary>
    /// Adiciona valor ao saldo (depósito)
    /// </summary>
    procedure Creditar(AValor: Currency);
    
    /// <summary>
    /// Remove valor do saldo (saque)
    /// </summary>
    procedure Debitar(AValor: Currency);
  end;

  /// <summary>
  /// Gerenciador de contas de usuários - persiste em arquivo .ini
  /// </summary>
  TGerenciadorContas = class
  private
    FContas: TDictionary<string, TConta>;
    FArquivoIni: string;
    procedure CarregarContas;
    procedure SalvarContaNoIni(const AConta: TConta);
  public
    constructor Create(const AArquivoIni: string = '');
    destructor Destroy; override;
    
    /// <summary>
    /// Cria uma nova conta e salva no .ini
    /// </summary>
    function CriarConta(const AIdentificador: string; ASaldoInicial: Currency = 0): TConta;
    
    /// <summary>
    /// Busca uma conta pelo identificador (carrega do .ini se necessário)
    /// </summary>
    function BuscarConta(const AIdentificador: string): TConta;
    
    /// <summary>
    /// Verifica se uma conta existe (no .ini ou na memória)
    /// </summary>
    function ContaExiste(const AIdentificador: string): Boolean;
    
    /// <summary>
    /// Força recarregar todas as contas do .ini
    /// </summary>
    procedure RecarregarContas;
  end;

implementation

{ TConta }

constructor TConta.Create(const AIdentificador: string; ASaldoInicial: Currency;
  const AArquivoIni: string);
begin
  inherited Create;
  FIdentificador := AIdentificador;
  FSaldo := ASaldoInicial;
  FArquivoIni := AArquivoIni;
end;

procedure TConta.SalvarNoIni;
var
  LIni: TIniFile;
begin
  if FArquivoIni.IsEmpty then Exit;
  
  LIni := TIniFile.Create(FArquivoIni);
  try
    LIni.WriteString('Contas', FIdentificador, FormatFloat('0.00', FSaldo));
  finally
    LIni.Free;
  end;
end;

procedure TConta.Creditar(AValor: Currency);
begin
  FSaldo := FSaldo + AValor;
  SalvarNoIni;
end;

procedure TConta.Debitar(AValor: Currency);
begin
  FSaldo := FSaldo - AValor;
  SalvarNoIni;
end;

{ TGerenciadorContas }

constructor TGerenciadorContas.Create(const AArquivoIni: string);
begin
  inherited Create;
  FContas := TDictionary<string, TConta>.Create;
  
  if AArquivoIni.IsEmpty then
    FArquivoIni := GetCurrentDir + '\contas.ini'
  else
    FArquivoIni := AArquivoIni;
    
  CarregarContas;
end;

destructor TGerenciadorContas.Destroy;
var
  LConta: TConta;
begin
  for LConta in FContas.Values do
    LConta.Free;
  FContas.Free;
  inherited Destroy;
end;

procedure TGerenciadorContas.CarregarContas;
var
  LIni: TIniFile;
  LIdentificadores: TStringList;
  I: Integer;
  LIdentificador: string;
  LSaldo: Currency;
  LConta: TConta;
begin
  if not FileExists(FArquivoIni) then Exit;
  
  LIni := TIniFile.Create(FArquivoIni);
  LIdentificadores := TStringList.Create;
  try
    LIni.ReadSection('Contas', LIdentificadores);
    
    for I := 0 to LIdentificadores.Count - 1 do
    begin
      LIdentificador := LIdentificadores[I];
      LSaldo := StrToCurrDef(LIni.ReadString('Contas', LIdentificador, '0'), 0);
      
      // Cria a conta na memória
      LConta := TConta.Create(LIdentificador, LSaldo, FArquivoIni);
      FContas.AddOrSetValue(LIdentificador, LConta);
    end;
  finally
    LIdentificadores.Free;
    LIni.Free;
  end;
end;

procedure TGerenciadorContas.SalvarContaNoIni(const AConta: TConta);
var
  LIni: TIniFile;
begin
  LIni := TIniFile.Create(FArquivoIni);
  try
    LIni.WriteString('Contas', AConta.Identificador, FormatFloat('0.00', AConta.Saldo));
  finally
    LIni.Free;
  end;
end;

function TGerenciadorContas.CriarConta(const AIdentificador: string; 
  ASaldoInicial: Currency): TConta;
var
  LConta: TConta;
begin
  if FContas.ContainsKey(AIdentificador) then
    raise Exception.Create('Ja existe uma conta com este identificador');
    
  // Verifica se ja existe no arquivo ini
  if FileExists(FArquivoIni) then
  begin
    LConta := BuscarConta(AIdentificador);
    if LConta <> nil then
      raise Exception.Create('Ja existe uma conta com este identificador');
  end;
    
  Result := TConta.Create(AIdentificador, ASaldoInicial, FArquivoIni);
  FContas.Add(AIdentificador, Result);
  
  // Salva no arquivo ini
  SalvarContaNoIni(Result);
end;

function TGerenciadorContas.BuscarConta(const AIdentificador: string): TConta;
var
  LIni: TIniFile;
  LSaldo: Currency;
  LConta: TConta;
begin
  Result := nil;
  
  // Primeiro procura na memória
  if FContas.TryGetValue(AIdentificador, Result) then
    Exit;
    
  // Se não encontrou na memória, procura no arquivo ini
  if FileExists(FArquivoIni) then
  begin
    LIni := TIniFile.Create(FArquivoIni);
    try
      LSaldo := StrToCurrDef(LIni.ReadString('Contas', AIdentificador, ''), -1);
      if LSaldo >= 0 then
      begin
        // Cria a conta na memória
        LConta := TConta.Create(AIdentificador, LSaldo, FArquivoIni);
        FContas.Add(AIdentificador, LConta);
        Result := LConta;
      end;
    finally
      LIni.Free;
    end;
  end;
end;

function TGerenciadorContas.ContaExiste(const AIdentificador: string): Boolean;
begin
  // Verifica na memória
  if FContas.ContainsKey(AIdentificador) then
  begin
    Result := True;
    Exit;
  end;
  
  // Verifica no arquivo ini
  Result := False;
  if FileExists(FArquivoIni) then
  begin
    with TIniFile.Create(FArquivoIni) do
    try
      Result := ValueExists('Contas', AIdentificador);
    finally
      Free;
    end;
  end;
end;

procedure TGerenciadorContas.RecarregarContas;
begin
  // Limpa contas da memória
  FContas.Clear;
  // Recarrega do arquivo ini
  CarregarContas;
end;

end.
