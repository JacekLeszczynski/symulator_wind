unit UnitElementy;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  TUnitElementySysExecute = procedure(Sender: TObject; aType: string; aID: integer) of object;

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
    property Identificator: integer read FID;
    property State: boolean read FState write SetState;
    property OnSysExecute: TUnitElementySysExecute read FSysExec write FSysExec;
  end;

implementation

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

