{*******************************************************************************
  ����: dmzn@163.com 2009-7-2
  ����: ԭ����
*******************************************************************************}
unit UFramePMaterails;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, dxLayoutControl, cxMaskEdit,
  cxButtonEdit, cxTextEdit, ADODB, cxContainer, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin;

type
  TfFrameMaterails = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditName: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    procedure EditNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
  private
    { Private declarations }
  protected
    function InitFormDataSQL(const nWhere: string): string; override;
    {*��ѯSQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, UFormBase;

class function TfFrameMaterails.FrameID: integer;
begin
  Result := cFI_FrameMaterails;
end;

function TfFrameMaterails.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + sTable_Materails;
  if nWhere <> '' then
    Result := Result + ' Where (' + nWhere + ')';
  Result := Result + ' Order By M_Name';
end;

//Desc: ���
procedure TfFrameMaterails.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormMaterails, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: �޸�
procedure TfFrameMaterails.BtnEditClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nP.FCommand := cCmd_EditData;
    nP.FParamA := SQLQuery.FieldByName('M_ID').AsString;
    CreateBaseFormItem(cFI_FormMaterails, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
    end;
  end;
end;

//Desc: ɾ��
procedure TfFrameMaterails.BtnDelClick(Sender: TObject);
var nStr,nName: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nName := SQLQuery.FieldByName('M_Name').AsString;
    nStr := 'Select Count(*) From %s Where L_Mate=''%s''';
    nStr := Format(nStr, [sTable_ProvideLog, nName]);

    with FDM.QueryTemp(nStr) do
    if Fields[0].AsInteger > 0 then
    begin
      ShowMsg('��ԭ���޷�ɾ��', '�ѹ���'); Exit;
    end;

    nStr := Format('ȷ��Ҫɾ��ԭ����[ %s ]��?', [nName]);
    if not QueryDlg(nStr, sAsk) then Exit;

    nStr := 'Delete From %s Where M_ID=%s';
    nStr := Format(nStr, [sTable_Materails, SQLQuery.FieldByName('M_ID').AsString]);

    FDM.ExecuteSQL(nStr);
    InitFormData(FWhere);
  end;
end;

//Desc: ��ѯ
procedure TfFrameMaterails.EditNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    FWhere := Format('M_Name Like ''%%%s%%''', [EditName.Text]);
    InitFormData(FWhere);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameMaterails, TfFrameMaterails.FrameID);
end.
