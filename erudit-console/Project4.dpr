Program Project1;

{$APPTYPE CONSOLE}

Uses
    System.SysUtils;

Type
    TLang = (RUS, ENG);
    TArrayInt = Array Of Integer;
    TArrayStr = Array Of String;
    TArrayBool = Array Of Boolean;

Const
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
