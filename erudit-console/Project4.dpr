Program Project1;

{$APPTYPE CONSOLE}

Uses
    System.SysUtils, Classes;

Type
    TLang = (RUS, ENG);
    TArrayInt = Array Of Integer;
    TArrayStr = Array Of AnsiString;
    TArrayBool = Array Of Boolean;
    TMatrixChar = Array Of Array Of AnsiChar;
    TMessages = (MFailStrLen, MFailIntRage, MFailInt);

Const
    COL_LETTERS_FOR_USER = 10;
    COL_LETTERS_RU = 33;
    COL_LETTERS_EN = 26;
    COL_PLAYERS_MIN = 2;
    COL_PLAYERS_MAX = 5;
    RUS_A = 192;
    ENG_A = 65;
    COL_USER_LETTERS = 10;
    MESSAGES: Array [TMessages] Of String = ('String is so long. Repeat: ',
        'Fail number limit. Repeat: ', 'Fail data. Repeat: ');

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

Function GetRandomLetter(): Integer;
Var
    I, K: Integer;
Begin
    If ColOfAllLetters > 0 Then
        While true Do
        Begin
            K := Random(Length(LettersBank));
            If LettersBank[K] > 0 Then
            Begin
                GetRandomLetter := K;
                Exit;
            End;
        End;

    GetRandomLetter := -1;
    Exit;
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

    setLength(PlayersLetters, ColPlayers, COL_LETTERS_FOR_USER);
    for I := Low(PlayersLetters) to High(PlayersLetters) do
        for var J := Low(PlayersLetters) to High(PlayersLetters) do
            PlayersLetters[I][J] := #0;

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

Function BinarySearch(Const AnswerStr: AnsiString): Integer;
Var
    Words: TStringList;
    Left, Right, Mid, CompareResult: Integer;
Begin
    writeln(answerStr);
    Words := TStringList.Create;
    Try
        Words.LoadFromFile('russian.txt');

        Left := 0;
        Right := Words.Count - 1;

        While Left <= Right Do
        Begin
            Mid := (Left + Right) Div 2;
            CompareResult := CompareStr(AnswerStr, ansistring(UTF8Decode(Words[mid])));

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

        Result := -1;
    Finally
        Words.Free; // Русский пр
    End;
End;

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

Function CalculatePoints(LastAnswerStr, AnswerStr: AnsiString): Integer;
Begin
    if BinarySearch(AnswerStr) = -1 then
    begin
        Writeln('No word in dictionary');
        CalculatePoints := -Length(AnswerStr);
        exit();
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

Procedure FormatString(var str: AnsiString);
var
    Val_a: ansichar;
    countOfletters : integer;
begin
    while (str <> '') and (str[1] = ' ') do
        delete(str, 1, 1);

    while (str <> '') and (str[length(str)] = ' ') do
        delete(str, length(str), 1);

    if language = RUS then
        val_a := 'а'
    else
        val_a := 'a';

    for var I := 1 to length(str) do
        if ord(str[I]) >= ord(Val_a) then
            str[I] := ansichar(Ord(str[I]) - 32);

end;

Function CheckIntForLimit(Const Value, MinLimit, MaxLimit: Integer): Boolean;
Begin
    Result := (Value >= MinLimit) And (Value <= MaxLimit);
End;

Procedure GivePlayersTheirLetters(Const IndexPlayer: Integer);
Var
    Ind, Pos: Integer;
Begin
    Ind := 0;
    While (Ind < COL_LETTERS_FOR_USER) And (ColOfAllLetters > 0) Do
    Begin
        If PlayersLetters[IndexPlayer][Ind] = #0 Then
        Begin
            Pos := GetRandomLetter();
            PlayersLetters[IndexPlayer][Ind] := AnsiChar(ValueA + Pos);
            Dec(ColOfAllLetters);
            Dec(LettersBank[Pos]);
        End;

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

Procedure Bonus_1_50(Var PlayersLetters: TArrayStr; Var PlayersRes: TArrayInt);

Var
    I, J: Integer;
    ReplaceLetters: AnsiString;

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
    Char1, Char2, Temp: AnsiChar;
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
    RequestStr, PrevStr: AnsiString;

Begin

    Writeln('~~~ ERUDIT GAME ~~~');
    Writeln('Rules of game');

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

        // function to find num of letters for use
        ReadlnStrWithChecking(RequestStr, 10);
        FormatString(RequestStr);

        If RequestStr = '50/50' Then
            //
        Else
            If RequestStr = 'HELP' Then
                //
            Else
            Begin
                Var CurrentPlayerResult := 0;

                if RequestStr <> '' then
                begin
                    CurrentPlayerResult := CalculatePoints(PrevStr,
                        RequestStr);
                    Inc(PlayersRes[ActivePlayer], CurrentPlayerResult);
                    PrevStr := RequestStr;
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
