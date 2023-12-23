
    
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
shadowsRemoval = false;          % Habilitar la reducción de sombras
filling = false;                 % Habilitar el rellenado de la máscara
smoothing = false;               % Habilitar el suavizado de bordes
createPlot = false;              % Habilitar gráficas de las métricas

% Crear un vector de opciones de procesamiento
processingOptions = [shadowsRemoval, filling, smoothing];

% Definir los vectores de puntos de control
points = [Cb_min, Cb_max, Cr_min, Cr_max];
points2 = [Cb_min2, Cb_max2, Cr_min2, Cr_max2];
points3 = [Cb_min3, Cb_max3, Cr_min3, Cr_max3];
points4 = [Cb_min4, Cb_max4, Cr_min4, Cr_max4];
points5 = [Cb_min5, Cb_max5, Cr_min5, Cr_max5];

% Definir la matriz points_matrix concatenando los vectores verticalmente
points_matrix = [points; points2; points3; points4; points5];

% Inicializa variables para almacenar el mejor F-Score y el umbral correspondiente
bestFScore = 0;
bestThreshold = 0;

UmbralSup = 98000;
UmbralInf = 98000;
Paso = 1;

% Define un rango de umbrales que deseas probar
thresholds = UmbralInf:Paso:UmbralSup;

% Calcular el número total de iteraciones
total_iterations = (UmbralSup-UmbralInf)/Paso;

% Inicializar el contador de iteraciones completadas
completed_iterations = 0;

% Crear la barra de progreso
h = waitbar(0, 'Procesando...');

for threshold = thresholds
    % Llama a la función algo3 con el valor actual de threshold
    algo3(points_matrix, dataset_type, umbralApertura, processingOptions)
    
    % Llama a la función algo4 con dataset_type
    FScore = algo4Graphics(dataset_type, createPlot);
    
    % Verifica si el F-Score actual es mejor que el mejor F-Score 
    % encontrado hasta ahora
    if FScore > bestFScore
        bestFScore = FScore;
        bestThreshold = threshold;
    end
    % Incrementar el contador de iteraciones completadas
    completed_iterations = completed_iterations + 1;

    % Calcular el progreso en porcentaje
	progress_percent = (completed_iterations / total_iterations) * 100;

	% Actualizar la barra de progreso
    waitbar(progress_percent / 100, h, sprintf('Progreso: %.2f%%', progress_percent));
    
end

% Cerrar la barra de progreso
close(h);

% Imprime el mejor F-Score y el umbral correspondiente
disp(['El mejor valor del F-Score es: ' num2str(bestFScore)]);
disp(['El umbral correspondiente es: ' num2str(bestThreshold)]);
