% Definir los valores de los umbrales para cada región de piel
Cb_min = 114; Cb_max = 149;
Cr_min = 102; Cr_max = 137;

Cb_min2 = 108; Cb_max2 = 115;
Cr_min2 = 155; Cr_max2 = 168;

Cb_min3 = 95;  Cb_max3 = 111;
Cr_min3 = 139; Cr_max3 = 146;

Cb_min4 = 111; Cb_max4 = 118;
Cr_min4 = 137; Cr_max4 = 138;

Cb_min5 = 112; Cb_max5 = 114;
Cr_min5 = 140; Cr_max5 = 142;


% Opciones de procesamiento
dataset_type = 'Training';      % Directorio del conjunto de datos
umbralApertura = 98000;         % Umbral para el proceso de apertura
shadowsRemoval = true;          % Habilitar la reducción de sombras
filling = true;                 % Habilitar el rellenado de la máscara
smoothing = true;               % Habilitar el suavizado de bordes
createPlot = false;              % Habilitar gráficas de las métricas


% Definir los vectores de puntos de control para cada región
points  = [Cb_min, Cb_max, Cr_min, Cr_max];
points2 = [Cb_min2, Cb_max2, Cr_min2, Cr_max2];
points3 = [Cb_min3, Cb_max3, Cr_min3, Cr_max3];
points4 = [Cb_min4, Cb_max4, Cr_min4, Cr_max4];
points5 = [Cb_min5, Cb_max5, Cr_min5, Cr_max5];

% Crear un vector de opciones de procesamiento
processingOptions = [shadowsRemoval, filling, smoothing];

% Definir la matriz points_matrix concatenando los vectores verticalmente
points_matrix = [points; points2; points3; points4; points5];

% Mostrar histogramas de las regiones de piel utilizadas (opcional)
%algo1(points, dataset_type)
%algo1(points2, dataset_type)
%algo1(points3, dataset_type)
%algo1(points4, dataset_type)
%algo1(points5, dataset_type)


% Llamar a la función algo3 para generar máscaras de detección de piel
algo3(points_matrix, dataset_type, umbralApertura, processingOptions)

% Llama a la función algo4 y captura el F-Score
FScore = algo4Graphics(dataset_type, false);

% Mostrar el valor del F-Score en la consola
disp(['El valor del F-Score es: ' num2str(FScore)]);


