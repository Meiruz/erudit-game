Program Project1;

{$APPTYPE CONSOLE}

Uses
    System.SysUtils, Classes;

Type
    TLang = (RUS, ENG);
    TArrayInt = Array Of Integer;
    TArrayStr = Array Of String;
    TArrayBool = Array Of Boolean;
    TMatrix = Array Of Array Of String;

Const
    COL_LETTERS_RU = 33;
    COL_LETTERS_EN = 26;
    COL_PLAYERS_MIN = 1;
    COL_PLAYERS_MAX = 4;
    RUS_A = 128;
    ENG_A = 65;
    COL_USER_LETTERS = 10;

Var
    Language: TLang;
    ColPlayers: Integer;
    ColOfAllLetters: Integer;
    PlayerNames: TArrayStr;
    LettersBank: TArrayInt;
    PlayersRes: TArrayInt;
    PlayersBonus1: TArrayBool;
    PlayersBonus2: TArrayBool;
    ActivePlayer: Integer;
    ValueA: Integer;
    History: TArrayStr;

Procedure Preparation(Const Lang: TLang; Const UserNames: TArrayStr);
Var
    I: Integer;
Begin
    Language := Lang;
    ColPlayers := High(UserNames) + 1;
    PlayerNames := UserNames;

    ActivePlayer := -1;

    SetLength(PlayersRes, ColPlayers);
    SetLength(PlayersBonus1, ColPlayers);
    SetLength(PlayersBonus2, ColPlayers);
    SetLength(History, ColPlayers);

    For I := 0 To High(UserNames) Do
    Begin
        PlayersBonus1[I] := True;
        PlayersBonus2[I] := True;
        PlayersRes[I] := 0;
        History[I] := ' ';
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

End;

Function BinarySearch(Const AnswerStr: String; Const FileName: String): Integer;
Var
    Words: TStringList;
    Left, Right, Mid, CompareResult: Integer;
Begin
    Words := TStringList.Create;
    Try
        Words.LoadFromFile(FileName);

        Left := 0;
        Right := Words.Count - 1;

        While Left <= Right Do
        Begin
            Mid := (Left + Right) Div 2;
            CompareResult := CompareStr(AnswerStr, Words[Mid]);

            If CompareResult = 0 Then
            Begin
                Result := Mid; // Найдено
                Exit;
            End
            Else If CompareResult < 0 Then
                Right := Mid - 1
            Else
                Left := Mid + 1;
        End;

        // Если строка не найдена, возвращаем -1
        Result := -1;
    Finally
        Words.Free;
    End;
End;


Function FindStrInUserLetters(AnswerStr: String; MatrixOfUserLetters: TMatrix;
    ActiveUser: Integer): Boolean;
Var
    I, J, NumOfMatches: Integer;
Begin
    For I := 1 To Length(AnswerStr) Do
    Begin
        NumOfMatches := 0;
        For J := 1 To COL_USER_LETTERS Do
        Begin
            If AnswerStr[I] = MatrixOfUserLetters[ActiveUser][J] Then
                Inc(NumOfMatches);
        End;
        If (NumOfMatches < 1) Then
        Begin
            FindStrInUserLetters := False;
            Break;
        End
        Else
            FindStrInUserLetters := True;
    End;
End;

Function CalculatePoints(LastAnswerStr, AnswerStr: String;
    IsCorrectAnswer: Boolean): Integer;
Begin
    If IsCorrectAnswer Then
    Begin
        If (LastAnswerStr[Length(LastAnswerStr)] = AnswerStr[1]) Then
            CalculatePoints := 2 * Length(AnswerStr)
        Else
            CalculatePoints := Length(AnswerStr);
    End
    Else
        CalculatePoints := -Length(AnswerStr);
End;

Procedure Bonus_1_50(Var PlayersLetters: TArrayStr; Var PlayersRes: TArrayInt);

Var
    I, J: Integer;
    ReplaceLetters: String;

Begin
    WriteLn('Enter the letters you want to replace.');
    ReadLn(ReplaceLetters);
    For I := 1 To Length(PlayersLetters[ActivePlayer]) Do
    Begin
        For J := 1 To Length(ReplaceLetters) Do
            If PlayersLetters[ActivePlayer][I] = ReplaceLetters[J] Then
            Begin
                PlayersLetters[ActivePlayer][I] := '0';
                Break;
            End;
        If PlayersLetters[ActivePlayer][I] = '0' Then
            PlayersLetters[ActivePlayer][I] := 'A';
    End;
    WriteLn('Changed letters: ', PlayersLetters[ActivePlayer]);
    PlayersRes[ActivePlayer] := PlayersRes[ActivePlayer] Div 2;
End;

Procedure Bonus_2_Swap(Var PlayersLetters: TArrayStr);

Var
    Char1, Char2, Temp: Char;
    I, J, OtherPlayer: Integer;

Begin
    Temp := #0;
    WriteLn('Specify the letter you want to replace.');
    ReadLn(Char1);
    WriteLn('Enter your opponent`s number.');
    ReadLn(OtherPlayer);
    WriteLn('The letters of the opponent: ', PlayersLetters[OtherPlayer]);
    WriteLn('Specify the letter of the opponent you want to replace.');
    ReadLn(Char2);
    For I := 1 To Length(PlayersLetters[ActivePlayer]) Do
        If PlayersLetters[ActivePlayer][I] = Char1 Then
        Begin
            Temp := PlayersLetters[ActivePlayer][I];
            Break;
        End;
    For I := 1 To Length(PlayersLetters[ActivePlayer]) Do
        If PlayersLetters[OtherPlayer][I] = Char2 Then
        Begin
            PlayersLetters[ActivePlayer][I] := PlayersLetters[OtherPlayer][I];
            PlayersLetters[OtherPlayer][I] := Temp;
            Break;
        End;
    WriteLn('Changed letters: ', PlayersLetters[ActivePlayer]);
End;

Var
    LangNum, UsersNum: Integer;
    UserNames: TArrayStr;
    IsGameOn: Boolean;
    RequestStr: String;

Begin

    Writeln('~~~ ERUDIT GAME ~~~');
    Writeln('Rules of game');

    Writeln('Choose language:', #13#10, #9, '1-RUSSIAN', #13#10, #9,
        '2-ENGLISH');
    Readln(LangNum);
    // ReadlnIntWithChecking(LangNum);

    Writeln('Write count of players (from 2 to 5):');
    Readln(UsersNum);
    // ReadlnWithChecking(UsersNum);

    SetLength(UserNames, UsersNum);
    For Var I := 0 To High(UserNames) Do
    Begin
        Write('Name of player #', I + 1, ': ');
        Readln(UserNames[I]);
    End;

    If LangNum = 1 Then
        Preparation(RUS, UserNames)
    Else
        Preparation(ENG, UserNames);

    IsGameOn := True;
    While IsGameOn Do
    Begin
        ActivePlayer := (ActivePlayer + 1) Mod ColPlayers;

        Writeln('Player #', ActivePlayer + 1, ' (',
            PlayerNames[ActivePlayer], '): ');
        Readln(RequestStr);

        Inc(PlayersRes[ActivePlayer], 0);
        History[ActivePlayer] := RequestStr;

        IsGameOn := False;
        For Var I := 0 To High(History) Do
            IsGameOn := (IsGameOn) Or (History[I] <> '');
    End;

    Writeln('Game over.');
    Readln;

End.
