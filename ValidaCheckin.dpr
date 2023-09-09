program ValidaCheckin;

uses
  Vcl.Forms,
  uValidaCheckin in 'uValidaCheckin.pas' {frmValidaCheckin};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmValidaCheckin, frmValidaCheckin);
  Application.Run;
end.
