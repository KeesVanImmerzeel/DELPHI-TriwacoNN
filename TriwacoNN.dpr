program TriwacoNN;

uses
  Vcl.Forms,
  u_TriwacoNN in 'u_TriwacoNN.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
