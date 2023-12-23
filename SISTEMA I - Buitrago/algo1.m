function algo1(points, dataset_type)
    %--------------------------------------------------------------------------
    %
    % algo1 - Generar un histograma 3D de los píxeles de piel en el 
    %         espacio de color YCbCr.
    %
    %--------------------------------------------------------------------------
    %
    % Entradas:
    %   - points: Vector de 4 puntos de control [Cb_min, Cb_max, Cr_min, Cr_max].
    %   - dataset_type: Tipo de conjunto de datos, "Training" o "Validation".
    %
    %--------------------------------------------------------------------------
    %
    % Explicación de la función:
    % La función algo1 analiza las imágenes del conjunto de entrenamiento o 
    % validación y genera un histograma 3D de las componentes de crominancia 
    % Cb y Cr. Los puntos de control especificados definen los límites para 
    % identificar los píxeles de piel en las imágenes. El histograma resalta 
    % las regiones de piel en el espacio de color YCbCr y muestra los límites 
    % definidos por los puntos de control.
    %
    %--------------------------------------------------------------------------
    %
    % Ejemplo de uso:
    %   points = [Cb_min, Cb_max, Cr_min, Cr_max];  % Definir puntos de control
    %   algo1(points, 'Validation');  % Generar histograma para el conjunto de 
    %                                   validación
    %
    %--------------------------------------------------------------------------
    %
    % Salida:
    %   La función no tiene una salida explícita, pero genera un histograma 3D 
    %   y lo muestra en la figura actual.
    %
    %--------------------------------------------------------------------------
    
    
    % Verificar si se proporcionaron los valores de puntos de control
    if nargin < 1
        error(['Debes proporcionar un vector de puntos de ' ...
            'control [Cb_min, Cb_max, Cr_min, Cr_max].']);
    end
    
    % Asegurarse de que el vector de puntos tenga 4 elementos
    if numel(points) ~= 4
        error(['El vector de puntos de control debe contener ' ...
            'exactamente 4 valores.']);
    end
    
    Cb_min = points(1);
    Cb_max = points(2);
    Cr_min = points(3);
    Cr_max = points(4);
    
    % Verificar si se proporcionó el directorio del conjunto de datos
    if nargin < 2
        % Valor predeterminado del directorio del conjunto de datos
        dataset_type = 'Training';  % Directorio "Training-Dataset" por defecto
    end 

    % Agregar "-Dataset" al nombre del directorio
    dataset_dir = strcat(dataset_type, '-Dataset');
    
    % Definimos el directorio de las imágenes de entrenamiento 
    % o validación y las máscaras ideales
    img_dir = fullfile('/Users/pol/Desktop/PIV/Laboratorio/Prog1', ...
        dataset_dir, 'Images');
    mask_dir = fullfile('/Users/pol/Desktop/PIV/Laboratorio/Prog1', ...
        dataset_dir, 'Masks-Ideal');

    % Lista de imágenes en el directorio
    image_files = dir(fullfile(img_dir, '*.jpg'));

    % Inicializamos vectores para almacenar los datos de crominancia
    vect_im_mask_cb = [];
    vect_im_mask_cr = [];

    % Recorremos cada imagen del directorio
    for n = 1:length(image_files)
        % Leemos la imagen
        img = imread(fullfile(img_dir, image_files(n).name));

        % Transformamos de RGB a YCbCr
        img_ycbcr = rgb2ycbcr(img);

        % Extraemos las componentes de crominancia Cb y Cr
        img_cb = img_ycbcr(:,:,2);
        img_cr = img_ycbcr(:,:,3);

        % Leemos la máscara correspondiente
        mask_name = strrep(image_files(n).name, 'jpg', 'bmp');
        mask = imread(fullfile(mask_dir, mask_name));

        % Aplicamos la máscara a las componentes Cb y Cr
        img_mask_cb = img_cb(mask);
        img_mask_cr = img_cr(mask);

        % Concatenamos los vectores con datos de crominancia
        vect_im_mask_cb = [vect_im_mask_cb; img_mask_cb];
        vect_im_mask_cr = [vect_im_mask_cr; img_mask_cr];
    end
    
    figure;
    % Creamos la matriz CbCr resultante
    matriz_cbcr_final = [vect_im_mask_cb, vect_im_mask_cr];

    % Creación y presentación del histograma en 3D
    hist3(matriz_cbcr_final, 'Edges', {0:1:255, 0:1:255}, 'CDataMode', 'auto');
    xlabel('Componente Cb');
    ylabel('Componente Cr');
    zlabel('Frecuencia');
    title('Histograma de las Componentes de Crominancia Cb y Cr');

    % Invertir los colores del colormap
    colormap(flipud(colormap));
    % Mostrar el gráfico
    colorbar;  % Agrega una barra de colores para mostrar 
               % la correspondencia de valores

    % Dibujar líneas verticales y horizontales para marcar los límites
    hold on;
    line([Cb_min, Cb_min], [0, 255], 'Color', 'r', 'LineWidth', 2);
    line([Cb_max, Cb_max], [0, 255], 'Color', 'r', 'LineWidth', 2);
    line([0, 255], [Cr_min, Cr_min], 'Color', 'r', 'LineWidth', 2);
    line([0, 255], [Cr_max, Cr_max], 'Color', 'r', 'LineWidth', 2);
    hold off;

    % Agregar etiquetas a las líneas para mostrar los valores de los límites
    text(Cb_min, 10, 'Cb min', 'Color', 'r', 'FontSize', 12);
    text(Cb_max, 10, 'Cb max', 'Color', 'r', 'FontSize', 12);
    text(10, Cr_min, 'Cr min', 'Color', 'r', 'FontSize', 12);
    text(10, Cr_max, 'Cr max', 'Color', 'r', 'FontSize', 12);
end

