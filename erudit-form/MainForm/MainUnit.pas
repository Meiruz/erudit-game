Unit MainUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.Pngimage,
    Vcl.StdCtrls;

Type
    TLang = (RUS, ENG);
    TArrayInt = Array Of Integer;
    TArrayStr = Array Of AnsiString;
    TArrayBool = Array Of Boolean;
    TMatrixChar = Array Of AnsiString;

    TMainForm = Class(TForm)
        BackgroundImage: TImage;
        Table: TImage;
        Line: TImage;
        ActivePlayerImage: TImage;
        TopLine: TImage;
        PlayerName: TLabel;
        Procedure SetPlayersOnTheirPos();
        Procedure FormShow(Sender: TObject);
    Private
        { Private declarations }
    Public
        Language: TLang;
        PlayerNames: TArrayStr;

    End;

Const
    COL_LETTERS_FOR_USER = 10;
    COL_LETTERS_RU = 33;
    COL_LETTERS_EN = 26;
    COL_PLAYERS_MIN = 2;
    COL_PLAYERS_MAX = 5;
    RUS_A = Ord('�');
    ENG_A = Ord('a');
    COL_USER_LETTERS = 10;

Var
    MainForm: TMainForm;

    Language: TLang;
    PlayerNames: TArrayStr;
    ColPlayers: Integer;
    ColOfAllLetters: Integer;
    LettersBank: TArrayInt;
    PlayersLetters: TMatrixChar;
    PlayersRes: TArrayInt;
    PlayersBonus1: TArrayBool;
    PlayersBonus2: TArrayBool;
    ActivePlayer: Integer;
    ValueA: Integer;
    History: TArrayInt;

Implementation

{$R *.dfm}

Procedure CenterImage(Const Element: TImage);
Begin
    Element.Left := (MainForm.ClientWidth - Element.Width) Div 2;
End;

Procedure CenterLabelByImage(Const Element: TLabel; Const SecondEl: TImage);
Begin
    Element.Left := SecondEl.Left + (SecondEl.Width - Element.Width) Div 2;
End;

Function GetRandomLetter(): Ansichar;
Var
    I, K: Integer;
Begin
    Randomize;
    While True Do
    Begin
        K := Random(High(LettersBank));
        If LettersBank[K] > 0 Then
        Begin
            GetRandomLetter := Ansichar(K + ValueA);
            Dec(ColOfAllLetters);
            Dec(LettersBank[K]);
            Exit;
        End;
    End;
End;

Procedure Preparation(Const Lang: TLang; Const UserNames: TArrayStr);
Var
    I: Integer;
Begin
    Language := Lang;
    ColPlayers := High(UserNames) + 1;
    PlayerNames := UserNames;

    ActivePlayer := 0;

    SetLength(PlayersRes, ColPlayers);
    SetLength(PlayersBonus1, ColPlayers);
    SetLength(PlayersBonus2, ColPlayers);
    SetLength(History, ColPlayers);

    For I := 0 To High(UserNames) Do
    Begin
        PlayersBonus1[I] := True;
        PlayersBonus2[I] := True;
        PlayersRes[I] := 0;
        History[I] := -1;
    End;

    If Language = RUS Then
    Begin
        ColOfAllLetters := COL_LETTERS_RU * 4;
        SetLength(LettersBank, COL_LETTERS_RU);
        ValueA := RUS_A;
    End
    Else
    Begin
        ColOfAllLetters := COL_LETTERS_EN * 4;
        SetLength(LettersBank, COL_LETTERS_EN);
        ValueA := ENG_A;
    End;

    For I := 0 To High(LettersBank) Do
        LettersBank[I] := 4;

    SetLength(PlayersLetters, ColPlayers);
    For I := Low(PlayersLetters) To High(PlayersLetters) Do
    Begin
        PlayersLetters[I] := '';
        For Var J := 1 To COL_LETTERS_FOR_USER Do
            PlayersLetters[I] := PlayersLetters[I] + GetRandomLetter();
    End;

End;

Procedure TMainForm.FormShow(Sender: TObject);
Begin
    Preparation(Self.Language, Self.PlayerNames);
    CenterImage(Table);
    CenterImage(TopLine);
    CenterImage(Line);
    CenterImage(ActivePlayerImage);
    CenterLabelByImage(PlayerName, ActivePlayerImage);
    SetPlayersOnTheirPos;
End;

Procedure TMainForm.SetPlayersOnTheirPos();
Begin
    PlayerName.Caption := PlayerNames[ActivePlayer];
    CenterLabelByImage(PlayerName, ActivePlayerImage);
End;

End.
