

% Definir rangos de búsqueda para Cb_min, Cb_max, Cr_min y Cr_max
Cb_min_range = 114:1:114;
Cb_max_range = 149:1:149;
Cr_min_range = 102:1:102;
Cr_max_range = 137:1:137;

% Calcular el número total de iteraciones
total_iterations = length(Cb_min_range) * length(Cb_max_range) ...
                 * length(Cr_min_range) * length(Cr_max_range);

% Inicializar el contador de iteraciones completadas
completed_iterations = 0;

% Crear la barra de progreso
h = waitbar(0, 'Procesando...');

% Inicializar una matriz para almacenar los resultados del F-Score
FScore_matrix = zeros(length(Cb_min_range), length(Cb_max_range), ...
                      length(Cr_min_range), length(Cr_max_range));

% Inicializar variables para almacenar los valores óptimos
optimal_Cb_min = 0;
optimal_Cb_max = 0;
optimal_Cr_min = 0;
optimal_Cr_max = 0;
max_FScore = -inf;

% Iterar a través de diferentes combinaciones de Cb_min, Cb_max, Cr_min y Cr_max
for i = 1:length(Cb_min_range)
    for j = 1:length(Cb_max_range)
        for k = 1:length(Cr_min_range)
            for l = 1:length(Cr_max_range)
                % Obtener los valores de Cb_min, Cb_max, Cr_min y Cr_max
                Cb_min = Cb_min_range(i);
                Cb_max = Cb_max_range(j);
                Cr_min = Cr_min_range(k);
                Cr_max = Cr_max_range(l);
                
                points = [Cb_min, Cb_max, Cr_min, Cr_max];
                
                % Llamar a algo3 con los valores de Cb_min, Cb_max, Cr_min y Cr_max
                algo3Simple(points, 'Training');

                % Llamar a algo4 para obtener el FScore
                FScore = algo4();

                % Almacenar el FScore en la matriz
                FScore_matrix(i, j, k, l) = FScore;
                
                % Actualizar los valores óptimos si se encuentra un FScore mejor
                if FScore > max_FScore
                    max_FScore = FScore;
                    optimal_Cb_min = Cb_min;
                    optimal_Cb_max = Cb_max;
                    optimal_Cr_min = Cr_min;
                    optimal_Cr_max = Cr_max;
                end

                % Incrementar el contador de iteraciones completadas
                completed_iterations = completed_iterations + 1;

                % Calcular el progreso en porcentaje
                progress_percent = (completed_iterations / total_iterations) * 100;

                % Actualizar la barra de progreso
                waitbar(progress_percent / 100, h, sprintf('Progreso: %.2f%%', ...
                        progress_percent));
            end
        end
    end
end

% Cerrar la barra de progreso
close(h);

% Mostrar los valores óptimos
disp('Los valores óptimos son:');
disp(['Cb_min = ' num2str(optimal_Cb_min)]);
disp(['Cb_max = ' num2str(optimal_Cb_max)]);
disp(['Cr_min = ' num2str(optimal_Cr_min)]);
disp(['Cr_max = ' num2str(optimal_Cr_max)]);
disp(['El mejor F-Score encontrado es: ' num2str(max_FScore)]);

