unit DM_Estoque_1;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Principal;

type
  TDM_Estoque = class(TDataModule)
    qry_Produtos: TFDQuery;
    dsr_Produtos: TDataSource;
    qry_pesquisa: TFDQuery;
    upt_Produtos: TFDUpdateSQL;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM_Estoque: TDM_Estoque;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}


procedure TDM_Estoque.DataModuleCreate(Sender: TObject);
begin
  qry_Produtos.Open;
end;

end.
