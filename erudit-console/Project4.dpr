program Project4;

{$APPTYPE CONSOLE}

uses
    System.SysUtils;

Type
    TLang = (RUS, ENG);
    TArrayInt = Array Of Integer;
    TArrayStr = Array Of String;
    TArrayBool = Array Of Boolean;

Var
    I: Integer;
    Language: TLang;
    ColUsers: Integer;
    ColOfAllLetters: Integer;
    PlayerNames: TArrayStr;
    PlayersLetters: TArrayStr;
    LettersBank: TArrayInt;
    PlayersRes: TArrayInt;
    PlayersBonus1: TArrayBool;
    PlayersBonus2: TArrayBool;
    ActivePlayer: Integer;

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
            PlayersLetters[ActivePlayer][I] := rand();
    End;
    WriteLn('Changed letters: ', PlayersLetters[ActivePlayer]);
    PlayersRes[ActivePlayer] := PlayersRes[ActivePlayer] div 2;
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

begin

end.
