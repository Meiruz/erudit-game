program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {StartForm},
  MainUnit in 'MainForm\MainUnit.pas' {MainForm},
  Unit2 in 'SwapBonus\Unit2.pas' {SwapLetters},
  Unit3 in 'Bonus50\Unit3.pas' {Bonus50},
  Unit4 in 'helper\Unit4.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TStartForm, StartForm);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSwapLetters, SwapLetters);
  Application.CreateForm(TBonus50, Bonus50);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
