{*******************************************************************************
  作者: dmzn@163.com 2009-7-10
  描述: 供应记录
*******************************************************************************}
unit UFramePProvideLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, Menus, dxLayoutControl, cxCheckBox,
  cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB, cxContainer, cxLabel,
  UBitmapPanel, cxSplitter, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin;

type
  TfFrameProvideLog = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    EditProvider: TcxButtonEdit;
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
    EditMate: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Check1: TcxCheckBox;
    dxLayout1Item9: TdxLayoutItem;
    N5: TMenuItem;
    N6: TMenuItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
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
    function DealCommand(Sender: TObject; const nCmd: integer): integer; override;
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UFormBase, UDataModule, USysBusiness,
  UFormDateFilter;

class function TfFrameProvideLog.FrameID: integer;
begin
  Result := cFI_FrameProvideLog;
end;

procedure TfFrameProvideLog.OnCreateFrame;
begin
  inherited;
  FJBWhere := '';
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameProvideLog.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFrameProvideLog.DealCommand(Sender: TObject;
  const nCmd: integer): integer;
begin
  Result := -1;
  
  if (nCmd = cCmd_RefreshData) and (Sender is TBaseForm) and
     (TBaseForm(Sender).FormID = cFI_FormProvideBF) then
  begin
    InitFormData(FWhere);
  end;
end;

function TfFrameProvideLog.InitFormDataSQL(const nWhere: string): string;
var nStr: string;
begin
  N3.Enabled := BtnDel.Enabled;
  N4.Enabled := BtnDel.Enabled;
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  if FJBWhere = '' then
  begin
    if Check1.Checked then
         nStr := '(L_PDate>=''$S'' and L_PDate<''$E'')'
    else nStr := '((L_PDate>=''$S'' and L_PDate<''$E'') or ' +
                 '(L_MDate>=''$S'' and L_MDate<''$E'') or ' +
                 '(L_YDate>=''$S'' and L_YDate<''$E''))';
  end else nStr := FJBWhere;

  Result := 'Select *,L_MValue-L_PValue-IsNull(L_YValue,0) as L_JValue From $T ' +
            'Where ' + nStr;
  //xxxxx

  if nWhere <> '' then
       Result := Result + ' and (' + nWhere + ')';
  //xxxxx

  Result := MacroValue(Result, [MI('$T', sTable_ProvideLog),
            MI('$S', Date2Str(FStart)), MI('$E', Date2Str(FEnd+1))]);
  //xxxxx
end;

//Desc: 日期筛选
procedure TfFrameProvideLog.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameProvideLog.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := Format('L_Truck like ''%%%s%%''', [EditTruck.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditMate then
  begin
    EditMate.Text := Trim(EditMate.Text);
    if EditMate.Text = '' then Exit;

    FWhere := Format('L_Mate like ''%%%s%%''', [EditMate.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditProvider then
  begin
    EditProvider.Text := Trim(EditProvider.Text);
    if EditProvider.Text = '' then Exit;

    FWhere := Format('L_Provider like ''%%%s%%''', [EditProvider.Text]);
    InitFormData(FWhere);
  end else
end;

//Desc: 打印磅单
procedure TfFrameProvideLog.N1Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then 
  if SQLQuery.FieldByName('L_PValue').AsFloat > 0 then
  begin
    nStr := SQLQuery.FieldByName('L_ID').AsString;
    PrintProvidePoundReport(nStr, False);
  end else ShowMsg('请先称量皮重', sHint);
end;

//Desc: 删除记录
procedure TfFrameProvideLog.N3Click(Sender: TObject);
var nStr,nID: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nID := SQLQuery.FieldByName('L_ID').AsString;
    nStr := Format('确定要删除编号为[ %s ]的供应记录吗?', [nID]);
    if not QueryDlg(nStr, sAsk) then Exit;

    nStr := 'Delete From %s Where L_ID=%s';
    nStr := Format(nStr, [sTable_ProvideLog, nID]);

    FDM.ExecuteSQL(nStr);
    InitFormData(FWhere);
  end;
end;

//Desc: 验收
procedure TfFrameProvideLog.N4Click(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nP.FCommand := cCmd_EditData;
    nP.FParamA := SQLQuery.FieldByName('L_ID').AsString;
    CreateBaseFormItem(cFI_FormProvideYS, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
      InitFormData(FWhere);
    //xxxxx
  end
end;

//Desc: 交接班查询
procedure TfFrameProvideLog.N6Click(Sender: TObject);
var nStart,nEnd: TDateTime;
begin
  if not GetJiaoBanTime(nStart, nEnd) then
  begin
    ShowMsg('交班时段无效', sHint); Exit;
  end;

  try
    if Check1.Checked then
         FJBWhere := '(L_PDate>=''$S'' and L_PDate<''$E'')'
    else FJBWhere := '((L_PDate>=''$S'' and L_PDate<''$E'') or ' +
                     '(L_MDate>=''$S'' and L_MDate<''$E'') or ' +
                     '(L_YDate>=''$S'' and L_YDate<''$E''))';
    //xxxxx
    
    FJBWhere := MacroValue(FJBWhere, [MI('$S', DateTime2Str(nStart)),
                MI('$E', DateTime2Str(nEnd))]);
    InitFormData;
  finally
    FJBWhere := '';
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameProvideLog, TfFrameProvideLog.FrameID);
end.
