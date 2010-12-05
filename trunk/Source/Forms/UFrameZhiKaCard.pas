{*******************************************************************************
  作者: dmzn@163.com 2009-7-15
  描述: 办理磁卡
*******************************************************************************}
unit UFrameZhiKaCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, Menus, dxLayoutControl,
  cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB, cxContainer, cxLabel,
  UBitmapPanel, cxSplitter, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin, UFrameNormal,
  cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFrameZhiKaCard = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditCus: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    cxLevel2: TcxGridLevel;
    cxView2: TcxGridDBTableView;
    DataSource2: TDataSource;
    SQLNo1: TADOQuery;
    PMenu2: TPopupMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    EditZK: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure cxGrid1ActiveTabChanged(Sender: TcxCustomGrid;
      ALevel: TcxGridLevel);
    procedure cxView2DblClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure PMenu1Popup(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure N17Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FWhereNo: string;
    //未开条件
    FStart,FEnd: TDate;
    //时间区间
    FQueryHas,FQueryNo: Boolean;
    //查询开关
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    procedure OnLoadGridConfig(const nIni: TIniFile); override;
    procedure OnSaveGridConfig(const nIni: TIniFile); override;
    procedure OnInitFormData(var nDefault: Boolean; const nWhere: string = '';
     const nQuery: TADOQuery = nil); override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UFormBase, USysDataDict, USysConst, USysDB, USysGrid,
  USysBusiness, UDataModule, UFormDateFilter, UForminputbox;

//------------------------------------------------------------------------------
class function TfFrameZhiKaCard.FrameID: integer;
begin
  Result := cFI_FrameZhiKaCard;
end;

procedure TfFrameZhiKaCard.OnCreateFrame;
begin
  inherited;
  FWhereNo := '';
  FQueryNo := True;
  FQueryHas := True;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameZhiKaCard.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

procedure TfFrameZhiKaCard.OnLoadGridConfig(const nIni: TIniFile);
begin
  if BtnAdd.Enabled then
       BtnAdd.Tag := 10
  else BtnAdd.Tag := 0;

  if BtnDel.Enabled then
       BtnDel.Tag := 10
  else BtnDel.Tag := 0;

  cxGrid1.ActiveLevel := cxLevel2;
  cxGrid1ActiveTabChanged(cxGrid1, cxGrid1.ActiveLevel);

  gSysEntityManager.BuildViewColumn(cxView2, 'MAIN_D05');
  InitTableView(Name, cxView2, nIni);
end;

procedure TfFrameZhiKaCard.OnSaveGridConfig(const nIni: TIniFile);
begin
  SaveUserDefineTableView(Name, cxView2, nIni);
end;

procedure TfFrameZhiKaCard.OnInitFormData(var nDefault: Boolean;
  const nWhere: string; const nQuery: TADOQuery);
var nStr: string;
begin
  nDefault := False;
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  if FQueryHas then
  begin
    nStr := 'Select zc.*,C_PY,C_Name,Z_ID From $ZC zc ' +
            ' Left Join $Cus cus On cus.C_ID=zc.C_OwnerID ' +
            ' Left Join $ZK zk On zk.Z_ID=zc.C_ZID ';
    //xxxxx

    if FWhere = '' then
         nStr := nStr + 'Where (Z_Date>=''$S'' and Z_Date<''$End'')'
    else nStr := nStr + 'Where (' + FWhere + ')';

    nStr := MacroValue(nStr, [MI('$ZC', sTable_ZhiKaCard),
            MI('$Cus', sTable_Customer), MI('$ZK', sTable_ZhiKa),
            MI('$S', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
    FDM.QueryData(SQLQuery, nStr);
  end;

  if not FQueryNo then Exit;
  nStr := 'Select zk.*,S_Name,C_PY,C_Name From $ZK zk ' +
          ' Left Join $ZC zc On zc.C_ZID=zk.Z_ID ' +
          ' Left Join $SM sm On sm.S_ID=zk.Z_SaleMan ' +
          ' Left Join $Cus cus On cus.C_ID=zk.Z_Custom ' +
          'Where (C_ZID Is Null) and (Z_InValid Is Null or Z_InValid<>''$Yes'')';
  //xxxxx

  if FWhereNo = '' then
       nStr := nStr + ' And (Z_Date>=''$S'' and Z_Date<''$End'')'
  else nStr := nStr + ' And (' + FWhereNo + ')';

  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
          MI('$ZC', sTable_ZhiKaCard), MI('$Yes', sFlag_Yes),
          MI('$Cus', sTable_Customer), MI('$SM', sTable_Salesman),
          MI('$S', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx

  FDM.QueryData(SQLNo1, nStr);
end;

//------------------------------------------------------------------------------
procedure TfFrameZhiKaCard.cxGrid1ActiveTabChanged(Sender: TcxCustomGrid;
  ALevel: TcxGridLevel);
begin
  //BtnAdd.Enabled := (BtnAdd.Tag > 0) and (cxGrid1.ActiveView = cxView2);
  BtnDel.Enabled := (BtnDel.Tag > 0) and (cxGrid1.ActiveView = cxView1);
end;

//Desc: 刷新
procedure TfFrameZhiKaCard.BtnRefreshClick(Sender: TObject);
begin
  FWhere := '';
  FWhereNo := '';
  FQueryNo := True;
  FQueryHas := True;
  InitFormData(FWhere);
end;

//Desc: 办理
procedure TfFrameZhiKaCard.BtnAddClick(Sender: TObject);
var nStr,nID: string;
    nParam: TFormCommandParam;
begin
  nID := '';
  if cxGrid1.ActiveView = cxView1 then
  begin
    if cxView1.DataController.GetSelectedCount > 0 then
         nID := SQLQuery.FieldByName('C_ZID').AsString
    else ShowMsg('请选择要办理的记录', sHint);
  end else

  if cxGrid1.ActiveView = cxView2 then
  begin
    if cxView2.DataController.GetSelectedCount > 0 then
         nID := SQLNo1.FieldByName('Z_ID').AsString
    else ShowMsg('请选择要办理的记录', sHint);
  end;

  if nID = '' then Exit;
  nStr := 'Select Count(*) From %s Where Z_ID=''%s'' And Z_Verified=''%s''';
  nStr := Format(nStr, [sTable_ZhiKa, nID, sFlag_Yes]);

  with FDM.QueryTemp(nStr) do
  if Fields[0].AsInteger < 1 then
  begin
    ShowMsg('该纸卡无法办理磁卡', '请先审核'); Exit;
  end;

  nParam.FCommand := cCmd_AddData;
  nParam.FParamA := nID;
  CreateBaseFormItem(cFI_FormZhiKaCard, '', @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    FQueryNo := True;
    FQueryHas := True;
    InitFormData(FWhere);
  end;
end;

//Desc 删除
procedure TfFrameZhiKaCard.BtnDelClick(Sender: TObject);
var nStr,nSQL: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的磁卡', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('C_Status').AsString;
  if (nStr <> sFlag_CardIdle) and (nStr <> sFlag_CardInvalid) then
  begin
    ShowMsg('空闲或注销卡允许删除', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('C_IsFreeze').AsString;
  if nStr = sFlag_Yes then
  begin
    ShowMsg('该卡已经被冻结', sHint); Exit;
  end;

  nSQL := '确定要对卡[ %s ]执行删除操作吗?';
  nStr := SQLQuery.FieldByName('C_Card').AsString;

  nSQL := Format(nSQL, [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Delete From %s Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_ZhiKaCard, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('删除操作成功', sHint);
end;

//Desc: 快捷菜单
procedure TfFrameZhiKaCard.N2Click(Sender: TObject);
begin
  BtnAddClick(nil);
end;

//Desc: 双击处理
procedure TfFrameZhiKaCard.cxView2DblClick(Sender: TObject);
begin
  BtnAddClick(nil);
end;

//Desc: 日期筛选
procedure TfFrameZhiKaCard.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameZhiKaCard.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditCus then
  begin
    EditCus.Text := Trim(EditCus.Text);
    if EditCus.Text = '' then Exit;

    FWhere := 'C_PY like ''%%%s%%'' or C_Name like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCus.Text, EditCus.Text]);
    FWhereNo := FWhere;
    
    FQueryNo := True;
    FQueryHas := True;
    InitFormData(FWhere);
  end else

  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    if EditCard.Text = '' then Exit;

    FQueryNo := False;
    FQueryHas := True;

    FWhere := 'C_Card like ''%' + EditCard.Text + '%''';
    FWhereNo := '';
    InitFormData(FWhere);
    cxGrid1.ActiveLevel := cxLevel1;
  end else

  if Sender = EditZK then
  begin
    EditZK.Text := Trim(EditZK.Text);
    if EditZK.Text = '' then Exit;

    FQueryNo := False;
    FQueryHas := True;

    FWhere := 'Z_ID like ''%' + EditZK.Text + '%''';
    FWhereNo := '';
    InitFormData(FWhere);
    cxGrid1.ActiveLevel := cxLevel1;
  end;
end;

//Desc: 查询全部未办理
procedure TfFrameZhiKaCard.N4Click(Sender: TObject);
begin
  FQueryNo := True;
  FQueryHas := False;

  FWhereNo := '1=1';
  InitFormData(FWhere);
end;

//Desc: 无效磁卡
procedure TfFrameZhiKaCard.N5Click(Sender: TObject);
begin
  FQueryNo := False;
  FQueryHas := True;

  FWhere := 'Z_ID Is Null';
  FWhere := Format(FWhere, [sFlag_No]);
  InitFormData(FWhere);
end;

//Desc: 全部磁卡
procedure TfFrameZhiKaCard.N6Click(Sender: TObject);
begin
  FQueryNo := False;
  FQueryHas := True;

  FWhere := '1=1';
  FWhere := Format(FWhere, [sFlag_Yes]);
  InitFormData(FWhere);
end;

//Desc: 冻结磁卡
procedure TfFrameZhiKaCard.N8Click(Sender: TObject);
begin
  FQueryNo := False;
  FQueryHas := True;

  FWhere := 'C_IsFreeze=''%s''';
  FWhere := Format(FWhere, [sFlag_Yes]);
  InitFormData(FWhere);
end;

//------------------------------------------------------------------------------
//Desc: 控制菜单项
procedure TfFrameZhiKaCard.PMenu1Popup(Sender: TObject);
var nStr: string;
    i,nCount: integer;
begin
  nCount := PMenu1.Items.Count - 1;
  for i:=0 to nCount do
    PMenu1.Items[i].Enabled := False;
  //xxxxx
  
  N1.Enabled := True;
  N17.Enabled := cxView1.DataController.GetSelectedCount > 0;
  //备注信息

  if (cxView1.DataController.GetSelectedCount > 0) and BtnAdd.Enabled then
  begin
    nStr := SQLQuery.FieldByName('C_Status').AsString;
    N9.Enabled := nStr = sFlag_CardUsed;
    //使用中的卡可以挂失
    N10.Enabled := nStr = sFlag_CardLoss;
    //已挂失卡可以解挂失
    N11.Enabled := nStr = sFlag_CardLoss;
    //已挂失卡可以补办卡
    N12.Enabled := nStr <> sFlag_CardInvalid;
    //可随时销卡
  end;

  if (cxView1.DataController.GetSelectedCount > 0) and BtnEdit.Enabled then
  begin
    nStr := SQLQuery.FieldByName('C_IsFreeze').AsString;
    N14.Enabled := nStr <> sFlag_Yes;   //冻结
    N15.Enabled := nStr = sFlag_Yes;    //解除
  end;
end;

//Desc: 挂失磁卡
procedure TfFrameZhiKaCard.N9Click(Sender: TObject);
var nStr,nSQL: string;
begin
  nSQL := '确定要对卡[ %s ]执行挂失操作吗?';
  nStr := SQLQuery.FieldByName('C_Card').AsString;

  nSQL := Format(nSQL, [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Update %s Set C_Status=''%s'' Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_ZhiKaCard, sFlag_CardLoss, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('挂失操作成功', sHint);
end;

//Desc: 解除挂失
procedure TfFrameZhiKaCard.N10Click(Sender: TObject);
var nStr,nSQL: string;
begin
  nSQL := '确定要对卡[ %s ]执行解除挂失操作吗?';
  nStr := SQLQuery.FieldByName('C_Card').AsString;

  nSQL := Format(nSQL, [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Update %s Set C_Status=''%s'' Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_ZhiKaCard, sFlag_CardUsed, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('解除挂失操作成功', sHint);
end;

//Desc: 补办磁卡
procedure TfFrameZhiKaCard.N11Click(Sender: TObject);
var nStr,nCard: string;
begin
  nCard := '';
  if not ShowInputBox('请输入新的磁卡号:', '补卡', nCard, 32) then Exit;

  if not IsCardCanUsed(nCard, nStr) then
  begin
    ShowMsg(nStr, sHint); Exit;
  end;

  FDM.ADOConn.BeginTrans;
  try
    nStr := SQLQuery.FieldByName('C_Card').AsString;
    ChangeNewCard(nStr, nCard);

    FDM.ADOConn.CommitTrans;
    InitFormData(FWhere);
    ShowMsg('补卡操作成功', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('补卡操作失败', sWarn);
  end;
end;

//Desc: 注销磁卡
procedure TfFrameZhiKaCard.N12Click(Sender: TObject);
var nStr,nSQL: string;
begin
  nStr := SQLQuery.FieldByName('C_Card').AsString;
  if IsCardHasTruckIn(nStr) then
  begin
    ShowMsg('该卡还有车辆未出厂', sHint); Exit;
  end;

  if IsCardHasBill(nStr) then
  begin
    ShowMsg('该卡还有提货单', sHint); Exit;
  end;

  nSQL := Format('确定要对卡[ %s ]执行销卡操作吗?', [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Update %s Set C_ZID='''',C_Status=''%s'' Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_ZhiKaCard, sFlag_CardInvalid, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('注销操作成功', sHint);
end;

//Desc: 冻结磁卡
procedure TfFrameZhiKaCard.N14Click(Sender: TObject);
var nStr,nSQL: string;
begin
  nSQL := '确定要对卡[ %s ]执行冻结操作吗?';
  nStr := SQLQuery.FieldByName('C_Card').AsString;

  nSQL := Format(nSQL, [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Update %s Set C_IsFreeze=''%s'' Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_ZhiKaCard, sFlag_Yes, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('冻结操作成功', sHint);
end;

//Desc: 解除冻结
procedure TfFrameZhiKaCard.N15Click(Sender: TObject);
var nStr,nSQL: string;
begin
  nSQL := '确定要对卡[ %s ]执行解除冻结操作吗?';
  nStr := SQLQuery.FieldByName('C_Card').AsString;

  nSQL := Format(nSQL, [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Update %s Set C_IsFreeze=''%s'' Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_ZhiKaCard, sFlag_No, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('解除冻结操作成功', sHint);
end;

//Desc: 修改备注
procedure TfFrameZhiKaCard.N17Click(Sender: TObject);
var nStr: string;
    nP: TFormCommandParam;
begin
  if BtnEdit.Enabled then
  begin
    nP.FCommand := cCmd_EditData;
    nP.FParamA := SQLQuery.FieldByName('C_Memo').AsString;
    nP.FParamB := 50;

    nStr := SQLQuery.FieldByName('R_ID').AsString;
    nP.FParamC := 'Update %s Set C_Memo=''$Memo'' Where R_ID=%s';
    nP.FParamC := Format(nP.FParamC, [sTable_ZhiKaCard, nStr]);

    CreateBaseFormItem(cFI_FormMemo, '', @nP);
    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
      InitFormData(FWhere);
    //xxxxx
  end else
  begin
    nP.FCommand := cCmd_ViewData;
    nP.FParamA := SQLQuery.FieldByName('C_Memo').AsString;
    CreateBaseFormItem(cFI_FormMemo, '', @nP);
  end;;
end;

initialization
  gControlManager.RegCtrl(TfFrameZhiKaCard, TfFrameZhiKaCard.FrameID);
end.
