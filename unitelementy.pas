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

  TeElement = class
  private
    FID: integer;
    FPins: TePins;
    FState: boolean;
  protected
  public
    constructor Create(aID: integer);
    destructor Destroy; override;
  published
    property Identificator: integer read FID write FID;
    property State: boolean read FState write FState default false;
    property Pins: TePins read FPins write FPins;
  end;

  { TeZasilanie }

  TeZasilanie = class(TeElement)
  private
  public
  end;

  { TePrzycisk }

  TePrzycisk = class
  private
    FID: integer;
    FState: boolean;
    FSysExec: TUnitElementySysExecute;
    procedure SetState(AValue: boolean);
  public
    constructor Create(aID: integer);
    destructor Destroy; override;
  published
    property Identificator: integer read FID;
    property State: boolean read FState write SetState;
    property OnSysExecute: TUnitElementySysExecute read FSysExec write FSysExec;
  end;

implementation

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

constructor TeElement.Create(aID: integer);
begin
  FID:=aID;
  FState:=false;
  FPins:=TePins.Create;
end;

destructor TeElement.Destroy;
begin
  FPins.Free;
  inherited Destroy;
end;

{ TePrzycisk }

procedure TePrzycisk.SetState(AValue: boolean);
begin
  if FState=AValue then Exit;
  FState:=AValue;
  if assigned(FSysExec) then FSysExec(self,'przycisk',FID);
end;

constructor TePrzycisk.Create(aID: integer);
begin
  FID:=aID;
end;

destructor TePrzycisk.Destroy;
begin
  inherited Destroy;
end;

end.

