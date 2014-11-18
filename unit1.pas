unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, Forms, Controls, Graphics,
  Dialogs, StdCtrls, MaskEdit, Spin, Buttons;


type

  { TForm1 }

  TForm1 = class(TForm)
    Label9: TLabel;
    npuntos: TSpinEdit;
    todoanalitico: TButton;
    todoadelantado: TButton;
    dt: TFloatSpinEdit;
    serieZad: TLineSeries;
    serieYad: TLineSeries;
    Label8: TLabel;
    yadelantado: TButton;
    zadelantado: TButton;
    serieXad: TLineSeries;
    xadelantado: TButton;
    Zanalitica: TLineSeries;
    Yanalitica: TLineSeries;
    ztanalitica: TButton;
    ytanalitica: TButton;
    limpiar: TButton;
    xtanalitica: TButton;
    grafico: TChart;
    Xanalitica: TLineSeries;
    lambda1: TFloatSpinEdit;
    lambda2: TFloatSpinEdit;
    x0: TFloatSpinEdit;
    y0: TFloatSpinEdit;
    z0: TFloatSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure todoadelantadoClick(Sender: TObject);
    procedure todoanaliticoClick(Sender: TObject);
    procedure xadelantadoClick(Sender: TObject);
    procedure xtanaliticaClick(Sender: TObject);
    procedure limpiarClick(Sender: TObject);
    procedure yadelantadoClick(Sender: TObject);
    procedure ytanaliticaClick(Sender: TObject);
    procedure zadelantadoClick(Sender: TObject);
    procedure ztanaliticaClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  t,i: integer;
  vx: array [0..1000] of real; //
  vy: array [0..1000] of real; //vectores para guardar los valores anteriores.
  vz: array [0..1000] of real; //

implementation

{$R *.lfm}

{ TForm1 }

function x(lambda,x0,t:real):real;  //funcion x, solucion analitica del sistema
  begin
       x:=x0 * exp(-lambda*t);
  end;

function y(lambda1,lambda2,x0,y0,t:real):real;  //funcion y, solucion analitica del sistema
         begin
              y:= y0*exp(-lambda2*t) + (lambda1*x0)*(exp(-lambda1*t)-exp(-lambda2*t))/(lambda2-lambda1);
         end;

function z(lambda1,lambda2,x0,y0,z0,t:real):real;  //funcion z, solucion analitica del sistema
  begin
       z:= z0 + y0*(1-exp(-lambda2*t)) + x0*(1 + (1/(lambda1-lambda2))*(lambda2*exp(-lambda1*t)-lambda1*exp(-lambda2*t)));
  end;

function xad(lambda1,xi,dt:real):real;  //solucion por esquema adelantado de x
         begin
              xad:=xi*(1-lambda1*dt)
         end;

function yad(lambda1,lambda2,xi,yi,dt:real):real;  //solucion por esquema adelantado de y
         begin
              yad:= yi*(1-lambda2*dt)+lambda1*xi*dt;
         end;

function zad(lambda2,yi,zi,dt:real):real;  //solucion por esquema adelantado de z
         begin
              zad:=lambda2*yi*dt + zi;
         end;

procedure TForm1.xtanaliticaClick(Sender: TObject);  //grafica la solucion analitica de x
begin
  for t:=0 to npuntos.Value do
      begin
        Xanalitica.AddXY(t*dt.Value,x(lambda1.Value,x0.Value,t*dt.Value));
      end;
end;

procedure TForm1.xadelantadoClick(Sender: TObject);  //grafica la solucion numerica de x
begin
  vx[0]:=x0.Value;
  for i:=0 to npuntos.Value do
      begin
        vx[i+1]:=xad(lambda1.Value,vx[i],dt.Value);
        serieXad.AddXY(i*dt.Value,vx[i]);
      end;
end;

procedure TForm1.todoanaliticoClick(Sender: TObject);
begin
     if lambda1.Value=lambda2.Value then
        MessageDlg('Las constantes lambda1 y lambda2 no pueden tener el mismo valor, división por cero',mtError, mbOkCancel, 0)
     else
     begin
          xtanaliticaClick(Sender);
          ytanaliticaClick(Sender);
          ztanaliticaClick(Sender);
     end;
end;

procedure TForm1.todoadelantadoClick(Sender: TObject);
begin
     xadelantadoClick(Sender);
     yadelantadoClick(Sender);
     zadelantadoClick(Sender);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  todoadelantado.Caption:='  Graficar'+#13+'soluciones'+#13+' numéricas';
  todoanalitico.Caption:='  Graficar'+#13+'soluciones'+#13+' analíticas';
end;

procedure TForm1.ytanaliticaClick(Sender: TObject);  //grafica la solucion analitica de y
begin
     if lambda1.Value=lambda2.Value then
        MessageDlg('Las constantes lambda1 y lambda2 no pueden tener el mismo valor, división por cero',mtError, mbOkCancel, 0)
     else
     for t:=0 to npuntos.Value do
         begin
            Yanalitica.AddXY(t*dt.Value,y(lambda1.Value,lambda2.Value,x0.Value,y0.Value,t*dt.Value));
         end;
end;

procedure TForm1.zadelantadoClick(Sender: TObject);  //grafica la solucion numerica de z
begin
  vz[0]:=z0.Value;
  for i:=0 to npuntos.Value do
      begin
           vz[i+1]:= zad(lambda2.Value,vy[i],vz[i],dt.Value);
           serieZad.AddXY(i*dt.Value,vz[i]);
      end;
end;

procedure TForm1.ztanaliticaClick(Sender: TObject);  //grafica la solucion analitica de z
begin
  if lambda1.Value=lambda2.Value then
        MessageDlg('Las constantes lambda1 y lambda2 no pueden tener el mismo valor, división por cero',mtError, mbOkCancel, 0)
  else
  for t:=0 to npuntos.Value do
      begin
        Zanalitica.AddXY(t*dt.Value,z(lambda1.Value,lambda2.Value,x0.Value,y0.Value,z0.Value,t*dt.Value));
      end;
end;

procedure TForm1.limpiarClick(Sender: TObject);
begin
  Xanalitica.Clear;
  Yanalitica.Clear;
  Zanalitica.Clear;
  serieXad.Clear;
  serieYad.Clear;
  serieZad.Clear;
end;

procedure TForm1.yadelantadoClick(Sender: TObject);  //grafica la solucion numerica de y
begin
     vy[0]:=y0.Value;
     for i:=0 to npuntos.Value do
         begin
           vy[i+1]:= yad(lambda1.Value,lambda2.Value,vx[i],vy[i],dt.Value);
           serieYad.AddXY(i*dt.Value,vy[i]);
         end;
end;

begin


end.

