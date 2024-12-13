Program Project1;

{$APPTYPE CONSOLE}

Uses
    System.SysUtils;

Type
    TLang = (RUS, ENG);
    TArrayInt = Array Of Integer;
    TArrayStr = Array Of String;
    TArrayBool = Array Of Boolean;
    TMatrixChar = Array Of Array Of Char;

Const
    COL_LETTERS_FOR_USER = 10;
    COL_LETTERS_RU = 33;
    COL_LETTERS_EN = 26;
    COL_PLAYERS_MIN = 1;
    COL_PLAYERS_MAX = 4;
    RUS_A = 128;
    ENG_A = 65;

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

Function PlayersWithMaxPointsFound(MaxPoints: Integer): Integer;
Var
    I: Integer;
    { IndexesOfWinners: Array Of Boolean; }
Begin
    For I := 0 To High(PlayersRes) Do
        If PlayersRes[I] = MaxPoints Then
            { IndexesOfWinners[I] := True; }
            Writeln(I);

End;

Function CheckIntForLimit(Const Value, MinLimit, MaxLimit: Integer): Boolean;
Begin
    Result := Not((Value < MinLimit) Or (Value > MaxLimit));
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
            Pos := 0;
            PlayersLetters[IndexPlayer][Ind] := Chr(ValueA + Pos);
            Dec(ColOfAllLetters);
            Dec(LettersBank[Pos]);
        End;

        Inc(Ind);
    End;
End;

Function CheckStrForLimit(PlayersWord: String): Boolean;
Begin
    Result := Length(PlayersWord) <= COL_LETTERS_FOR_USER;
End;

Procedure ReadlnStrWithChecking(Var PlayersWord: String);
Var
    IsOk: Boolean;
Begin
    Repeat
        Readln(PlayersWord);
        IsOk := CheckStrForLimit(PlayersWord);
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
            IsOk := False;
        End;
        If IsOk Then
            IsOk := CheckIntForLimit(Value, MinLimit, MaxLimit);
    Until IsOk;

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
        History[ActivePlayer] := PlayersRes[ActivePlayer];

        IsGameOn := False;
        For Var I := 0 To High(History) Do
            IsGameOn := (IsGameOn) Or (History[I] <> 0);
    End;

    Writeln('Game over.');
    Readln;

End.
