{*******************************************************************************
  ����: dmzn 2009-07-16
  ����: ջ̨���ò���
*******************************************************************************}
unit UFormLadingDaiParam_M;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, StdCtrls, ExtCtrls, dxLayoutControl, cxContainer, cxEdit,
  cxTextEdit, cxControls, cxMemo, cxGraphics, cxLabel, cxMaskEdit,
  cxDropDownEdit, cxCheckComboBox, cxLookAndFeels, cxLookAndFeelPainters,
  Menus, cxButtons, cxMCListBox;

type
  TfFormZTParam = class(TForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    EditDesc: TcxTextEdit;
    dxLayoutControl1Item1: TdxLayoutItem;
    EditWeight: TcxTextEdit;
    dxLayoutControl1Item2: TdxLayoutItem;
    BtnExit: TButton;
    dxLayoutControl1Item7: TdxLayoutItem;
    BtnOK: TButton;
    dxLayoutControl1Item8: TdxLayoutItem;
    dxLayoutControl1Group2: TdxLayoutGroup;
    PortList1: TcxComboBox;
    dxLayoutControl1Item9: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayoutControl1Item3: TdxLayoutItem;
    dxLayoutControl1Group3: TdxLayoutGroup;
    dxLayoutControl1Group4: TdxLayoutGroup;
    EditStock: TcxCheckComboBox;
    dxLayoutControl1Item4: TdxLayoutItem;
    cxLabel2: TcxLabel;
    dxLayoutControl1Item5: TdxLayoutItem;
    ListTunnel: TcxMCListBox;
    dxLayoutControl1Item6: TdxLayoutItem;
    cxLabel3: TcxLabel;
    dxLayoutControl1Item10: TdxLayoutItem;
    dxLayoutControl1Group5: TdxLayoutGroup;
    EditNum: TcxTextEdit;
    dxLayoutControl1Item11: TdxLayoutItem;
    EditDelay: TcxTextEdit;
    dxLayoutControl1Item12: TdxLayoutItem;
    dxLayoutControl1Group6: TdxLayoutGroup;
    BtnDel: TcxButton;
    dxLayoutControl1Item13: TdxLayoutItem;
    BtnAdd: TcxButton;
    dxLayoutControl1Item14: TdxLayoutItem;
    dxLayoutControl1Group8: TdxLayoutGroup;
    dxLayoutControl1Group7: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure ListTunnelClick(Sender: TObject);
  private
    { Private declarations }
    procedure InitFormData;
    {*��ʼ������*}
    procedure SaveZTParam(const nAll: Boolean);
    {*�������*}
  public
    { Public declarations }
  end;

function ShowZTParamForm: Boolean;
function LoadZTList(const nList: TStrings): Boolean;
function LoadForbidZtock(const nList: TStrings): Boolean;
function GetWeightPerPackage: Double;
//��ں���

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrCOMM, UAdjustForm, USysConst, USysGrid, USysDB;

resourcestring
  sZTParam = 'ZTParam';

//------------------------------------------------------------------------------
//Desc: ��������
function ShowZTParamForm: Boolean;
begin
  with TfFormZTParam.Create(Application) do
  begin
    InitFormData;
    BtnOK.Enabled := gSysParam.FIsAdmin;

    Result := ShowModal = mrOK;
    Free;
  end;
end;

//Desc: ��ȡջ̨�б�
function LoadZTList(const nList: TStrings): Boolean;
var nStr: string;
    nIdx: integer;
    nIni: TIniFile;
begin
  nList.Clear;
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nIdx := 0;

    while True do
    begin
      nStr := nIni.ReadString(sZTParam, 'Line' + IntToStr(nIdx), '');
      if nStr <> '' then
      begin
        nList.Add(nStr);
        Inc(nIdx);
      end else Break;
    end;

    Result := nList.Count > 0;
  finally
    nIni.Free;
  end;
end;

//Desc: ��ȡ������Ʒ��
function LoadForbidZtock(const nList: TStrings): Boolean;
var nStr: string;
    nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nStr := nIni.ReadString(sZTParam, 'StockForbid', '');
    Result := SplitStr(nStr, nList, 0, ';');
  finally
    nIni.Free;
  end;
end;

//Desc: ��ȡÿ������
function GetWeightPerPackage: Double;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    Result := nIni.ReadInteger(sZTParam, 'PerWeight', 0);
    if Result < 1 then Result := 1;
  finally
    nIni.Free;
  end;
end;

procedure TfFormZTParam.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ModalResult <> mrOK then
    SaveZTParam(False);
  SaveMCListBoxConfig(Name, ListTunnel);
end;

//------------------------------------------------------------------------------
//Desc: ��ʼ����������
procedure TfFormZTParam.InitFormData;
var nStr: string;
    nList: TStrings;
begin
  GetValidCOMPort(PortList1.Properties.Items);
  LoadZTList(ListTunnel.Items);
  EditWeight.Text := FloatToStr(GetWeightPerPackage);

  nList := TStringList.Create;
  try
    EditStock.Properties.Items.Clear;
    LoadForbidZtock(nList);

    nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                        MI('$Name', sFlag_StockItem)]);
    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        if FieldByName('D_Memo').AsString = sFlag_Dai then
        begin
          nStr := FieldByName('D_Value').AsString;
          with EditStock.Properties.Items.Add do
          begin
            Description := nStr;
            if nList.IndexOf(nStr) > -1 then
              EditStock.States[Index] := cbsChecked;
            //xxxxx
          end;
        end;

        Next;
      end;
    end;
  finally
    nList.Free;
  end;

  LoadMCListBoxConfig(Name, ListTunnel);
  //list config
end;

//Desc: ����ջ̨����
procedure TfFormZTParam.SaveZTParam(const nAll: Boolean);
var nIni: TIniFile;
    i,nCount: integer;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    if nAll then
    begin
      nIni.EraseSection(sZTParam);
      nIni.WriteString(sZTParam, 'PerWeight', EditWeight.Text);
    end;

    nIni.WriteString(sZTParam, 'StockForbid', EditStock.Text);
    if not nAll then Exit;
    
    nCount := ListTunnel.Items.Count - 1;
    for i:=0 to nCount do
      nIni.WriteString(sZTParam, 'Line' + IntToStr(i), ListTunnel.Items[i]);
    //xxxxx
  finally
    nIni.Free;
  end;
end;

//Desc: ���
procedure TfFormZTParam.BtnAddClick(Sender: TObject);
var nIdx: Integer;
    nList: TStrings;
begin
  PortList1.Text := Trim(PortList1.Text);
  if PortList1.Text = '' then
  begin
    PortList1.SetFocus;
    ShowMsg('��������Ч�Ķ˿�', sHint); Exit;
  end;

  EditDesc.Text := Trim(EditDesc.Text);
  if EditDesc.Text = '' then
  begin
    EditDesc.SetFocus;
    ShowMsg('��������Ч����', sHint); Exit;
  end;

  if not IsNumber(EditNum.Text, False) then
  begin
    EditNum.SetFocus;
    ShowMsg('��������Ч�ı��', sHint); Exit;
  end;

  if not IsNumber(EditDelay.Text, False) then
  begin
    EditDelay.SetFocus;
    ShowMsg('��������Ч���ӳ�', sHint); Exit;
  end;

  nList := TStringList.Create;
  try
    for nIdx:=ListTunnel.Items.Count - 1 downto 0 do
    begin
      if not SplitStr(ListTunnel.Items[nIdx], nList, 4, ';') then Continue;
      if (CompareText(PortList1.Text, nList[1]) = 0) and
         (EditNum.Text = nList[2]) then
      begin
        ListTunnel.Items[nIdx] := EditDesc.Text + ';' + PortList1.Text + ';' +
                                  EditNum.Text + ';' + EditDelay.Text;
        Exit;
      end;
    end;
  finally
    nList.Free;
  end;

  ListTunnel.Items.Add(EditDesc.Text + ';' + PortList1.Text + ';' +
                       EditNum.Text + ';' + EditDelay.Text);
  //xxxxx
end;

//Desc: ɾ��
procedure TfFormZTParam.BtnDelClick(Sender: TObject);
begin
  if ListTunnel.ItemIndex > -1 then
       ListTunnel.DeleteSelected
  else ShowMsg('��ѡ��Ҫɾ���ļ�¼', sHint);
end;

//Desc: ��ʾѡ��
procedure TfFormZTParam.ListTunnelClick(Sender: TObject);
var nList: TStrings;
begin
  nList := TStringList.Create;
  try
    if SplitStr(ListTunnel.Items[ListTunnel.ItemIndex], nList, 4, ';') then
    begin
      EditDesc.Text := nList[0];
      PortList1.Text := nList[1];
      EditNum.Text := nList[2];
      EditDelay.Text := nList[3];
    end;
  finally
    nList.Free;
  end;
end;

//Desc: ����
procedure TfFormZTParam.BtnOKClick(Sender: TObject);
begin
  if (not IsNumber(EditWeight.Text, True)) or
     (StrToFloat(EditWeight.Text) < 0) then
  begin
    EditWeight.SetFocus;
    ShowMsg('��������Ч�Ĵ���ֵ', sHint); Exit;
  end;

  SaveZTParam(True);
  ModalResult := mrOK;
  ShowMsg('�����ѱ���', sHint);
end;

end.
