Program Project1;

{$APPTYPE CONSOLE}

Uses
    System.SysUtils, Classes;

Type
    TLang = (RUS, ENG);
    TArrayInt = Array Of Integer;
    TArrayStr = Array Of AnsiString;
    TArrayBool = Array Of Boolean;
    TMatrixChar = Array Of AnsiString;
    TMessages = (MFailStrLen, MFailIntRage, MFailInt);

Const
    COL_LETTERS_FOR_USER = 10;
    COL_LETTERS_RU = 33;
    COL_VOWELS_LETTERS_RU = 10;
    VOWELS_RU: Set Of AnsiChar = ['а', 'о', 'у', 'е', 'ё', 'ы', 'э', 'я',
        'и', 'ю'];
    COL_LETTERS_EN = 26;
    COL_VOWELS_LETTERS_EN = 6;
    VOWELS_EN: Set Of AnsiChar = ['e', 'y', 'u', 'i', 'o', 'a'];
    COL_PLAYERS_MIN = 2;
    COL_PLAYERS_MAX = 5;
    RUS_A = Ord('а');
    ENG_A = Ord('a');
    COL_USER_LETTERS = 10;
    MESSAGES: Array [TMessages] Of String = ('String is so long. Repeat: ',
        'Fail number limit. Repeat: ', 'Fail data. Repeat: ');
    DICTIONARY_FILE: Array [TLang] Of String = ('russian.txt', 'english.txt');

Var
    Language: TLang;
    ColPlayers: Integer;
    ColOfAllLetters: Integer;
    PlayerNames: TArrayStr;
    LettersBank: TArrayInt;

    PlayersLetters: TMatrixChar;
    PlayersRes: TArrayInt;
    PlayersBonus1: TArrayBool;
    PlayersBonus2: TArrayBool;
    ActivePlayer: Integer;
    ValueA: Integer;
    History: TArrayInt;

Function GetRandomLetter(): Ansichar;
Var
    I, K: Integer;
Begin
    Randomize;
    While True Do
    Begin
        K := Random(High(LettersBank) + 1);
        If LettersBank[K] > 0 Then
        Begin
            If K <> High(LettersBank) Then
                GetRandomLetter := Ansichar(K + ValueA)
            Else
                GetRandomLetter := 'ё';
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
        ColOfAllLetters := COL_LETTERS_RU * 4 + COL_VOWELS_LETTERS_RU * 4;
        SetLength(LettersBank, COL_LETTERS_RU);
        ValueA := RUS_A;
    End
    Else
    Begin
        ColOfAllLetters := COL_LETTERS_EN * 4 + COL_VOWELS_LETTERS_EN * 4;
        SetLength(LettersBank, COL_LETTERS_EN);
        ValueA := ENG_A;
    End;

    For I := 0 To High(LettersBank) - 1 Do
        If (Ansichar(ValueA + I) In VOWELS_RU) Or
            (Ansichar(ValueA + I) In VOWELS_EN) Then
            LettersBank[I] := 8
        Else
            LettersBank[I] := 4;

    If ValueA = Ord('а') Then
        LettersBank[High(LettersBank)] := 8
    Else
        LettersBank[High(LettersBank)] := 4;

    SetLength(PlayersLetters, ColPlayers);
    For I := Low(PlayersLetters) To High(PlayersLetters) Do
    Begin
        PlayersLetters[I] := '';
        For Var J := 1 To COL_LETTERS_FOR_USER Do
            PlayersLetters[I] := PlayersLetters[I] + GetRandomLetter();
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
            Else If CompareResult < 0 Then
                Right := Mid - 1
            Else
                Left := Mid + 1;
        End;

        Result := -(Left + 1);
    Finally
        Words.Free;
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

Function FindStrInUserLetters(AnswerStr: AnsiString): Boolean;
Var
    I, J: Integer;
    IsIn: Boolean;
Begin
    FindStrInUserLetters := True;
    For I := 1 To Length(AnswerStr) Do
    Begin
        IsIn := False;
        For J := LOW(PlayersLetters[ActivePlayer]) To HIGH(PlayersLetters[ActivePlayer]) Do
        Begin
            If AnswerStr[I] = 'Ш' Then
                AnswerStr[I] := 'ё';
            If AnswerStr[I] = PlayersLetters[ActivePlayer][J] Then
                IsIn := True;
        End;

        If Not IsIn Then
        Begin
            FindStrInUserLetters := False;
            Writeln('Incorrect letters in your word.');
            Exit();
        End;
    End;
End;

Function WinnerFound(): Integer;
Var
    MaxPoints, I: Integer;

Begin
    MaxPoints := PlayersRes[0];
    For I := 1 To High(PlayersRes) Do
        If PlayersRes[I] > MaxPoints Then
            MaxPoints := PlayersRes[I];

    Result := MaxPoints;

End;

Function PlayersWithMaxPointsFound(): Integer;
Var
    I, MaxPoints: Integer;
Begin
    MaxPoints := WinnerFound;
    Writeln('Winners: ');
    For I := 0 To High(PlayersRes) Do
        If PlayersRes[I] = MaxPoints Then
            Writeln(#9, PlayerNames[I], ' with ', MaxPoints, ' points.');
End;

Procedure DeleteUsedLetters(Const Str: Ansistring);
Var
    TempStr: Ansistring;
Begin
    TempStr := Str;
    For Var I := Low(TempStr) To High(TempStr) Do
    Begin
        Var
        J := 1;
        While J <= Length(PlayersLetters[ActivePlayer]) Do
        Begin
            If TempStr[I] = PlayersLetters[ActivePlayer][J] Then
            Begin
                Delete(PlayersLetters[ActivePlayer], J, 1);
                break;
            End
            Else
                Inc(J);
        End;
    End;
End;

Procedure FormatString(Var Str: AnsiString);
Var
    CountOfletters: Integer;
Begin
    While (Str <> '') And (Str[1] = ' ') Do
        Delete(Str, 1, 1);

    While (Str <> '') And (Str[Length(Str)] = ' ') Do
        Delete(Str, Length(Str), 1);

    For Var I := 1 To Length(Str) Do
        If (Ord(Str[I]) < ValueA) And (Ord(Str[I]) >= Ord('A')) Then
            Str[I] := Ansichar(Ord(Str[I]) + 32);
End;

Function CheckIntForLimit(Const Value, MinLimit, MaxLimit: Integer): Boolean;
Begin
    Result := (Value >= MinLimit) And (Value <= MaxLimit);
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

Function CheckStrForLimit(Const PlayersWord: String;
    Const Len: Integer): Boolean;
Begin
    Result := Length(PlayersWord) <= Len;
End;

Procedure ReadlnStrWithChecking(Var PlayersWord: AnsiString;
    Const Len: Integer);
Var
    IsOk: Boolean;
Begin
    Repeat
        Readln(PlayersWord);
        IsOk := CheckStrForLimit(PlayersWord, Len);

        If Not(IsOk) Then
            Write(MESSAGES[MFailStrLen]);
    Until IsOk;

End;

Procedure ReadlnIntWithChecking(Var Value: Integer;
    Const MinLimit, MaxLimit: Integer);
Var
    IsOk: Boolean;
Begin
    Repeat
        IsOk := True;
        Try
            Readln(Value);
        Except
            Write(MESSAGES[MFailInt]);
            IsOk := False;
        End;
        If IsOk Then
            IsOk := CheckIntForLimit(Value, MinLimit, MaxLimit);
        If Not IsOk Then
            Write(MESSAGES[MFailIntRage]);
    Until IsOk;
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
            Writeln('No word in dictionary');

            Write('Do you wonna add this word to dictionary?', #13#10, #9,
                '1 - Yes', #13#10, #9, '2 - No', #13#10, '-> ');
            ReadlnIntWithChecking(ToSave, 1, 2);
            If ToSave = 1 Then
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

End;

Procedure OutLettersOfPlayer(Const IndexOfPlayer: Integer);
Begin
    WriteLn('Letters of player #', IndexOfPlayer + 1);
    For Var I := Low(PlayersLetters[IndexOfPlayer])
        To High(PlayersLetters[IndexOfPlayer]) Do
        Write(PlayersLetters[IndexOfPlayer][I], ' ');
    Writeln;
End;

Procedure Bonus_1_50();
Var
    I, J: Integer;
    IndexReplaceLetters: Integer;
Begin
    If PlayersBonus1[ActivePlayer] Then
    Begin
        If ColOfAllLetters > 4 Then
        Begin
            OutLettersOfPlayer(ActivePlayer);

            For I := 1 To 5 Do
            Begin
                Write('#', I,
                    ' Enter the index of letters you want to replace: ');
                ReadlnIntWithChecking(IndexReplaceLetters, 1, 10);
                PlayersLetters[ActivePlayer][IndexReplaceLetters] :=
                    GetRandomLetter();

                OutLettersOfPlayer(ActivePlayer);
            End;

            PlayersRes[ActivePlayer] := PlayersRes[ActivePlayer] - 2;
            PlayersBonus1[ActivePlayer] := False;
        End
        Else
        Begin
            Writeln('There are no letters in bank.');
        End;
    End
    Else
        Writeln('You cant do it again.');
End;

Procedure Bonus_2_Swap();
Var
    Char1, Char2, Temp: Integer;
    I, J, OtherPlayer: Integer;
    Dp: AnsiChar;
Begin
    If PlayersBonus2[ActivePlayer] Then
    Begin
        Write('Enter the index of your letter you want to replace: ');
        ReadlnIntWithChecking(Char1, 1, Length(PlayersLetters[ActivePlayer]));
        Write('Enter your opponent`s number: ');

        ReadlnIntWithChecking(OtherPlayer, 1, Length(PlayerNames));
        Dec(OtherPlayer);
        While OtherPlayer = ActivePlayer Do
        Begin
            Write('You cant choose yourself! Try again: ');
            ReadlnIntWithChecking(OtherPlayer, 1, Length(PlayerNames));
            Dec(OtherPlayer);
        End;

        WriteLn('The letters of the opponent: ');
        OutLettersOfPlayer(OtherPlayer);
        Write('Specify the letter of the opponent you want to replace: ');
        ReadlnIntWithChecking(Char2, 1,
            COL_LETTERS_FOR_USER);

        Dp := PlayersLetters[ActivePlayer][Char1];
        PlayersLetters[ActivePlayer][Char1] :=
            PlayersLetters[OtherPlayer][Char2];
        PlayersLetters[OtherPlayer][Char2] := Dp;

        Write('Changed letters: ');
        OutLettersOfPlayer(ActivePlayer);
        PlayersBonus2[ActivePlayer] := False;
    End
    Else
        Writeln('You cant do it again.');
End;

Var
    LangNum, UsersNum: Integer;
    UserNames: TArrayStr;
    IsGameOn: Boolean;
    RequestStr, PrevStr: AnsiString;

Begin
    Writeln('~~~ ERUDIT GAME ~~~');
    Writeln(#13#10,
        'To use bonus you should write 50/50 or help (помощь на русском).',
        #13#10);

    Write('Choose language:', #13#10, #9, '1-RUSSIAN', #13#10, #9, '2-ENGLISH',
        #13#10, ' -> ');
    ReadlnIntWithChecking(LangNum, 1, 2);

    Write('Write count of players (from 2 to 5): ');
    ReadlnIntWithChecking(UsersNum, COL_PLAYERS_MIN, COL_PLAYERS_MAX);

    SetLength(UserNames, UsersNum);
    For Var I := 0 To High(UserNames) Do
    Begin
        Write('Name of player #', I + 1, ': ');
        ReadlnStrWithChecking(UserNames[I], 10);
    End;

    If LangNum = 1 Then
        Preparation(RUS, UserNames)
    Else
        Preparation(ENG, UserNames);

    IsGameOn := True;
    GivePlayersTheirLetters(ActivePlayer);
    PrevStr := ' ';
    While IsGameOn Do
    Begin


        Writeln(#13#10, 'Player #', ActivePlayer + 1, ' (',
            PlayerNames[ActivePlayer], '): ', #13#10, 'Letters: ');
        For Var I := Low(PlayersLetters[ActivePlayer])
            To High(PlayersLetters[ActivePlayer]) Do
            Write(PlayersLetters[ActivePlayer][I], ' ');

        Write(#13#10, 'Your score: ', PlayersRes[ActivePlayer]);

        If PrevStr <> ' ' Then
        Begin
            For Var I := 1 To Length(PrevStr) Do
                If PrevStr[I] = 'Ш' Then
                    PrevStr[I] := 'ё';
            Write(#13#10, 'Last word: ', PrevStr);
        End;

        Write(#13#10, '-> ');

        ReadlnStrWithChecking(RequestStr, Length(PlayersLetters[ActivePlayer]));
        FormatString(RequestStr);

        If RequestStr = '50/50' Then
            Bonus_1_50()
        Else If (RequestStr = 'help') Or (RequestStr = 'помощь') Then
            Bonus_2_Swap()
        Else
        Begin
            Var
            CurrentPlayerResult := 0;

            If RequestStr <> '' Then
            Begin
                CurrentPlayerResult := CalculatePoints(PrevStr, RequestStr);
                Inc(PlayersRes[ActivePlayer], CurrentPlayerResult);

                If CurrentPlayerResult > 0 Then
                Begin
                    PrevStr := RequestStr;

                    DeleteUsedLetters(RequestStr);
                    GivePlayersTheirLetters(ActivePlayer);
                End;
            End;

            History[ActivePlayer] := CurrentPlayerResult;

            // Next step
            ActivePlayer := (ActivePlayer + 1) Mod ColPlayers;

            IsGameOn := False;
            For Var I := 0 To High(History) Do
                IsGameOn := (IsGameOn) Or (History[I] <> 0);
        End;
    End;

    Writeln('Game over.', #13#10);
    PlayersWithMaxPointsFound();

    Readln;

End.
