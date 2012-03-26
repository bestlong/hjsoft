{*******************************************************************************
  ����: dmzn@163.com 2010-3-14
  ����: ��Ӧ��������Ƥ��
*******************************************************************************}
unit UFormPBangFangP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, USysBusiness, ComCtrls, cxGraphics, cxDropDownEdit,
  cxMaskEdit, cxButtonEdit, cxEdit, cxTextEdit, cxListView, cxContainer,
  cxMCListBox, dxLayoutControl, StdCtrls, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox,
  cxMemo, cxCalendar, cxLabel;

type
  TfFormPBangFangP = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    EditValue: TcxButtonEdit;
    dxLayout1Item9: TdxLayoutItem;
    BtnGet: TButton;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Item6: TdxLayoutItem;
    EditPNum: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item11: TdxLayoutItem;
    EditPTime: TcxDateEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    EditProvider: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    EditMate: TcxTextEdit;
    dxLayout1Item14: TdxLayoutItem;
    EditSM: TcxTextEdit;
    dxLayout1Item15: TdxLayoutItem;
    EditKZ: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditMValue: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditWeight: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group7: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditValuePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnGetClick(Sender: TObject);
    procedure EditKZPropertiesEditValueChanged(Sender: TObject);
  protected
    { Protected declarations }
    procedure InitFormData(const nID: string);
    //��������
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    procedure GetSaveSQLList(const nList: TStrings); override;
    procedure AfterSaveData(var nDefault: Boolean); override;
    //���෽��
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
    //���ຯ��
  end;

implementation

{$R *.dfm}
uses
  IniFiles, DB, ULibFun, UMgrControl, USysPopedom, USysGrid, USysDB, USysConst,
  UFormCtrl, UDataModule, UFrameBase, UFormBase, UFormWeight;

type
  TCommonInfo = record
    FRecord: string;      //��¼��
    FProvider: string;    //��Ӧ��
    FMate: string;        //ԭ����
    FSaleMan: string;     //ҵ��Ա

    FCardNo: string;      //�ſ���
    FTruckNo: string;     //���ƺ�
    FMValue: Double;      //ë��
    FPaiNum: string;      //�ɳ���
    FPaiTime: TDateTime;  //ʱ��
    FMemo: string;        //��ע
  end;

var
  gInfo: TCommonInfo;
  //ȫ��ʹ��

//------------------------------------------------------------------------------
class function TfFormPBangFangP.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr: string;
    nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  nStr := 'Select * From %s Where L_ID=%s';
  nStr := Format(nStr, [sTable_ProvideLog, nP.FParamA]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    if (FieldByName('L_Status').AsString <> sFlag_TruckBFP) and
       (FieldByName('L_NextStatus').AsString <> sFlag_TruckBFP) then
    begin
      ShowMsg('�ó��������Ƥ��', sHint);
      Exit;
    end;

    with gInfo do
    begin
      FRecord := nP.FParamA;
      FProvider := FieldByName('L_Provider').AsString;
      FMate := FieldByName('L_Mate').AsString;
      FSaleMan := FieldByName('L_SaleMan').AsString;

      FTruckNo:= FieldByName('L_Truck').AsString;
      FMValue := FieldByName('L_MValue').AsFloat;

      FPaiNum := FieldByName('L_PaiNum').AsString;
      FPaiTime := FieldByName('L_PaiTime').AsDateTime;
      FMemo := FieldByName('L_Memo').AsString;
    end;
  end else
  begin
    ShowMsg('��¼����Ч', sHint);
    Exit;
  end;

  with TfFormPBangFangP.Create(Application) do
  begin
    Caption := '����Ƥ��';
    PopedomItem := nPopedom;

    InitFormData('');
    ShowModal;
    Free;
  end;
end;

class function TfFormPBangFangP.FormID: integer;
begin
  Result := cFI_FormProvideBFP;
end;

procedure TfFormPBangFangP.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormPBangFangP.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��ʼ������
procedure TfFormPBangFangP.InitFormData(const nID: string);
begin
  ActiveControl := BtnGet;
  EditValue.Text := '0';
  EditValue.Properties.ReadOnly := True;

  with gInfo do
  begin
    EditProvider.Text := FProvider;
    EditMate.Text := FMate;
    EditSM.Text := FSaleMan;

    EditMemo.Text := FMemo;
    EditPNum.Text := FPaiNum;
    EditPTime.Date := FPaiTime;

    dxGroup2.Caption := Format('������Ϣ ���ƺ�:[ %s ]', [FTruckNo]);
    EditMValue.Text := Format('%.2f', [FMValue]);
  end;
end;

//Desc: �Ӵ�����
procedure TfFormPBangFangP.EditValuePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
begin
  if not gPopedomManager.HasPopedom(PopedomItem, sPopedom_Edit) then Exit;
  //�޸�Ȩ�޿���

  if EditValue.Properties.ReadOnly then
       nStr := '�Ƿ�Ҫ�ֶ��������?'
  else nStr := '�Ƿ�Ҫ�Զ���ȡ����?';

  if QueryDlg(nStr, sAsk, Handle) then
    EditValue.Properties.ReadOnly := not EditValue.Properties.ReadOnly;
  //xxxxx
end;

//Desc: ����
procedure TfFormPBangFangP.BtnGetClick(Sender: TObject);
begin
  Visible := False;
  try
    EditValue.Text := ShowBangFangWeightForm(PopedomItem);
  finally
    Visible := True;
  end;

  if IsNumber(EditValue.Text, False) and (StrToFloat(EditValue.Text) > 0) then
       ActiveControl := BtnOK
  else ActiveControl := BtnGet;
end;

//Desc: ���㾻��
procedure TfFormPBangFangP.EditKZPropertiesEditValueChanged(Sender: TObject);
var nVal: Double;
begin
  if IsNumber(EditValue.Text, True) and IsNumber(EditKZ.Text, True) then
  begin
    nVal := gInfo.FMValue - StrToFloat(EditValue.Text) - StrToFloat(EditKZ.Text);
    EditWeight.Text := Format('%.2f', [nVal]);
  end;
end;

function TfFormPBangFangP.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
var nVal: Double;
begin
  Result := True;

  if Sender = EditValue then
  begin
    Result := IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text) > 0);
    nHint := '����Ϊ�������ֵ';
    if not Result then Exit;

    Result := StrToFloat(EditValue.Text) <= gInfo.FMValue;
    nHint := 'Ƥ�ز��ܴ���ë��';
  end else

  if Sender = EditKZ then
  begin
    Result := IsNumber(EditKZ.Text, True) and (StrToFloat(EditKZ.Text) >= 0);
    nHint := '������Ϊ�������ֵ';
    if not Result then Exit;

    nVal := gInfo.FMValue - StrToFloat(EditValue.Text) - StrToFloat(EditKZ.Text);
    Result := nVal >= 0;
    nHint := '�������ѳ�������';
  end;
end;

//Desc: ����SQL
procedure TfFormPBangFangP.GetSaveSQLList(const nList: TStrings);
var nStr: string;
    nTmp: TStrings;
begin
  nTmp := TStringList.Create;
  try
    nTmp.Add(SF('L_PValue', EditValue.Text, sfVal));
    nTmp.Add(SF('L_PMan', gSysParam.FUserID));
    nTmp.Add(SF('L_PDate', FDM.SQLServerNow, sfVal));
    nTmp.Add(SF('L_PaiNum', EditPNum.Text));
    nTmp.Add(SF('L_PaiTime', Date2Str(EditPTime.Date)));
    nTmp.Add(SF('L_Memo', EditMemo.Text));

    if StrToFloat(EditKZ.Text) > 0 then
    begin
      nTmp.Add(SF('L_YValue', EditKZ.Text, sfVal));
      nTmp.Add(SF('L_YMan', gSysParam.FUserID));
      nTmp.Add(SF('L_YDate', FDM.SQLServerNow, sfVal));
    end;

    if IsProvideTruckAutoIO(2) then
    begin
      nTmp.Add(SF('L_Card', ''));
      nTmp.Add(SF('L_Status', sFlag_TruckOut));
      nTmp.Add(SF('L_NextStatus', ''));
      nTmp.Add(SF('L_OutMan', gSysParam.FUserID));
      nTmp.Add(SF('L_OutDate', FDM.SQLServerNow, sfVal));
    end else //auto out
    begin
      nTmp.Add(SF('L_Status', sFlag_TruckBFP));
      nTmp.Add(SF('L_NextStatus', sFlag_TruckOut));
    end;

    nStr := MakeSQLByCtrl(nil, sTable_ProvideLog, 'L_ID=' + gInfo.FRecord,
            False, nil, nTmp);
    nList.Add(nStr);
  finally
    nTmp.Free;
  end;
end;

procedure TfFormPBangFangP.AfterSaveData(var nDefault: Boolean);
begin
  PrintProvidePoundReport(gInfo.FRecord, True);
  BroadcastFrameCommand(Self, cCmd_RefreshData);
end;

initialization
  gControlManager.RegCtrl(TfFormPBangFangP, TfFormPBangFangP.FormID);
end.
