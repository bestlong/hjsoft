{*******************************************************************************
  作者: dmzn 2009-07-09
  描述: 地磅称重
*******************************************************************************}
unit UFormWeight;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, CPort, CPortTypes, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ExtCtrls, dxLayoutControl,
  cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, StdCtrls;

type
  TfFormWeight = class(TForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxGroup1: TdxLayoutGroup;
    BtnExit: TButton;
    dxLayoutControl1Item7: TdxLayoutItem;
    BtnOK: TButton;
    dxLayoutControl1Item8: TdxLayoutItem;
    EditPort: TcxComboBox;
    dxLayoutControl1Item1: TdxLayoutItem;
    EditType: TcxComboBox;
    dxLayoutControl1Item2: TdxLayoutItem;
    dxLayoutControl1Group1: TdxLayoutGroup;
    dxGroup2: TdxLayoutGroup;
    LabelValue: TcxLabel;
    dxLayoutControl1Item3: TdxLayoutItem;
    Timer1: TTimer;
    EditBote: TcxComboBox;
    dxLayoutControl1Item4: TdxLayoutItem;
    comWeight: TComPort;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure comWeightReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure EditPortPropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FBuffer: array of Char;
    //接收缓冲
    procedure InitFormData;
    //初始化界面
    function InitComProperty: Boolean;
    //初始化Com属性
  public
    { Public declarations }
  end;

function ShowBangFangWeightForm(const nPopedom: string): string;
//入口函数

implementation

{$R *.dfm}
uses
  IniFiles, Registry, StrUtils, UMgrCOMM, ULibFun, USysFun, USysConst, USysDB,
  USysPopedom;

type
  TPoundItem = record
   FName: string;
   FBaudRate: Cardinal;
   FByteSize: TDataBits;
   FStopBits: TStopBits;
   FParity: TParityBits;
  end;

const
  cPoundList: array[0..2] of TPoundItem = (
    (FName: '315A6P'; FBaudRate: 2400;
     FByteSize: dbEight; FStopBits: sbOneStopBit; FParity: prNone;),
    (FName: 'XK3190'; FBaudRate: 2400;
     FByteSize: dbEight; FStopBits: sbOneStopBit; FParity: prNone;),
    (FName: 'XK3190_D'; FBaudRate: 4800;
     FByteSize: dbEight; FStopBits: sbOneStopBit; FParity: prNone;));

//------------------------------------------------------------------------------
//Desc: 称重窗口
function ShowBangFangWeightForm(const nPopedom: string): string;
begin
  with TfFormWeight.Create(Application) do
  begin
    EditPort.Properties.ReadOnly := not gSysParam.FIsAdmin;
    EditType.Properties.ReadOnly := EditPort.Properties.ReadOnly;
    EditBote.Properties.ReadOnly := EditPort.Properties.ReadOnly;

    ActiveControl := BtnOK;
    InitFormData;

    if ShowModal = mrOk then
         Result := LabelValue.Caption
    else Result := '0';
    Free;
  end;
end;

procedure TfFormWeight.FormCreate(Sender: TObject);
begin
  LoadFormConfig(Self);
end;

procedure TfFormWeight.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self);
    nIni.WriteInteger(Name, 'ComPort', EditPort.ItemIndex);
    nIni.WriteInteger(Name, 'PoundType', EditType.ItemIndex);
    nIni.WriteInteger(Name, 'BoteRate', EditBote.ItemIndex);
  finally
    nIni.Free;
  end;

  Timer1.Enabled := False;
  comWeight.Close;
end;

//Desc: 读取数字
procedure TfFormWeight.BtnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

//------------------------------------------------------------------------------
//Desc: 修改配置
procedure TfFormWeight.EditPortPropertiesChange(Sender: TObject);
begin
  Timer1.Enabled := False;
  comWeight.Close;

  Timer1.Tag := 0;
  Timer1.Interval := 10;
  Timer1.Enabled := True;
end;

//Desc: 初始化界面数据
procedure TfFormWeight.InitFormData;
var nIdx: integer;
    nIni: TIniFile;
begin
  EditType.Properties.Items.Clear;
  for nIdx:=Low(cPoundList) to High(cPoundList) do
    EditType.Properties.Items.Add(cPoundList[nIdx].FName);
  GetValidCOMPort(EditPort.Properties.Items);

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    EditPort.ItemIndex := nIni.ReadInteger(Name, 'ComPort', 0);
    EditType.ItemIndex := nIni.ReadInteger(Name, 'PoundType', 0);
    EditBote.ItemIndex := nIni.ReadInteger(Name, 'BoteRate', 0);
  finally
    nIni.Free;
  end;
end;

//Desc: 初始化Com组件
function TfFormWeight.InitComProperty: Boolean;
var nIdx: Integer;
begin
  Result := True;
  comWeight.Close;

  for nIdx:=Low(cPoundList) to High(cPoundList) do
   if cPoundList[nIdx].FName = EditType.Text then
   begin
     comWeight.Port := EditPort.Text;
     comWeight.BaudRate := StrToBaudRate(EditBote.Text);
     comWeight.DataBits := cPoundList[nIdx].FByteSize;
     comWeight.Parity.Bits := cPoundList[nIdx].FParity;
     comWeight.StopBits := cPoundList[nIdx].FStopBits; Exit;
   end;

  Result := False;
  dxGroup2.Caption := '*.不支持的地方型号...';
end;

procedure TfFormWeight.Timer1Timer(Sender: TObject);
begin
  if EditPort.ItemIndex < 0 then
  begin
    EditPort.SetFocus;
    dxGroup2.Caption := '*.请选择端口...'; Exit;
  end;

  if EditType.ItemIndex < 0 then
  begin
    EditType.SetFocus;
    dxGroup2.Caption := '*.请选择型号...'; Exit;
  end;

  if EditBote.ItemIndex < 0 then
  begin
    EditBote.SetFocus;
    dxGroup2.Caption := '*.请选择速率...'; Exit;
  end;

  if comWeight.Handle = 0 then
  try
    if InitComProperty then
         comWeight.Open
    else Exit;
  except
    //ignor any error
  end;

  if comWeight.Handle = 0 then
  begin
    dxGroup2.Caption := '*.连接地磅失败!!';
    Timer1.Enabled := False;
    Exit;
  end;

  if Timer1.Interval <> 1000 then
    Timer1.Interval := 1000;
  //xxxxx
  
  dxGroup2.Caption := '*.正在读数...[ ' + IntToStr(Timer1.Tag + 1) + ' ]';
  Timer1.Tag := Timer1.Tag + 1;
end;

//Desc: 格式化
function Float2Str(Value: Real): String;
begin
  Result := FormatFloat('0.00', Value);
end;

//Desc: 接收数据
procedure TfFormWeight.comWeightReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
var nStr: string;
    nIdx,nLen: integer;
begin
  nLen := Length(FBuffer);
  SetLength(FBuffer, nLen + BufferLength);
  Move(Buffer^, FBuffer[nLen], BufferLength);

  if EditType.ItemIndex = 0 then //315a6p
  begin
    //no action
  end else

  if EditType.ItemIndex = 1 then //xk3190
  begin
    //#2'+00000001B'#3
    nLen := nLen + BufferLength;
    if (nLen > 0) and (nLen < 100) then Exit;

    for nIdx:=nLen downto 0 do
    if (FBuffer[nIdx] = '+') and (nLen - nIdx > 6) then
    begin
      SetLength(nStr, 6);
      Move(FBuffer[nIdx+1], PChar(nStr)^, 6);

      if IsNumber(nStr, True) then
      begin
        LabelValue.Caption := Float2Str(StrToFloat(nStr) / 1000.00);
        Break;
      end;
    end;
  end else

  if EditType.ItemIndex = 2 then //xk3190d9
  begin
    //no action
  end;

  if nLen > 100 then SetLength(FBuffer, 0);
  //避免大缓冲
end;

end.
