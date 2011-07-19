{*******************************************************************************
  作者: dmzn@163.com 2011-6-7
  描述: 物品出库
*******************************************************************************}
unit UFormBadPound;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMCListBox, cxMaskEdit,
  cxDropDownEdit, cxTextEdit, dxLayoutControl, StdCtrls, cxLabel,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox;

type
  TfFormBadPound = class(TfFormNormal)
    EditCus: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    EditStock: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item5: TdxLayoutItem;
    EditZK: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    EditTH: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    EditP: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditM: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FRecordID,FTruck: string;
    //编号
    FWeight: Double;
    //净重
    procedure InitFormData(const nID: string);
    //载入数据
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UFormBase, UMgrControl, UFormCtrl, USysDB,
  USysConst, UDataModule, USysBusiness;

class function TfFormBadPound.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;

  nP := nParam;
  if nP.FCommand <> cCmd_EditData then Exit;

  with TfFormBadPound.Create(Application) do
  try
    Caption := '过磅记录';
    FRecordID := nP.FParamA;

    InitFormData(FRecordID);
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormBadPound.FormID: integer;
begin
  Result := cFI_FormBadPound;
end;

//------------------------------------------------------------------------------
//Desc: 初始化界面
procedure TfFormBadPound.InitFormData(const nID: string);
var nStr: string;
begin
  nStr := 'Select C_Name,L_Stock,L_TruckNo,E_ZID,E_Bill,E_TID,T_BFPValue,' +
          'T_BFMValue From $TE ' +
          ' Left Join $Bill On L_ID=E_Bill ' +
          ' Left Join $TL On T_ID=E_TID ' +
          ' Left Join $Cus On C_ID=L_Custom ' +
          'Where E_ID=$ID';
  nStr := MacroValue(nStr, [MI('$TE', sTable_TruckLogExt),
          MI('$TL', sTable_TruckLog), MI('$Bill', sTable_Bill),
          MI('$Cus', sTable_Customer), MI('$ID', nID)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    FWeight := FieldByName('T_BFMValue').AsFloat -
               FieldByName('T_BFPValue').AsFloat;
    FTruck := FieldByName('E_TID').AsString;

    LoadDataToCtrl(FDM.SqlTemp, Self);
    ActiveControl := EditM;
  end else
  begin
    ShowMsg('记录已无效', sHint);
    BtnOK.Enabled := False;      
  end;
end;

//Desc: 保存
procedure TfFormBadPound.BtnOKClick(Sender: TObject);
var nStr: string;
    nVal: Double;
begin
  if (not IsNumber(EditP.Text, True)) or (StrToFloat(EditP.Text) < 0) then
  begin
    EditP.SetFocus;
    ShowMsg('请填写有效的皮重', sHint); Exit;
  end;

  if (not IsNumber(EditM.Text, True)) or (StrToFloat(EditM.Text) < 0) then
  begin
    EditM.SetFocus;
    ShowMsg('请填写有效的毛重', sHint); Exit;
  end;

  nVal := StrToFloat(EditM.Text) - StrToFloat(EditP.Text);
  if nVal < 0 then
  begin
    EditM.SetFocus;
    ShowMsg('毛重不能比皮重小', sHint); Exit;
  end;

  if nVal > FWeight then
  begin
    nStr := '当前设置的净重已超过有效净重,详细如下:  ' + #13#10#13#10 +
            '※.有效净重: %.2f 吨' + #13#10 +
            '※.当前净重: %.2f 吨' + #13#10 +
            '※.超出重量: %.3f 吨' + #13#10#13#10 +
            '请调整皮重、毛重后再次打印.';
    nStr := Format(nStr, [FWeight, nVal, nVal - FWeight]);
    ShowDlg(nStr, sHint, Handle); Exit;
  end;

  FDM.ADOConn.BeginTrans;
  try
    nStr := MakeSQLByStr([SF('P_TID', FTruck), SF('P_Bill', EditTH.Text),
            SF('P_ZID', EditZK.Text), SF('P_PValue', EditP.Text, sfVal),
            SF('P_MValue', EditM.Text, sfVal), SF('P_Man', gSysParam.FUserID),
            SF('P_Date', FDM.SQLServerNow, sfVal)], sTable_BadPound, '', True);
    FDM.ExecuteSQL(nStr);

    nStr := IntToStr(FDM.GetFieldMax(sTable_BadPound, 'R_ID'));
    FDM.ADOConn.CommitTrans;
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('保存数据失败', sError); Exit;
  end;

  PrintBadPoundReport(nStr);
  ModalResult := mrOk;
  ShowMsg('磅单打印完毕', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormBadPound, TfFormBadPound.FormID);
end.
