unit uHashCryptoNotBuildIn;

interface

uses
  uHashLibTypes,
  uHash,
  uHashBuffer,
  uIHashInfo,
  uHashResult,
  uIHashBuffer,
  uIHashResult;

type
  TBlockHash = class abstract(THash, IBlockHash)
  strict protected

    Fm_buffer: IHashBuffer;
    Fm_processed_bytes: UInt64;

    procedure TransformBuffer();
    procedure Finish(); virtual; abstract;
    procedure TransformBlock(a_data: THashLibByteArray; a_index: Int32);
      virtual; abstract;
    function GetResult(): THashLibByteArray; virtual; abstract;

  public
    constructor Create(a_hash_size, a_block_size: Int32;
      a_buffer_size: Int32 = -1);
    procedure TransformBytes(a_data: THashLibByteArray;
      a_index, a_length: Int32); override;
    procedure Initialize(); override;
    function TransformFinal(): IHashResult; override;
  end;

implementation

{ TBlockHash }

constructor TBlockHash.Create(a_hash_size, a_block_size, a_buffer_size: Int32);
begin
  Inherited Create(a_hash_size, a_block_size);
  if (a_buffer_size = -1) then
  begin
    a_buffer_size := a_block_size;
  end;

  Fm_buffer := THashBuffer.Create(a_buffer_size);
  Fm_processed_bytes := 0;
end;

procedure TBlockHash.Initialize;
begin
  Fm_buffer.Initialize();
  Fm_processed_bytes := 0;

end;

procedure TBlockHash.TransformBuffer;
begin
{$IFDEF DEBUG}
  System.Assert(Fm_buffer.IsFull);
{$ENDIF}
  TransformBlock(Fm_buffer.GetBytes(), 0);
end;

{$HINTS OFF}

procedure TBlockHash.TransformBytes(a_data: THashLibByteArray;
  a_index, a_length: Int32);
begin
{$IFDEF DEBUG}
  System.Assert(a_index >= 0);
  System.Assert(a_length >= 0);
  System.Assert(a_index + a_length <= System.Length(a_data));
{$ENDIF}
  if (not Fm_buffer.IsEmpty) then
  begin
    if (Fm_buffer.Feed(a_data, a_index, a_length, Fm_processed_bytes)) then
    begin
      TransformBuffer();
    end;
  end;

  while (a_length >= (Fm_buffer.Length)) do
  begin
    Fm_processed_bytes := Fm_processed_bytes + UInt64(Fm_buffer.Length);
    TransformBlock(a_data, a_index);
    a_index := a_index + (Fm_buffer.Length);
    a_length := a_length - (Fm_buffer.Length);
  end;

  if (a_length > 0) then
  begin
    Fm_buffer.Feed(a_data, a_index, a_length, Fm_processed_bytes);
  end;
end;
{$HINTS ON}

function TBlockHash.TransformFinal: IHashResult;
var
  tempresult: THashLibByteArray;
begin
  Finish();

{$IFDEF DEBUG}
  System.Assert(Fm_buffer.IsEmpty);
{$ENDIF}
  tempresult := GetResult();
{$IFDEF DEBUG}
  System.Assert(System.Length(tempresult) = HashSize);
{$ENDIF}
  Initialize();

  result := THashResult.Create(tempresult);
end;

end.
