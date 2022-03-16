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

  { TeElement }

  (* To jest moja klasa główna elementów,                    *)
  (* wszystkie elementy będą budowane na tej właśnie klasie. *)

  TeElement = class
  private
    FID: integer;
    FPins: TePins;
    FState: boolean;
    procedure SetState(AValue: boolean);
  protected
  public
    constructor Create(aID: integer; aCountPins: integer);
    destructor Destroy; override;
  published
    property Identificator: integer read FID write FID;
    property State: boolean read FState write SetState default false;
    property Pins: TePins read FPins write FPins;
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
  for i:=1 to aCountPins do FPins.Add(piZero);
end;

destructor TeElement.Destroy;
begin
  FPins.Free;
  inherited Destroy;
end;

end.

