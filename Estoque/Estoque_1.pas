unit Estoque_1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Menus, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids;

type
  TEstoque = class(TForm)
    DbgEstoque: TDBGrid;
    btnNovoProduto: TBitBtn;
    BtnEditarProduto: TBitBtn;
    BitBtn3: TBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    btnAdicionarEstoque: TBitBtn;
    btnRemoverEstoque: TBitBtn;
    Histórico: TPopupMenu;
    Verhistrico1: TMenuItem;
    Panel3: TPanel;
    Label1: TLabel;
    procedure btnAdicionarEstoqueClick(Sender: TObject);
    procedure btnRemoverEstoqueClick(Sender: TObject);
    procedure btnNovoProdutoClick(Sender: TObject);
    procedure BtnEditarProdutoClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Verhistrico1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Estoque: TEstoque;

implementation

{$R *.dfm}

uses
  DM_Estoque_1, Principal, Produtos_1, DM_Produtos_1, DM_Historico_1, Historico_1;


procedure TEstoque.BtnEditarProdutoClick(Sender: TObject);
var
  ValorStr: string;
begin
  // Abre InputBox para editar a descrição do produto
  ValorStr := InputBox('Entrada de Valor', 'Digite a nova descrição do produto:', '');

  if Trim(ValorStr) <> '' then
  begin
    Dm_Estoque.qry_pesquisa.SQL.Text := 'UPDATE PRODUTOS SET DESCRICAO = :Desc WHERE ID = :ID';
    Dm_Estoque.qry_pesquisa.ParamByName('Desc').AsString := ValorStr;
    Dm_Estoque.qry_pesquisa.ParamByName('ID').AsInteger := DbgEstoque.DataSource.DataSet.FieldByName('ID').AsInteger;
    Dm_Estoque.qry_pesquisa.ExecSQL;
  end
  else
  begin
    ShowMessage('Descrição não pode ser vazia.');
  end;

  DbgEstoque.DataSource.DataSet.Refresh;
end;


procedure TEstoque.btnNovoProdutoClick(Sender: TObject);
var
  ValorStr: string;
begin
  // Abre InputBox para incluir a descrição do produto
  ValorStr := InputBox('Entrada de Valor', 'Digite a descrição do novo produto:', '');

  if Trim(ValorStr) <> '' then
  begin
    Dm_Estoque.qry_pesquisa.SQL.Text := 'INSERT INTO PRODUTOS (DESCRICAO, ESTOQUE_ATUAL) VALUES (:Desc, 0)';
    Dm_Estoque.qry_pesquisa.ParamByName('Desc').AsString := ValorStr;
    Dm_Estoque.qry_pesquisa.ExecSQL;
  end
  else
  begin
    ShowMessage('Descrição não pode ser vazia.');
  end;

  DbgEstoque.DataSource.DataSet.Refresh;
end;

procedure TEstoque.BitBtn3Click(Sender: TObject);
var
  Resposta: Integer;
begin
//Exclusão de Produtos
  Resposta := MessageBox(Handle, 'Deseja excluir o produto selecionado?', 'Excluir Produto', MB_ICONQUESTION or MB_YESNO);
  if Resposta = IDYES then
  begin
    Dm_Estoque.qry_pesquisa.SQL.Text := 'DELETE FROM PRODUTOS WHERE ID = :ID';
    Dm_Estoque.qry_pesquisa.ParamByName('ID').AsInteger := DbgEstoque.DataSource.DataSet.FieldByName('ID').AsInteger;
    Dm_Estoque.qry_pesquisa.ExecSQL;
    ShowMessage('Produto excluído.');
  end
  else
    Abort;

  DbgEstoque.DataSource.DataSet.Refresh;
end;

procedure TEstoque.btnAdicionarEstoqueClick(Sender: TObject);
var
  ValorStr: string;
  ValorInt: Integer;
begin

//Abre inputbox para fazer adição do estoque
  ValorStr := InputBox('Entrada de Valor', 'Digite o valor para adicionar no estoque:', '');

  if TryStrToInt(ValorStr, ValorInt) then
  begin
    Dm_Estoque.qry_pesquisa.sql.Text := 'Update PRODUTOS set ESTOQUE_ATUAL = ESTOQUE_ATUAL + :Estoque where ID = :ID';
    Dm_Estoque.qry_pesquisa.parambyname('Estoque').AsInteger := ValorInt;
    Dm_Estoque.qry_pesquisa.ParamByName('ID').AsInteger := DbgEstoque.DataSource.DataSet.FieldByName('ID').AsInteger;
    Dm_Estoque.qry_pesquisa.Execsql;
  end
  else
  begin
    ShowMessage('Valor inválido. Digite apenas números inteiros.');
  end;

  DbgEstoque.DataSource.DataSet.Refresh;
end;

procedure TEstoque.btnRemoverEstoqueClick(Sender: TObject);
var
  ValorStr: string;
  ValorInt: Integer;
begin

//Abre inputbox para fazer remoção do estoque
  ValorStr := InputBox('Saída de Valor', 'Digite o valor para remover do estoque:', '');

  if TryStrToInt(ValorStr, ValorInt) then
  begin
    Dm_Estoque.qry_pesquisa.sql.Text := 'Update PRODUTOS set ESTOQUE_ATUAL = ESTOQUE_ATUAL + (:Estoque) where ID = :ID';
    Dm_Estoque.qry_pesquisa.parambyname('Estoque').AsInteger := ValorInt * -1;
    Dm_Estoque.qry_pesquisa.ParamByName('ID').AsInteger := DbgEstoque.DataSource.DataSet.FieldByName('ID').AsInteger;
    Dm_Estoque.qry_pesquisa.Execsql;
  end
  else
  begin
    ShowMessage('Valor inválido. Digite apenas números inteiros.');
  end;

  DbgEstoque.DataSource.DataSet.Refresh;
end;


procedure TEstoque.Verhistrico1Click(Sender: TObject);
begin
  DM_Historico := TDM_Historico.Create(Application);
  Historico := THistorico.Create(Application);
  try
    Historico.ID := DbgEstoque.DataSource.DataSet.FieldByName('ID').AsInteger;
    Historico.ShowModal;
  finally
    FreeAndNil(Historico);
    FreeAndNil(DM_Historico);
  end;
end;

end.
