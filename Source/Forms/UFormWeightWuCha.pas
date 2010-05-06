{*******************************************************************************
  ����: dmzn@163.com 2010-3-8
  ����: 24Сʱ�Զ�Ƥ��
*******************************************************************************}
unit UFormWeightWuCha;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxContainer,
  cxEdit, cxLabel, cxRadioGroup, cxTextEdit;

type
  TfFormWeightWuCha = class(TfFormNormal)
    Radio1: TcxRadioButton;
    dxLayout1Item3: TdxLayoutItem;
    Radio2: TcxRadioButton;
    dxLayout1Item4: TdxLayoutItem;
    cxLabel2: TcxLabel;
    dxLayout1Item6: TdxLayoutItem;
    EditVal1: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Item7: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Item8: TdxLayoutItem;
    cxLabel4: TcxLabel;
    dxLayout1Item9: TdxLayoutItem;
    EditVal2: TcxTextEdit;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Item11: TdxLayoutItem;
    cxLabel3: TcxLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure OnLoadPopedom; override;
    procedure GetSaveSQLList(const nList: TStrings); override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    procedure InitFormData;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UFormCtrl, UMgrControl, UDataModule, USysBusiness, USysPopedom,
  USysDB, USysConst;

class function TfFormWeightWuCha.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  with TfFormWeightWuCha.Create(Application) do
  begin
    Caption := '�������';
    PopedomItem := nPopedom;

    InitFormData;
    ShowModal;
    Free;
  end;
end;

class function TfFormWeightWuCha.FormID: integer;
begin
  Result := cFI_FormBFWuCha;
end;

procedure TfFormWeightWuCha.OnLoadPopedom;
begin
  BtnOK.Enabled := gPopedomManager.HasPopedom(PopedomItem, sPopedom_Edit);
end;

procedure TfFormWeightWuCha.FormCreate(Sender: TObject);
begin
  inherited;
  LoadFormConfig(Self);
end;

procedure TfFormWeightWuCha.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SaveFormConfig(Self);
end;

//------------------------------------------------------------------------------
//Desc: ��ʼ����������
procedure TfFormWeightWuCha.InitFormData;
var nBool: Boolean;
begin
  EditVal1.Text := FloatToStr(GetWeightWuCha(nBool));
  EditVal2.Text := EditVal1.Text;

  if nBool then
       Radio1.Checked := True
  else Radio2.Checked := True;
end;

//Desc: ��֤����
function TfFormWeightWuCha.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
begin
  Result := True;

  if (Sender = EditVal1) or (Sender = EditVal2) then
  begin     
    Result := IsNumber(TcxTextEdit(Sender).Text, True) and
              (StrToFloat(TcxTextEdit(Sender).Text) > 0);
    nHint := '��������Ч����ֵ';
  end;
end;

//Desc: ����SQL
procedure TfFormWeightWuCha.GetSaveSQLList(const nList: TStrings);
var nStr,nSQL,nVal: string;
begin
  if Radio1.Checked then
  begin
    nStr := sFlag_Yes;
    nVal := EditVal1.Text;
  end else
  begin
    nStr := sFlag_No;
    nVal := EditVal2.Text;
  end;

  nSQL := 'Select D_ID From $T Where D_Name=''$N'' and D_Memo=''$M''';
  nSQL := MacroValue(nSQL, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
                           MI('$M', sFlag_WuCha)]);
  //xxxxx

  with FDM.QueryTemp(nSQL) do
  if RecordCount > 0 then
  begin
    nSQL := 'Update $T Set D_Value=''$V'',D_ParamA=$P Where D_ID=$ID';
    nSQL := MacroValue(nSQL, [MI('$T', sTable_SysDict), MI('$V', nStr),
            MI('$P', nVal), MI('$ID', Fields[0].AsString)]);
  end else
  begin
    nSQL := 'Insert Into $T(D_Name,D_Memo,D_Value,D_ParamA) Values(''$N'',' +
            '''$M'',''$V'',$P)';
    nSQL := MacroValue(nSQL, [MI('$T', sTable_SysDict), MI('$V', nStr),
            MI('$N', sFlag_SysParam), MI('$M', sFlag_WuCha), MI('$P', nVal)]);
  end;  

  nList.Add(nSQL);
end;

initialization
  gControlManager.RegCtrl(TfFormWeightWuCha, TfFormWeightWuCha.FormID);
end.
