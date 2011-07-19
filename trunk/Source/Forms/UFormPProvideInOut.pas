{*******************************************************************************
  ����: dmzn@163.com 2011-6-7
  ����: ԭ�Ϲ�Ӧ������
*******************************************************************************}
unit UFormPProvideInOut;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxButtonEdit, cxLabel, cxTextEdit, cxContainer, cxEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, cxMCListBox;

type
  TfFormPProvideInOut = class(TfFormNormal)
    dxLayout1Item4: TdxLayoutItem;
    ListTrucks: TcxMCListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FTruckIO: string;
    //�������
    FTruckCard: string;
    //�����ſ�
    procedure InitFormData(const nID: string);
    //��������
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UFormBase, UMgrControl, USysDB, USysConst, UDataModule,
  USysBusiness, USysGrid, UFormCtrl;

class function TfFormPProvideInOut.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr: string;
    nP: PFormCommandParam;
begin                                            
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  if nP.FParamB = sFlag_TruckIn then
  begin
    if IsProvideTruckAutoIO(1) then
    begin
      ShowDlg('��Ӧ������ֱ�ӽ���,�����Ҳ���ˢ��.', sHint);
      Exit;
    end;

    if IsCardHasProvideTruck(nP.FParamA) then
    begin
      ShowDlg('�ÿ����й�Ӧ����δ����,���Ժ�.', sHint);
      Exit;
    end;

    nStr := '����';
  end else

  if nP.FParamB = sFlag_TruckOut then
  begin
    if IsProvideTruckAutoIO(2) then
    begin
      ShowDlg('��Ӧ������ֱ�ӳ���,�����Ҳ���ˢ��.', sHint);
      Exit;
    end;

    if not IsCardHasProvideTruck(nP.FParamA, sFlag_TruckOut) then
    begin
      ShowDlg('�ÿ�û��Ҫ�����Ĺ�Ӧ����.', sHint);
      Exit;
    end;

    nStr := '����';
  end else Exit;

  with TfFormPProvideInOut.Create(Application) do
  begin
    Caption := '��Ӧ - ' + nStr;
    FTruckCard := nP.FParamA;
    FTruckIO := nP.FParamB;

    InitFormData('');
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
    Free;
  end;
end;

class function TfFormPProvideInOut.FormID: integer;
begin
  Result := cFI_FormProvideInOut;
end;

procedure TfFormPProvideInOut.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, ListTrucks, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormPProvideInOut.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, ListTrucks, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormPProvideInOut.InitFormData(const nID: string);
var nStr: string;
begin
  ListTrucks.Items.Clear;
  //init list

  if FTruckIO = sFlag_TruckIn then
  begin
    nStr := 'Select P_Owner,P_Provider,P_Mate From %s ' +
            'Where P_Card=''%s'' Order By P_Owner';
    nStr := Format(nStr, [sTable_ProvideCard, FTruckCard]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        ListTrucks.Items.Add(CombinStr([Fields[0].AsString, Fields[1].AsString,
            Fields[2].AsString], ListTrucks.Delimiter));
        Next;
      end;
    end;
  end else

  if FTruckIO = sFlag_TruckOut then
  begin
    nStr := 'Select L_Truck,L_Provider,L_Mate,L_ID From %s ' +
            'Where L_Card=''%s'' And L_NextStatus=''%s'' Order By L_Truck';
    nStr := Format(nStr, [sTable_ProvideLog, FTruckCard, sFlag_TruckOut]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        ListTrucks.Items.Add(CombinStr([Fields[0].AsString, Fields[1].AsString,
            Fields[2].AsString, Fields[3].AsString], ListTrucks.Delimiter));
        Next;
      end;
    end;
  end;

  if ListTrucks.Items.Count > 0 then
    ListTrucks.ItemIndex := 0;
  //init default
end;

//Desc: ����
procedure TfFormPProvideInOut.BtnOKClick(Sender: TObject);
var nStr: string;
    nList: TStrings;
begin
  if ListTrucks.ItemIndex < 0 then
  begin
    ShowMsg('��ѡ����Ч����ϸ', sHint); Exit;
  end;

  nList := TStringList.Create;
  try
    nStr := ListTrucks.Items[ListTrucks.ItemIndex];
    if not SplitStr(nStr, nList, 0, ListTrucks.Delimiter) then Exit;

    if FTruckIO = sFlag_TruckIn then
    begin
      nStr := MakeSQLByStr([SF('L_Card', FTruckCard), SF('L_Truck', nList[0]),
              SF('L_Status', sFlag_TruckIn), SF('L_NextStatus', sFlag_TruckBFM),
              SF('L_InMan', gSysParam.FUserID),
              SF('L_InDate', FDM.SQLServerNow, sfVal)], sTable_ProvideLog, '', True);
      //xxxxx
      FDM.ExecuteSQL(nStr);
      nStr := '����'
    end else

    if FTruckIO = sFlag_TruckOut then
    begin
      nStr := MakeSQLByStr([SF('L_Card', ''),
              SF('L_Status', sFlag_TruckOut), SF('L_NextStatus', ''),
              SF('L_OutMan', gSysParam.FUserID),
              SF('L_OutDate', FDM.SQLServerNow, sfVal)],
              sTable_ProvideLog, Format('L_ID=%s', [nList[3]]), False);
      //xxxxx

      FDM.ExecuteSQL(nStr);
      nStr := '����';
    end else Exit;
  finally
    nList.Free;
  end;

  ModalResult := mrOk;
  ShowMsg(nStr + '�����ɹ�', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormPProvideInOut, TfFormPProvideInOut.FormID);
end.
