Unit Unit3;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.Pngimage, Vcl.ExtCtrls,
    Vcl.StdCtrls, MainUnit;

Type
    TArrayStr = Array Of String;
    TArrayInt = Array Of Integer;

    TBonus50 = Class(TForm)
        I: TImage;
        Procedure FormShow(Sender: TObject);
        Procedure ButtonClick(Sender: TObject);
        Procedure SwapBtnClick(Sender: TObject);

    Private
        { Private declarations }
    Public
        PlayerLetters: TArrayStr;
        LetterBank: TArrayInt;
        ActivePlayer: Integer;
        MainForm: TMainForm;

    End;

Var
    Bonus50: TBonus50;
    LetPl: Array [1 .. 10] Of TButton;
    ActivePlayerLet: Integer = -1;
    OtherPlayerLet: Integer = -1;

Implementation

{$R *.dfm}

Procedure TBonus50.FormShow(Sender: TObject);
Begin
    For Var I := 1 To High(PlayerLetters[ActivePlayer]) Do
    Begin
        LetPl[I] := TButton.Create(Self);
        LetPl[I].Left := 60 + I * 50;
        LetPl[I].Top := 90;
        LetPl[I].Name := 'LetPl' + IntToStr(I + 1);
        LetPl[I].Caption := PlayerLetters[ActivePlayer][I];
        LetPl[I].Parent := Self;
        LetPl[I].Height := 25;
        LetPl[I].Width := 25;
        LetPl[I].OnClick := ButtonClick;
        LetPl[I].Tag := I;
    End;
End;

Procedure TBonus50.ButtonClick(Sender: TObject);
Var
    I, K: Integer;
Begin
    //
End;

End.
