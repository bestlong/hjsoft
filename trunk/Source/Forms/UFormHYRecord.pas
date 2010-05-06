{*******************************************************************************
  ����: dmzn@163.com 2009-07-20
  ����: ����¼��
*******************************************************************************}
unit UFormHYRecord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, cxGraphics, StdCtrls, cxMaskEdit, cxDropDownEdit,
  cxMCListBox, cxMemo, dxLayoutControl, cxContainer, cxEdit, cxTextEdit,
  cxControls, cxButtonEdit, cxCalendar, ExtCtrls, cxPC;

type
  TfFormHYRecord = class(TForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    BtnOK: TButton;
    dxLayoutControl1Item10: TdxLayoutItem;
    BtnExit: TButton;
    dxLayoutControl1Item11: TdxLayoutItem;
    dxLayoutControl1Group5: TdxLayoutGroup;
    EditID: TcxButtonEdit;
    dxLayoutControl1Item1: TdxLayoutItem;
    EditStock: TcxComboBox;
    dxLayoutControl1Item12: TdxLayoutItem;
    dxLayoutControl1Group2: TdxLayoutGroup;
    wPanel: TPanel;
    dxLayoutControl1Item4: TdxLayoutItem;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Bevel2: TBevel;
    cxTextEdit17: TcxTextEdit;
    cxTextEdit18: TcxTextEdit;
    cxTextEdit19: TcxTextEdit;
    cxTextEdit20: TcxTextEdit;
    cxTextEdit21: TcxTextEdit;
    cxTextEdit22: TcxTextEdit;
    cxTextEdit23: TcxTextEdit;
    cxTextEdit24: TcxTextEdit;
    cxTextEdit25: TcxTextEdit;
    cxTextEdit26: TcxTextEdit;
    cxTextEdit27: TcxTextEdit;
    cxTextEdit28: TcxTextEdit;
    cxTextEdit29: TcxTextEdit;
    cxTextEdit30: TcxTextEdit;
    cxTextEdit31: TcxTextEdit;
    cxTextEdit32: TcxTextEdit;
    cxTextEdit33: TcxTextEdit;
    cxTextEdit34: TcxTextEdit;
    cxTextEdit35: TcxTextEdit;
    cxTextEdit36: TcxTextEdit;
    cxTextEdit37: TcxTextEdit;
    cxTextEdit38: TcxTextEdit;
    cxTextEdit39: TcxTextEdit;
    cxTextEdit40: TcxTextEdit;
    cxTextEdit41: TcxTextEdit;
    cxTextEdit42: TcxTextEdit;
    cxTextEdit43: TcxTextEdit;
    cxTextEdit47: TcxTextEdit;
    cxTextEdit48: TcxTextEdit;
    cxTextEdit49: TcxTextEdit;
    EditDate: TcxDateEdit;
    dxLayoutControl1Item2: TdxLayoutItem;
    EditMan: TcxTextEdit;
    dxLayoutControl1Item3: TdxLayoutItem;
    dxLayoutControl1Group3: TdxLayoutGroup;
    Label1: TLabel;
    cxTextEdit1: TcxTextEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditStockPropertiesEditValueChanged(Sender: TObject);
    procedure cxTextEdit17KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FRecordID: string;
    //��ͬ���
    FPrefixID: string;
    //ǰ׺���
    FIDLength: integer;
    //ǰ׺����
    procedure InitFormData(const nID: string);
    //��������
    procedure GetData(Sender: TObject; var nData: string);
    function SetData(Sender: TObject; const nData: string): Boolean;
    //���ݴ���
  public
    { Public declarations }
  end;

function ShowStockRecordAddForm: Boolean;
function ShowStockRecordEditForm(const nID: string): Boolean;
procedure ShowStockRecordViewForm(const nID: string);
procedure CloseStockRecordForm;

function ShowStockRecordAddOrEditForm(const nSerialNo: string): Boolean;
procedure PrintStockRecordReport(const nID: string; const nAsk: Boolean);
procedure PrintStockHeGeReport(const nID: string; const nAsk: Boolean);
//��ں���

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UFormCtrl, UAdjustForm, USysDB, USysConst, UDataReport;

var
  gForm: TfFormHYRecord = nil;
  //ȫ��ʹ��

//------------------------------------------------------------------------------
//Desc: ���
function ShowStockRecordAddForm: Boolean;
begin
  with TfFormHYRecord.Create(Application) do
  begin
    FRecordID := '';
    Caption := '�����¼ - ���';

    InitFormData('');
    Result := ShowModal = mrOK;
    Free;
  end;
end;

//Desc: �޸�
function ShowStockRecordEditForm(const nID: string): Boolean;
begin
  with TfFormHYRecord.Create(Application) do
  begin
    FRecordID := nID;
    Caption := '�����¼ - �޸�';

    InitFormData(nID);
    Result := ShowModal = mrOK;
    Free;
  end;
end;

//Desc: �鿴
procedure ShowStockRecordViewForm(const nID: string);
begin
  if not Assigned(gForm) then
  begin
    gForm := TfFormHYRecord.Create(Application);
    gForm.Caption := '�����¼ - �鿴';
    gForm.FormStyle := fsStayOnTop;
    gForm.BtnOK.Visible := False;
  end;

  with gForm  do
  begin
    FRecordID := nID;
    InitFormData(nID);
    if not Showing then Show;
  end;
end;

procedure CloseStockRecordForm;
begin
  FreeAndNil(gForm);
end;

//Desc: ���or�޸ı��ΪnSerialNo��Ʒ��
function ShowStockRecordAddOrEditForm(const nSerialNo: string): Boolean;
var nStr: string;
begin
  nStr := 'Select Top 1 R_ID From %s Where R_serialNo=''%s'' Order By R_ID DESC';
  nStr := Format(nStr, [sTable_StockRecord, nSerialNo]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
         nStr := Fields[0].AsString
    else nStr := '';
  end;

  with TfFormHYRecord.Create(Application) do
  begin
    FRecordID := nStr;
    Caption := '���鵥 - �����¼';

    InitFormData(nStr);
    EditID.Enabled := False;
    
    Result := ShowModal = mrOK;
    Free;
  end;
end;

//Desc: ��ӡ��ʶΪnID�ļ����¼
procedure PrintStockRecordReport(const nID: string; const nAsk: Boolean);
var nStr: string;
begin
  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ���鵥?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From $SR sr ' +
          '  Left Join $SP sp On sp.P_ID=sr.R_PID ' +
          'Where sr.R_ID=$ID';

  nStr := MacroValue(nStr, [MI('$SR', sTable_StockRecord),
            MI('$SP', sTable_StockParam), MI('$ID', nID)]);

  if FDM.QueryTemp(nStr).RecordCount <> 1 then
  begin
    nStr := '���Ϊ[ %s] �ļ����¼����Ч!!';
    nStr := Format(nStr, [nID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := FDM.SqlTemp.FieldByName('P_Stock').AsString;
  if Pos('32', nStr) > 0 then
    nStr := gPath + sReportDir + 'HuaYan32_R.fr3'
  else if Pos('42', nStr) > 0 then
    nStr := gPath + sReportDir + 'HuaYan42_R.fr3'
  else nStr := '';

  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
end;

//Desc: ��ӡ���ΪnID�ĺϸ�֤
procedure PrintStockHeGeReport(const nID: string; const nAsk: Boolean);
var nStr: string;
begin
  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ�ϸ�֤?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From $SR sr ' +
          '  Left Join $SP sp On sp.P_ID=sr.R_PID ' +
          'Where sr.R_ID=$ID';

  nStr := MacroValue(nStr, [MI('$SR', sTable_StockRecord),
            MI('$SP', sTable_StockParam), MI('$ID', nID)]);

  if FDM.QueryTemp(nStr).RecordCount <> 1 then
  begin
    nStr := '���Ϊ[ %s] �ļ����¼����Ч!!';
    nStr := Format(nStr, [nID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'HeGeZheng_R.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
end;

//------------------------------------------------------------------------------
procedure TfFormHYRecord.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  ResetHintAllForm(Self, 'E', sTable_StockRecord);
  //���ñ�����
  
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    FPrefixID := nIni.ReadString(Name, 'IDPrefix', 'SN');
    FIDLength := nIni.ReadInteger(Name, 'IDLength', 8);
  finally
    nIni.Free;
  end;
end;

procedure TfFormHYRecord.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;

  gForm := nil;
  Action := caFree;
  ReleaseCtrlData(Self);
end;

procedure TfFormHYRecord.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFormHYRecord.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0; Close;
  end else

  if Key = VK_DOWN then
  begin
    Key := 0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end else

  if Key = VK_UP then
  begin
    Key := 0;
    Perform(WM_NEXTDLGCTL, 1, 0);
  end;
end;

procedure TfFormHYRecord.cxTextEdit17KeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = Char(VK_RETURN) then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormHYRecord.GetData(Sender: TObject; var nData: string);
begin
  if Sender = EditDate then nData := DateTime2Str(EditDate.Date);
end;

function TfFormHYRecord.SetData(Sender: TObject; const nData: string): Boolean;
begin
  if Sender = EditDate then
  begin
    EditDate.Date := Str2DateTime(nData);
    Result := True;
  end else Result := False;
end;

//Date: 2009-6-2
//Parm: ��¼���
//Desc: ����nID��Ӧ�̵���Ϣ������
procedure TfFormHYRecord.InitFormData(const nID: string);
var nStr: string;
begin
  EditDate.Date := Now;
  EditMan.Text := gSysParam.FUserID;
  
  if EditStock.Properties.Items.Count < 1 then
  begin
    nStr := 'P_ID=Select P_ID,P_Name From %s';
    nStr := Format(nStr, [sTable_StockParam]);

    FDM.FillStringsData(EditStock.Properties.Items, nStr, -1, '��');
    AdjustStringsItem(EditStock.Properties.Items, False);
  end;

  if nID <> '' then
  begin
    nStr := 'Select * From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_StockRecord, nID]);
    LoadDataToForm(FDM.QueryTemp(nStr), Self, '', SetData);
  end;
end;

//Desc: ��������
procedure TfFormHYRecord.EditStockPropertiesEditValueChanged(Sender: TObject);
var nStr: string;
begin
  if FRecordID = '' then
  begin
    nStr := 'Select * From %s Where R_PID=''%s''';
    nStr := Format(nStr, [sTable_StockParamExt, GetCtrlData(EditStock)]);
    LoadDataToCtrl(FDM.QueryTemp(nStr), wPanel);
  end;
end;

//Desc: ����������
procedure TfFormHYRecord.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  EditID.Text := FDM.GetSerialID(FPrefixID, sTable_StockRecord, 'R_SerialNo');
end;

//Desc: ��������
procedure TfFormHYRecord.BtnOKClick(Sender: TObject);
var nStr,nSQL: string;
begin
  EditID.Text := Trim(EditID.Text);
  if EditID.Text = '' then
  begin
    EditID.SetFocus;
    ShowMsg('����д��Ч��ˮ����', sHint); Exit;
  end;

  if EditStock.ItemIndex < 0 then
  begin
    EditStock.SetFocus;
    ShowMsg('����д��Ч��Ʒ��', sHint); Exit;
  end;

  if FRecordID = '' then
  begin
    nSQL := MakeSQLByForm(Self, sTable_StockRecord, '', True, GetData);
  end else
  begin
    EditID.Text := FRecordID;
    nStr := 'R_ID=''' + FRecordID + '''';
    nSQL := MakeSQLByForm(Self, sTable_StockRecord, nStr, False, GetData);
  end;

  FDM.ExecuteSQL(nSQL);
  ModalResult := mrOK;
  ShowMsg('�����ѱ���', sHint);
end;

end.
