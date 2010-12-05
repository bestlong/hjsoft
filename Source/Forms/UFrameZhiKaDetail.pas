{*******************************************************************************
  ����: dmzn@163.com 2009-7-15
  ����: ֽ��������ϸ��ѯ
*******************************************************************************}
unit UFrameZhiKaDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin;

type
  TfFrameZhiKaDetail = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditCus: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    EditZK: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    procedure EditZKPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N8Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    //ʱ������
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*��ѯSQL*}
    procedure FreezeZK(const nFreeze: Boolean);
    //����ѡ�������
    procedure SelectedZK(const nList: TStrings);
    //��ȡѡ��ֽ����
    function GetVal(const nRow: Integer; const nField: string): string;
    //��ȡָ���ֶ�
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, UFormDateFilter,
  UFormBase;

//------------------------------------------------------------------------------
class function TfFrameZhiKaDetail.FrameID: integer;
begin
  Result := cFI_FrameZhiKaDetail;
end;

procedure TfFrameZhiKaDetail.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameZhiKaDetail.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFrameZhiKaDetail.InitFormDataSQL(const nWhere: string): string;
begin
  N4.Enabled := BtnAdd.Enabled;
  N6.Enabled := BtnEdit.Enabled;
  EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select zk.*,zd.*,zd.R_ID as D_RID,S_PY,S_Name,C_PY,C_Name From $ZK zk ' +
            ' Left Join $SM sm on sm.S_ID=zk.Z_SaleMan' +
            ' Left Join $Cus cus on cus.C_ID=zk.Z_Custom' +
            ' Left Join $ZD zd on zd.D_ZID=zk.Z_ID ' +
            'Where (Z_Date>=''$STT'' and Z_Date<''$End'')';
  //xxxxx

  if nWhere = '' then
       Result := Result + ' and (Z_InValid Is Null or Z_InValid<>''$Yes'')'
  else Result := Result + ' and (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$ZK', sTable_ZhiKa), MI('$Yes', sFlag_Yes),
            MI('$ZD', sTable_ZhiKaDtl), MI('$SM', sTable_Salesman),
            MI('$Cus', sTable_Customer),
            MI('$STT', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//Desc: ��ѯ
procedure TfFrameZhiKaDetail.EditZKPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditZK then
  begin
    EditZK.Text := Trim(EditZK.Text);
    if EditZK.Text = '' then Exit;

    FWhere := Format('Z_ID Like ''%%%s%%''', [EditZK.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCus then
  begin
    EditCus.Text := Trim(EditCus.Text);
    if EditCus.Text = '' then Exit;

    FWhere := Format('C_PY Like ''%%%s%%'' or C_Name Like ''%%%s%%''',
              [EditCus.Text, EditCus.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: ����ɸѡ
procedure TfFrameZhiKaDetail.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//------------------------------------------------------------------------------
//Desc: ��ȡnRow��nField�ֶε�����
function TfFrameZhiKaDetail.GetVal(const nRow: Integer;
 const nField: string): string;
var nVal: Variant;
begin
  nVal := cxView1.DataController.GetValue(
            cxView1.Controller.SelectedRows[nRow].RecordIndex,
            cxView1.GetColumnByFieldName(nField).Index);
  //xxxxx

  if VarIsNull(nVal) then
       Result := ''
  else Result := nVal;
end;

//Desc: ��ȡѡ��ֽ���б�
procedure TfFrameZhiKaDetail.SelectedZK(const nList: TStrings);
var nStr: string;
    nIdx: Integer;
begin
  nList.Clear;
  for nIdx:=cxView1.Controller.SelectedRowCount - 1 downto 0 do
  begin
    nStr := GetVal(nIdx, 'Z_ID');
    if (nStr <> '') and (nList.IndexOf(nStr) < 0) then
      nList.Add(nStr);
    //xxxxx
  end;
end;

//Desc: ���ᵱǰѡ�е������
procedure TfFrameZhiKaDetail.FreezeZK(const nFreeze: Boolean);
var nStr,nY: string;
    nIdx: Integer;
    nList: TStrings;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
    Exit;
  //xxxxx

  nList := TStringList.Create;
  try
    SelectedZK(nList);
    if nList.Count < 1 then Exit;

    if nFreeze then
         nY := '''Y'''
    else nY := 'Null';

    FDM.ADOConn.BeginTrans;
    try
      for nIdx:=nList.Count - 1 downto 0 do
      begin
        nStr := 'Update %s Set Z_Freeze=%s Where Z_ID=''%s''';
        nStr := Format(nStr, [sTable_ZhiKa, nY, nList[nIdx]]);
        FDM.ExecuteSQL(nStr);
      end;

      FDM.ADOConn.CommitTrans;
      InitFormData(FWhere);
      ShowMsg('�����ɹ�', sHint);
    except
      FDM.ADOConn.RollbackTrans;
      ShowMsg('����ʧ��', sError);
    end;
  finally
    nList.Free;
  end;
end;

//Desc: ��ݲ�ѯ
procedure TfFrameZhiKaDetail.N1Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
   10: FWhere := Format('Z_InValid=''$Yes''', [sFlag_Yes]);
   20: FWhere := '1=1';
   30: FreezeZK(True);
   40: FreezeZK(False);
  end;

  InitFormData(FWhere);
end;

//Desc: ��Ʒ�ֶ���
procedure TfFrameZhiKaDetail.N8Click(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_ModalResult;
  CreateBaseFormItem(cFI_FormFreezeZK, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOk) then
  begin
    InitFormData(FWhere);
  end;
end;

//Desc: ѡ��ֽ������
procedure TfFrameZhiKaDetail.N6Click(Sender: TObject);
var nList: TStrings;
    nIdx,nLen: Integer;
    nP: TFormCommandParam;
    nStr,nRID,nZID,nStock,nType: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
    Exit;
  //xxxxx

  nList := TStringList.Create;
  try
    nType := GetVal(0, 'D_Type');
    nStock := GetVal(0, 'D_Stock');
    nLen := cxView1.DataController.GetSelectedCount - 1;

    for nIdx:=0 to nLen do
    begin
      nRID := GetVal(nIdx, 'D_RID');
      nZID := GetVal(nIdx, 'Z_ID');
      if (nRID = '') or (nZID = '') then Continue;

      if (GetVal(nIdx, 'D_Type') <> nType) or
         (GetVal(nIdx, 'D_Stock') <> nStock) then
      begin
        nStr := 'ֻ��ͬƷ�ֵ�ˮ�����ͳһ����,��¼[ %s ]������Ҫ��.';
        nStr := Format(nStr, [nRID]);
        ShowDlg(nStr, sHint, Handle); Exit;
      end;

      nStr := Format('%s;%s;%s;%s', [nRID,
              GetVal(nIdx, 'D_Price'), nZID, nStock]);
      nList.Add(nStr);
    end;

    if nList.Count < 1 then
    begin
      ShowMsg('ѡ�м�¼��Ч', sHint); Exit;
    end;

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := Integer(nList);
    CreateBaseFormItem(cFI_FormAdjustPrice, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOk) then
    begin
      InitFormData(FWhere);
    end;
  finally
    nList.Free;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameZhiKaDetail, TfFrameZhiKaDetail.FrameID);
end.
