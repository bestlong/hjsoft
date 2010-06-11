{*******************************************************************************
  作者: dmzn@163.com 2009-7-15
  描述: 栈台查询
*******************************************************************************}
unit UFrameLadingDai;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, Menus, dxLayoutControl, cxMaskEdit,
  cxButtonEdit, cxTextEdit, ADODB, cxContainer, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin;

type
  TfFrameLadingDai = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
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
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, UFormDateFilter,
  UFormInputbox, UFormBase, USysBusiness;

class function TfFrameLadingDai.FrameID: integer;
begin
  Result := cFI_FrameZhanTaiQuery;
end;

procedure TfFrameLadingDai.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameLadingDai.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFrameLadingDai.InitFormDataSQL(const nWhere: string): string;
var nStr: string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  nStr := 'Select Z_ID,C_Name as Z_CusName From %s zk ' +
          ' Left Join %s cus On cus.C_ID=zk.Z_Custom ';
  nStr := Format(nStr, [sTable_ZhiKa, sTable_Customer]);

  Result := 'Select te.*,tl.*,Z_CusName,L_Type,L_Stock from $TE te ' +
            ' Left Join $TL tl on tl.T_ID=te.E_TID ' +
            ' Left Join $Bill b on b.L_ID=te.E_Bill ' +
            ' Left Join ($ZK) zk on zk.Z_ID=E_ZID ';
  //xxxxx

  if nWhere = '' then
       Result := Result + 'Where (T_ZTTime>=''$S'' and T_ZTTime <''$End'') ' +
                          'or T_NextStatus=''$ZT'''
  else Result := Result + 'Where (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$TE', sTable_TruckLogExt), 
              MI('$TL', sTable_TruckLog), MI('$Bill', sTable_Bill),
              MI('$ZK', nStr), MI('$ZT', sFlag_TruckZT),
              MI('$S', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//Desc: 修改水泥编号
procedure TfFrameLadingDai.N1Click(Sender: TObject);
var nStr,nNo,nID: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nNo := SQLQuery.FieldByName('E_StockNo').AsString;
    while True do
    begin
      if ShowInputBox('请填写有效的水泥编号:', '修改', nNo, 15) then
           nNo := Trim(nNo)
      else Exit;

      if nNo <> '' then
           Break
      else ShowMsg('无效的水泥编号', sHint);
    end;

    nID := SQLQuery.FieldByName('E_ID').AsString;
    nStr := 'Update %s Set E_StockNo=''%s'' Where E_ID=%s';
    nStr := Format(nStr, [sTable_TruckLogExt, nNo, nID]);

    FDM.ExecuteSQL(nStr);
    InitFormData(FWhere);
    ShowMsg('编号已修改成功', sHint);
  end;
end;

//Desc: 水泥合卡
procedure TfFrameLadingDai.N3Click(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    if SQLQuery.FieldByName('T_Status').AsString <> sFlag_TruckZT then
    begin
      ShowMsg('只有栈台车辆可以合卡', sHint); Exit;
    end;

    nP.FCommand := cCmd_AddData;
    nP.FParamA := SQLQuery.FieldByName('T_ID').AsString;
    nP.FParamB := SQLQuery.FieldByName('T_Truck').AsString;
    nP.FParamC := SQLQuery.FieldByName('E_Card').AsString;
    CreateBaseFormItem(cFI_FormDaiHeKa, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
      InitFormData(FWhere);
    //xxxxx
  end;
end;

//Desc: 执行查询
procedure TfFrameLadingDai.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := 'E_Truck like ''%%%s%%'' and (T_ZTTime>=''$S'' and ' +
              'T_ZTTime <''$End'')';
    FWhere := Format(FWhere, [EditTruck.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    if EditCard.Text = '' then Exit;

    FWhere := 'E_Card like ''%%%s%%'' and (T_ZTTime>=''$S'' and ' +
              'T_ZTTime <''$End'')';
    FWhere := Format(FWhere, [EditCard.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 日期筛选
procedure TfFrameLadingDai.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 快捷查询
procedure TfFrameLadingDai.N6Click(Sender: TObject);
var nStart,nEnd: TDateTime;
begin
  case TComponent(Sender).Tag of
   10:
    begin
      if not GetJiaoBanTime(nStart, nEnd) then
      begin
        ShowMsg('交班时段无效', sHint); Exit;
      end;

      FWhere := '(T_OutTime>=''$S'' and T_OutTime<''$End'') or ' +
                 '(T_ZTTime>=''$S'' and T_ZTTime<''$End'')';
      FWhere := MacroValue(FWhere, [MI('$S', DateTime2Str(nStart)),
                                    MI('$End', DateTime2Str(FEnd))]);
      //xxxxx
    end;
   20: FWhere := '(T_OutTime>=''$S'' and T_OutTime<''$End'') and ' +
                 '(T_ZTTime Is Not Null)';
  end;

  InitFormData(FWhere);
end;

initialization
  gControlManager.RegCtrl(TfFrameLadingDai, TfFrameLadingDai.FrameID);
end.
