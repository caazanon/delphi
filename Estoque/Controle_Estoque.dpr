program Controle_Estoque;

{$APPTYPE GUI}

{$R *.res}

uses
  Vcl.Forms,
  System.SysUtils,
  Estoque_1 in 'Estoque_1.pas' {Estoque},
  Produtos_1 in 'Produtos_1.pas' {Produtos},
  DM_Estoque_1 in 'DM_Estoque_1.pas' {DM_Estoque: TDataModule},
  DM_Produtos_1 in 'DM_Produtos_1.pas' {DM_Produtos: TDataModule},
  Principal in 'Principal.pas' {Frm_Principal},
  Vcl.Themes,
  Vcl.Styles,
  Historico_1 in 'Historico_1.pas' {Historico},
  DM_Historico_1 in 'DM_Historico_1.pas' {DM_Historico: TDataModule};

begin
  Application.Initialize;
  TStyleManager.TrySetStyle('Glow');
  Application.CreateForm(TFrm_Principal, Frm_Principal);
  Application.Run;
end.
