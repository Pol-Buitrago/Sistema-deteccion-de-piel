function algo3(points_matrix, dataset_type, umbralApertura, processingOptions)
    %--------------------------------------------------------------------------
    %
    % algo3 - Genera máscaras de detección de piel para un conjunto de imágenes.
    %
    %--------------------------------------------------------------------------
    %
    % Entradas:
    %   - points_matrix: Matriz de 4 puntos de control (Cb_min, Cb_max, Cr_min, 
    %                                                   Cr_max) para cada región.
    %
    %   - dataset_type: Directorio del conjunto de datos('Training' o 'Validation').
    %
    %   - umbralApertura: Umbral para el proceso de apertura (ajuste personalizado).
    %
    %   - processingOptions: Vector de booleanos que controlan varias opciones de 
    %                                                              procesamiento.
    %
    %     - processingOptions(1): Habilita o deshabilita la reducción de sombras.
    %     - processingOptions(2): Habilita o deshabilita el rellenado de la máscara.
    %     - processingOptions(3): Habilita o deshabilita el suavizado de bordes de 
    %                                                                   la máscara.
    %
    %--------------------------------------------------------------------------
    %
    % Explicación de la función:
    % La función algo3 utiliza la función algo2 para generar máscaras de detección
    % de piel para un conjunto de imágenes. El conjunto de imágenes se define 
    % mediante un directorio ("Images") dentro del directorio del conjunto de datos 
    % especificado. Las máscaras se generan y se escriben en un directorio llamado 
    % "Masks" con el mismo nombre que las imágenes procesadas. El umbral de apertura 
    % se utiliza para controlar el proceso de apertura morfológica y ajustar la 
    % detección de piel.Los elementos de processingOptions controlan varias opciones 
    % de procesamiento.
    %
    %--------------------------------------------------------------------------
    %
    % Ejemplo de uso:
    %   points_matrix = [120, 140, 120, 140;     % Puntos de control de la región 1
    %                    100, 120, 150, 170;     % Puntos de control de la región 2
    %                    110, 130, 160, 180;     % Puntos de control de la región 3
    %                    ...
    %                    90,  110, 130, 150];    % Puntos de control de la región N 
    %
    %
    %   dataset_type = 'Training';  % Especifica el directorio del conjunto de datos
    %   umbralApertura = 98000;     % Ajusta el umbral de apertura
    %   processingOptions = [true, true, true];  % Habilita todas las opciones de 
    %                                              procesamiento
    %
    %   % Llama a la función para generar máscaras.
    %   algo3(points_matrix, dataset_type, umbralApertura, processingOptions);  
    %
    %--------------------------------------------------------------------------

    % Verificar los argumentos de entrada
    dataset_type = checkInputArguments(points_matrix, dataset_type);

    % Configurar directorios
    [input_dir, output_dir] = setupDirectories(dataset_type);
   
    
    % Creamos o no la matriz de eliminación de sombras
    if processingOptions(1) 
        % Agregar un matriz de conjuntos para eliminación
        points_removal_matrix = [[122, 122, 139, 141]; ...
                                [120,120,142,142]; ...
                                [121,121,140,140]; ...
                                [113,117,139,139]; ...
                                [123,123,139,139]]; 
                            
        % Procesar imágenes con eliminación de sombras
        processImages(points_matrix, points_removal_matrix, input_dir, ...
                  output_dir, umbralApertura, processingOptions);
    
    else
        % Procesar imágenes sineliminación de sombras
        processImages(points_matrix, [], input_dir, ...
                      output_dir, umbralApertura, processingOptions);
    end
    
end


%--------------------------------------------------------------------------
%--------------------------SUBFUNCIONES------------------------------------
%--------------------------------------------------------------------------
% Subfunción para verificar los argumentos de entrada
function dataset_type = checkInputArguments(points_matrix, dataset_type)
    % Comprobar si se proporcionó la matriz de puntos
    if nargin < 1
        error(['Debes proporcionar una matriz de puntos de control ' ...
            '[Cb_min, Cb_max, Cr_min, Cr_max] para las cuatro regiones.']);
    end

    % Asegurarse de que la matriz de puntos tenga 4 columnas
    if size(points_matrix, 2) ~= 4
        error(['La matriz de puntos de control debe contener exactamente 4 ' ...
            'columnas (Cb_min, Cb_max, Cr_min, Cr_max).']);
    end

    % Verificar y ajustar el directorio del conjunto de datos
    if nargin < 2
        dataset_type = 'Training';  % Valor predeterminado: directorio "Training"
    end

    % Agregar sufijo "-Dataset" al directorio si es necesario
    if ~contains(dataset_type, '-Dataset')
        dataset_type = strcat(dataset_type, '-Dataset');
    end
end
%--------------------------------------------------------------------------
% Subfunción para configurar directorios
function [input_dir, output_dir] = setupDirectories(dataset_type)
    % Directorio base
    base_dir = '/Users/pol/Desktop/PIV/Laboratorio/Prog1';
    
    % Directorio de entrada de imágenes
    input_dir = fullfile(base_dir, dataset_type, 'Images');
    
    % Directorio de salida de máscaras
    output_dir = fullfile(base_dir, dataset_type, 'Masks');

    % Comprobar y crear el directorio de salida si no existe
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end
end
%--------------------------------------------------------------------------
% Subfunción para procesar imágenes
function processImages(points_matrix, points_removal_matrix, input_dir, ...
                        output_dir, umbralApertura, processingOptions)
    
    % Definimos las operaciones de post-procesamiento
    shadowsRemoval = processingOptions(1);
    filling = processingOptions(2);
    smoothing = processingOptions(3);
                    
    % Obtener la lista de archivos de imágenes en el directorio de entrada
    image_files = dir(fullfile(input_dir, '*.jpg'));
    
    for n = 1:length(image_files)
        % Leer la imagen
        image = imread(fullfile(input_dir, image_files(n).name));
        
        % Generar máscaras para las cuatro regiones
        masks = generateMasks(image, points_matrix);
        
        % Combinar las máscaras
        combined_mask = combineMasks(masks);
        
        if shadowsRemoval
            % Generar máscaras para todas las regiones
            masks_removal = generateMasks(image, points_removal_matrix);
            
            % Combinar las máscaras
            combined_removal_mask = combineMasks(masks_removal);
            
            % Restarla
            combined_mask = combined_mask & combined_removal_mask;
        end
            
        % Construir el nombre de archivo de salida
        output_filename = constructOutputFilename(output_dir, image_files(n).name);

        % Guardar el componente conectado más grande o la máscara combinada
        if saveLargestConnectedComponent(combined_mask, output_filename, ...
                                         umbralApertura, filling, smoothing)
            continue;
        end
        
        % Guardar la máscara combinada si no se encontraron componentes conectados
        imwrite(~combined_mask, output_filename);
    end
end
%--------------------------------------------------------------------------
% Subfunción para generar máscaras
function masks = generateMasks(image, points_matrix)
    % Utilizar algo2 para generar máscaras para las regiones
    masks = arrayfun(@(i) algo2(image, points_matrix(i, :)), ...
        1:size(points_matrix, 1), 'UniformOutput', false);
end
%--------------------------------------------------------------------------
% Subfunción para combinar máscaras
function combined_mask = combineMasks(masks)
    % Combinar las máscaras negando cualquier máscara activa
    combined_mask = ~(any(cat(3, masks{:}), 3));
end
%--------------------------------------------------------------------------
% Subfunción para construir nombres de archivo de salida
function output_filename = constructOutputFilename(output_dir, image_filename)
    % Obtener el nombre base del archivo de imagen
    [~, base_name, ~] = fileparts(image_filename);
    
    % Combinar con el directorio de salida y el formato de archivo
    output_filename = fullfile(output_dir, [base_name, '.bmp']);
end
%--------------------------------------------------------------------------
% Subfunción para guardar el componente conectado más grande
function save = saveLargestConnectedComponent(combined_mask, output_filename, ...
                                              umbralApertura, filling, smoothing)
    % Encontrar componentes conectados en la máscara combinada
    cc = bwconncomp(combined_mask);
    
    % Variable para rastrear es necesario realizar un proceso de apertura
    apertura = false;
    
    if cc.NumObjects > 0
        % Calcular el número de píxeles en cada componente
        numPixels = cellfun(@numel, cc.PixelIdxList);
        
        % Comprobar si el componente mayor es demasido grande 
        % *Indicio de píxeles de piel no pertenecientes a la mano*
        if max(numPixels) > umbralApertura
            % Si es así, realiza una erosión para reducir el tamaño del componente
            se = strel('sphere', 10); % Esfera de radio 10
            combined_mask = imerode(combined_mask, se);
            
            %Encontrar las nuevas componentes
            cc = bwconncomp(combined_mask);
            numPixels = cellfun(@numel, cc.PixelIdxList);
            apertura = true;
        end
        
        % Encontrar el índice del componente más grande
        [~, idx] = max(numPixels);

        % Crear una nueva máscara con solo el componente más grande
        largestComponent = false(size(combined_mask));
        largestComponent(cc.PixelIdxList{idx}) = true;
        
        % Si se realizó una erosión previamente, realiza una dilatación 
        % para restaurar el tamaño
        if apertura
            largestComponent = imdilate(largestComponent, se);
        end
        
        mask = largestComponent;
        
        if filling
            % Rellenar los huecos en la máscara
            mask = imfill(mask, 'holes');
        end
        
        if smoothing
            % Suavizar los bordes de la máscara
            mask = smoothEdges(mask); 
        end 
        
        if (filling && smoothing)
            % Rellenar los huecos en la máscara
            mask = imfill(mask, 'holes');
        end

        % Guardar la máscara en el directorio de salida
        imwrite(~mask, output_filename);
        
        save = true;
    else
        % No se encontraron componentes conectados, guardar la máscara original
        imwrite(combined_mask, output_filename); 
        save = false;
    end
end
%--------------------------------------------------------------------------
% Subfunción para suavizar los bordes por apertura
function smoothed_mask = smoothEdges(mask)
    % Crear un elemento estructurante (kernel) para suavizado de bordes
    se = strel('disk', 4); % Kernel circular de radio 4 

    % Aplicar dilatación seguida de erosión para suavizar los bordes
    smoothed_mask = imerode(imdilate(mask, se), se);
end
%--------------------------------------------------------------------------


