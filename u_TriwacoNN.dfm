object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'iModNN'
  ClientHeight = 527
  ClientWidth = 815
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object LabeledEdit_ve_grid: TLabeledEdit
    Left = 48
    Top = 72
    Width = 721
    Height = 21
    EditLabel.Width = 220
    EditLabel.Height = 13
    EditLabel.Caption = 'Integer ESRII grid met verdampingseenheden'
    TabOrder = 0
    Text = 'D:\Projdirs\52411Tilburg\GIS\Data\Grid\ve'
    OnClick = LabeledEdit_ve_gridClick
  end
  object GoButton: TButton
    Left = 694
    Top = 464
    Width = 75
    Height = 25
    Caption = 'Go'
    TabOrder = 1
    OnClick = GoButtonClick
  end
  object LabeledEdit_nn_per_decade: TLabeledEdit
    Left = 48
    Top = 136
    Width = 721
    Height = 21
    EditLabel.Width = 321
    EditLabel.Height = 13
    EditLabel.Caption = 'File met per verdampingseenheid het neerslagoverschot in mm/dag'
    TabOrder = 2
    Text = 'D:\Projdirs\52411Tilburg\Data\meteo\nn_2008_2014_per_decade.txt'
    TextHint = 'nn in mm/dag voor iedere verdampingseenheid'
    OnClick = LabeledEdit_nn_per_decadeClick
  end
  object MemoInfo: TMemo
    Left = 48
    Top = 240
    Width = 721
    Height = 209
    Lines.Strings = (
      
        'Maakt een ado file (RP1.ADO) met per decade het neerslagoverscho' +
        't (m/dag). Daarnaast een ado-file'
      'met het gemiddelde neerslagoverschot (RP1_GEM.ado).'
      ''
      
        'Verder wordt in de uitvoer folder het bestand '#39'timesteps.txt'#39' we' +
        'ggeschreven. Gebruik dit '
      'in Triwaco!'
      ''
      
        'Voorbeeld voor bestand met neerslagoverschot per decade (voor ie' +
        'dere verdampingseenheid)'
      
        'De laatste regel bevat het gemiddelde neerslagoverschot over de ' +
        'hele periode,'
      'waarbij het jaar, maand, dag als 0,0,0 is ingevuld.'
      'Gemaakt met get_decade_nn.bat (get_decade_nn.py)'
      ''
      '252 22'
      
        '2008 1 1 1.77 1.938 1.8655 1.5785 1.854 1.826 1.966 0.41 1.312 1' +
        '.826 1.854 1.4555 1.77 '
      '1.77 1.91 1.77 1.845 0.615 0.205 '
      
        '2008 1 11 3.56 3.692 3.4398 2.9106 3.626 3.604 3.714 0.756 2.419' +
        '2 3.604 3.626 2.6838 '
      '3.56 3.56 3.67 3.56 3.402 1.134 0.378 '
      
        '2008 1 21 1.40909090909 1.6 1.57181818182 1.33 1.50454545455 1.4' +
        '7272727273 '
      
        '1.63181818182 0.345454545455 1.10545454545 1.47272727273 1.50454' +
        '545455 '
      
        '1.22636363636 1.40909090909 1.40909090909 1.56818181818 1.409090' +
        '90909 '
      '1.55454545455 0.518181818182 0.172727272727 '
      
        '2008 2 1 3.68 4.058 3.9221 3.3187 3.869 3.806 4.121 0.862 2.7584' +
        ' 3.806 3.869 3.0601 '
      '3.68 3.68 3.995 3.68 3.879 1.293 0.431 '
      
        '2008 2 11 -0.77 -0.308 0.0 0.0 -0.539 -0.616 -0.231 0.0 0.0 -0.6' +
        '16 -0.539 0.0 -0.77 -0.77 -'
      '0.385 -0.77 0.0 0.0 0.0 ')
    TabOrder = 3
  end
  object LabeledEditTriwacoGrid: TLabeledEdit
    Left = 48
    Top = 192
    Width = 721
    Height = 21
    EditLabel.Width = 135
    EditLabel.Height = 13
    EditLabel.Caption = 'File met Triwaco grid (*.teo)'
    TabOrder = 4
    OnClick = LabeledEditTriwacoGridClick
  end
  object OpenGridFileDialog: TOpenDialog
    DefaultExt = '*.teo'
    FileName = 'Grid.teo'
    Filter = '*.teo|*.teo'
    Title = 'Select Grid file'
    Left = 503
    Top = 64
  end
  object ve_int_ESRIgrid: TIntegerESRIgrid
    Left = 400
    Top = 56
  end
  object OpenDialogNNperDecade: TOpenDialog
    DefaultExt = '*.txt'
    FileName = 'nn_per_verd_eenh.txt'
    Filter = '*.txt|*.txt'
    Title = 'File met per verdampingseenheid de nuttige neerslag (mm/dag)'
    Left = 480
    Top = 136
  end
  object DoubleMatrixNN_per_Decade: TDoubleMatrix
    Left = 400
    Top = 136
  end
  object triwacoGrid1: TtriwacoGrid
    Left = 400
    Top = 192
  end
  object OpenTriwacoGridFileDialog: TOpenDialog
    DefaultExt = '*.teo'
    FileName = 'grid.teo'
    Filter = '*.teo|*.teo'
    Title = 'Specify Triwaco grid (*.teo)'
    Left = 472
    Top = 192
  end
  object RealAdoSetNN: TRealAdoSet
    Left = 640
    Top = 464
  end
end
