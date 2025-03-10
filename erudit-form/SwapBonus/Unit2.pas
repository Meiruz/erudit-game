Unit Unit2;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.Pngimage, Vcl.ExtCtrls,
    Vcl.StdCtrls;

Type
    TArrayStr = Array Of String;

    TSwapLetters = Class(TForm)
        I: TImage;
        SwapBtn: TButton;
        Procedure FormShow(Sender: TObject);
        Procedure ActiveButtonClick(Sender: TObject);
        Procedure OtherButtonClick(Sender: TObject);
        Procedure SwapBtnClick(Sender: TObject);

    Private
        { Private declarations }
    Public
        PlayerLetters: TArrayStr;
        ActivePlayer: Integer;
        OtherPlayer: Integer;
        PlayerName: String;
    End;

Var
    SwapLetters: TSwapLetters;
    LetPl: Array [1 .. 10] Of TButton;
    LetOtherPl: Array [1 .. 10] Of TButton;
    ActivePlayerLet: Integer = -1;
    OtherPlayerLet: Integer = -1;

Implementation

{$R *.dfm}

Procedure TSwapLetters.FormShow(Sender: TObject);
Begin
    SwapBtn.Enabled := False;
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
        LetPl[I].OnClick := ActiveButtonClick;
        LetPl[I].Tag := I;
    End;

    For Var I := 1 To High(PlayerLetters[OtherPlayer]) Do
    Begin
        LetOtherPl[I] := TButton.Create(Self);
        LetOtherPl[I].Left := 60 + I * 50;
        LetOtherPl[I].Top := 210;
        LetOtherPl[I].Name := 'LetOthPl' + IntToStr(I + 1);
        LetOtherPl[I].Caption := PlayerLetters[OtherPlayer][I];
        LetOtherPl[I].Parent := Self;
        LetOtherPl[I].Height := 25;
        LetOtherPl[I].Width := 25;
        LetOtherPl[I].OnClick := OtherButtonClick;
        LetOtherPl[I].Tag := I;
    End;
End;

Procedure TSwapLetters.ActiveButtonClick(Sender: TObject);
Begin
    ActivePlayerLet := (Sender As TButton).Tag;
    For Var I := 1 To High(PlayerLetters[ActivePlayer]) Do
        If I = ActivePlayerLet Then
            (Sender As TButton).Enabled := False
        Else
            LetPl[I].Enabled := True;

    If (OtherPlayerLet <> -1) And (ActivePlayerLet <> -1) Then
        SwapBtn.Enabled := True;
End;

Procedure TSwapLetters.OtherButtonClick(Sender: TObject);
Begin
    OtherPlayerLet := (Sender As TButton).Tag;
    For Var I := 1 To High(PlayerLetters[OtherPlayer]) Do
        If I = OtherPlayerLet Then
            (Sender As TButton).Enabled := False
        Else
            LetOtherPl[I].Enabled := True;

    If (OtherPlayerLet <> -1) And (ActivePlayerLet <> -1) Then
        SwapBtn.Enabled := True;
End;

Procedure TSwapLetters.SwapBtnClick(Sender: TObject);
Var
    Dp: Char;
Begin
    Dp := PlayerLetters[OtherPlayer][OtherPlayerLet];
    PlayerLetters[OtherPlayer][OtherPlayerLet] := PlayerLetters[ActivePlayer][ActivePlayerLet];
    PlayerLetters[ActivePlayer][ActivePlayerLet] := Dp;

    Self.Close;
End;

End.
