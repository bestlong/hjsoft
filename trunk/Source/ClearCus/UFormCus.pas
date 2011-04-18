{*******************************************************************************
  作者: dmzn@163.com 2011-3-17
  描述: 按名称选择客户
*******************************************************************************}
unit UFormCus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxCheckBox, StdCtrls, ExtCtrls, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxClasses, cxGridCustomView, cxGrid;

type
  TfFormFilteCus = class(TForm)
    cxGrid1: TcxGrid;
    cxView1: TcxGridTableView;
    cxView1Column1: TcxGridColumn;
    cxView1Column2: TcxGridColumn;
    cxView1Column3: TcxGridColumn;
    cxLevel1: TcxGridLevel;
    Panel1: TPanel;
    BtnCheck: TButton;
    BtnUnCheck: TButton;
    BtnDCheck: TButton;
    Button4: TButton;
    BtnOK: TButton;
    cxView1Column4: TcxGridColumn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnCheckClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FFiles: TStrings;
    procedure InitFormData;
    //初始化
  public
    { Public declarations }
  end;

function ShowFilteCustomerForm(const nList: TStrings): Boolean;
//入口函数

implementation

{$R *.dfm}
uses ULibFun;

type
  PCustomerItem = ^TCustomerItem;
  TCustomerItem = record
    FChecked: Boolean;
    FCusID: string;
    FCusName: string;
    FCusYW: string;
    FFileName: string;
  end;

  TCustomerItems = class(TcxCustomDataSource)
  private
    FDataList: TList;
  protected
    procedure ClearData(const nFree: Boolean);
    //清理资源
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle;
     AItemHandle: TcxDataItemHandle): Variant; override;
    procedure SetValue(ARecordHandle: TcxDataRecordHandle;
     AItemHandle: TcxDataItemHandle; const AValue: Variant); override;
     //读写数据
  public
    constructor Create;
    destructor Destroy; override;
    //创建释放
    procedure LoadCustomers(const nFiles: TStrings);
    //读取客户
  end;

var
  gCustomers: TCustomerItems;
  //全局使用

constructor TCustomerItems.Create;
begin
  FDataList := TList.Create;
end;

destructor TCustomerItems.Destroy;
begin
  ClearData(True);
  inherited;
end;

procedure TCustomerItems.ClearData(const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx:=FDataList.Count - 1 downto 0 do
  begin
    Dispose(PCustomerItem(FDataList[nIdx]));
    FDataList.Delete(nIdx);
  end;

  if nFree then
    FDataList.Free;
  //xxxxx
end;

//Desc: 读取客户
procedure TCustomerItems.LoadCustomers(const nFiles: TStrings);
var nStr: string;
    nList: TStrings;
    i,nCount: Integer;
    nItem: PCustomerItem;
begin
  ClearData(False);
  nList := TStringList.Create;
  try
    nCount := nFiles.Count - 1;
    for i:=0 to nCount do
    begin
      nList.LoadFromFile(nFiles[i]);
      if nList.Count < 3 then Continue;
      //无效内容

      New(nItem);
      FDataList.Add(nItem);
      FillChar(nItem^, SizeOf(TCustomerItems), #0);

      nItem.FChecked := False;
      nItem.FFileName := nFiles[i];
      
      nStr := nList[0];
      System.Delete(nStr, 1, Pos(':', nStr));
      nItem.FCusID := nStr;

      nStr := nList[1];
      System.Delete(nStr, 1, Pos(':', nStr));
      nItem.FCusName := nStr;

      nStr := nList[2];
      if Pos('业务员', nStr) > 0 then
      begin
        System.Delete(nStr, 1, Pos(':', nStr));
        nItem.FCusYW := nStr;
      end;
    end;
  finally
    nList.Free;
  end;
end;

function TCustomerItems.GetRecordCount: Integer;
begin
  Result := FDataList.Count;
end;

function TCustomerItems.GetValue(ARecordHandle: TcxDataRecordHandle;
  AItemHandle: TcxDataItemHandle): Variant;
var nColumn: Integer;
    nItem: PCustomerItem;
begin
  nColumn := GetDefaultItemID(Integer(AItemHandle));
  nItem := FDataList[Integer(ARecordHandle)];

  case nColumn of
    0: Result := nItem.FChecked;
    1: Result := nItem.FCusYW;
    2: Result := nItem.FCusID;
    3: Result := nItem.FCusName;
  end;
end;

procedure TCustomerItems.SetValue(ARecordHandle: TcxDataRecordHandle;
  AItemHandle: TcxDataItemHandle; const AValue: Variant);
var nColumn: Integer;
    nItem: PCustomerItem;
begin
  nColumn := GetDefaultItemID(Integer(AItemHandle));
  nItem := FDataList[Integer(ARecordHandle)];

  case nColumn of
    0: nItem.FChecked := AValue;
  end;
end;

//------------------------------------------------------------------------------
function ShowFilteCustomerForm(const nList: TStrings): Boolean;
begin
  with TfFormFilteCus.Create(Application) do
  try
    Caption := '选择客户';
    FFiles := nList;

    gCustomers := TCustomerItems.Create;
    cxView1.DataController.CustomDataSource := gCustomers;

    InitFormData;
    Result := ShowModal = mrOk;
  finally
    Free;
    gCustomers.Free;
  end;  
end;

procedure TfFormFilteCus.FormCreate(Sender: TObject);
begin
  LoadFormConfig(Self);
end;

procedure TfFormFilteCus.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

//------------------------------------------------------------------------------
procedure TfFormFilteCus.InitFormData;
begin
  gCustomers.LoadCustomers(FFiles);
  gCustomers.DataChanged;
end;

procedure TfFormFilteCus.BtnCheckClick(Sender: TObject);
var nItem: PCustomerItem;
    i,nCount,nIdx: Integer;
begin
  nItem := nil;
  nCount := cxView1.ViewData.RowCount - 1;

  for i:=0 to nCount do
  begin
    nIdx := cxView1.ViewData.Rows[i].RecordIndex;
    nItem := gCustomers.FDataList[nIdx];

    if Sender = BtnCheck then
      nItem.FChecked := True else
    if Sender = BtnUnCheck then
      nItem.FChecked := False else
    if Sender = BtnDCheck then
      nItem.FChecked := not nItem.FChecked;
  end;

  if Assigned(nItem) then gCustomers.DataChanged;
end;

//Desc: 選中有效
procedure TfFormFilteCus.BtnOKClick(Sender: TObject);
var i,nCount: Integer;
    nItem: PCustomerItem;
begin
  FFiles.Clear;
  nCount := gCustomers.FDataList.Count - 1;

  for i:=0 to nCount do
  begin
    nItem := gCustomers.FDataList[i];
    if nItem.FChecked then FFiles.Add(nItem.FFileName);
  end;

  ModalResult := mrOk;
end;

end.
