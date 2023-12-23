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
shadowsRemoval = false;          % Habilitar la reducción de sombras
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

% Tipos de elementos estructurantes y valores
se_types = {'disk', 'square', 'diamond', 'cube', 'sphere'}; 
values = 0:7; 

% Matrices para almacenar los resultados
f_scores = zeros(length(se_types), length(values));

for i = 1:length(se_types)
    for j = 1:length(values)
        se = se_types{i};
        value = values(j);
        
        algo3SE(points_matrix, dataset_type, umbralApertura, processingOptions, ...
            se, value);
    
        % Llama a la función algo4 y captura el F-Score
        FScore = algo4Graphics(dataset_type, false);
        
        % Almacena el F-Score en la matriz
        f_scores(i, j) = FScore;
    end
end

% Encuentra el valor máximo de F-Score y su ubicación
[max_f_score, max_index] = max(f_scores(:));
[se_index, value_index] = ind2sub(size(f_scores), max_index);
optimal_se = se_types{se_index};
optimal_value = values(value_index);

% Gráfica
figure;
hold on;
for i = 1:length(se_types)
    plot(values, f_scores(i, :), 'o-', 'DisplayName', se_types{i});
end

% Marcar el punto máximo
plot(optimal_value, max_f_score, 'ro', 'DisplayName', 'Máximo F-Score');

hold off;

xlabel('Value');
ylabel('F-Score');
legend('Location', 'Best');
title('F-Score vs. SE Type and Value');
grid on;

% Mostrar el valor máximo en la gráfica
text(optimal_value, max_f_score, ...
    [' (' num2str(optimal_value) ', ' num2str(max_f_score) ')'], ...
     'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
