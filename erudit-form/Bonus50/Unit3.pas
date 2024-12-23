unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, MainUnit;

type
  TArrayStr = Array Of String;
  TArrayInt = Array Of Integer;

  TBonus50 = class(TForm)
    Image1: TImage;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    PlayerLetters: TArrayStr;
    LetterBank: TArrayInt;
  end;

Var
    Bonus50: TBonus50;
    LetPl: Array [1 .. 10] Of TButton;
    ActivePlayerLet: Integer = -1;

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
    K: Integer;
Begin
    Randomize;
    While True Do
    Begin
        K := Random(High(LetterBank));
        If LetterBank[K] > 0 Then
        Begin
            (Sender as TButton).Caption := Ansichar(K + MainUnit.ValueA);
            Dec(ColOfAllLetters);
            Dec(LettersBank[K]);
            Exit;
        End;
    End;
End;

End.
