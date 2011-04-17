unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, cxLookAndFeels, XPMan, dxLayoutLookAndFeels, cxEdit,
  cxGraphics, cxControls, cxLookAndFeelPainters, cxContainer, Menus,
  StdCtrls, cxButtons, cxGroupBox, dxLayoutControl, cxTextEdit, ExtCtrls,
  dxStatusBar, cxLabel, cxMCListBox, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls;

type
  TfFormMain = class(TForm)
    cxGroupBox1: TcxGroupBox;
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    HintPanel: TPanel;
    Image1: TImage;
    Image2: TImage;
    HintLabel: TLabel;
    cxLabel1: TcxLabel;
    EditCard: TEdit;
    cxLabel2: TcxLabel;
    ListInfo: TcxMCListBox;
    cxLabel3: TcxLabel;
    ListAccount: TcxMCListBox;
    dxGroup1: TdxLayoutGroup;
    dxGroup2: TdxLayoutGroup;
    dxGroup3: TdxLayoutGroup;
    dxLayoutControl1Group4: TdxLayoutGroup;
    cxView1: TcxGridDBTableView;
    cxLevel1: TcxGridLevel;
    GridBill: TcxGrid;
    dxLayoutControl1Item1: TdxLayoutItem;
    cxView2: TcxGridDBTableView;
    cxLevel2: TcxGridLevel;
    GridLading: TcxGrid;
    dxLayoutControl1Item2: TdxLayoutItem;
    cxView3: TcxGridDBTableView;
    cxLevel3: TcxGridLevel;
    GridDetail: TcxGrid;
    dxLayoutControl1Item3: TdxLayoutItem;
    BtnExit: TcxButton;
    SBar: TStatusBar;
    Timer1: TTimer;
    BtnRefresh: TcxButton;
    ADOQueryBill: TADOQuery;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DataSource3: TDataSource;
    ADOQueryLading: TADOQuery;
    ADOQueryDetail: TADOQuery;
    ListStock: TcxMCListBox;
    cxLabel4: TcxLabel;
    BtnFilter: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure EditCardKeyPress(Sender: TObject; var Key: Char);
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure EditCardExit(Sender: TObject);
    procedure BtnFilterClick(Sender: TObject);
  private
    { Private declarations }
    FLastLoad: Int64;
    {*�ϴ�����*}
    FDateFilte: Boolean;
    FDefaultToday: Boolean;
    {*Ĭ�ϵ���*}
    FStart,FEnd: TDate;
    {*��������*}
    FScreenMouse: TPoint;
    FScreenKeepTime: Word;
    FScreenAlarmTime: Word;
    FScreenCounter: Word;
    {*��Ļ����*}
    procedure FormLoadConfig;
    procedure FormSaveConfig;
    {*������Ϣ*}
    procedure EnableCtrl(const nEnable: Boolean);
    {*���״̬*}
    procedure SetHintText(const nLabel: TLabel);
    {*��ʾ��Ϣ*}
    procedure LoadCardData(const nCard: string);
    {*��ȡ����*}
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  IniFiles, UcxChinese, ULibFun, UMgrLog, USysDB, USysConst, USysObject,
  USysFun, USysGrid, USysDataDict, USysBusiness, UFormWait, UFormLogin,
  UDataModule, UFormDateFilter, UFormDTimer;

procedure WriteLog(const nEvent: string);
var nItem: PLogItem;
begin
  nItem := gLogManager.NewLogItem;
  nItem.FWriter.FOjbect := TfFormMain;
  nItem.FWriter.FDesc := '�û�������ѯ';
  nItem.FLogTag := [ltWriteFile];
  nItem.FEvent := nEvent;
  gLogManager.AddNewLog(nItem);
end;

//Date: 2007-10-15
//Parm: ��ǩ
//Desc: ��nLabel����ʾ��ʾ��Ϣ
procedure TfFormMain.SetHintText(const nLabel: TLabel);
begin
  nLabel.Font.Color := clWhite;
  nLabel.Font.Size := 15;
  nLabel.Font.Style := nLabel.Font.Style + [fsBold];

  nLabel.Caption := gSysParam.FHintText;
  nLabel.Left := 8;
  nLabel.Top := (HintPanel.Height + nLabel.Height - 12) div 2;
end;

//Desc: ���봰������
procedure TfFormMain.FormLoadConfig;
var nStr: string;
    nIni: TIniFile;
begin                       
  DoubleBuffered := True;
  HintPanel.DoubleBuffered := True;

  ActiveControl := EditCard;
  SetHintText(HintLabel);
  gStatusBar := sBar;
  
  nStr := Format(sDate, [DateToStr(Now)]);
  StatusBarMsg(nStr, cSBar_Date);

  nStr := Format(sTime, [TimeToStr(Now)]);
  StatusBarMsg(nStr, cSBar_Time);

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    FDefaultToday := nIni.ReadBool('Setup', 'DefaultToday', False);
    FScreenKeepTime := nIni.ReadInteger('Setup', 'ScreenKeepTime', 60);
    FScreenAlarmTime := nIni.ReadInteger('Setup', 'ScreenAlarmTime', 10);

    if FScreenKeepTime < 5 then FScreenKeepTime := 5;
    if FScreenAlarmTime > FScreenKeepTime then
      FScreenAlarmTime := FScreenKeepTime;
    //У����Ļʱ��

    LoadMCListBoxConfig(Name, ListInfo, nIni);
    LoadMCListBoxConfig(Name, ListStock, nIni);
    LoadMCListBoxConfig(Name, ListAccount, nIni);

    gSysEntityManager.BuildViewColumn(cxView1, 'ZZ_BILL');
    gSysEntityManager.BuildViewColumn(cxView2, 'ZZ_LADING');
    gSysEntityManager.BuildViewColumn(cxView3, 'ZZ_DETAIL');
    //��ʼ����ͷ
    InitTableView(Name, cxView1, nIni);
    InitTableView(Name, cxView2, nIni);
    InitTableView(Name, cxView3, nIni);
    //��ʼ������˳��
  finally
    nIni.Free;
  end;
end;

//Desc: ���洰������
procedure TfFormMain.FormSaveConfig;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, ListInfo, nIni);
    SaveMCListBoxConfig(Name, ListStock, nIni);
    SaveMCListBoxConfig(Name, ListAccount, nIni);

    SaveUserDefineTableView(Name, cxView1, nIni);
    SaveUserDefineTableView(Name, cxView2, nIni);
    SaveUserDefineTableView(Name, cxView3, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormMain.FormCreate(Sender: TObject);
var nStr: string;
begin
  Application.Title := gSysParam.FAppTitle;
  InitGlobalVariant(gPath, gPath + sConfigFile, gPath + sFormConfig, gPath + sDBConfig);

  nStr := GetFileVersionStr(Application.ExeName);
  if nStr <> '' then
  begin
    nStr := Copy(nStr, 1, Pos('.', nStr) - 1);
    Caption := gSysParam.FMainTitle + ' V' + nStr;
  end else Caption := gSysParam.FMainTitle;

  InitSystemObject;
  //ϵͳ����
  EnableCtrl(False);
  //�رղ���

  if ShowLoginForm then
  begin
     FormLoadConfig;
     WriteLog('ϵͳ����');
  end else
  begin
    FreeSystemObject;
    ShowWindow(Handle, SW_MINIMIZE);
    
    Application.ProcessMessages;
    Application.Terminate; Exit;
  end;
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ShowWaitForm(Self, '�����˳�ϵͳ');
  Application.ProcessMessages;
  try
    FormSaveConfig;          //��������

    WriteLog('ϵͳ�ر�');
    {$IFNDEF debug}
    Sleep(2200);
    {$ENDIF}
    FreeSystemObject;        //ϵͳ����
  finally
    CloseWaitForm;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ����������,ʱ��
procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  sBar.Panels[cSBar_Date].Text := Format(sDate, [DateToStr(Now)]);
  sBar.Panels[cSBar_Time].Text := Format(sTime, [TimeToStr(Now)]);

  if not BtnExit.Enabled then Exit;
  //�޵�¼����ʱ
  
  with Mouse.CursorPos do
  if (FScreenMouse.X <> X) or (FScreenMouse.Y <> Y) then
  begin
    FScreenMouse := Point(X, Y);
    FScreenCounter := FScreenKeepTime; Exit;
  end; //��λ�������ü�ʱ

  if FScreenCounter = FScreenAlarmTime then
  begin
    FScreenCounter := 0;
    //stop counter

    if ShowDTimer(Self, FScreenAlarmTime) then
         BtnExit.Click
    else FScreenCounter := FScreenKeepTime;
  end else Dec(FScreenCounter);
end;

//Desc: ����������
procedure TfFormMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and (not EditCard.Focused) then
  begin
    Key := #0;
    EditCard.SetFocus;
  end;
end;

//Desc: ����ʧȥ����
procedure TfFormMain.EditCardExit(Sender: TObject);
begin
  if not BtnRefresh.Enabled then
    EditCard.SetFocus;
  //xxxxx
end;

procedure TfFormMain.EditCardKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditCard.Text := Trim(EditCard.Text);

    if EditCard.Text = '' then
    begin
      EditCard.SetFocus;
      ShowMsg('��ˢ��', sHint); Exit;
    end;

    EditCard.SelectAll;
    if FDefaultToday then
    begin
      FStart := FDM.ServerNow;
      FEnd := FStart;
    end else
    begin
      FStart := 0;
      FEnd := 0;
    end;
    
    FDateFilte := FDefaultToday;
    LoadCardData(EditCard.Text);
  end;
end;

//Desc: ����ɸѡ
procedure TfFormMain.BtnFilterClick(Sender: TObject);
begin
  if FStart = 0 then
  begin
    FStart := FDM.ServerNow;
    FEnd := FStart;
  end;

  if ShowDateFilterForm(FStart, FEnd) then
  begin
    FDateFilte := True;
    LoadCardData(EditCard.Text);
  end;
end;

//Desc: ˢ��
procedure TfFormMain.BtnRefreshClick(Sender: TObject);
begin
  LoadCardData(EditCard.Text);
end;

//Desc: ���ƽ���Ԫ��
procedure TfFormMain.EnableCtrl(const nEnable: Boolean);
begin
  BtnFilter.Enabled := nEnable;
  BtnExit.Enabled := nEnable;
  BtnRefresh.Enabled := nEnable;

  if not nEnable then
  begin
    FLastLoad := 0;
    ActiveControl:= EditCard;

    ADOQueryBill.Close;
    ADOQueryLading.Close;
    ADOQueryDetail.Close;

    ListInfo.Clear;
    ListStock.Clear;
    ListAccount.Clear;
  end;

  FScreenMouse := Mouse.CursorPos;
  //���¶�λ
  FScreenCounter := FScreenKeepTime;
  //���¼�ʱ
end;

//Desc: �˳���ѯ
procedure TfFormMain.BtnExitClick(Sender: TObject);
begin
  EditCard.Text := '';
  EnableCtrl(False);
end;

//Desc: ����ſ�nCard����Ϣ
procedure TfFormMain.LoadCardData(const nCard: string);
var nDB: TDataSet;
    nBool: Boolean;
    nVal,nPrice: Double;
    nDT,nValid: TDateTime;
    nStr,nSQL,nZK,nCus: string;
begin
  if GetTickCount - FLastLoad < 2.2 * 1000 then
  begin
    ShowMsg('��ˢ��̫Ƶ��', sHint); Exit;
  end;

  EnableCtrl(False);
  try
    nSQL := 'Select Z_ID,C_Card From %s zk ' +
            ' Left Join %s zc on zc.C_ZID=zk.Z_ID ' +
            'Where C_Card=''%s'' or Z_ID=''%s''';
    nSQL := Format(nSQL, [sTable_ZhiKa, sTable_ZhiKaCard, nCard, nCard]);

    with FDM.QueryTemp(nSQL) do
    if RecordCount > 0 then
    begin
      nZK := Fields[0].AsString;
    end else
    begin
      EditCard.SetFocus;
      ShowMsg('��Ч�Ĵſ�', '������'); Exit;
    end;

    nDB := LoadZhiKaInfo(nZK, ListInfo, nStr);
    //zk info
    
    if Assigned(nDB) then
    begin
      nValid := nDB.FieldByName('Z_ValidDays').AsDateTime;
      nCus := nDB.FieldByName('Z_Custom').AsString;
    end else
    begin
      ShowMsg(nStr, sHint); Exit;
    end;

    nDT := nValid - FDM.ServerNow;
    if nDT <= 0 then
    begin
      nDT := -nDT;
      nStr := '��Ч����:;%s �ѹ���:[ %d ]��';
    end else nStr := '��Ч����:;%s ��ʣ��:[ %d ]��';

    nStr := Format(nStr, [Date2Str(nValid), Trunc(nDT)]);
    ListInfo.Items.Add(nStr);

    nVal := GetValidMoneyByZK(nZK, nBool);
    if nBool then
         nStr := 'ֽ������:;����ֽ�� ���ý��[ %.2f ]Ԫ'
    else nStr := 'ֽ������:;��ֽͨ�� �ʻ����[ %.2f ]Ԫ';

    nStr := Format(nStr, [nVal]);
    ListInfo.Items.Add(nStr);

    //--------------------------------------------------------------------------
    nSQL := 'Select * From %s Where D_ZID=''%s''';
    nSQL := Format(nSQL, [sTable_ZhiKaDtl, nZK]);

    with FDM.QueryTemp(nSQL) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nPrice := FieldByName('D_Price').AsFloat;
        if nPrice > 0 then
             nStr := FloatToStr(Float2Float(nVal / nPrice, cPrecision, False))
        else nStr := '0';

        nStr := Format('%s;%s ��', [FieldByName('D_Stock').AsString, nStr]);
        ListStock.Items.Add(nStr);
        Next;
      end;
    end;

    //--------------------------------------------------------------------------
    nSQL := 'Select * From %s Where A_CID=''%s''';
    nSQL := Format(nSQL, [sTable_CusAccount, nCus]);

    with FDM.QueryTemp(nSQL) do
    if RecordCount = 1 then
    begin
      nStr := Format('����ܶ�:;%.2f Ԫ', [FieldByName('A_InMoney').AsFloat]);
      ListAccount.Items.Add(nStr);

      nStr := Format('�����ܶ�:;%.2f Ԫ', [FieldByName('A_OutMoney').AsFloat]);
      ListAccount.Items.Add(nStr);

      nStr := Format('������:;%.2f Ԫ', [FieldByName('A_FreezeMoney').AsFloat]);
      ListAccount.Items.Add(nStr);

      nStr := Format('�������:;%.2f Ԫ', [FieldByName('A_Compensation').AsFloat]);
      ListAccount.Items.Add(nStr);

      nStr := Format('���ý��:;%.2f Ԫ', [FieldByName('A_CreditLimit').AsFloat]);
      ListAccount.Items.Add(nStr);

      nVal := FieldByName('A_InMoney').AsFloat -
              FieldByName('A_OutMoney').AsFloat -
              FieldByName('A_Compensation').AsFloat -
              FieldByName('A_FreezeMoney').AsFloat +
              FieldByName('A_CreditLimit').AsFloat;
      //xxxxx

      nStr := Format('���ý��:;%.2f Ԫ', [nVal]);
      ListAccount.Items.Add(nStr);
    end else
    begin
      EditCard.SetFocus;
      ShowMsg('�ʻ���Ϣ����Ч', sHint); Exit;
    end;

    //--------------------------------------------------------------------------
    nSQL := 'Select b.*,L_Value*L_Price as L_Money From $Bill b ' +
            'Where L_ZID=''$ZID'' and (L_ID Not In (' +
            'Select IsNull(E_Bill, '''') From $TE))';
    nSQL := MacroValue(nSQL, [MI('$Bill', sTable_Bill), MI('$ZID', nZK),
            MI('$TE', sTable_TruckLogExt)]);   
    FDM.QueryData(ADOQueryBill, nSQL);

    nSQL := 'Select b.*,L_Value*L_Price as L_Money,T_Status,T_InTime From $TE te ' +
          ' Left Join $TL tl on tl.T_ID=te.E_TID ' +
          ' Left Join $Bill b on b.L_ID=te.E_Bill ' +
          'Where E_ZID=''$ZID'' And L_IsDone<>''$Yes'' Order By T_InTime';
    nSQL := MacroValue(nSQL, [MI('$Bill', sTable_Bill), MI('$ZID', nZK),
            MI('$TE', sTable_TruckLogExt), MI('$TL', sTable_TruckLog),
            MI('$Yes', sFlag_Yes)]);
    FDM.QueryData(ADOQueryLading, nSQL);

    nSQL := 'Select b.*,L_Value*L_Price as L_Money From $Bill b ' +
            'Where L_ZID=''$ZID'' And L_IsDone=''$Yes''';
    nSQL := MacroValue(nSQL, [MI('$Bill', sTable_Bill), MI('$ZID', nZK),
            MI('$Yes', sFlag_Yes)]);
    //xxxxx

    if FDateFilte then
    begin
      nStr := ' And (L_OKDate>=''%s'' and L_OKDate<''%s'')';
      nStr := Format(nStr, [Date2Str(FStart), Date2Str(FEnd + 1)]);
      nSQL := nSQL + nStr;

      nStr := '�������ϸ ����:[%s �� %s]';
      nStr := Format(nStr, [Date2Str(FStart), Date2Str(FEnd)]);
      dxGroup3.Caption := nStr;
    end else dxGroup3.Caption := '�������ϸ';

    FDM.QueryData(ADOQueryDetail, nSQL);
    FLastLoad := GetTickCount;
    EnableCtrl(True);
  except
    on E:Exception do
    begin
      ShowDlg(E.Message, sHint, Handle);
    end;
  end;
end;

end.
