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
    LastWordImg: TImage;
    LastWordLabel: TLabel;
        Procedure SetPlayersOnTheirPos();
        Procedure FormShow(Sender: TObject);
        Procedure CreatePlayers();
        Procedure stopGame();
        Procedure UpdateStates();
        Procedure WordEditKeyPress(Sender: TObject; Var Key: Char);
    Private
        { Private declarations }
    Public
        Language: TLang;
        PlayerNames: TArrayStr;

    End;

Const
    COL_LETTERS_FOR_USER = 10;
    COL_LETTERS_RU = 32;
    COL_LETTERS_EN = 26;
    COL_PLAYERS_MIN = 2;
    COL_PLAYERS_MAX = 5;
    RUS_A = Ord('а');
    ENG_A = Ord('a');
    COL_USER_LETTERS = 10;
    PIC_URL: Array [0 .. 4] Of String = ('../../images/brownCat.png',
        '../../images/greyCat.png', '../../images/whiteCat.png',
        '../../images/blackCat.png', '../../images/redCat.png');
    DICTIONARY_FILE: Array [TLang] Of String = ('russian.txt', 'english.txt');

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
    LastRightWord: String;

    Players: Array Of TImage;

Implementation

{$R *.dfm}

Function FormatString(Const OldStr: AnsiString): Ansistring;
Var
    CountOfletters: Integer;
    Str: Ansistring;
Begin
    Str := OldStr;
    While (Str <> '') And (Str[1] = ' ') Do
        Delete(Str, 1, 1);

    While (Str <> '') And (Str[Length(Str)] = ' ') Do
        Delete(Str, Length(Str), 1);

    For Var I := 1 To Length(Str) Do
        If (Ord(Str[I]) < ValueA) And (Ord(Str[I]) >= Ord('A')) Then
            Str[I] := Ansichar(Ord(Str[I]) + 32);

    FormatString := Str;
End;

Procedure CenterImage(Const Element: TImage);
Begin
    Element.Left := (MainForm.ClientWidth - Element.Width) Div 2;
End;

Procedure CenterLabelByImage(Const Element: TLabel; Const SecondEl: TImage);
Begin
    Element.Left := SecondEl.Left + (SecondEl.Width - Element.Width) Div 2 - 5;
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

Procedure GivePlayersTheirLetters(Const IndexPlayer: Integer);
Var
    Ind, Pos: Integer;
Begin
    Ind := Length(PlayersLetters[IndexPlayer]);
    While (Ind < COL_LETTERS_FOR_USER) And (ColOfAllLetters > 0) Do
    Begin
        PlayersLetters[IndexPlayer] := PlayersLetters[IndexPlayer] +
            GetRandomLetter();
        Inc(Ind);
    End;
End;

Procedure TMainForm.UpdateStates();
Var
    I: Integer;
Begin
    for I := Low(playerNames) to High(playerNames) do
        GivePlayersTheirLetters(i);

    PlayerName.Caption := PlayerNames[ActivePlayer];
    CenterLabelByImage(PlayerName, ActivePlayerImage);

    ResultLabel.Caption := IntToStr(PlayersRes[ActivePlayer]);
    CenterLabelByImage(ResultLabel, Result);

    BonusFriend.Visible := PlayersBonus1[ActivePlayer];
    BonusSwap.Visible := PlayersBonus2[ActivePlayer];

    LettersLabel.Caption := '';
    For I := Low(PlayersLetters[ActivePlayer])
        To High(PlayersLetters[ActivePlayer]) Do
    Begin
        LettersLabel.Caption := LettersLabel.Caption + PlayersLetters
            [ActivePlayer][I];
        If I <> High(PlayersLetters[ActivePlayer]) Then
            LettersLabel.Caption := LettersLabel.Caption + ', ';
    End;

    CenterLabelByImage(LettersLabel, BackgroundImage);
    LettersLabel.BringToFront;

    For I := 0 To Colplayers - 2 Do
    Begin
        Players[I].Picture.LoadFromFile
            (PIC_URL[(I + ActivePlayer + 1) Mod ColPlayers]);
    End;
End;

Function BinarySearch(Const AnswerStr: AnsiString): Integer;
Var
    Words: TStringList;
    Left, Right, Mid, CompareResult: Integer;
Begin
    Words := TStringList.Create;
    Try
        Words.LoadFromFile(DICTIONARY_FILE[Language]);

        Left := 0;
        Right := Words.Count - 1;

        While Left <= Right Do
        Begin
            Mid := (Left + Right) Div 2;
            CompareResult := CompareStr(AnswerStr, Ansistring(Words[Mid]));

            If CompareResult = 0 Then
            Begin
                Result := Mid;
                Exit;
            End
            Else
                If CompareResult < 0 Then
                    Right := Mid - 1
                Else
                    Left := Mid + 1;
        End;

        Result := -(Left + 1);
    Finally
        Words.Free;
    End;
End;

Procedure TMainForm.stopGame();
begin
    //
end;

Function FindStrInUserLetters(AnswerStr: AnsiString): Boolean;
Var
    I, J: Integer;
    IsIn: Boolean;
Begin
    FindStrInUserLetters := True;
    For I := 1 To Length(AnswerStr) Do
    Begin
        IsIn := False;
        For J := LOw(PlayersLetters[ActivePlayer])
            To HIGH(PlayersLetters[ActivePlayer]) Do
            If AnswerStr[I] = PlayersLetters[ActivePlayer][J] Then
                IsIn := True;

        If Not IsIn Then
        Begin
            FindStrInUserLetters := False;
            Exit();
        End;
    End;
End;

Procedure AddStringInOrder(Const NewStr: String; Const Ind: Integer);
Var
    StringList: TStringList;
    InsertIndex: Integer;
Begin
    StringList := TStringList.Create;
    Try
        If FileExists(DICTIONARY_FILE[Language]) Then
            StringList.LoadFromFile(DICTIONARY_FILE[Language], TEncoding.ANSI)
        Else
            StringList.Clear;

        InsertIndex := Ind;
        StringList.Insert(InsertIndex, NewStr);

        StringList.SaveToFile(DICTIONARY_FILE[Language], TEncoding.ANSI);
    Finally
        StringList.Free;
    End;
End;

Function CalculatePoints(LastAnswerStr, AnswerStr: AnsiString): Integer;
Var
    Pos, ToSave: Integer;
Begin
    Pos := BinarySearch(AnswerStr);
    If FindStrInUserLetters(AnswerStr) Then
    Begin
        If Pos < 0 Then
        Begin
            var i := ActivePlayer;
            Repeat
                ToSave := Application.MessageBox(PWideChar(WideString(PlayerNames[I]) + ', ¬ы согласны на добавление слова в словарь?'), PWideChar(WideString(PlayerNames[I])), MB_YESNO);
                Application.MessageBox(PWideChar(IntToStr(ToSave)), '');
                i := (i + 1) mod ColPlayers;
            Until (i = ActivePlayer) or (ToSave = 7);

            If ToSave = 6 Then
                AddStringInOrder(AnswerStr, -(Pos + 1))
            Else
            Begin
                CalculatePoints := -Length(AnswerStr);
                Exit();
            End;
        End;

        If (LastAnswerStr[Length(LastAnswerStr)] = AnswerStr[1]) Then
            CalculatePoints := 2 * Length(AnswerStr)
        Else
            CalculatePoints := Length(AnswerStr);
    End
    Else
        CalculatePoints := -Length(AnswerStr);

    Application.MessageBox(PWideChar(IntToStr(Result)), 'Result');
End;

Procedure DeleteUsedLetters(Const Str: Ansistring);
Begin
    For Var I := Low(Str) To High(Str) Do
    Begin
        Var
        J := 1;
        While J <= Length(PlayersLetters[ActivePlayer]) Do
            If Str[I] = PlayersLetters[ActivePlayer][J] Then
                Delete(PlayersLetters[ActivePlayer], J, 1)
            Else
                Inc(J);
    End;
End;

Procedure TMainForm.WordEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    If Key = #13 Then
    Begin
        Var
        CurrentPlayerResult := 0;

        If WordEdit.Text <> '' Then
        Begin
            CurrentPlayerResult := CalculatePoints(LastRightWord,
                FormatString(WordEdit.Text));
            Inc(PlayersRes[ActivePlayer], CurrentPlayerResult);

            If CurrentPlayerResult > 0 Then
            Begin
                LastRightWord := WordEdit.Text;

                DeleteUsedLetters(WordEdit.Text);
            End;
        End;

        History[ActivePlayer] := CurrentPlayerResult;

        // Next step
        ActivePlayer := (ActivePlayer + 1) Mod ColPlayers;

        Var
        IsGameOn := False;
        For Var I := 0 To High(History) Do
            IsGameOn := (IsGameOn) Or (History[I] <> 0);

        if not isGameOn then
            stopGame();

        LastWordLabel.Caption := WordEdit.Text;
        CenterLabelByImage(LastWordLabel, LastWordImg);

        WordEdit.Text := '';

        UpdateStates;



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

    LastRightWord := ' ';

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
        Var
        Ar := Players[I].Picture.Height / Players[I].Picture.Width;
        Players[I].Width := 170;
        Players[I].Height := Round(Players[I].Width * Ar);
        Players[I].Parent := Self;
    End;

    Table.BringToFront;
    Line.BringToFront;

End;

Procedure TMainForm.FormShow(Sender: TObject);
Begin
    Self.Scaled := False;
    Preparation(Self.Language, Self.PlayerNames);
    CenterImage(Table);
    CenterImage(TopLine);
    CenterImage(Line);
    CenterImage(ActivePlayerImage);
    WordEdit.Left := (Self.ClientWidth - WordEdit.Width) Div 2;

    SetPlayersOnTheirPos;
    CreatePlayers;
    UpdateStates;
End;

Procedure TMainForm.SetPlayersOnTheirPos();
Begin
    PlayerName.Caption := PlayerNames[ActivePlayer];
    CenterLabelByImage(PlayerName, ActivePlayerImage);
End;

End.
