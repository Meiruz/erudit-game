Unit Unit1;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.Pngimage, Vcl.ExtCtrls,
    Vcl.StdCtrls, Vcl.Grids, MainUnit;

Type
    TStartForm = Class(TForm)
        CatImage: TImage;
        TitleLabel: TLabel;
        PlayerNames: TStringGrid;
        I: TImage;
        Image1: TImage;
        Label1: TLabel;
        Procedure Image1Click(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    StartForm: TStartForm;
    Scale: Integer;

Implementation

{$R *.dfm}

Procedure TStartForm.Image1Click(Sender: TObject);
var
    MainForm: TMainForm;
Begin
    // Get language and players and put them in function with creating of new form
    MainForm := TMainForm.Create(Self);

    Try
        MainForm.Language := RUS;
        MainForm.PlayerNames := ['Bob', 'Helen', 'Karl', 'david'];
        MainForm.ShowModal;
    Finally
        MainForm.Free;
    End;

End;

End.
