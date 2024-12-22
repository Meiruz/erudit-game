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
    TMatrix = Array Of Array Of Integer;

    TMainForm = Class(TForm)
        BackgroundImage: TImage;
        Table: TImage;
        Line: TImage;
        ActivePlayerImage: TImage;
        TopLine: TImage;
        PlayerName: TLabel;
        BonusFriend: TImage;
        BonusSwap: TImage;
        Result: TImage;
        Coins: TImage;
    ResultLabel: TLabel;
    WordEdit: TEdit;
    LettersLabel: TLabel;
        Procedure SetPlayersOnTheirPos();
        Procedure FormShow(Sender: TObject);
        Procedure CreatePlayers();
        Procedure UpdateStates();
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
    RUS_A = Ord('à');
    ENG_A = Ord('a');
    COL_USER_LETTERS = 10;
    PIC_URL: Array [0 .. 4] Of String = ('../../images/brownCat.png',
        '../../images/greyCat.png', '../../images/whiteCat.png',
        '../../images/blackCat.png', '../../images/redCat.png');

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

    Players: Array Of TImage;

Implementation

{$R *.dfm}



Procedure CenterImage(Const Element: TImage);
Begin
    Element.Left := (MainForm.ClientWidth - Element.Width) Div 2;
End;

Procedure CenterLabelByImage(Const Element: TLabel; Const SecondEl: TImage);
Begin
    Element.Left := SecondEl.Left + (SecondEl.Width - Element.Width) Div 2 - 5;
End;

Procedure TMainForm.UpdateStates();
var
  I: Integer;
begin
    PlayerName.Caption := PlayerNames[ActivePlayer];
    CenterLabelByImage(PlayerName, ActivePlayerImage);

    ResultLabel.Caption := IntToStr(PlayersRes[ActivePlayer]);
    CenterLabelByImage(ResultLabel, Result);

    BonusFriend.Visible := PlayersBonus1[ActivePlayer];
    BonusSwap.Visible := PlayersBonus2[ActivePlayer];

    LettersLabel.Caption := playersLetters[ActivePlayer];
    CenterLabelByImage(LettersLabel, BackgroundImage);
    LettersLabel.BringToFront;

    for I := 0 to colplayers-2 do
    begin
        Application.MessageBox(PWideChar(PIC_URL[(I + ActivePlayer + 1) mod ColPlayers]), '');
        players[i].Picture.LoadFromFile(PIC_URL[(I + ActivePlayer + 1) mod ColPlayers]);
    end;
end;

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

Function GetPositionsOfPlayers(Const Count: Integer): TMatrix;
Begin
    Case Count Of
        2: Result := [[456, 88]];
        3: Result := [[795, 225], [123, 225]];
        4: Result := [[795, 225], [456, 88], [123, 225]];
        5: Result := [[795, 225], [603, 65], [299, 65], [123, 225]];
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

Procedure TMainForm.CreatePlayers();
Var
    Positions: TMatrix;
Begin
    Positions := GetPositionsOfPlayers(ColPlayers);
    SetLength(Players, ColPlayers);

    For Var I := Low(Positions) To High(Positions) Do
    Begin
        Players[I] := TImage.Create(Self);
        Players[I].Left := Positions[I][0];
        Players[I].Top := Positions[I][1];
        Players[I].Proportional := True;
        Players[I].Name := 'PlayerImage' + IntToStr(I);
        Players[I].Picture.LoadFromFile(PIC_URL[I]);
        var ar := players[i].picture.height / Players[i].Picture.width;
        Players[I].Width := 170;
        Players[i].Height := round(Players[I].Width * ar);
        Players[I].Parent := Self;
    End;

    Table.BringToFront;
    Line.BringToFront;

End;

Procedure TMainForm.FormShow(Sender: TObject);
Begin
    Self.Scaled := false;
    Preparation(Self.Language, Self.PlayerNames);
    CenterImage(Table);
    CenterImage(TopLine);
    CenterImage(Line);
    CenterImage(ActivePlayerImage);
    WordEdit.Left := (Self.ClientWidth - WordEdit.width) div 2;

    SetPlayersOnTheirPos;
    CreatePlayers;
    updateStates;
End;

Procedure TMainForm.SetPlayersOnTheirPos();
Begin
    PlayerName.Caption := PlayerNames[ActivePlayer];
    CenterLabelByImage(PlayerName, ActivePlayerImage);
End;

End.
