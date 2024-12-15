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
    COL_LETTERS_EN = 26;
    COL_PLAYERS_MIN = 2;
    COL_PLAYERS_MAX = 5;
    RUS_A = ord('а');
    ENG_A = ord('a');
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
    While true Do
    Begin
        K := Random(high(LettersBank));
        If LettersBank[K] > 0 Then
        Begin
            GetRandomLetter := Ansichar(K + ValueA);
            dec(ColOfAllLetters);
            dec(LettersBank[K]);
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

    setLength(PlayersLetters, ColPlayers);
    for I := Low(PlayersLetters) to High(PlayersLetters) do
    begin
        PlayersLetters[I]  := '';
        for var J := 1 to COL_LETTERS_FOR_USER do
            PlayersLetters[I] := PlayersLetters[I] + GetRandomLetter();
    end;

End;

Function BinarySearch(Const AnswerStr: AnsiString): Integer;
Var
    Words: TStringList;
    Left, Right, Mid, CompareResult: Integer;
Begin
    Words := TStringList.Create;
    Try
        Words.LoadFromFile(DICTIONARY_FILE[language]);

        Left := 0;
        Right := Words.Count - 1;

        While Left <= Right Do
        Begin
            Mid := (Left + Right) Div 2;
            CompareResult := CompareStr(AnswerStr, ansistring(Words[mid]));

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

procedure AddStringInOrder(const NewStr: string; const ind: integer);
var
  StringList: TStringList;
  InsertIndex: Integer;
begin
    writeln(ind);
  StringList := TStringList.Create;
  try
    if FileExists(DICTIONARY_FILE[language]) then
      StringList.LoadFromFile(DICTIONARY_FILE[language], TEncoding.ANSI)
    else
      StringList.Clear;

    InsertIndex := ind;
    StringList.Insert(InsertIndex, NewStr);

    StringList.SaveToFile(DICTIONARY_FILE[language], TEncoding.ANSI);
  finally
    StringList.Free;
  end;
end;

Function FindStrInUserLetters(AnswerStr: AnsiString): Boolean;
Var
    I, J: Integer;
    isIn: Boolean;
Begin
    FindStrInUserLetters := true;
    For I := 1 To Length(AnswerStr) Do
    Begin
        isIn := false;
        For J := LOw(PlayersLetters[ActivePlayer]) To HIGH(PlayersLetters[ActivePlayer]) Do
            If AnswerStr[I] = PlayersLetters[ActivePlayer][J] Then
                isIn := true;

        if not isIn then
            begin
                FindStrInUserLetters := False;
                Exit();
            end;
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

procedure deleteUsedLetters(const str: ansistring);
begin
    for var I := Low(str) to High(str) do
    begin
        var j := 1;
        while j <= length(PlayersLetters[ActivePlayer]) do
        begin
            if str[i] = PlayersLetters[ActivePlayer][j] then
                delete(PlayersLetters[ActivePlayer], j, 1)
            else
                inc(j);
        end;
    end;
end;

Procedure FormatString(var str: AnsiString);
var
    countOfletters : integer;
begin
    while (str <> '') and (str[1] = ' ') do
        delete(str, 1, 1);

    while (str <> '') and (str[length(str)] = ' ') do
        delete(str, length(str), 1);

    for var I := 1 to length(str) do
        if (ord(str[I]) < ValueA) and (ord(str[i]) >= ord('A')) then
            str[I] := ansichar(Ord(str[I]) + 32);
end;

Function CheckIntForLimit(Const Value, MinLimit, MaxLimit: Integer): Boolean;
Begin
    Result := (Value >= MinLimit) And (Value <= MaxLimit);
End;

Procedure GivePlayersTheirLetters(Const IndexPlayer: Integer);
Var
    Ind, Pos: Integer;
Begin
    Ind := length(PlayersLetters[IndexPlayer]);
    While (Ind < COL_LETTERS_FOR_USER) And (ColOfAllLetters > 0) Do
    Begin
        PlayersLetters[IndexPlayer] := PlayersLetters[IndexPlayer] + GetRandomLetter();
        Inc(Ind);
    End;
End;

Function CheckStrForLimit(Const PlayersWord: String;
    Const Len: Integer): Boolean;
Begin
    Result := Length(PlayersWord) <= Len;
End;

Procedure ReadlnStrWithChecking(Var PlayersWord: AnsiString; Const Len: Integer);
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
var
    pos, toSave: integer;
Begin
    pos := BinarySearch(AnswerStr);
    if pos < 0 then
    begin
        Writeln('No word in dictionary');

        write('Do you wonna add this word to dictionary?', #13#10, #9, '1 - Yes', #13#10, #9, '2 - No', #13#10, '-> ');
        ReadlnIntWithChecking(toSave, 1, 2);
        if toSave = 1 then
            AddStringInOrder(AnswerStr, -(pos + 1))
        else
        begin
            CalculatePoints := -Length(AnswerStr);
            exit();
        end;
    end;

    If FindStrInUserLetters(AnswerStr) Then
    begin
        If (LastAnswerStr[Length(LastAnswerStr)] = AnswerStr[1]) Then
            CalculatePoints := 2 * Length(AnswerStr)
        Else
            CalculatePoints := Length(AnswerStr);
    End
    Else
        CalculatePoints := -Length(AnswerStr);
End;

procedure outLettersOfPlayer(const indexOfPlayer: integer);
begin
    writeLn('Letters of player #', indexOfPlayer + 1);
    for var I := Low(playersLetters[indexOfPlayer]) to High(playersLetters[indexOfPlayer]) do
        write(playersLetters[indexOfPlayer][i],' ');
    writeln;
end;

Procedure Bonus_1_50();
Var
    I, J: Integer;
    IndexReplaceLetters: Integer;
Begin
    if PlayersBonus1[ActivePlayer] then
    begin
        if colOfAllLetters > 4 then
        begin
            outLettersOfPlayer(ActivePlayer);

            for I := 1 to 5 do
            begin
                Write('#', i, ' Enter the index of letters you want to replace: ');
                ReadlnIntWithChecking(IndexReplaceLetters, 1, 10);
                PlayersLetters[ActivePlayer][IndexReplaceLetters] := GetRandomLetter();

                outLettersOfPlayer(ActivePlayer);
            end;

            PlayersRes[ActivePlayer] := PlayersRes[ActivePlayer] - 2;
            PlayersBonus1[ActivePlayer] := false;
        end
        else
        begin
            writeln('There are no letters in bank.');
        end;
    end
    else
        writeln('You cant do it again.');
End;

Procedure Bonus_2_Swap();
Var
    Char1, Char2, Temp: Integer;
    I, J, OtherPlayer: Integer;
    dp: AnsiChar;
Begin
    if PlayersBonus2[ActivePlayer] then
    begin
        Write('Enter the index of your letter you want to replace: ');
        ReadlnIntWithChecking(Char1, 1, length(playersLetters[activePlayer]));
        Write('Enter your opponent`s number: ');

        ReadlnIntWithChecking(OtherPlayer, 1, length(playerNames));
        dec(OtherPlayer);
        while otherPlayer = activePlayer do
        begin
            write('You cant choose yourself! Try again: ');
            ReadlnIntWithChecking(OtherPlayer, 1, length(playerNames));
        end;

        WriteLn('The letters of the opponent: ');
        outLettersOfPlayer(otherPlayer);
        Write('Specify the letter of the opponent you want to replace: ');
        ReadlnIntWithChecking(Char2, 1, length(playersLetters[otherPlayer - 1]));

        dp := playersLetters[activePlayer][char1];
        playersLetters[activePlayer][char1] := playersLetters[OtherPlayer][char2];
        playersLetters[OtherPlayer][char2] := dp;

        Write('Changed letters: ');
        outLettersOfPlayer(ActivePlayer);
        PlayersBonus2[ActivePlayer]:= false;
    end
    else
        writeln('You cant do it again.');
End;

Var
    LangNum, UsersNum: Integer;
    UserNames: TArrayStr;
    IsGameOn: Boolean;
    RequestStr, PrevStr: AnsiString;

Begin
    Writeln('~~~ ERUDIT GAME ~~~');
    Writeln(#13#10, 'To use bonus you should write 50/50 or help (помощь на русском).', #13#10);

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
    PrevStr := ' ';
    While IsGameOn Do
    Begin
        GivePlayersTheirLetters(ActivePlayer);

        Writeln(#13#10, 'Player #', ActivePlayer + 1, ' (',
            PlayerNames[ActivePlayer], '): ', #13#10, 'Letters: ');
        for var I := Low(PlayersLetters[ActivePlayer]) to High(PlayersLetters[ActivePlayer]) do
            Write(PlayersLetters[ActivePlayer][I], ' ');

        if PrevStr <> ' ' then
            write(#13#10, 'Last word: ', PrevStr);

        Write(#13#10, '-> ');

        ReadlnStrWithChecking(RequestStr, length(playersLetters[activePlayer]));
        FormatString(RequestStr);

        If RequestStr = '50/50' Then
            Bonus_1_50()
        Else
            If (RequestStr = 'help') or (RequestStr = 'помощь') Then
                Bonus_2_Swap()
            Else
            Begin
                Var CurrentPlayerResult := 0;

                if RequestStr <> '' then
                begin
                    CurrentPlayerResult := CalculatePoints(PrevStr,
                        RequestStr);
                    Inc(PlayersRes[ActivePlayer], CurrentPlayerResult);

                    if currentPlayerResult > 0 then
                        PrevStr := RequestStr;

                    deleteUsedLetters(RequestStr);
                end;

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
