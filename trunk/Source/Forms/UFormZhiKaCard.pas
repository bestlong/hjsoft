{*******************************************************************************
  作者: dmzn@163.com 2010-3-14
  描述: 纸卡办理磁卡
*******************************************************************************}
unit UFormZhiKaCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxCheckBox,
  cxEdit, cxTextEdit, cxContainer, cxMCListBox, ComCtrls, cxMaskEdit,
  cxButtonEdit, cxListView, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TfFormZhiKaCard = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    ListInfo: TcxMCListBox;
    dxLayout1Item3: TdxLayoutItem;
    Check1: TcxCheckBox;
    dxLayout1Item6: TdxLayoutItem;
    ListCard: TcxListView;
    dxLayout1Item7: TdxLayoutItem;
    EditPwd: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxButtonEdit1PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnOKClick(Sender: TObject);
    procedure ListCardClick(Sender: TObject);
    procedure ListCardDblClick(Sender: TObject);
    procedure EditCardKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FRecordID: string;
    //纸卡编号
    procedure InitFormData(const nID: string);
    //载入数据
    procedure LoadCardList;
    //载入磁卡
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, DB, ULibFun, UMgrControl, UFormCtrl, UFormBase, UAdjustForm,
  USysGrid, USysBusiness, USysDB, USysConst, UDataModule;

type
  TZhiKaItem = record
    FZID: string;
    FPwd: string;
    FCus: string;
    FOnly: Boolean;
  end;

  TCardItem = record
    FCard: string;         //卡号
    FPwd: string;          //密码
    FStatus: string;       //状态
    FTruckNo: string;      //车牌
    FMaxTime: Integer;     //限提
    FBillTime: Integer;    //已提
    FMan: string;          //办理人
    FDate: string;         //日期
    FValid: Boolean;       //有效
    FOnlyLade: string;     //提货卡
  end;

var
  gZhiKa: TZhiKaItem;
  gCardItems: array of TCardItem;
  //全局使用

//------------------------------------------------------------------------------
class function TfFormZhiKaCard.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormZhiKaCard.Create(Application) do
  begin
    FRecordID := nP.FParamA;
    Caption := '办理磁卡';

    InitFormData(FRecordID);
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
    Free;
  end;
end;

class function TfFormZhiKaCard.FormID: integer;
begin
  Result := cFI_FormZhiKaCard;
end;

procedure TfFormZhiKaCard.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, ListInfo, nIni);
    LoadcxListViewConfig(Name, ListCard, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormZhiKaCard.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, ListInfo, nIni);
    SavecxListViewConfig(Name, ListCard, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 载入nID纸卡的内容
procedure TfFormZhiKaCard.InitFormData(const nID: string);
var nStr: string;
    nDS: TDataset;
    nIdx: integer;
begin
  ActiveControl := EditCard;
  nDS := LoadZhiKaInfo(nID, ListInfo, nStr);

  if not Assigned(nDS) then
  begin
    BtnOK.Enabled := False;
    ShowMsg(nStr, sHint); Exit;
  end;

  gZhiKa.FZID := nID;
  gZhiKa.FPwd := nDS.FieldByName('Z_Password').AsString;
  gZhiKa.FCus := nDS.FieldByName('Z_Custom').AsString;
  gZhiKa.FOnly := nDS.FieldByName('Z_OnlyPwd').AsString = sFlag_Yes;

  EditPwd.Text := gZhiKa.FPwd;
  Check1.Checked := gZhiKa.FOnly;

  SetLength(gCardItems, 0);
  nStr := 'Select * From %s Where C_ZID=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaCard, nID]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    SetLength(gCardItems, RecordCount);
    nIdx := 0;
    First;

    while not Eof do
    with gCardItems[nIdx] do
    begin
      FCard := FieldByName('C_Card').AsString;
      FPwd := FieldByName('C_Password').AsString;
      FStatus := FieldByName('C_Status').AsString;

      FMaxTime := FieldByName('C_MaxTime').AsInteger;
      FBillTime := FieldByName('C_BillTime').AsInteger;
      FTruckNo := FieldByName('C_TruckNo').AsString;
      
      FMan := FieldByName('C_Man').AsString;
      FDate := Format('''%s''', [FieldByName('C_Date').AsString]);
      FValid := FieldByName('C_IsFreeze').AsString <> sFlag_Yes;
      FOnlyLade := FieldByName('C_OnlyLade').AsString;

      Inc(nIdx);
      Next;
    end;

    LoadCardList;
  end;
end;

//Desc: 读取卡列表
procedure TfFormZhiKaCard.LoadCardList;
var nStr: string;
    nIdx,nItem: Integer;
begin
  nItem := ListCard.ItemIndex;
  ListCard.Items.BeginUpdate;
  try
    ListCard.Clear;

    for nIdx:=Low(gCardItems) to High(gCardItems) do
    with ListCard.Items.Add do
    begin
      Caption := gCardItems[nIdx].FCard;
      nStr := CardStatusToStr(gCardItems[nIdx].FStatus);
      SubItems.Add(nStr);

      nStr := StringOfChar('*', Length(gCardItems[nIdx].FPwd));
      SubItems.Add(nStr);
      Checked := gCardItems[nIdx].FValid;
    end;
  finally
    ListCard.Items.EndUpdate;
    ListCard.ItemIndex := nItem;
  end;
end;

procedure TfFormZhiKaCard.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nP: TFormCommandParam;
begin
  CreateBaseFormItem(cFI_FormSetPassword, '', @nP);
  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    EditPwd.Text := nP.FParamB;
  //xxxxx
end;

procedure TfFormZhiKaCard.ListCardClick(Sender: TObject);
var nIdx: integer;
begin
  for nIdx:=Low(gCardItems) to High(gCardItems) do
   if gCardItems[nIdx].FValid <> ListCard.Items[nIdx].Checked then
    gCardItems[nIdx].FValid := ListCard.Items[nIdx].Checked;
  //xxxxx
end;

//Desc: 添加新磁卡
procedure TfFormZhiKaCard.cxButtonEdit1PropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
var nStr: string;
    nIdx: integer;
    nP: TFunctionParam;
begin
  EditCard.Text := Trim(EditCard.Text);
  if EditCard.Text = '' then
  begin
    EditCard.SetFocus;
    ShowMsg('请填写有效的卡号', sHint); Exit;
  end;

  for nIdx:=Low(gCardItems) to High(gCardItems) do
  if gCardItems[nIdx].FCard = EditCard.Text then
  begin
    EditCard.SetFocus;
    ShowMsg('该卡已在列表中', sHint); Exit;
  end;

  if not IsCardCanUsed(EditCard.Text, nStr, @nP) then
  begin
    EditCard.SetFocus;
    ShowMsg(nStr, sHint); Exit;
  end;

  nIdx := Length(gCardItems);
  SetLength(gCardItems, nIdx + 1);
  FillChar(gCardItems[nIdx], SizeOf(TCardItem), #0);

  with gCardItems[nIdx] do
  begin
    FCard := EditCard.Text;
    FStatus := sFlag_CardUsed;
    FMan := gSysParam.FUserID;
    FDate := FDM.SQLServerNow;

    FValid := True;
    FOnlyLade := sFlag_No;

    if VarIsNumeric(nP.FParamA) then
    begin
      FMaxTime := nP.FParamA;
      FBillTime := FMaxTime; //新卡若限提则不允许提货
    end; 
  end;

  LoadCardList;
end;

procedure TfFormZhiKaCard.EditCardKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    TcxButtonEdit(Sender).Properties.OnButtonClick(Sender, 0);
    TcxButtonEdit(Sender).SelectAll;
  end;
end;

//Desc: 设置密码
procedure TfFormZhiKaCard.ListCardDblClick(Sender: TObject);
var nList: TStrings;
    nP: TFormCommandParam;
begin
  if ListCard.ItemIndex > -1 then
  with gCardItems[ListCard.ItemIndex] do
  begin
    nP.FParamA := FCard;
    nP.FParamB := CombinStr([FPwd, FTruckNo, 
                  IntToStr(FMaxTime), IntToStr(FBillTime), FOnlyLade], #9);
    //pwd + truck + max + bill

    nList := nil;
    nP.FCommand := cCmd_EditData;
    CreateBaseFormItem(cFI_FormSetCardPwd, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    try
      nList := TStringList.Create;
      if not SplitStr(nP.FParamB, nList, 5, #9) then Exit;

      FPwd := nList[0];
      FTruckNo := nList[1];
      FMaxTime := StrToInt(nList[2]);

      FBillTime := StrToInt(nList[3]);
      FOnlyLade := nList[4];
      LoadCardList;
    finally
      nList.Free;
    end;
  end;
end;

//Desc: 保存
procedure TfFormZhiKaCard.BtnOKClick(Sender: TObject);
var nStr,nSQL: string;
    nIdx: integer;
begin
  if Length(gCardItems) < 1 then
  begin
    EditCard.SetFocus;
    ShowMsg('请先办理磁卡', sHint); Exit;
  end;

  FDM.ADOConn.BeginTrans;
  try
    if (gZhiKa.FPwd <> EditPwd.Text) or (gZhiKa.FOnly <> Check1.Checked) then
    begin
      if Check1.Checked then
           nStr := sFlag_Yes
      else nStr := sFlag_No;

      nSQL := 'Update %s Set Z_Password=''%s'',Z_OnlyPwd=''%s'' ' +
              'Where Z_ID=''%s''';
      nSQL := Format(nSQL, [sTable_ZhiKa, EditPwd.Text, nStr, gZhika.FZID]);
      FDM.ExecuteSQL(nSQL);
    end;

    nStr := 'Insert Into $TB(C_ZID,C_Card,C_Password,C_OwnerID,C_Status,' +
            'C_IsFreeze,C_TruckNo,C_MaxTime,C_BillTime,C_FixZK,C_OnlyLade,' +
            'C_Man,C_Date) Values(''$ZID'',''$CID'',''$Pwd'',''$OID'',' +
            '''$Sta'',''$Fre'',''$Truck'',$Max,$Bill,''$FZK'',''$OL'',''$CM'',$CD)';
    nStr := MacroValue(nStr, [MI('$TB', sTable_ZhiKaCard), MI('$ZID', gZhiKa.FZID),
            MI('$OID', gZhiKa.FCus)]);
    //xxxxx

    for nIdx:=Low(gCardItems) to High(gCardItems) do
    with gCardItems[nIdx] do
    begin
      nSQL := 'Update $TB Set C_ZID=''$ZID'',C_Password=''$Pwd'',' +
              'C_Status=''$Used'',C_OwnerID=''$OID'',C_IsFreeze=''$Fre'',' +
              'C_TruckNo=''$Truck'',C_Man=''$CM'',C_FixZK=''$FZK'',' +
              'C_OnlyLade=''$OL'',C_Date=$CD,C_MaxTime=$Max,' +
              'C_BillTime=$Bill Where C_Card=''$CID''';
      nSQL := MacroValue(nSQL, [MI('$TB', sTable_ZhiKaCard), MI('$Pwd', FPwd),
              MI('$Used', sFlag_CardUsed), MI('$OID', gZhiKa.FCus),
              MI('$ZID', gZhiKa.FZID), MI('$CID', FCard),
              MI('$FZK', gZhiKa.FZID), MI('$OL', FOnlyLade),
              MI('$CM', FMan), MI('$CD', FDate), MI('$Truck', FTruckNo),
              MI('$Max', IntToStr(FMaxTime)), MI('$Bill', IntToStr(FBillTime))]);
      //xxxxx

      if FValid then
           nSQL := MacroValue(nSQL, [MI('$Fre', sFlag_No)])
      else nSQL := MacroValue(nSQL, [MI('$Fre', sFlag_Yes)]);
      if FDM.ExecuteSQL(nSQL) > 0 then Continue;

      nSQL := MacroValue(nStr, [MI('$CID', FCard), MI('$Pwd', FPwd),
              MI('$Sta', FStatus), MI('$Truck', FTruckNo),
              MI('$FZK', gZhiKa.FZID), MI('$OL', FOnlyLade),
              MI('$CM', FMan), MI('$CD', FDate),
              MI('$Max', IntToStr(FMaxTime)), MI('$Bill', IntToStr(FBillTime))]);
      //xxxxx

      if FValid then
           nSQL := MacroValue(nSQL, [MI('$Fre', sFlag_No)])
      else nSQL := MacroValue(nSQL, [MI('$Fre', sFlag_Yes)]);
      FDM.ExecuteSQL(nSQL);
    end;

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOk;
    ShowMsg('磁卡办理成功', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('数据保存失败', sWarn);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormZhiKaCard, TfFormZhiKaCard.FormID);
end.
