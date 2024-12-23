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
    Background: TImage;
        Image1: TImage;
        Label1: TLabel;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label2: TLabel;
    ArrayInputGrid: TStringGrid;
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
    lang: TLang;
    I, ColPlayers: Integer;
    names: TArrayStr;
Begin
    if RadioButton1.Enabled then
        lang := RUS
    else
        lang := ENG;

    colPlayers := 0;
    for I := 0 to 4 do
        if ArrayInputGrid.Cells[0, I] <> '' then
            inc(colPlayers);

    if colPlayers > 2 then
    begin
        setLength(names, colPlayers);
        var j := 0;

        for I := 0 to 4 do
            if ArrayInputGrid.Cells[0, I] <> '' then
            begin
                names[j] := ArrayInputGrid.Cells[0, I];
                inc(j);
            end;

        // Get language and players and put them in function with creating of new form
        MainForm := TMainForm.Create(Self);

        Try
            MainForm.Language := lang;
            MainForm.PlayerNames := names;
            StartForm.Visible := false;
            MainForm.ShowModal;
        Finally
            MainForm.Free;
        End;
    end;

End;

End.
