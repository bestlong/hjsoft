{*******************************************************************************
  作者: dmzn@163.com 2010-10-20
  描述: 批量供应核算
*******************************************************************************}
unit UFormProvideHS_P;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxButtonEdit, cxLabel, cxTextEdit, cxContainer, cxEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TfFormProvideHS_P = class(TfFormNormal)
    dxLayout1Item8: TdxLayoutItem;
    EditMate: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditWeight: TcxTextEdit;
    dxLayout1Item11: TdxLayoutItem;
    EditMoney: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    EditYF: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    EditTruck: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    cxLabel2: TcxLabel;
    dxLayout1Item6: TdxLayoutItem;
    EditPrice: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    dxLayout1Group7: TdxLayoutGroup;
    dxLayout1Group8: TdxLayoutGroup;
    EditTime: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
    procedure EditPricePropertiesEditValueChanged(Sender: TObject);
  private
    { Private declarations }
    FList: TStrings;
    //记录列表
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

class function TfFormProvideHS_P.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormProvideHS_P.Create(Application) do
  begin
    Caption := '批量核算';
    FList := TStrings(TObject(Integer(nP.FParamA)));
    EditTime.Text := nP.FParamB;
    EditMate.Text := nP.FParamC;
    EditTruck.Text := nP.FParamD;
    EditWeight.Text := nP.FParamE;

    InitFormData('');
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
    Free;
  end;
end;

class function TfFormProvideHS_P.FormID: integer;
begin
  Result := cFI_FormProvideHS_P;
end;

procedure TfFormProvideHS_P.InitFormData(const nID: string);
begin
  EditYF.Text := '0';
  EditPrice.Text := '0';
  EditMoney.Text := '0';
  ActiveControl := EditMoney;
end;

//Desc: 计算金额
procedure TfFormProvideHS_P.EditPricePropertiesEditValueChanged(
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
function TfFormProvideHS_P.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
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
  end else

  if Sender = EditWeight then
  begin
    Result := IsNumber(EditWeight.Text, True) and
              (StrToFloat(EditWeight.Text) > 0);
    nHint := '无效的净重';
  end;
end;

//Desc: 保存
procedure TfFormProvideHS_P.BtnOKClick(Sender: TObject);
var nStr,nSQL: string;
    i,nCount,nPos: Integer;
    nPrice,nYuFei,nVal,nWeight,nAllMon,nAllYF: Double;
begin
  if not IsDataValid then Exit;

  nVal := StrToFloat(EditMoney.Text);
  nPrice := nVal / StrToFloat(EditWeight.Text);

  nStr := Format('%.2f', [nPrice]);
  nPrice := StrToFloat(nStr);

  nVal := StrToFloat(EditYF.Text);
  nYuFei := nVal / StrToFloat(EditWeight.Text);

  nStr := Format('%.2f', [nYuFei]);
  nYuFei := StrToFloat(nStr);

  //----------------------------------------------------------------------------
  nSQL := 'Update %s Set L_Money=$Money,L_YunFei=$YF,L_HSer=''%s'',L_HSDate=%s,' +
          'L_Price=%s,L_Memo=''%s'' Where L_ID=$ID';
  nSQL := Format(nSQL, [sTable_ProvideLog, gSysParam.FUserID, FDM.SQLServerNow,
          EditPrice.Text, EditMemo.Text]);
  //xxxxx

  FDM.ADOConn.BeginTrans;
  try
    nAllMon := 0;
    nAllYF := 0;
    nCount := FList.Count - 1;
    
    for i:=0 to nCount do
    begin
      nStr := FList[i];
      //ID;Weight

      nPos := Pos(';', nStr);
      System.Delete(nStr, 1, nPos);
      nWeight := StrToFloat(nStr);

      if i < nCount then
      begin
        nVal := Round(nPrice * nWeight);
        nAllMon := nAllMon + nVal;
      end else
      begin
        nVal := StrToFloat(EditMoney.Text) - nAllMon;
        //校正误差金额
      end;

      nStr := MacroValue(nSQL, [MI('$ID', Copy(FList[i], 1, nPos - 1)),
              MI('$Money', FloatToStr(nVal))]);
      //xxxxx

      if i < nCount then
      begin
        nVal := Round(nYuFei * nWeight);
        nAllYF := nAllYF + nVal;
      end else
      begin
        nVal := StrToFloat(EditYF.Text) - nAllYF;
        //校正误差金额
      end;

      nStr := MacroValue(nStr, [MI('$YF', FloatToStr(nVal))]);
      FDM.ExecuteSQL(nStr);
    end;     

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOk;
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('提交核算数据失败', sError);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormProvideHS_P, TfFormProvideHS_P.FormID);
end.
