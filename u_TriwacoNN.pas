unit u_TriwacoNN;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, {uProgramSettings,} uError, Vcl.StdCtrls,
  Vcl.ExtCtrls, FileCtrl, uTabstractESRIgrid, uTIntegerESRIgrid, LargeArrays,
  OPwstring, uTSingleESRIgrid, Vcl.ComCtrls, uTriwacoGrid, AdoSets, System.IOUtils,
  AVGRIDIO;

type
  TForm3 = class(TForm)
    OpenGridFileDialog: TOpenDialog;
    LabeledEdit_ve_grid: TLabeledEdit;
    ve_int_ESRIgrid: TIntegerESRIgrid;
    GoButton: TButton;
    LabeledEdit_nn_per_decade: TLabeledEdit;
    OpenDialogNNperDecade: TOpenDialog;
    MemoInfo: TMemo;
    DoubleMatrixNN_per_Decade: TDoubleMatrix;
    triwacoGrid1: TtriwacoGrid;
    LabeledEditTriwacoGrid: TLabeledEdit;
    OpenTriwacoGridFileDialog: TOpenDialog;
    RealAdoSetNN: TRealAdoSet;
    procedure LabeledEdit_ve_gridClick(Sender: TObject);
    procedure GoButtonClick(Sender: TObject);
    procedure LabeledEdit_nn_per_decadeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabeledEditTriwacoGridClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation
var
  Directory: String; //Selected output directory

const
  cIni_Input_Files = 'INPUT FILES';
  cIni_Output_Files = 'OUTPUT FILES';
  cIni_ve_grid = 've_grid';
  cIni_nn_file = 'nn_file';
  cIni_Triwaco_Grid_file = 'Triwaco_grid_file';
  cIni_Default_Triwaco_Grid_file = 'c:\grid.teo';
  cIni_Default_nn_file_name = 'nn_per_decade.txt';
  cIni_Output_dir = 'output_dir';
  cIni_DefaultInputDir = 'c:\'; cIni_DefaultOutputDir = 'c\';

{$R *.dfm}

procedure TForm3.FormCreate(Sender: TObject);
begin
  InitialiseLogFile;
  InitialiseGridIO;
  with fini do begin
    LabeledEdit_ve_grid.Text := ReadString( cIni_Input_Files, cIni_ve_grid,
      cIni_DefaultInputDir );
    LabeledEdit_nn_per_decade.Text := ReadString( cIni_Input_Files, cIni_nn_file,
      cIni_DefaultInputDir + cIni_Default_nn_file_name );
    Directory := ReadString( cIni_Output_Files, cIni_Output_dir,
      cIni_DefaultOutputDir );
    LabeledEditTriwacoGrid.Text :=  ReadString( cIni_Input_Files, cIni_Triwaco_Grid_file,
      cIni_Default_Triwaco_Grid_file );
  end;
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
FinaliseLogFile;
end;

procedure TForm3.GoButtonClick(Sender: TObject);
Const
  WordDelims: CharSet = [' '];
var
  iResult, row, nrows, col, ncols, jaar, maand, dag,
  verdampingseenheid, nrOf_AdoSet_nodes, node, CellDepth: Integer;
  f: TextFile;
  Ado_Setname, TimeStepsFileName: string;
  nn, time, x, y: double;
  Initiated: Boolean;
  BeginDate, aDate: TDateTime;
begin
  Try
    Try
      ve_int_ESRIgrid := TIntegerESRIgrid.InitialiseFromESRIGridFile(
            LabeledEdit_ve_grid.Text, iResult, self );
      if not fileExists( LabeledEdit_nn_per_decade.text ) then
        raise Exception.CreateFmt('File does not exist [%s]', [LabeledEdit_nn_per_decade.text]);
      AssignFile( f, LabeledEdit_nn_per_decade.text ); Reset( f );
      DoubleMatrixNN_per_Decade := TDoubleMatrix.InitialiseFromTextFile( f, self );
      CloseFile( f );
      if not SelectDirectory( Directory,  [sdAllowCreate, sdPrompt, sdPerformCreate], 0 ) then
        raise Exception.Create('No output directory chosen');
      fini.WriteString( cIni_Output_Files, cIni_Output_dir, Directory );

      SetCurrentDir( Directory );
      WriteToLogFile('CurrentDir=' + Directory );

      TimeStepsFileName :=  ExpandFileName( 'timesteps.txt' );
      {Schrijf eerst timesteps.txt: neem over in Triwaco!}
      if fileExists( TimeStepsFileName ) then
        TFile.Delete( TimeStepsFileName );

      AssignFile( f, TimeStepsFileName ); Rewrite( f );
      nrows := DoubleMatrixNN_per_Decade.GetNRows;
      ncols := DoubleMatrixNN_per_Decade.GetNCols;

      for row := 1 to nrows-1 do begin
        jaar := trunc( DoubleMatrixNN_per_Decade[ row, 1] );
        maand := trunc(DoubleMatrixNN_per_Decade[ row, 2] );
        dag := trunc( DoubleMatrixNN_per_Decade[ row, 3] );
        writeln( f, dag, '/', maand, '/', jaar, ' 00:00' );
      end;
      CloseFile( f );

      {Create result file RP1.ADO'}
      AssignFile( f, 'RP1.ADO' ); Rewrite( f );

      {-Schrijf per tijdstap een ado-set}
      triwacoGrid1 := TtriwacoGrid.InitFromTextFile( LabeledEditTriwacoGrid.Text,
        self, Initiated );
      nrOf_AdoSet_nodes := triwacoGrid1.NrOfNodes;

        jaar := trunc( DoubleMatrixNN_per_Decade[ 1, 1] );
        maand := trunc(DoubleMatrixNN_per_Decade[ 1, 2] );
        dag := trunc( DoubleMatrixNN_per_Decade[ 1, 3] );
        BeginDate := EncodeDate( jaar, maand, dag);

      for row := 1 to nrows do begin
        jaar := trunc( DoubleMatrixNN_per_Decade[ row, 1] );
        maand := trunc(DoubleMatrixNN_per_Decade[ row, 2] );
        dag := trunc( DoubleMatrixNN_per_Decade[ row, 3] );

        if jaar > 0 then begin
          aDate := EncodeDate( jaar, maand, dag);
          if row = 1 then
            BeginDate := aDate;
          time := aDate - BeginDate;
          Ado_Setname := formatfloat('0.0000000', time );
          Ado_Setname := Copy( Ado_Setname, 1, 9 ); {-9 is het aantal karakters i.d. setnaam...}
          Ado_SetName := 'RP1,TIME=' + Ado_Setname;
        end else begin
          CloseFile( f ); {'RP1.ADO'}
          AssignFile( f, 'RP1_GEM.ado' ); Rewrite( f );
          Ado_Setname := 'RP1_GEM';
        end;
        RealAdoSetNN := TRealAdoSet.Create( nrOf_AdoSet_nodes, Ado_Setname, self );

        for node := 1 to nrOf_AdoSet_nodes do begin
          x := triwacoGrid1.XcoordinatesNodes[ node ];
          y := triwacoGrid1.YcoordinatesNodes[ node ];
          ve_int_ESRIgrid.GetValueNearXY( x, y, 4, CellDepth, verdampingseenheid );
          col := verdampingseenheid + 3;
          if ( col > ncols ) or ( col < 1 ) then begin
            {WriteToLogFile( 'x=' + FloatToStr( x ) + ' y=' + FloatToStr( y ) );
            raise Exception.CreateFmt('Ongeldige verdampingseenheid: %d',
              [verdampingseenheid]);}
            verdampingseenheid := 1; {-Default = gras}
          end;
          nn := DoubleMatrixNN_per_Decade[ row, col ];
          RealAdoSetNN[ node ] := nn / 1000;
        end;

        RealAdoSetNN.ExportToOpenedTextFile( f );
        RealAdoSetNN.Free;

      end;
      CloseFile( f ); {-'RP1_GEM.ado'}

      showmessage('Gereed.' + #13#10 + 'Vergeet niet de timesteps in ' + #13#10 +
      TimeStepsFileName + #13#10 + 'te importeren in de niet-stationaire dataset van Triwaco.');
    Except
      On E: Exception do begin
        HandleError( E.Message, true );
      End;
    End;
  Finally

  End;
end;

procedure TForm3.LabeledEditTriwacoGridClick(Sender: TObject);
begin
  with OpenTriwacoGridFileDialog do begin
    if Execute then begin
      LabeledEditTriwacoGrid.Text := ExpandFileName( FileName );
      fini.WriteString( cIni_Input_Files, cIni_Triwaco_Grid_file,
        LabeledEditTriwacoGrid.Text );
    end;
  end;
end;

procedure TForm3.LabeledEdit_nn_per_decadeClick(Sender: TObject);
begin
  with OpenDialogNNperDecade do begin
    if execute then begin
      LabeledEdit_nn_per_decade.Text := ExpandFileName( FileName );
      fini.WriteString( cIni_Input_Files, cIni_nn_file,
      LabeledEdit_nn_per_decade.Text );
    end;
  end;
end;

procedure TForm3.LabeledEdit_ve_gridClick(Sender: TObject);
var
  Directory: string;
begin
  Directory := GetCurrentDir;
  if SelectDirectory( Directory,  [], 0 ) then begin
    LabeledEdit_ve_grid.Text := ExpandFileName( Directory );
    fini.WriteString( cIni_Input_Files, cIni_ve_grid,
      LabeledEdit_ve_grid.Text );
  end;
end;


end.
