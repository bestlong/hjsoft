{*******************************************************************************
  作者: dmzn@163.com 2010-3-16
  描述: 供应验收
*******************************************************************************}
unit UFormPYanShou;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxButtonEdit, cxLabel, cxTextEdit, cxContainer, cxEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar;

type
  TfFormYanShou = class(TfFormNormal)
    dxLayout1Item3: TdxLayoutItem;
    EditDate: TcxDateEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditMan: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    cxLabel2: TcxLabel;
    dxLayout1Item7: TdxLayoutItem;
    EditName: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditMate: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditValue: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item11: TdxLayoutItem;
    EditKC: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Item6: TdxLayoutItem;
    cxLabel3: TcxLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
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
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UFormCtrl, UFormBase, UMgrControl, USysDB, USysConst, UDataModule, 
  UForminputbox, USysBusiness;

class function TfFormYanShou.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr: string;
    nID: Integer;
    nInfo: TDynamicStrArray;
begin
  nID := -1;
  Result := nil;
  
  if not Assigned(nParam) then
  begin
    while true do
    begin
      if nID < 0 then
       if not ShowInputBox('请输入车牌号或磁卡号:', '验收', nStr) then Exit;
      //xxxxx

      nID := GetProvideLog(nStr, nInfo);
      if nID < 0 then
           ShowMsg('请输入有效供应编号', sHint)
      else Break;
    end;
  end else nID := PFormCommandParam(nParam).FParamA;

  with TfFormYanShou.Create(Application) do
  begin
    FRecordID := IntToStr(nID);
    Caption := '供应验收 - ' + FRecordID;

    InitFormData(FRecordID);
    if Assigned(nParam) then
    begin
      PFormCommandParam(nParam).FCommand := cCmd_ModalResult;
      PFormCommandParam(nParam).FParamA := ShowModal;
    end else ShowModal;
    Free;
  end;
end;

class function TfFormYanShou.FormID: integer;
begin
  Result := cFI_FormProvideYS;
end;

procedure TfFormYanShou.FormCreate(Sender: TObject);
begin
  LoadFormConfig(Self);
end;

procedure TfFormYanShou.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

//------------------------------------------------------------------------------
//Desc: 载入数据
procedure TfFormYanShou.InitFormData(const nID: string);
var nStr: string;
    nVal: Double;
begin
  EditKC.Text := '0';
  BtnOK.Enabled := False;
  ActiveControl := EditKC;

  nStr := 'Select * From %s Where L_ID=%s';
  nStr := Format(nStr, [sTable_ProvideLog, nID]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    EditName.Text := FieldByName('L_Provider').AsString;
    EditMate.Text := FieldByName('L_Mate').AsString;
    EditMemo.Text := FieldByName('L_Memo').AsString;

    nVal := FieldByName('L_MValue').AsFloat - FieldByName('L_PValue').AsFloat;
    EditValue.Text := Format('%.2f', [nVal]);

    BtnOK.Enabled := True;
    EditDate.Date := Now;
    EditMan.Text := gSysParam.FUserID;
  end;
end;

//Desc: 验收
procedure TfFormYanShou.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if (not IsNumber(EditKC.Text, True)) or (StrToFloat(EditKC.Text) < 0) then
  begin
    EditKC.SetFocus;
    ShowMsg('扣除量为大于零的值', sHint); Exit;
  end;

  nStr := 'Update %s Set L_YValue=%s,L_YMan=''%s'',L_YDate=%s,L_Memo=''%s'' ' +
          'Where L_ID=%s';
  nStr := Format(nStr, [sTable_ProvideLog, EditKC.Text, gSysParam.FUserID,
          FDM.SQLServerNow, EditMemo.Text, FRecordID]);
  FDM.ExecuteSQL(nStr);

  ModalResult := mrOk;
  ShowMsg('验收完毕', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormYanShou, TfFormYanShou.FormID);
end.
