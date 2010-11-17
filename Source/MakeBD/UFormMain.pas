{*******************************************************************************
  作者: dmzn@163.com 2010-9-19
  描述: 主单元
*******************************************************************************}
unit UFormMain;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UTrayIcon, Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Menus, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxCheckBox, DB, ADODB,
  StdCtrls, ExtCtrls, dxStatusBar, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxClasses, cxGridCustomView, cxGrid, cxTextEdit,
  cxProgressBar, cxLabel, cxButtons, cxGroupBox, cxMemo, cxRichEdit, cxPC,
  cxDBData, cxGridDBTableView, cxDropDownEdit, cxCalendar, cxMaskEdit;

type
  TfFormMain = class(TForm)
    wPage: TcxPageControl;
    Sheet2: TcxTabSheet;
    cxLookAndFeelController1: TcxLookAndFeelController;
    ADOConnLocal: TADOConnection;
    ADOQuery1: TADOQuery;
    SBar1: TdxStatusBar;
    HintPanel: TPanel;
    Image1: TImage;
    Image2: TImage;
    HintLabel: TLabel;
    cxDefaultEditStyleController1: TcxDefaultEditStyleController;
    cxGroupBox1: TcxGroupBox;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    EditLocalDB: TcxTextEdit;
    EditLocalHost: TcxTextEdit;
    EditLocalPort: TcxTextEdit;
    EditLocalUser: TcxTextEdit;
    EditLocalPwd: TcxTextEdit;
    ADOCmd1: TADOQuery;
    PMenu1: TPopupMenu;
    N2: TMenuItem;
    BtnConn: TcxButton;
    Sheet1: TcxTabSheet;
    DataSource1: TDataSource;
    QueryDB1: TADOQuery;
    cxGroupBox2: TcxGroupBox;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    EditPValue: TcxTextEdit;
    EditMValue: TcxTextEdit;
    EditPer: TcxComboBox;
    EditMate: TcxComboBox;
    EditTruck: TcxComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EditPMan: TcxComboBox;
    EditMMan: TcxComboBox;
    EditPTime: TcxDateEdit;
    EditMTime: TcxDateEdit;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxButton3: TcxButton;
    Label5: TLabel;
    cxLabel11: TcxLabel;
    cxView1Column1: TcxGridDBColumn;
    cxView1Column2: TcxGridDBColumn;
    cxView1Column3: TcxGridDBColumn;
    cxView1Column4: TcxGridDBColumn;
    cxView1Column5: TcxGridDBColumn;
    cxView1Column6: TcxGridDBColumn;
    cxView1Column7: TcxGridDBColumn;
    cxView1Column8: TcxGridDBColumn;
    cxView1Column9: TcxGridDBColumn;
    cxView1Column10: TcxGridDBColumn;
    Label6: TLabel;
    Label7: TLabel;
    EditID: TcxTextEdit;
    EditPDate: TcxDateEdit;
    N1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    cxView1Column11: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnConnClick(Sender: TObject);
    procedure ADOConnLocalConnectComplete(Connection: TADOConnection;
      const Error: Error; var EventStatus: TEventStatus);
    procedure ADOConnLocalDisconnect(Connection: TADOConnection;
      var EventStatus: TEventStatus);
    procedure cxButton3Click(Sender: TObject);
    procedure wPagePageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure EditPDatePropertiesEditValueChanged(Sender: TObject);
    procedure EditPTimePropertiesEditValueChanged(Sender: TObject);
    procedure cxView1FocusedRecordChanged(Sender: TcxCustomGridTableView;
      APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure cxButton2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FTrayIcon: TTrayIcon;
    {*状态栏图标*}
  protected
    procedure FormLoadConfig;
    procedure FormSaveConfig;
    {*配置信息*}
    procedure SetHintText(const nLabel: TLabel);
    {*提示信息*}
    function QueryData(const nSQL: string): TDataSet;
    function ExecSQL(const nSQL: string): Integer;
    //数据操作
    procedure LoadData(const nBegin,nEnd: TDateTime);
    //读取数据
    function PrintProvidePoundReport(const nPID: string): Boolean;
    function GetVal(const nRow: Integer; const nField: string): string;
    //报表相关
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, USysConst, USysDB, UFormCtrl, UDataReport;

//------------------------------------------------------------------------------
//Date: 2007-10-15
//Parm: 标签
//Desc: 在nLabel上显示提示信息
procedure TfFormMain.SetHintText(const nLabel: TLabel);
begin
  nLabel.Font.Color := clWhite;
  nLabel.Font.Size := 12;
  nLabel.Font.Style := nLabel.Font.Style + [fsBold];

  nLabel.Caption := gSysParam.FHintText;
  nLabel.Left := 8;
  nLabel.Top := (HintPanel.Height + nLabel.Height - 12) div 2;
end;

procedure TfFormMain.FormLoadConfig;
begin
  with gSysParam do
  begin
    EditLocalDB.Text := FLocalDB;
    EditLocalHost.Text := FLocalHost;
    EditLocalPort.Text := IntToStr(FLocalPort);
    EditLocalUser.Text := FLocalUser;
    EditLocalPwd.Text := FLocalPwd;
  end;

  LoadFormConfig(Self);
end;

procedure TfFormMain.FormSaveConfig;
begin
  AdminDBParam(False);
  SaveFormConfig(Self);
end;

procedure TfFormMain.FormCreate(Sender: TObject);
var nStr: string;
begin
  InitSystemEnvironment;
  LoadSysParameter;
  
  Application.Title := gSysParam.FAppTitle;
  InitGlobalVariant(gPath, gPath + sConfigFile, gPath + sFormConfig);

  nStr := GetFileVersionStr(Application.ExeName);
  if nStr <> '' then
  begin
    nStr := Copy(nStr, 1, Pos('.', nStr) - 1);
    Caption := gSysParam.FMainTitle + ' V' + nStr;
  end else Caption := gSysParam.FMainTitle;

  wPage.ActivePageIndex := 0;
  SetHintText(HintLabel);
  FormLoadConfig;
  //载入配置
  
  FTrayIcon := TTrayIcon.Create(Self);
  FTrayIcon.Hint := gSysParam.FAppTitle;
  FTrayIcon.Visible := True;
  //任务托盘
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {$IFNDEF debug}
  if not QueryDlg(sCloseQuery, sHint) then
  begin
    Action := caNone; Exit;
  end;
  {$ENDIF}

  gLogManager.Free;
  Sleep(520);
  FormSaveConfig;
end;

procedure TfFormMain.ADOConnLocalConnectComplete(
  Connection: TADOConnection; const Error: Error;
  var EventStatus: TEventStatus);
begin
  BtnConn.Enabled := not Connection.Connected;
end;

procedure TfFormMain.ADOConnLocalDisconnect(Connection: TADOConnection;
  var EventStatus: TEventStatus);
begin
  BtnConn.Enabled := not Connection.Connected;
  wPage.ActivePage := Sheet2;
end;

procedure TfFormMain.wPagePageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  AllowChange := (NewPage <> Sheet1) or ADOConnLocal.Connected;
end;

procedure TfFormMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    SwitchFocusCtrl(Self, True);
  end;
end;

//Desc: 连接数据库
procedure TfFormMain.BtnConnClick(Sender: TObject);
begin
  with gSysParam do
  begin
    FLocalDB := EditLocalDB.Text;
    FLocalHost := EditLocalHost.Text;

    if IsNumber(EditLocalPort.Text, False) then
      FLocalPort := StrToInt(EditLocalPort.Text);
    FLocalUser := EditLocalUser.Text;
    FLocalPwd := EditLocalPwd.Text;
  end;

  try
    ADOConnLocal.Close;
    ADOConnLocal.ConnectionString := MakeDBConnection(gSysParam);
    ADOConnLocal.Open;
  except
    on E:Exception do
    begin
      ShowDlg(E.Message, sHint, Handle);
    end;
  end;
end;

//------------------------------------------------------------------------------
function TfFormMain.ExecSQL(const nSQL: string): Integer;
begin
  ADOCmd1.Close;
  ADOCmd1.SQL.Text := nSQL;
  Result := ADOCmd1.ExecSQL;
end;

function TfFormMain.QueryData(const nSQL: string): TDataSet;
begin
  ADOQuery1.Close;
  ADOQuery1.SQL.Text := nSQL;
  ADOQuery1.Open;
  Result := ADOQuery1;
end;

procedure TfFormMain.LoadData(const nBegin, nEnd: TDateTime);
var nStr: string;
    nBookMark: Pointer;
begin
  nStr := 'Select *,L_MValue-L_PValue as L_JValue from %s Where L_Card<>''''';
  nStr := Format(nStr, [sTable_ProvideLog]);
  //自助时使用卡号字段

  if nBegin <= nEnd then
  begin
    nStr := nStr + ' and (L_YDate>=''%s'' And L_YDate<''%s'')';
    nStr := Format(nStr, [Date2Str(nBegin), Date2Str(nEnd+1)])
  end; //验收字段存打印时间

  QueryDB1.DisableControls;
  nBookMark := QueryDB1.GetBookmark;
  try
    QueryDB1.Close;
    QueryDB1.SQL.Text := nStr;
    QueryDB1.Open;

    if QueryDB1.BookmarkValid(nBookMark) then
      QueryDB1.GotoBookmark(nBookMark);
  finally
    QueryDB1.FreeBookmark(nBookMark);
    QueryDB1.EnableControls;
  end;
end;

procedure TfFormMain.EditPDatePropertiesEditValueChanged(Sender: TObject);
var nStr: string;
begin
  if not EditPDate.IsFocused then Exit;
  nStr := Date2Str(EditPDate.Date) + ' ' + Time2Str(Now);

  EditPTime.Date := Str2DateTime(nStr);
  EditPTimePropertiesEditValueChanged(nil);
  N2Click(nil);
end;

procedure TfFormMain.EditPTimePropertiesEditValueChanged(Sender: TObject);
var nStr: string;
    nInt: Integer;
begin
  if (EditPTime.IsFocused) or (Sender = nil) then
  begin
    nInt := Random(59);
    while nInt < 15 do
      nInt := Random(59);
    //不小于15分钟

    nStr := Format('00:%2d:%2d', [nInt, Random(59)]);
    EditMTime.Date := EditPTime.Date + StrToTime(nStr);
  end;
end;

//Desc: 查询全部
procedure TfFormMain.N1Click(Sender: TObject);
begin
  LoadData(1, 0);
end;

//Desc: 查询当天
procedure TfFormMain.N2Click(Sender: TObject);
begin
  if EditPDate.Text <> '' then
    LoadData(EditPDate.Date, EditPDate.Date);
  //xxxxx
end;

procedure TfFormMain.cxView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  if Assigned(APrevFocusedRecord) then
  begin
    EditPer.Text := QueryDB1.FieldByName('L_Provider').AsString;
    EditMate.Text := QueryDB1.FieldByName('L_Mate').AsString;
    EditTruck.Text := QueryDB1.FieldByName('L_Truck').AsString;
    EditPValue.Text := QueryDB1.FieldByName('L_PValue').AsString;
    EditPMan.Text := QueryDB1.FieldByName('L_PMan').AsString;
    EditPTime.Date := QueryDB1.FieldByName('L_PDate').AsDateTime;
    EditMValue.Text := QueryDB1.FieldByName('L_MValue').AsString;
    EditMMan.Text := QueryDB1.FieldByName('L_MMan').AsString;
    EditMTime.Date := QueryDB1.FieldByName('L_MDate').AsDateTime;
    EditID.Text := QueryDB1.FieldByName('L_Card').AsString;
    EditPDate.Date := QueryDB1.FieldByName('L_YDate').AsDateTime;
  end;
end;

//Desc: 刷新参数
procedure TfFormMain.cxButton3Click(Sender: TObject);
var nStr: string;
begin
  nStr := 'Select P_Name From %s Order By P_Name';
  nStr := Format(nStr, [sTable_Provider]);
  LoadDataToList(QueryData(nStr), EditPer.Properties.Items, '', -1);

  nStr := 'Select M_Name From %s Order By M_Name';
  nStr := Format(nStr, [sTable_Materails]);
  LoadDataToList(QueryData(nStr), EditMate.Properties.Items, '', -1);

  nStr := 'Select distinct L_Truck From %s Order By L_Truck';
  nStr := Format(nStr, [sTable_ProvideLog]);
  LoadDataToList(QueryData(nStr), EditTruck.Properties.Items, '', -1);

  nStr := 'Select distinct L_Truck From %s Order By L_Truck';
  nStr := Format(nStr, [sTable_ProvideLog]);
  LoadDataToList(QueryData(nStr), EditTruck.Properties.Items, '', -1);

  nStr := 'Select U_Name From %s Order By U_Name';
  nStr := Format(nStr, [sTable_User]);
  LoadDataToList(QueryData(nStr), EditPMan.Properties.Items, '', -1);

  LoadDataToList(ADOQuery1, EditMMan.Properties.Items, '', -1);
  ShowMsg('刷新完毕', sHint);
end;

//Desc: 添加磅单
procedure TfFormMain.cxButton1Click(Sender: TObject);
var nStr: string;
begin
  EditPer.Text := Trim(EditPer.Text);
  if EditPer.Text = '' then
  begin
    EditPer.SetFocus;
    ShowMsg('请填写供应商', sHint); Exit;
  end;

  EditMate.Text := Trim(EditMate.Text);
  if EditMate.Text = '' then
  begin
    EditMate.SetFocus;
    ShowMsg('请填写原材料', sHint); Exit;
  end;

  EditTruck.Text := Trim(EditTruck.Text);
  if EditTruck.Text = '' then
  begin
    EditTruck.SetFocus;
    ShowMsg('请填写车牌号', sHint); Exit;
  end;

  EditID.Text := Trim(EditID.Text);
  if EditID.Text = '' then
  begin
    EditID.SetFocus;
    ShowMsg('请填写磅单号', sHint); Exit;
  end;

  if EditPDate.Text = '' then
  begin
    EditPDate.SetFocus;
    ShowMsg('请填写打印时间', sHint); Exit;
  end;

  EditPMan.Text := Trim(EditPMan.Text);
  EditMMan.Text := Trim(EditMMan.Text);
  if (EditPMan.Text = '') or (EditMMan.Text = '') then
  begin
    if EditPMan.Text = '' then EditPMan.SetFocus;
    if EditMMan.Text = '' then EditMMan.SetFocus;
    ShowMsg('请填写司磅员', sHint); Exit;
  end;

  if not IsNumber(EditPValue.Text, True) then
  begin
    EditPValue.SetFocus;
    ShowMsg('请填写皮重', sHint); Exit;
  end;

  if not IsNumber(EditMValue.Text, True) then
  begin
    EditMValue.SetFocus;
    ShowMsg('请填写毛重', sHint); Exit;
  end;

  nStr := 'Select Count(*) From %s Where L_Card=''%s''';
  nStr := Format(nStr, [sTable_ProvideLog, EditID.Text]);

  if QueryData(nStr).Fields[0].AsInteger > 0 then
  begin
    EditID.SetFocus;
    ShowMsg('该磅单已存在', sHint); Exit;
  end;

  nStr := 'Select Count(*) From %s Where (L_PDate>''%s'' and L_PDate<''%s'') or ' +
          '(L_MDate>''%s'' and L_MDate<''%s'')';
  nStr := Format(nStr, [sTable_ProvideLog,
          DateTime2Str(EditPTime.Date - Str2Time('00:02:00')),
          DateTime2Str(EditPTime.Date + Str2Time('00:02:00')),
          DateTime2Str(EditMTime.Date - Str2Time('00:02:00')),
          DateTime2Str(EditMTime.Date - Str2Time('00:02:00'))]);
  //皮重,毛重前后两分钟不允许有记录

  if QueryData(nStr).Fields[0].AsInteger > 0 then
  begin
    EditPTime.SetFocus;
    ShowMsg('该时间有车在磅上', sHint); Exit;
  end;

  nStr := 'Select Count(*) From %s Where L_Truck=''%s'' and ' +
          'L_PDate>''%s'' and L_PDate<''%s''';
  nStr := Format(nStr, [sTable_ProvideLog, EditTruck.Text,
          DateTime2Str(EditPTime.Date - Str2Time('00:30:00')),
          DateTime2Str(EditPTime.Date + Str2Time('00:30:00'))]);
  //单车皮重,毛重前后半小时不允许有记录

  if QueryData(nStr).Fields[0].AsInteger > 0 then
  begin
    EditPTime.SetFocus;
    ShowMsg('该车进厂过于频繁', sHint); Exit;
  end;

  nStr := 'Insert Into $PL(L_Provider,L_Mate,L_Truck,L_PValue,L_PMan,L_PDate,' +
          'L_MValue,L_MMan,L_MDate,L_Card,L_YDate,L_PrintNum) Values(''$Per'',' +
          '''$Mate'', ''$Truck'', $Pv, ''$PM'', ''$PD'', $Mv, ''$MM'', ''$MD'',' +
          '''$ID'', ''$PT'', 0)';
  nStr := MacroValue(nStr, [MI('$PL', sTable_ProvideLog), MI('$Per', EditPer.Text),
          MI('$Mate', EditMate.Text), MI('$Truck', EditTruck.Text),
          MI('$Pv', EditPValue.Text), MI('$PM', EditPMan.Text),
          MI('$PD', DateTime2Str(EditPTime.Date)),
          MI('$Mv', EditMValue.Text), MI('$MM', EditMMan.Text),
          MI('$MD', DateTime2Str(EditMTime.Date)), MI('$ID', EditID.Text),
          MI('$PT', DateTime2Str(EditPDate.Date))]);
  ExecSQL(nStr);

  N2Click(nil);
  EditPValue.SetFocus;
  ShowMsg('添加成功', sHint);
end;

procedure TfFormMain.cxButton2Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := 'Delete From %s Where L_Card=''%s''';
    nStr := Format(nStr, [sTable_ProvideLog, QueryDB1.FieldByName('L_Card').AsString]);
    ExecSQL(nStr);

    N2Click(nil);
    ShowMsg('删除成功', sHint);
  end;
end;

//------------------------------------------------------------------------------
//Desc: 供应过榜单
function TfFormMain.PrintProvidePoundReport(const nPID: string): Boolean;
var nStr: string;
begin
  Result := False;
  nStr := 'Select * From %s Where L_Card in (%s)';
  nStr := Format(nStr, [sTable_ProvideLog, nPID]);

  if QueryData(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s ] 的记录已无效!!';
    nStr := Format(nStr, [nPID]);
    ShowDlg(nStr, sHint); Exit;
  end;

  nStr := gPath + 'PPound.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := ADOQuery1;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;

  if Result then
  begin
    nStr := 'Update %s Set L_PrintNum=L_PrintNum+1 Where L_Card in (%s)';
    nStr := Format(nStr, [sTable_ProvideLog, nPID]);
    ExecSQL(nStr);
  end;
end;

//Desc: 获取nRow行nField字段的内容
function TfFormMain.GetVal(const nRow: Integer; const nField: string): string;
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

//Desc: 打印磅单
procedure TfFormMain.N3Click(Sender: TObject);
var nStr,nID: string;
    i,nCount: Integer;
begin
  if cxView1.DataController.GetSelectedCount < 1 then Exit;
  nID := '';
  nCount := cxView1.Controller.SelectedRowCount - 1;

  for i:=0 to nCount do
  begin
    nStr := GetVal(i, 'L_Card');
    if nStr = '' then Continue;

    if nID = '' then
        nID := nStr
    else nID := nID + ',' + nStr;
  end;

  PrintProvidePoundReport(nID);
end;

end.
