Program Project4;

{$APPTYPE CONSOLE}
{$R *.res}

Uses
    System.SysUtils;

Begin
    Try
        { TODO -oUser -cConsole Main : Insert code here }
    Except
        On E: Exception Do
            Writeln(E.ClassName, ': ', E.Message);
    End;

End.
