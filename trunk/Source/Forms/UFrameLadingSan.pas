{*******************************************************************************
  作者: dmzn@163.com 2009-7-15
  描述: 放灰查询
*******************************************************************************}
unit UFrameLadingSan;

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
  TfFrameLadingSan = class(TfFrameNormal)
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
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
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
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, UFormDateFilter,
  UFormInputbox, USysBusiness;

class function TfFrameLadingSan.FrameID: integer;
begin
  Result := cFI_FrameFangHuiQuery;
end;

procedure TfFrameLadingSan.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameLadingSan.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFrameLadingSan.InitFormDataSQL(const nWhere: string): string;
var nStr: string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  nStr := 'Select Z_ID,C_Name as Z_CusName From %s zk ' +
          ' Left Join %s cus On cus.C_ID=zk.Z_Custom ';
  nStr := Format(nStr, [sTable_ZhiKa, sTable_Customer]);

  Result := 'Select te.*,tl.*,Z_CusName,L_Type,L_Stock,' +
            '(T_BFMValue-T_BFPValue) as T_Value from $TE te' +
            ' Left Join $TL tl On tl.T_ID=te.E_TID' +
            ' Left Join $Bill b on b.L_ID=te.E_Bill ' +
            ' Left Join ($ZK) zk On zk.Z_ID=te.E_ZID ';
  //xxxxx

  if nWhere = '' then
       Result := Result + 'Where (T_FHSTime>=''$S'' and T_FHSTime <''$End'') ' +
                          'or T_NextStatus=''$FH'''
  else Result := Result + 'Where (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$TE', sTable_TruckLogExt),
              MI('$TL', sTable_TruckLog), MI('$Bill', sTable_Bill),
              MI('$ZK', nStr),  MI('$FH', sFlag_TruckFH),
              MI('$S', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//Desc: 修改水泥编号
procedure TfFrameLadingSan.N1Click(Sender: TObject);
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

//Desc: 日期筛选
procedure TfFrameLadingSan.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameLadingSan.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := 'E_Truck like ''%%%s%%'' and (T_FHSTime>=''$S'' and ' +
              'T_FHSTime <''$End'')';
    FWhere := Format(FWhere, [EditTruck.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    if EditCard.Text = '' then Exit;

    FWhere := 'E_Card like ''%%%s%%'' and (T_FHSTime>=''$S'' and ' +
              'T_FHSTime <''$End'')';
    FWhere := Format(FWhere, [EditCard.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 快捷查询
procedure TfFrameLadingSan.N5Click(Sender: TObject);
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
                 '(T_FHSTime>=''$S'' and T_FHSTime<''$End'')';
      FWhere := MacroValue(FWhere, [MI('$S', DateTime2Str(nStart)),
                                    MI('$End', DateTime2Str(FEnd))]);
      //xxxxx
    end;
   20: FWhere := '(T_OutTime>=''$S'' and T_OutTime<''$End'') and ' +
                 '(T_FHSTime Is Not Null)';
  end;

  InitFormData(FWhere);
end;

initialization
  gControlManager.RegCtrl(TfFrameLadingSan, TfFrameLadingSan.FrameID);
end.
