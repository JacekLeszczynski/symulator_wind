unit UnitElementy;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  TePines = (piZero,piPlus,piMinus);
  TUnitElementySysExecute = procedure(Sender: TObject; aType: string; aID: integer) of object;

  { TePins }

  TePins = class
  private
    FCount: integer;
    tab: array of TePines;
    function GetValue(Index: Integer): TePines;
    procedure SetFValue(Index: Integer; AValue: TePines);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(aValue: TePines): integer;
    procedure Delete(aIndex: integer);
    procedure Clear;
    property Values[Index: Integer]: TePines read GetValue write SetFValue; default;
  published
    property Count: integer read FCount;
  end;

  { TeMap }

  TeMap = class
    private
      tab: TStringList;
      function GetCount: integer;
    public
      constructor Create;
      destructor Destroy; override;
      function Add(aRodzaj,aPiny: string): integer; //rodzaj: Z (zasilanie,cewki) P (piny: zaczynamy od domyślnych, w środku wspólny)
      procedure Delete(aIndex: integer);
      procedure Clear;
      function GetPin(aState: boolean; aNrPin: integer): integer;
    published
      property Count: integer read GetCount;
  end;

  { TeElement }

  (* To jest moja klasa główna elementów,                               *)
  (* wszystkie elementy będą budowane na tej właśnie klasie.            *)
  (* Jeśli coś mam posłać dalej, to:                                    *)
  (* - z Map dostaję nr pinu z którego mam posłać wartość ładunku dalej *)
  (* - z Pins dostaję jaka wartość ładunku ma zostać posłana            *)
  (* - z Lines dostaję gdzie na zewnątrz mam posłać w/w informacje      *)

  TeElement = class
  private
    FID: integer;
    FMap: TeMap;
    FPins: TePins;
    FState: boolean;
    procedure SetState(AValue: boolean);
  protected
  public
    constructor Create(aID: integer; aCountPins: integer);
    destructor Destroy; override;
  published
    property Identificator: integer read FID write FID;
    property State: boolean read FState write SetState default false; //stan zasilenia elementu
    property Pins: TePins read FPins write FPins; //wartości ładunków na kolejnych pinach
    property Map: TeMap read FMap write FMap; //mapa pinów (pary, sekcje)
    //property Lines: TeLines read FLines write FLines; //mapa podłączeń zewnętrznych, tzw. linie
  end;

  { TeZasilanie }

  TeZasilanie = class(TeElement)
  private
  public
  end;

  { TePrzycisk }

  TePrzycisk = class(TeElement)
  private
  public
    constructor Create(aID: integer; aCountPins: integer);
    destructor Destroy; override;
  published
    //property OnSysExecute: TUnitElementySysExecute read FSysExec write FSysExec;
  end;

implementation

uses
  ecode;

{ TeMap }

function TeMap.GetCount: integer;
begin
  result:=tab.Count;
end;

constructor TeMap.Create;
begin
  tab:=TStringList.Create;
end;

destructor TeMap.Destroy;
begin
  tab.Free;
  inherited Destroy;
end;

function TeMap.Add(aRodzaj, aPiny: string): integer;
begin
  result:=tab.Add(aRodzaj+','+aPiny);
end;

procedure TeMap.Delete(aIndex: integer);
begin
  tab.Delete(aIndex);
end;

procedure TeMap.Clear;
begin
  tab.Clear;
end;

function TeMap.GetPin(aState: boolean; aNrPin: integer): integer;
var
  i,r,l: integer;
  pom,s,s1,s2,s3: string;
  p1,p2,p3: integer;
begin
  r:=0;
  for i:=0 to tab.Count-1 do
  begin
    l:=-1;
    pom:=tab[i];
    s:=GetLineToStr(pom,1,',');
    s1:=GetLineToStr(pom,2,',');
    s2:=GetLineToStr(pom,3,',');
    s3:=GetLineToStr(pom,4,',');
    if s1<>'' then inc(l);
    if s2<>'' then inc(l);
    if s3<>'' then inc(l);
    if l>0 then p1:=StrToInt(s1) else p1:=-1;
    if l>1 then p2:=StrToInt(s1) else p2:=-1;
    if l>2 then p3:=StrToInt(s1) else p3:=-1;
    if s='Z' then
    begin
      if aNrPin=p1 then r:=p2 else
      if aNrPin=p2 then r:=p1;
    end else
    if s='P' then
    begin
      if aState then
      begin
        if aNrPin=p1 then r:=0 else
        if aNrPin=p2 then r:=p3 else
        if aNrPin=p3 then r:=p2;
      end else begin
        if aNrPin=p1 then r:=p2 else
        if aNrPin=p2 then r:=p1 else r:=0;
      end;
    end;
    if r>-1 then break;
  end;
  result:=r;
end;

{ TePrzycisk }

constructor TePrzycisk.Create(aID: integer; aCountPins: integer);
begin
  inherited Create(aID, aCountPins);
end;

destructor TePrzycisk.Destroy;
begin
  inherited Destroy;
end;

{ TePins }

function TePins.GetValue(Index: Integer): TePines;
begin
  result:=tab[Index];
end;

procedure TePins.SetFValue(Index: Integer; AValue: TePines);
begin
  tab[Index]:=AValue;
end;

constructor TePins.Create;
begin
  FCount:=0;
end;

destructor TePins.Destroy;
begin
  SetLength(tab,0);
  inherited Destroy;
end;

function TePins.Add(aValue: TePines): integer;
begin
  SetLength(tab,FCount+1);
  tab[FCount]:=aValue;
  inc(FCount);
end;

procedure TePins.Delete(aIndex: integer);
var
  i: integer;
begin
  for i:=aIndex+1 to FCount-1 do tab[i-1]:=tab[i];
  dec(FCount);
  SetLength(tab,FCount);
end;

procedure TePins.Clear;
begin
  FCount:=0;
  SetLength(tab,0);
end;

{ TeElement }

procedure TeElement.SetState(AValue: boolean);
begin
  if FState=AValue then Exit;
  FState:=AValue;
end;

constructor TeElement.Create(aID: integer; aCountPins: integer);
var
  i: integer;
begin
  FID:=aID;
  FState:=false;
  FPins:=TePins.Create;
  FMap:=TeMap.Create;
  for i:=1 to aCountPins do FPins.Add(piZero);
end;

destructor TeElement.Destroy;
begin
  FPins.Free;
  FMap.Free;
  inherited Destroy;
end;

end.

