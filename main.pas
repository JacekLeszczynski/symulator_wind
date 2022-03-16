unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  ExtMessage;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ExtMessage1: TExtMessage;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
  private
    projekt: string;
    elementy,zdarzenia,sekcje: TStringList;
    list11,list22: TStringList;
    list1,list2: TList;
    procedure projekt_load(aFileName: string);
    procedure projekt_unload;
    procedure obiekty_create;
    procedure obiekty_destroy;
    function GetTypeElement(aID: integer): string;
  public

  end;

var
  Form1: TForm1;

implementation

uses
  ecode, UnitElementy;

{$R *.lfm}

{ TForm1 }

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then projekt_load(OpenDialog1.FileName);
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  projekt_unload;
end;

procedure TForm1.projekt_load(aFileName: string);
var
  f: textfile;
  s,pom,s1,s2,s3: string;
  czesc: integer;
  pusta_linia: boolean;
  a,i: integer;
begin
  projekt_unload;
  (* definicje elementów *)
  czesc:=0;
  assignfile(f,aFileName);
  reset(f);
  while not eof(f) do
  begin
    if czesc=4 then break;
    readln(f,s);
    s:=trim(s);
    pusta_linia:=s='';
    a:=pos('#',s);
    if a>0 then delete(s,a,maxint);
    s:=trim(s);
    if (czesc<3) and pusta_linia then continue else
    if (not pusta_linia) and (s='') then continue;
    (* część nagłówkowa *)
    if czesc=0 then
    begin
      s1:=trim(GetLineToStr(s,1,' '));
      s2:=trim(GetLineToStr(s,2,' '));
      if s1='program' then projekt:=s2 else
      if s1='var' then
      begin
        czesc:=1;
        continue;
      end;
    end;
    (* część definicji elementów *)
    if czesc=1 then
    begin
      (* najpierw pozbywamy się wszystkich podwójnych spacji *)
      while true do
      begin
        a:=pos('  ',s);
        if a=0 then break;
        s:=StringReplace(s,'  ',' ',[]);
      end;
      (* czytamy sekcję definicji elementów *)
      s1:=trim(GetLineToStr(s,1,' '));
      if s1='const' then
      begin
        czesc:=2;
        continue;
      end else
      if s1='begin' then
      begin
        czesc:=3;
        continue;
      end;
      s2:=trim(GetLineToStr(s,2,' '));
      s3:='';
      i:=2;
      while true do
      begin
        inc(i);
        pom:=trim(GetLineToStr(s,i,' '));
        if pom='' then break;
        s3:=s3+pom;
      end;
      elementy.Add(s1+' '+s2+' '+s3);
    end;
    (* część definicji zdarzeń *)
    if czesc=2 then
    begin
      if s='begin' then
      begin
        czesc:=3;
        continue;
      end;
      zdarzenia.Add(s);
    end;
    (* część definicji sekcji *)
    if czesc=3 then
    begin
      if s='end' then
      begin
        czesc:=4;
        continue;
      end;
      (* najpierw pozbywamy się wszystkich spacji *)
      s:=StringReplace(s,' ','',[rfReplaceAll]);
      (* wczytujemy sekcje *)
      if s='' then
      begin
        if sekcje.Count=0 then continue else
        if sekcje[sekcje.Count-1]='' then continue;
      end;
      sekcje.Add(s);
    end;
  end;
  closefile(f);
  (* ustawienie niektórych kontrolek *)
  Caption:='Symulator Wind ('+projekt+')';
  (* tworzę obiekty *)
  obiekty_create;
end;

procedure TForm1.projekt_unload;
begin
  obiekty_destroy;
  projekt:='';
  elementy.Clear;
  zdarzenia.Clear;
  sekcje.Clear;
  Caption:='Symulator Wind';
end;

procedure TForm1.obiekty_create;
var
  s,typ: string;
  i: integer;
  s1,s2,s3,s4: string;
  ePrzycisk: TePrzycisk;
  oPrzycisk: TButton;
begin
  for i:=0 to elementy.Count-1 do
  begin
    s:=elementy[i];
    s1:=GetLineToStr(s,1,' ');
    s2:=GetLineToStr(s,2,' ');
    s3:=GetLineToStr(s,3,' ');
    if s2='przycisk' then
    begin
      list11.Add('przycisk');
      ePrzycisk:=TePrzycisk.Create(StrToInt(s1));
      list1.Add(ePrzycisk);
    end;
  end;
  for i:=0 to zdarzenia.Count-1 do
  begin
    s:=zdarzenia[i];
    s1:=GetLineToStr(s,1,',');
    s2:=GetLineToStr(s,2,',');
    s3:=GetLineToStr(s,3,',');
    typ:=GetTypeElement(StrToInt(s1));
    if typ='przycisk' then
    begin
      list22.Add('button');
      oPrzycisk:=TButton.Create(self);
      list2.Add(oPrzycisk);
      oPrzycisk.Caption:=s1;
      oPrzycisk.Tag:=StrToInt(s1);
      oPrzycisk.Left:=StrToInt(s2);
      oPrzycisk.Top:=StrToInt(s3);
      oPrzycisk.Parent:=self;
    end;
  end;
end;

procedure TForm1.obiekty_destroy;
var
  i: integer;
begin
  (* zdarzenia (obiekty widoczne) *)
  for i:=list22.Count-1 downto 0 do
  begin
    if list22[i]='button' then
    begin
      TButton(list2[i]).Free;
    end;
    list22.Delete(i);
    list2.Delete(i);
  end;
  (* elementy *)
  for i:=list11.Count-1 downto 0 do
  begin
    if list11[i]='przycisk' then
    begin
      TePrzycisk(list1[i]).Free;
    end;
    list11.Delete(i);
    list1.Delete(i);
  end;
end;

function TForm1.GetTypeElement(aID: integer): string;
var
  i,a: integer;
begin
  result:='';
  for i:=0 to list11.Count-1 do
  begin
    if list11[i]='przycisk' then a:=TePrzycisk(list1[i]).Identificator;
    if a=aID then
    begin
      result:=list11[i];
      break;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  list11:=TStringList.Create;
  list22:=TStringList.Create;
  list1:=TList.Create;
  list2:=TList.Create;
  elementy:=TStringList.Create;
  zdarzenia:=TStringList.Create;
  sekcje:=TStringList.Create;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  a: TePins;
  i: integer;
begin
  a:=TePins.Create;
  try
    a.Add(piZero);
    a.Add(piPlus);
    a.Delete(1);
    a[0]:=piMinus;
    for i:=0 to a.Count-1 do
    begin
      writeln('I=',i,' Value=',a[i]);
    end;
  finally
    a.Free;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  elementy.Free;
  zdarzenia.Free;
  sekcje.Free;
end;

end.

