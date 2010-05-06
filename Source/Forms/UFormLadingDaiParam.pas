{*******************************************************************************
  作者: dmzn 2009-07-16
  描述: 栈台配置参数
*******************************************************************************}
unit UFormLadingDaiParam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, StdCtrls, ExtCtrls, dxLayoutControl, cxContainer, cxEdit,
  cxTextEdit, cxControls, cxMemo, cxGraphics, cxLabel, cxMaskEdit,
  cxDropDownEdit, cxCheckComboBox;

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
    procedure BtnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditDescPropertiesChange(Sender: TObject);
    procedure PortList1PropertiesChange(Sender: TObject);
  private
    { Private declarations }
    procedure InitFormData;
    {*初始化界面*}
    procedure SaveZTParam(const nAll: Boolean);
    {*保存参数*}
  public
    { Public declarations }
  end;

function ShowZTParamForm: Boolean;
function LoadZTList(const nList: TStrings; const nAll: Boolean): Boolean;
function LoadForbidZtock(const nList: TStrings): Boolean;
function GetWeightPerPackage: Double;
//入口函数

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UAdjustForm, USysConst, USysFun, USysDB,
  cxLookAndFeelPainters;

resourcestring
  sZTParam = 'ZTParam';

//------------------------------------------------------------------------------
//Desc: 参数设置
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

//Desc: 读取栈台列表
function LoadZTList(const nList: TStrings; const nAll: Boolean): Boolean;
var nStr: string;
    nIdx: integer;
    nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    GetComPortNames(nList);
    Result := nList.Count > 0;

    nIdx := 0;
    while nIdx < nList.Count do
    begin
      nStr := nIni.ReadString(sZTParam, nList[nIdx], '空');
      if (nStr = '空') and (not nAll) then
      begin
        nList.Delete(nIdx); Continue;
      end;

      nList[nIdx] := Format('%s.%s', [nList[nIdx], nStr]);
      Inc(nIdx);
    end;
  finally
    nIni.Free;
  end;
end;

//Desc: 读取被屏蔽品种
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

//Desc: 获取每袋重量
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
  ReleaseCtrlData(Self);
end;

//------------------------------------------------------------------------------
//Desc: 初始化界面数据
procedure TfFormZTParam.InitFormData;
var nStr: string;
    nList: TStrings;
begin
  if LoadZTList(PortList1.Properties.Items, True) then
       AdjustStringsItem(PortList1.Properties.Items, False)
  else ShowMsg('获取COM端口列表失败', sHint);

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
end;

//Desc: 修改端口描述
procedure TfFormZTParam.EditDescPropertiesChange(Sender: TObject);
var nStr: string;
    nIdx: integer;
begin
  if EditDesc.Focused and (PortList1.ItemIndex > -1) then
  begin
    nIdx := PortList1.ItemIndex;
    nStr := PortList1.Properties.Items[nIdx];
    nStr := Copy(nStr, 1, Pos('.', nStr) - 1) + '.' + Trim(EditDesc.Text);

    PortList1.Properties.Items[nIdx] := nStr;
    PortList1.Text := nStr;
    PortList1.ItemIndex := nIdx;
  end;
end;

//Desc: 获取描述
procedure TfFormZTParam.PortList1PropertiesChange(Sender: TObject);
var nStr: string;
begin
  if PortList1.Focused then
  if PortList1.ItemIndex > -1 then
  begin
    if not PortList1.Focused then Exit;
    nStr := PortList1.Properties.Items[PortList1.ItemIndex];

    System.Delete(nStr, 1, Pos('.', nStr));
    EditDesc.Text := nStr;
  end else EditDesc.Text := '';
end;

//Desc: 保存栈台参数
procedure TfFormZTParam.SaveZTParam(const nAll: Boolean);
var nStr,nTmp: string;
    nIni: TIniFile;
    i,nCount,nPos: integer;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nIni.WriteString(sZTParam, 'StockForbid', EditStock.Text);
    if not nAll then Exit;
    
    with PortList1.Properties do
    begin
      nCount := Items.Count - 1;

      for i:=0 to nCount do
      begin
        nTmp := Items[i];
        nPos := Pos('.', nTmp);

        nStr := Copy(nTmp, 1, nPos - 1);
        System.Delete(nTmp, 1, nPos);
        nIni.WriteString(sZTParam, nStr, nTmp);
      end;
    end;

    nIni.WriteString(sZTParam, 'PerWeight', EditWeight.Text);
  finally
    nIni.Free;
  end;
end;

//Desc: 保存
procedure TfFormZTParam.BtnOKClick(Sender: TObject);
begin
  if (not IsNumber(EditWeight.Text, True)) Or
     (StrToFloat(EditWeight.Text) < 0) then
  begin
    EditWeight.SetFocus;
    ShowMsg('请输入有效的袋重值', sHint); Exit;
  end;

  SaveZTParam(True);
  ModalResult := mrOK;
  ShowMsg('参数已保存', sHint);
end;

end.
