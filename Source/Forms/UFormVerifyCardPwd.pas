{*******************************************************************************
  作者: dmzn@163.com 2010-3-15
  描述: 使用卡号密码验证有效性
*******************************************************************************}
unit UFormVerifyCardPwd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxContainer, cxEdit, cxTextEdit, cxListBox, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, cxLabel;

type
  TfFormVerifyCardPwd = class(TfFormNormal)
    EditCard: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditPwd: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    ListMsg: TcxListBox;
    dxLayout1Item6: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditBCard: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    cxLabel1: TcxLabel;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    cxLabel2: TcxLabel;
    dxLayout1Item9: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure EditPwdKeyPress(Sender: TObject; var Key: Char);
    procedure ListMsgExit(Sender: TObject);
    procedure EditTruckExit(Sender: TObject);
    procedure EditBCardExit(Sender: TObject);
  private
    { Private declarations }
    FCardNo: string;
    //磁卡编号
    FZhiKa: string;
    //纸卡编号
    FCusID: string;
    //客户编号
    FTruck: string;
    //提货车辆
    procedure SaveTruckNo;
    //保存车号
    function IsValidBillCard(var nHint: string): Boolean;
    //验证提货卡
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormBase, USysConst, USysDB, USysBusiness;

class function TfFormVerifyCardPwd.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormVerifyCardPwd.Create(Application) do
  begin
    Caption := '身份验证';
    EditCard.Text := nP.FParamB;
    EditPwd.Text := nP.FParamC;
    EditTruck.Text := nP.FParamD;

    if EditCard.Text <> '' then ActiveControl := EditPwd;
    if EditPwd.Text <> '' then ActiveControl := EditTruck;

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
    if nP.FParamA = mrOk then;
    begin
      nP.FParamB := FCardNo;
      nP.FParamC := FZhiKa;
      nP.FParamD := FTruck;
    end;
    Free;
  end;
end;

class function TfFormVerifyCardPwd.FormID: integer;
begin
  Result := cFI_FormVerifyCardPwd;
end;

procedure TfFormVerifyCardPwd.EditPwdKeyPress(Sender: TObject; var Key: Char);
var nP: TFormCommandParam;
begin
  if Key = #13 then
  begin
    Key := #0;
    if Sender = EditCard then EditTruck.SetFocus else
    if Sender = EditTruck then EditPwd.SetFocus else
    if Sender = EditPwd then BtnOK.SetFocus else
    if Sender = EditBCard then BtnOK.SetFocus;
  end else

  if Key = #32 then
  begin
    Key := #0;
    nP.FParamA := EditTruck.Text;
    CreateBaseFormItem(cFI_FormGetTruck, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and(nP.FParamA = mrOk) then
      EditTruck.Text := nP.FParamB;
    EditTruck.SelectAll;
  end;
end;

//Desc: 获取车辆对应的磁卡号
procedure TfFormVerifyCardPwd.EditTruckExit(Sender: TObject);
var nStr: string;
begin
  EditTruck.Text := Trim(EditTruck.Text);
  if Length(EditTruck.Text) < 3 then Exit;

  if EditTruck.Text = FTruck then Exit;
  EditBCard.Text := Trim(EditBCard.Text);
  if EditBCard.Text <> '' then Exit;

  nStr := 'Select C_Card From %s Where C_TruckNo=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaCard, EditTruck.Text]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    EditBCard.Text := Fields[0].AsString;
    EditBCard.SetFocus;
    FTruck := EditTruck.Text;
  end;
end;

//Desc: 获取磁卡对应的车辆
procedure TfFormVerifyCardPwd.EditBCardExit(Sender: TObject);
var nStr: string;
begin
  EditBCard.Text := Trim(EditBCard.Text);
  if (EditBCard.Text = '') or (EditBCard.Text = FCardNo) then Exit;

  EditTruck.Text := Trim(EditTruck.Text);
  if EditTruck.Text <> '' then Exit;

  nStr := 'Select C_TruckNo From %s Where C_Card=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaCard, EditBCard.Text]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    EditTruck.Text := Fields[0].AsString;
    EditTruck.SetFocus;
    FCardNo := EditBCard.Text;
  end;
end;

procedure TfFormVerifyCardPwd.ListMsgExit(Sender: TObject);
begin
  ListMsg.ItemIndex := -1;
end;

//Desc: 保存车牌号
procedure TfFormVerifyCardPwd.SaveTruckNo;
var nStr,nTruck: string;
begin
  nTruck := Trim(EditTruck.Text);
  nStr := 'Select Count(*) From %s Where T_Truck=''%s''';

  nStr := Format(nStr, [sTable_Truck, nTruck]);
  if FDM.QueryTemp(nStr).Fields[0].AsInteger > 0 then Exit;

  nStr := 'Insert Into %s(T_Truck, T_PY) Values(''%s'', ''%s'')';
  nStr := Format(nStr, [sTable_Truck, nTruck, GetPinYinOfStr(nTruck)]);
  FDM.ExecuteSQL(nStr);
end;

//Desc: 验证提货磁卡是否有效,并保存
function TfFormVerifyCardPwd.IsValidBillCard(var nHint: string): Boolean;
var nStr,nZK: string;
begin
  nHint := '';
  Result := False;

  nStr := 'Select * From %s Where C_Card=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaCard, EditBCard.Text]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then
    begin
      nHint := '提货磁卡无效.'; Exit;
    end;

    nStr := FieldByName('C_IsFreeze').AsString;
    if nStr = sFlag_Yes then
      nHint := '提货磁卡已经冻结.' + #13#10;
    //xxxxx

    nStr := FieldByName('C_Status').AsString;
    if nStr = sFlag_CardLoss then
      nHint := nHint + '提货磁卡已经挂失.' + #13#10;
    //xxxxx

    if FieldByName('C_OnlyLade').AsString <> sFlag_Yes then
      nHint := nHint + '提货磁卡不是司机卡.' + #13#10;
    //xxxxx

    nZK := FieldByName('C_ZID').AsString;
    if nZK <> FZhiKa then
    begin
      if IsCardHasNoOKBill(EditBCard.Text) then
        nHint := nHint + '提货磁卡上有未提货的凭证.' + #13#10;
      //xxxxx
    end;

    nHint := Trim(nHint);
    Result := nHint = '';
    if (not Result) or (FZhiKa = nZK) then Exit;

    nStr := 'Update %s Set C_ZID=''%s'',C_Status=''%s'',C_OwnerID=''%s'',' +
            'C_BillTime=C_MaxTime Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_ZhiKaCard, FZhiKa, sFlag_CardUsed, FCusID,
            EditBCard.Text]);
    FDM.ExecuteSQL(nStr);
  end;
end;

//Desc: 验证
procedure TfFormVerifyCardPwd.BtnOKClick(Sender: TObject);
var nStr: string;
    nP: TFunctionParam;
begin
  FCardNo := Trim(EditCard.Text);
  if FCardNo = '' then
  begin
    EditCard.SetFocus;
    ShowMsg('请输入有效的磁卡号', sHint); Exit;
  end;

  FTruck := Trim(EditTruck.Text);
  if Length(FTruck) < 3 then
  begin
    EditTruck.SetFocus;
    ShowMsg('车牌号长度应大于3位', sHint); Exit;
  end;

  if IsCardCanBill(EditCard.Text, EditPwd.Text, nStr, @nP) then
  begin
    FZhiKa := nP.FParamA;
    FCusID := nP.FParamB;
  end else
  begin
    EditPwd.SetFocus;
    ListMsg.Items.Text := AdjustHintToRead(nStr);
    ShowMsg('验证失败,请重试', sHint); Exit;
  end;

  EditBCard.Text := Trim(EditBCard.Text);
  if EditBCard.Text <> '' then
  begin
    if EditBCard.Text = EditCard.Text then
    begin
      EditBCard.SetFocus;
      ShowMsg('提货磁卡无效', sHint); Exit;
    end;

    if not IsValidBillCard(nStr) then
    begin
      EditBCard.SetFocus;
      ListMsg.Items.Text := AdjustHintToRead(nStr);
      ShowMsg('验证失败,请重试', sHint); Exit;
    end else FCardNo := EditBCard.Text;
  end;

  SaveTruckNo;
  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormVerifyCardPwd, TfFormVerifyCardPwd.FormID);
end.
