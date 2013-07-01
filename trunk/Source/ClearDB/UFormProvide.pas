{*******************************************************************************
  作者: dmzn@163.com 2013-6-27
  描述: 修改供应记录
*******************************************************************************}
unit UFormProvide;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxTextEdit, dxSkinsCore, dxSkinsDefaultPainters;

type
  PProvideItem = ^TProvideItem;
  TProvideItem = record
    FChecked: Boolean;
    FRecordID: string;
    FWeek: string;
    FSaler: string;
    FProvider: string;
    FMate: string;
    FPValue,FMValue: Double;
    FWeight: Double;
    FTime: TDateTime;
  end;

  TfFormProvide = class(TfFormNormal)
    EditProvider: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditMate: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditWeight: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FData: PProvideItem;
    procedure InitFormData;
  public
    { Public declarations }
    class function FormID: integer; override;
  end;

function ShowModifyProvideForm(const nData: PProvideItem): Boolean;
//入口函数

implementation

{$R *.dfm}

uses
  ULibFun, UFormCtrl, UDataModule, USysDB, USysConst;

function ShowModifyProvideForm(const nData: PProvideItem): Boolean;
begin
  with TfFormProvide.Create(Application) do
  begin
    FData := nData;
    InitFormData();
    
    Result := ShowModal = mrOk;
    Free;
  end;
end;

class function TfFormProvide.FormID: integer;
begin
  Result := 0;
end;

procedure TfFormProvide.InitFormData;
begin
  EditProvider.Text := FData.FProvider;
  EditMate.Text := FData.FMate;
  EditWeight.Text := FloatToStr(FData.FWeight);
end;

procedure TfFormProvide.BtnOKClick(Sender: TObject);
var nStr: string;
    nVal: Double;
begin
  if not IsNumber(EditWeight.Text, True) then
  begin
    EditWeight.SetFocus;
    ShowMsg('净重需填写数值', sHint); Exit;
  end;

  nStr := Format('L_ID=%s', [FData.FRecordID]);
  nVal := FData.FPValue + StrToFloat(EditWeight.Text);
  //xxxxx

  nStr := MakeSQLByStr([SF('L_Provider', EditProvider.Text),
          SF('L_Mate', EditMate.Text), SF('L_MValue', nVal, sfVal)
          ], sTable_ProvideLog, nStr, False);
  FDM.ExecuteSQL(nStr);

  FData.FProvider := EditProvider.Text;
  FData.FMate := EditMate.Text;
  FData.FMValue := nVal;
  FData.FWeight := StrToFloat(EditWeight.Text);

  ShowMsg('修改成功', sHint);
  ModalResult := mrOk;
end;

end.
