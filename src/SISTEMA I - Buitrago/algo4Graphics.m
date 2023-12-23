function FScore = algo4Graphics(dataset_type, createPlot)
    %--------------------------------------------------------------------------
    %
    % algo4Graphics - Calcula el F-score comparando máscaras generadas y máscaras 
    % ideales y crea una gráfica.
    %
    %--------------------------------------------------------------------------
    %
    % Entradas:
    %   - dataset_type: Tipo de conjunto de datos, "Training" o "Validation."
    %   - createPlot: Booleano que indica si se debe crear una gráfica.
    %
    %--------------------------------------------------------------------------
    %
    % Explicación de la función:
    % La función algo4Graphics compara las máscaras generadas por nosotros con las 
    % máscaras ideales para un conjunto de imágenes y calcula el F-score. 
    % El F-score es una métrica que combina la precisión (Precision) y la 
    % exhaustividad (Recall) para evaluar la calidad de las máscaras generadas 
    % en la detección de piel. Si createPlot es true, se crea una gráfica que 
    % muestra Precision, Recall y F-Score para cada imagen.
    %
    %--------------------------------------------------------------------------
    %
    % Ejemplo de uso:
    %   FScore = algo4Graphics('Validation', true);  % Calcular el F-score para el 
    %                                                % conjunto de validación y 
    %                                                  crear una gráfica
    %
    %--------------------------------------------------------------------------
    %
    % Salida:
    %   - FScore: Valor del F-score que indica la calidad de las máscaras generadas.
    %
    %--------------------------------------------------------------------------

    % Verificar si se proporcionó el tipo de conjunto de datos
    if nargin < 1
        % Valor predeterminado del tipo de conjunto de datos
        dataset_type = 'Training';  % Directorio "Training-Dataset" por defecto
    end

    % Verificar si se debe crear una gráfica
    if nargin < 2
        createPlot = false;  % Valor predeterminado: no crear la gráfica
    end

    % Agregar "-Dataset" al nombre del directorio
    dataset_dir = strcat(dataset_type, '-Dataset');
    
    % Directorios de entrada
    input_dir = fullfile('/Users/pol/Desktop/PIV/Laboratorio/Prog1', ...
                            dataset_dir, 'Images');
    mask_dir = fullfile('/Users/pol/Desktop/PIV/Laboratorio/Prog1', ...
                            dataset_dir, 'Masks');
    ideal_mask_dir = fullfile('/Users/pol/Desktop/PIV/Laboratorio/Prog1', ...
                            dataset_dir, 'Masks-Ideal');

    % Información de las imágenes en el directorio de entrada
    lista_im = dir(fullfile(input_dir, '*.jpg'));

    % Variables para el cálculo de F-score
    vect_TP = zeros(1, length(lista_im));
    vect_T = zeros(1, length(lista_im));
    vect_P = zeros(1, length(lista_im));
    
    if createPlot
        % Crear una figura
        figure('Position', [100, 100, 1000, 400]);

        % Agregar un control deslizante (slider) para seleccionar la imagen
        slider = uicontrol('Style', 'slider', 'Min', 1, 'Max', length(lista_im), ...
            'Value', 1, 'SliderStep', [1/(length(lista_im)-1) 1/(length(lista_im)-1)], ...
            'Position', [100 20 300 20], 'Callback', @sliderCallback);

        % Agregar un texto para mostrar el valor del slider
        text = uicontrol('Style', 'text', 'Position', [420 20 40 20], ...
            'FontWeight', 'bold');
    end 
    
    % Función de devolución de llamada para el slider
    function sliderCallback(hObject, ~)
        slider_value = round(hObject.Value); % Obtener el valor del slider
        
        % Actualizar el texto con el valor del slider
        set(text, 'String', num2str(slider_value));
        
        % Leer la imagen correspondiente al valor del slider
        selected_image_name = lista_im(slider_value).name;
        mask_nuestra = imread(fullfile(mask_dir, strrep(selected_image_name,...
            'jpg', 'bmp')));
        
        % Mostrar la imagen y la máscara en el subplot izquierdo
        subplot(1, 3, 1);
        imshow(mask_nuestra);
        title(['Máscara de la imagen ' num2str(slider_value)]);
        
        % También puedes mostrar la imagen original si lo deseas
        img_original = imread(fullfile(input_dir, selected_image_name));
        subplot(1, 3, 2);
        imshow(img_original);
        title(['Imagen original ' num2str(slider_value)]);
        
        % Calcular Precision, Recall y F-Score para la imagen seleccionada
        TP_im = vect_TP(slider_value);
        P_im = vect_P(slider_value);
        T_im = vect_T(slider_value);
        Precision_im = TP_im / P_im;
        Recall_im = TP_im / T_im;
        FScore_im = 2 * Precision_im * Recall_im / (Precision_im + Recall_im);
        
        % Crear la gráfica en el subplot derecho
        subplot(1, 3, 3);
        bar([Precision_im, Recall_im, FScore_im]);
        title(['Precision, Recall, F-Score para la imagen ' num2str(slider_value)]);
        set(gca, 'XTickLabel', {'Precision', 'Recall', 'F-Score'});
    end
    
    % Por cada imagen en el directorio de entrada
    for n = 1:length(lista_im)
        % Leer la máscara generada por nosotros y la máscara ideal
        mask_nuestra = imread(fullfile(mask_dir, strrep(lista_im(n).name, ...
                                'jpg', 'bmp')));
        mask_ideal = imread(fullfile(ideal_mask_dir, strrep(lista_im(n).name, ...
                                'jpg', 'bmp')));

        % Calcular TP, T y P utilizando operaciones vectorizadas
        TP = sum(mask_nuestra(:) & mask_ideal(:));
        P = sum(mask_nuestra(:));
        T = sum(mask_ideal(:));

        % Almacenar los resultados en vectores
        vect_TP(n) = TP;
        vect_T(n) = T;
        vect_P(n) = P;
    end


    % Calcular TP, T y P totales
    total_TP = sum(vect_TP);
    total_T = sum(vect_T);
    total_P = sum(vect_P);

    % Calcular Precisión y Recall
    Precision = total_TP / total_P;
    Recall = total_TP / total_T;

    % Calcular F-Score
    FScore = 2 * Precision * Recall / (Precision + Recall);
    
    
    % Crear la gráfica si createPlot es true
    if createPlot
        sliderCallback(slider, []);
        
        vect_precision = zeros(1, length(lista_im));
        vect_recall = zeros(1, length(lista_im));
        vect_fScore = zeros(1, length(lista_im));

        for n = 1:length(lista_im)
            % Calcular Precision, Recall y F-Score para cada imagen
            vect_precision(n) = vect_TP(n) / vect_P(n);
            vect_recall(n) = vect_TP(n) / vect_T(n);
            vect_fScore(n) = 2 * vect_precision(n) * vect_recall(n) / ...
                (vect_precision(n) + vect_recall(n));
        end

        % Crear la gráfica con Precision, Recall y F-Score
        figure;
        x = 1:length(lista_im);

        % Define la variable que representa el valor deseado
        % Representar la precisión
        subplot(3, 1, 1);
        plot(x, vect_precision, 'r');
        title('Gráfica de Precision, Recall y F-Score por Número de Imagen');
        xlabel('Número de Imagen');
        ylabel('Precision');
        legend('Precision');
        h1 = refline(0, Precision); 
        h1.DisplayName = 'mean';

        % Representar el recall
        subplot(3, 1, 2);
        plot(x, vect_recall, 'g');
        xlabel('Número de Imagen');
        ylabel('Recall');
        legend('Recall');
        h2 = refline(0, Recall); 
        h2.DisplayName = 'mean';

        % Representar el F-Score
        subplot(3, 1, 3);
        plot(x, vect_fScore, 'b');
        xlabel('Número de Imagen');
        ylabel('F-Score');
        legend('F-Score');
        h3 = refline(0, FScore);  
        h3.DisplayName = 'mean';
    end
end
