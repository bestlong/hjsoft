{*******************************************************************************
  作者: dmzn@163.com 2010-10-16
  描述: 供应结算
*******************************************************************************}
unit UFormProvideJS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxButtonEdit, cxLabel, cxTextEdit, cxContainer, cxEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TfFormProvideJS = class(TfFormNormal)
    dxLayout1Item7: TdxLayoutItem;
    Edit1: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    Edit2: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditWeight: TcxTextEdit;
    dxLayout1Item11: TdxLayoutItem;
    EditMoney: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    EditYF: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    Edit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    cxLabel2: TcxLabel;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Group8: TdxLayoutGroup;
    dxLayout1Group6: TdxLayoutGroup;
    EditPrice: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    dxLayout1Group7: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
    procedure EditPricePropertiesEditValueChanged(Sender: TObject);
  private
    { Private declarations }
    FRecordID: string;
    //记录编号
    procedure InitFormData(const nID: string);
    //载入数据
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UFormCtrl, UFormBase, UMgrControl, USysDB, USysConst,
  USysBusiness, UDataModule;

class function TfFormProvideJS.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormProvideJS.Create(Application) do
  begin
    FRecordID := nP.FParamA;
    Caption := '核算费用';

    InitFormData(FRecordID);
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
    Free;
  end;
end;

class function TfFormProvideJS.FormID: integer;
begin
  Result := cFI_FormProvideHS;
end;

procedure TfFormProvideJS.InitFormData(const nID: string);
var nStr: string;
begin
  nStr := 'Select * From %s Where L_ID=%s';
  nStr := Format(nStr, [sTable_ProvideLog, nID]);

  with FDM.QueryTemp(nStr) do
  begin
    BtnOK.Enabled := RecordCount > 0;
    if not BtnOK.Enabled then
    begin
      ShowMsg('记录已无效', sHint); Exit;
    end;

    LoadDataToCtrl(FDM.SqlTemp, Self, '');
    if EditYF.Text = '' then EditYF.Text := '0';

    EditWeight.Text := Format('%.2f', [FieldByName('L_MValue').AsFloat -
      FieldByName('L_PValue').AsFloat - FieldByName('L_YValue').AsFloat]);
    //xxxxx

    EditMoney.Text := Format('%.2f', [StrToFloat(EditPrice.Text) *
                                      StrToFloat(EditWeight.Text)]);
    ActiveControl := EditMoney;
  end;
end;

//Desc: 计算金额
procedure TfFormProvideJS.EditPricePropertiesEditValueChanged(
  Sender: TObject);
begin
  if IsNumber(EditPrice.Text, True) and IsNumber(EditWeight.Text, True) then
  begin
    EditMoney.Text := Format('%.2f', [StrToFloat(EditPrice.Text) *
                                      StrToFloat(EditWeight.Text)]);
    //xxxxx
  end;
end;

//------------------------------------------------------------------------------
//Desc: 验证数据
function TfFormProvideJS.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditMoney then
  begin
    Result := IsNumber(EditMoney.Text, True) and
              (StrToFloat(EditMoney.Text) >= 0);
    nHint := '请填写正确的结算金额';
  end else

  if Sender = EditYF then
  begin
    Result := IsNumber(EditYF.Text, True) and
              (StrToFloat(EditYF.Text) >= 0);
    nHint := '请填写正确的运费';
  end else

  if Sender = EditPrice then
  begin
    Result := IsNumber(EditPrice.Text, True) and
              (StrToFloat(EditPrice.Text) >= 0);;
    nHint := '请填写正确的单价';
  end;
end;

//Desc: 保存
procedure TfFormProvideJS.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if not IsDataValid then Exit;

  nStr := 'Update %s Set L_Money=%s,L_YunFei=%s,L_HSer=''%s'',L_HSDate=%s,' +
          'L_Price=%s,L_Memo=''%s'' Where L_ID=%s';
  nStr := Format(nStr, [sTable_ProvideLog, EditMoney.Text, EditYF.Text,
          gSysParam.FUserID, FDM.SQLServerNow, EditPrice.Text, EditMemo.Text,
          FRecordID]);
  //xxxxx
  
  FDM.ExecuteSQL(nStr);
  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormProvideJS, TfFormProvideJS.FormID);
end.
