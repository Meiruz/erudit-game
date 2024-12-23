uses
  System.SysUtils, System.Classes;

procedure SortFileByRussianAlphabetAnsi(const FilePath: string);
var
  FileLines: TStringList;
  i: Integer;
begin

  FileLines := TStringList.Create;
  try
    FileLines.LoadFromFile(FilePath, TEncoding.ANSI);

    for i := 0 to FileLines.Count - 1 do
    begin
      FileLines[i] := StringReplace(FileLines[i], '¸', 'å', [rfReplaceAll, rfIgnoreCase]);
    end;

    FileLines.Sort;
    FileLines.SaveToFile(FilePath, TEncoding.ANSI);

  finally
    FileLines.Free;
  end;
end;
