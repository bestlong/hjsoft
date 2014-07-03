{*******************************************************************************
  作者: dmzn@163.com 2009-7-10
  描述: 称重查询
*******************************************************************************}
unit UFramePound;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, Menus, dxLayoutControl, cxCheckBox,
  cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB, cxContainer, cxLabel,
  UBitmapPanel, cxSplitter, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TfFramePound = class(TfFrameNormal)
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
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Check1: TcxCheckBox;
    dxLayout1Item8: TdxLayoutItem;
    N4: TMenuItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Check1Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    //时间区间
    FJBWhere: string;
    //交班条件
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
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, USysBusiness,
  UFormDateFilter, UFormBase;

class function TfFramePound.FrameID: integer;
begin
  Result := cFI_FramePoundQuery;
end;

procedure TfFramePound.OnCreateFrame;
begin
  inherited;
  FJBWhere := '';
  FEnableBackDB := True;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFramePound.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFramePound.InitFormDataSQL(const nWhere: string): string;
var nStr: string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  nStr := 'Select E_TID,Sum(E_Value) as E_HKValue From $TE te ' +
          'Where E_IsHK=''$Yes'' Group By E_TID';
  //xxxxx

  Result := 'Select te.*,tl.*,L_Custom,L_Type,L_Stock,L_Lading,T_Value=(Case ' +
            ' When T_BFMValue is Null then 0 ' +
            ' When E_IsHK=''$Yes'' then E_Value ' +
            ' else T_BFMValue-T_BFPValue-IsNull(E_HKValue,0) end) from $TE te' +
            '  Left Join $Bill b On b.L_ID=te.E_Bill ' +
            '  Left Join $TL tl On tl.T_ID=te.E_TID' +
            '  Left Join ($HK) hk On hk.E_TID=te.E_TID ';
  //xxxxx

  if FJBWhere = '' then
  begin
    if Check1.Checked then
         Result := Result + 'Where (T_OutTime>=''$Start'' and T_OutTime<''$End'')'
    else Result := Result + 'Where ((T_BFPTime>=''$Start'' and ' +
                   'T_BFPTime <''$End'') Or  (T_BFMTime>=''$Start'' and ' +
                   'T_BFMTime <''$End'') Or  (T_NextStatus=''$PZ'' Or ' +
                   'T_NextStatus=''$MZ''))';
  end else Result := Result + 'Where (' + FJBWhere + ')';
  
  Result := MacroValue(Result, [MI('$HK', nStr)]);
  Result := MacroValue(Result, [MI('$TE', sTable_TruckLogExt),
              MI('$TL', sTable_TruckLog), MI('$Bill', sTable_Bill),
              MI('$PZ', sFlag_TruckBFP), MI('$MZ', sFlag_TruckBFM),
              MI('$Yes', sFlag_Yes),
              MI('$Start', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  if nWhere <> '' then Result := Result + ' And (' + nWhere + ')';
end;

//Desc: 日期筛选
procedure TfFramePound.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 切换日期类型
procedure TfFramePound.Check1Click(Sender: TObject);
begin
  InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFramePound.EditTruckPropertiesButtonClick(Sender: TObject;
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

//Desc: 交班查询
procedure TfFramePound.N1Click(Sender: TObject);
var nStr: string;
    nStart,nEnd: TDateTime;
begin
  SetLength(nStr, 200);
  FillChar(PChar(nStr)^, 200, #0);

  if not GetJiaoBanTime(nStart, nEnd, PChar(nStr)) then
  begin
    ShowMsg('交班时段无效', sHint); Exit;
  end;

  try
    if Check1.Checked then
    begin
      FJBWhere := '(T_OutTime>=''$Start'' and T_OutTime <''$End'')';
      //out time
    end else
    begin
      FJBWhere := '';
      nStr := Trim(nStr);

      if Pos('+BP', nStr) > 0 then
        FJBWhere := '(T_BFPTime>=''$Start'' and T_BFPTime <''$End'')';
      //xxxxx

      if Pos('+BM', nStr) > 0 then
      begin
        if FJBWhere <> '' then
          FJBWhere := FJBWhere + ' Or ';
        FJBWhere := FJBWhere + '(T_BFMTime>=''$Start'' and T_BFMTime <''$End'')';
      end;

      if FJBWhere = '' then
      begin
        FJBWhere := '(T_BFPTime>=''$Start'' and T_BFPTime <''$End'') Or ' +
                    '(T_BFMTime>=''$Start'' and T_BFMTime <''$End'')';
      end;
    end;

    FJBWhere := MacroValue(FJBWhere, [MI('$Start', DateTime2Str(nStart)),
                MI('$End', DateTime2Str(nEnd))]);
    InitFormData;
  finally
    FJBWhere := '';
  end;
end;

//Desc: 打印磅单
procedure TfFramePound.N3Click(Sender: TObject);
var nStr: string;
    nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then Exit;
  nStr := SQLQuery.FieldByName('E_Used').AsString;
  if nStr <> sFlag_Sale then Exit;

  {$IFNDEF ya} //永安系统打袋装榜单
  if SQLQuery.FieldByName('L_Type').AsString <> sFlag_San then
  begin
    ShowMsg('只有散装水泥需要磅单', sHint); Exit;
  end;
  {$ENDIF} 

  if SQLQuery.FieldByName('T_BFMValue').AsFloat = 0 then
  begin
    ShowMsg('请先称量毛重', sHint); Exit;
  end;

  if SQLQuery.FieldByName('T_BFPValue').AsFloat = 0 then
  begin
    ShowMsg('请先称量皮重', sHint); Exit;
  end;

  if Sender = N3 then
  begin
    nStr := SQLQuery.FieldByName('E_ID').AsString;
    PrintPoundReport(nStr, False);
  end else

  if Sender = N4 then
  begin
    nP.FCommand := cCmd_EditData;
    nP.FParamA := SQLQuery.FieldByName('E_ID').AsString;
    CreateBaseFormItem(cFI_FormBadPound, '', @nP);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFramePound, TfFramePound.FrameID);
end.
