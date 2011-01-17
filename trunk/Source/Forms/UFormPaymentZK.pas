{*******************************************************************************
  作者: dmzn@163.com 2010-3-17
  描述: 纸卡回款
*******************************************************************************}
unit UFormPaymentZK;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxLabel, cxMemo, cxTextEdit,
  cxContainer, cxEdit, cxMaskEdit, cxDropDownEdit, dxLayoutControl,
  StdCtrls, cxControls, cxButtonEdit, cxMCListBox, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TfFormPaymentZK = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    dxLayout1Item3: TdxLayoutItem;
    EditType: TcxComboBox;
    dxLayout1Item4: TdxLayoutItem;
    EditMoney: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDesc: TcxMemo;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Item6: TdxLayoutItem;
    cxLabel2: TcxLabel;
    dxLayout1Item7: TdxLayoutItem;
    ListInfo: TcxMCListBox;
    dxGroup3: TdxLayoutGroup;
    dxLayout1Item12: TdxLayoutItem;
    EditSC: TcxTextEdit;
    dxLayout1Group2: TdxLayoutGroup;
    EditZK: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditCard: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    EditXT: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Group5: TdxLayoutGroup;
    EditZKMoney: TcxTextEdit;
    dxLayout1Item11: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item13: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditZKMoneyPropertiesEditValueChanged(Sender: TObject);
    procedure EditMoneyPropertiesEditValueChanged(Sender: TObject);
  protected
    { Private declarations }
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    procedure GetSaveSQLList(const nList: TStrings); override;
    procedure AfterSaveData(var nDefault: Boolean); override;
    //基类方法
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
  DB, IniFiles, ULibFun, UFormBase, UMgrControl, UAdjustForm, UDataModule, 
  UFormInputbox, USysGrid, USysDB, USysConst, USysBusiness;

type
  TCommonInfo = record
    FZhiKa: string;
    FCardNo: string;
    FZKMoney: Boolean;
    FCusID: string;
    FCusName: string;
    FSaleMan: string;
  end;

var
  gInfo: TCommonInfo;
  //全局使用

//------------------------------------------------------------------------------
class function TfFormPaymentZK.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr,nSQL: string;
    nP: PFormCommandParam;
begin
  nP := nParam;
  Result := nil;

  while True do
  begin
    if nStr = '' then
     if not ShowInputBox('请输入有效的纸卡或磁卡编号:', '纸卡', nStr) then Exit;
    //xxxxx
    
    nSQL := 'Select Z_ID,C_Card From %s zk ' +
            ' Left Join %s zc on zc.C_ZID=zk.Z_ID ' +
            'Where Z_ID=''%s'' or C_Card=''%s''';
    nSQL := Format(nSQL, [sTable_ZhiKa, sTable_ZhiKaCard, nStr, nStr]);

    with FDM.QueryTemp(nSQL) do
    if RecordCount > 0 then
    begin
      gInfo.FZhiKa := Fields[0].AsString;
      gInfo.FCardNo := Fields[1].AsString; Break;
    end else
    begin
      nStr := '';
      ShowMsg('输入内容无效', '请重试');
    end;
  end;

  with TfFormPaymentZK.Create(Application) do
  begin
    Caption := '纸卡回款';
    if Assigned(nP) then
    begin
      InitFormData(gInfo.FZhiKa);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
    end else
    begin
      InitFormData('');
      ShowModal;
    end;
    Free;
  end;
end;

class function TfFormPaymentZK.FormID: integer;
begin
  Result := cFI_FormPaymentZK;
end;

procedure TfFormPaymentZK.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, ListInfo, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormPaymentZK.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, ListInfo, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 读取nID纸卡的信息
procedure TfFormPaymentZK.InitFormData(const nID: string);
var nStr: string;
    nVal: Double;
    nDB: TDataSet;
    nDT,nValid: TDateTime;
begin
  ActiveControl := EditMoney;
  LoadSysDictItem(sFlag_PaymentItem2, EditType.Properties.Items);
  EditType.ItemIndex := 0;

  EditZK.Text := gInfo.FZhiKa;
  EditCard.Text := gInfo.FCardNo;
  nDB := LoadZhiKaInfo(gInfo.FZhiKa, ListInfo, nStr);

  if Assigned(nDB) then
  begin
    nValid := nDB.FieldByName('Z_ValidDays').AsDateTime;
    gInfo.FCusID := nDB.FieldByName('Z_Custom').AsString;
    gInfo.FCusName := nDB.FieldByName('C_Name').AsString;
    gInfo.FSaleMan := nDB.FieldByName('Z_SaleMan').AsString;
  end else
  begin
    ShowMsg(nStr, sHint); Exit;
  end;

  nDT := nValid - FDM.ServerNow;
  if nDT <= 0 then
  begin
    nDT := -nDT;
    nStr := '有效期至:[ %s ] 已过期:[ %d ]天';
  end else nStr := '有效期至:[ %s ] 还剩余:[ %d ]天';
  EditSC.Text := Format(nStr, [Date2Str(nValid), Trunc(nDT)]);
  
  nVal := GetValidMoneyByZK(gInfo.FZhiKa, gInfo.FZKMoney);
  if gInfo.FZKMoney then
       nStr := '限提纸卡 可用金额:[ %.2f ]元'
  else nStr := '普通纸卡 可用金额:[ %.2f ]元';

  EditXT.Text := Format(nStr, [nVal]);
  EditDesc.Text := Format('纸卡[ %s ]回款入金', [gInfo.FZhiKa]);
  EditZKMoney.Enabled := gInfo.FZKMoney and IsZKMoneyModify;
end;

procedure TfFormPaymentZK.EditMoneyPropertiesEditValueChanged(
  Sender: TObject);
var nStr: string;
begin
  Exit;
  
  if EditZKMoney.Enabled and
     OnVerifyCtrl(Sender, nStr) and (StrToFloat(EditMoney.Text) > 0) then
       EditZKMoney.Text := EditMoney.Text
  else EditZKMoney.Text := '0';
end;

procedure TfFormPaymentZK.EditZKMoneyPropertiesEditValueChanged(
  Sender: TObject);
var nStr: string;
begin
  if OnVerifyCtrl(Sender, nStr) and (StrToFloat(EditZKMoney.Text) > 0) then
       nStr := '纸卡[ %s ]回款,限提增加[ %s ]元'
  else nStr := '纸卡[ %s ]回款入金';

  EditDesc.Text := Format(nStr, [EditZK.Text, EditZKMoney.Text]);
end;

function TfFormPaymentZK.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditMoney then
  begin
    Result := IsNumber(EditMoney.Text, True) and
              (Float2PInt(StrToFloat(EditMoney.Text), cPrecision) > 0);
    nHint := '请填写有效的金额';
  end else

  if Sender = EditZKMoney then
  begin
    Result := IsNumber(EditZKMoney.Text, True) and
              (Float2PInt(StrToFloat(EditZKMoney.Text), cPrecision) >= 0);
    nHint := '请填写有效的金额';

    if not Result then Exit;
    if IsNumber(EditMoney.Text, True) then
    begin
      Result := Float2PInt(StrToFloat(EditMoney.Text), cPrecision, False) >=
                Float2PInt(StrToFloat(EditZKMoney.Text), cPrecision, True);
      nHint := '纸卡金额不能大于缴纳金额';
    end;
  end;
end;

procedure TfFormPaymentZK.GetSaveSQLList(const nList: TStrings);
var nStr: string;
begin
  nStr := 'Update %s Set A_InMoney=A_InMoney+%s Where A_CID=''%s''';
  nStr := Format(nStr, [sTable_CusAccount, EditMoney.Text, gInfo.FCusID]);
  nList.Add(nStr);

  nStr := 'Insert Into %s(M_SaleMan,M_CusID,M_CusName,' +
          'M_Type,M_Payment,M_Money,M_Date,M_Man,M_Memo) ' +
          'Values(''%s'',''%s'',''%s'',''%s'',''%s'',%s,%s,''%s'',''%s'')';
  nStr := Format(nStr, [sTable_InOutMoney, gInfo.FSaleMan,
          gInfo.FCusID, gInfo.FCusName, sFlag_MoneyHuiKuan, EditType.Text,
          EditMoney.Text, FDM.SQLServerNow, gSysParam.FUserID, EditDesc.Text]);
  nList.Add(nStr);

  if gInfo.FZKMoney and (StrToFloat(EditZKMoney.Text) <> 0) then
  begin
    nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney+%s Where Z_ID=''%s''';
    nStr := Format(nStr, [sTable_ZhiKa, EditZKMoney.Text, gInfo.FZhiKa]);
    nList.Add(nStr);
  end;
end;

//Desc: 保存完毕,打印收据
procedure TfFormPaymentZK.AfterSaveData(var nDefault: Boolean);
var nStr: string;
    nP: TFormCommandParam;
begin
  if gInfo.FZKMoney and (StrToFloat(EditZKMoney.Text) <> 0) then
  begin
    nStr := Format('纸卡[ %s ]增加限提金额[ %s ]元', [gInfo.FZhiKa,
            EditZKMoney.Text]);
    FDM.WriteSysLog(sFlag_ZhiKaItem, gInfo.FZhiKa, nStr, False);
  end;

  if StrToFloat(EditMoney.Text) > 0 then
  begin
    nP.FCommand := cCmd_AddData;
    nP.FParamA := gInfo.FCusName;
    nP.FParamB := Format('纸卡[ %s ]回款入金', [gInfo.FZhiKa]);
    nP.FParamC := EditMoney.Text;
    CreateBaseFormItem(cFI_FormShouJu, '', @nP);
  end;

  nDefault := False;
  ModalResult := mrOk;
  ShowMsg('回款操作成功', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormPaymentZK, TfFormPaymentZK.FormID);
end.
