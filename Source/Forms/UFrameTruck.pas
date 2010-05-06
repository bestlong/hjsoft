{*******************************************************************************
  作者: dmzn@163.com 2009-7-2
  描述: 门卫车辆查询
*******************************************************************************}
unit UFrameTruck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, dxLayoutControl, cxMaskEdit,
  cxButtonEdit, cxTextEdit, ADODB, cxContainer, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin;

type
  TfFrameTruck = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    //时间区间
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, UFormDateFilter;

class function TfFrameTruck.FrameID: integer;
begin
  Result := cFI_FrameTruckQuery;
end;

procedure TfFrameTruck.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameTruck.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFrameTruck.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
  
  Result := 'Select * From $TE te ' +
    ' Left Join $TL tl On tl.T_ID=te.E_TID ' +
    'Where ((T_InTime>=''$S'' and T_InTime <''$End'') or ' +
    ' (T_OutTime>=''$S'' and T_OutTime <''$End'') or T_NextStatus=''$Out'')';
  //xxxxx

  if nWhere <> '' then
    Result := Result + ' And (' + nWhere + ')';
  //xxxxx

  Result := MacroValue(Result, [MI('$TE', sTable_TruckLogExt),
              MI('$TL', sTable_TruckLog), MI('$Out', sFlag_TruckOut),
              MI('$S', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//Desc: 日期筛选
procedure TfFrameTruck.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameTruck.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditTruck then
  begin
    FWhere := 'E_Truck like ''%' + EditTruck.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditCard then
  begin
    FWhere := 'E_Card like ''%' + EditCard.Text + '%''';
    InitFormData(FWhere);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameTruck, TfFrameTruck.FrameID);
end.
