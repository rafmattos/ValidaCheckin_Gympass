unit uValidaCheckin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent, System.JSON,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TfrmValidaCheckin = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    edtToken: TEdit;
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    RadioGroup1: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
    function ValidarCheckin(Token : String) : String;
  public
    { Public declarations }
  end;

   function getCamposJsonString(json,value:String): String;
var
  frmValidaCheckin: TfrmValidaCheckin;

implementation

{$R *.dfm}


function getCamposJsonString(json,value:String): String;
var
   LJSONObject: TJSONObject;
   function TrataObjeto(jObj:TJSONObject):string;
   var i:integer;
       jPar: TJSONPair;
   begin
        result := '';
        for i := 0 to jObj.Size - 1 do
        begin
             jPar := jObj.Get(i);
             if jPar.JsonValue Is TJSONObject then
                result := TrataObjeto((jPar.JsonValue As TJSONObject)) else
             if sametext(trim(jPar.JsonString.Value),value) then
             begin
                  Result := jPar.JsonValue.Value;
                  break;
             end;
             if result <> '' then
                break;
        end;
   end;
begin
   try
      LJSONObject := nil;
      LJSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(json),0) as TJSONObject;
      result := TrataObjeto(LJSONObject);
   finally
      LJSONObject.Free;
   end;
end;

procedure TfrmValidaCheckin.Button1Click(Sender: TObject);
var
   Mensagem : String;
begin
   Mensagem := ValidarCheckin(Edit1.Text);
   if Mensagem = 'Liberado' then
   begin
      ShowMessage('Checkin ok')
   end
   else
      ShowMessage(Mensagem);
end;

procedure TfrmValidaCheckin.RadioGroup1Click(Sender: TObject);
begin
   Edit1.Text := RadioGroup1.Items[RadioGroup1.ItemIndex];
end;

function TfrmValidaCheckin.ValidarCheckin(Token: String): string;
var
  Xbody , Resp: TStringStream;
  HTTP: TIdHTTP;
  IOHandle: TIdSSLIOHandlerSocketOpenSSL;
  jsonObject : TJsonObject;
  jsonObject2 : TJSONArray;

  function RetiraBarra(sString :String) : String;
  begin
     Result:= StringReplace(StringReplace(sString, '[','',[rfReplaceAll])   ,']', '' ,   [rfReplaceAll])
  end;
begin
      try
        xBody := TStringStream.Create('{"gympass_id":"'+Token+'"}', TEncoding.UTF8);

        Resp := TStringStream.Create;
        HTTP := TIdHTTP.Create(nil);
        IOHandle := TIdSSLIOHandlerSocketOpenSSL.Create(HTTP);
        HTTP.Request.BasicAuthentication := False;
        HTTP.Request.UserAgent :=
          'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0';

        IOHandle.SSLOptions.Method := sslvTLSv1_2;
        IOHandle.SSLOptions.Mode := sslmUnassigned;
        HTTP.IOHandler := IOHandle;
        HTTP.Request.ContentType := 'application/json';
        HTTP.Request.CharSet := 'UTF-8';



        HTTP.Request.CustomHeaders.FoldLines := false;
        HTTP.Request.CustomHeaders.AddValue('Authorization','Bearer '+edtToken.Text);
        HTTP.Request.CustomHeaders.AddValue('X-Gym-Id','11');
        try
          HTTP.Post('https://sandbox.partners.gympass.com/access/v1/validate', xbody, Resp) ;

          if HTTP.ResponseCode = 200 then
          begin
             Result := 'Liberado';
          end
        except
          on e: EIdHTTPProtocolException do
          begin
             if HTTP.ResponseCode = 500 then
             begin
                Result := 'Erro de Comunicação com Gympass';
             end;

             if HTTP.ResponseCode = 404 then
             begin
                Result := 'Check-in não encontrado no banco de dados';
             end;

             if HTTP.ResponseCode = 400 then
             begin

                jsonObject := TJsonObject.ParseJSONValue( e.ErrorMessage) as TJsonObject;
                jsonObject2 := jsonObject.Get('errors').JsonValue as TJSONArray;
                jsonObject := TJsonObject.ParseJSONValue(RetiraBarra( jsonObject2.ToString)) as TJsonObject;

                if LowerCase(jsonObject.GetValue('message').Value) = LowerCase('Check-In canceled') then
                    Result := 'Check-in cancelado';

                if LowerCase(jsonObject.GetValue('message').Value) = LowerCase('Check-In already validated') then
                    Result := 'Check-in já validado';

                if LowerCase(jsonObject.GetValue('message').Value) = LowerCase('Check-In expired') then
                    Result := 'Check-in expirou';


             end;
//             ShowMessage('Error: ' + HTTP.ResponseText + ' - ' + e.ErrorMessage);
          end;
        end;
      finally
        Resp.Free;
        jsonObject.Free;
        jsonObject2.Free;
        Xbody.Free;
        HTTP.Free;
      end;

end;

end.
