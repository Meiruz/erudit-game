program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {StartForm},
  MainUnit in 'MainForm\MainUnit.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TStartForm, StartForm);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
