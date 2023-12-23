function SistemaDeteccion()
    % Valores predeterminados de regiones de detección
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
    
    umbralApertura = 98000;         % Umbral para el proceso de apertura
    
    % Processing options
    shadowsRemoval = true;          % Habilitar la reducción de sombras
    filling = true;                 % Habilitar el rellenado de la máscara
    smoothing = true;               % Habilitar el suavizado de bordes
    
    % Análisis 
    createPlot = false;              % Habilitar gráficas de las métricas


    % Crear la ventana principal
    figure('Name', 'Sistema de detección', 'NumberTitle', 'off', ...
        'Position', [350, 270, 680, 440], 'Toolbar', 'none', ...
        'MenuBar', 'none', 'resize', 'off');
    
    % Títulos principales
    uicontrol('Style', 'text', 'Position', [95, 390, 200, 20], 'String', ...
        'Secciones de detección', 'FontWeight', 'bold', ...
        'FontSize', 14, 'ForegroundColor', [0, 0, 0.8], ...
        'FontName', 'underline');
    uicontrol('Style', 'text', 'Position', [395, 360, 60, 20], 'String', ...
        'Ajustes', 'FontWeight', 'bold', ...
        'FontSize', 14, 'ForegroundColor', [0.5, 0.2, 0.2]);
    
    
    % Crear 20 cuadros de edición para los valores
    editBoxes = zeros(1, 20);
    labels = {'Cb_min', 'Cb_max', 'Cr_min', 'Cr_max', ...
            'Cb_min2', 'Cb_max2', 'Cr_min2', 'Cr_max2', ...
            'Cb_min3', 'Cb_max3', 'Cr_min3', 'Cr_max3', ...
            'Cb_min4', 'Cb_max4', 'Cr_min4', 'Cr_max4', ...
            'Cb_min5', 'Cb_max5', 'Cr_min5', 'Cr_max5'};
        
    row = 320;
    col = 60;
    for i = 1:20
        editBoxes(i) = uicontrol('Style', 'edit', 'Position', ...
                                 [col, row, 50, 20], 'String', ...
                                 num2str(eval(labels{i})));
        col = col + 70;
        if mod(i, 4) == 0
            col = 60;
            row = row - 55;
        end
    end

    % Agregar etiquetas de cada sección
    uicontrol('Style', 'text', 'Position', [140, 341, 100, 20], 'String', ...
              'Sección 1', 'FontWeight', 'bold');
    uicontrol('Style', 'text', 'Position', [140, 286, 100, 20], 'String', ...
              'Sección 2', 'FontWeight', 'bold');
    uicontrol('Style', 'text', 'Position', [140, 231, 100, 20], 'String', ...
              'Sección 3', 'FontWeight', 'bold');
    uicontrol('Style', 'text', 'Position', [140, 176, 100, 20], 'String', ...
              'Sección 4', 'FontWeight', 'bold');
    uicontrol('Style', 'text', 'Position', [140, 121, 100, 20], 'String', ...
              'Sección 5', 'FontWeight', 'bold');
    
    % Agregar etiquetas que indique la variable de cada casilla 
    uicontrol('Style', 'text', 'Position', [35,  365, 100, 20], 'String', 'Cb_min');
    uicontrol('Style', 'text', 'Position', [105, 365, 100, 20], 'String', 'Cb_max');
    uicontrol('Style', 'text', 'Position', [175, 365, 100, 20], 'String', 'Cr_min');
    uicontrol('Style', 'text', 'Position', [245, 365, 100, 20], 'String', 'Cr_max');

    %----------------------------------------------------------------------
    
    % Menú desplegable para seleccionar dataset_type
    datasetTypeMenu = uicontrol('Style', 'popupmenu', 'String', ...
                               {'Training', 'Validation', 'Test'}, 'Position', ...
                               [477, 226, 100, 120]);
    
    % Etiqueta para el banco de datos
    uicontrol('Style', 'text', 'Position', [395, 320, 78, 25], ...
              'String', 'Banco de datos:');
    
    %----------------------------------------------------------------------

    % Recuadro para imprimir el valor de F-Score
    fscoreText = uicontrol('Style', 'text', 'Position', [430, -90, 100, 170], ... 
                           'String', 'F-Score: ', 'FontWeight', 'bold');

    % Botón para actualizar el valor de F-Score
    uicontrol('Style', 'pushbutton', 'String', 'Actualizar F-Score', ...
              'Position', [50, 50, 120, 25], 'Callback', @updateFScore);
    
    %----------------------------------------------------------------------
    
    % Botón para generar histogramas
    uicontrol('Style', 'pushbutton', 'String', 'Generar Histogramas', ...
              'Position', [200, 50, 150, 25], 'Callback', @generarHistogramas);
    
    %----------------------------------------------------------------------
    
    % Agregar un cuadro de edición para umbralApertura
    umbralAperturaEdit = uicontrol('Style', 'edit', 'Position', ...
                                   [555, 284, 70, 25], 'String', ...
                                   num2str(umbralApertura));

    % Etiqueta para el cuadro de edición de umbralApertura
    uicontrol('Style', 'text', 'Position', [395, 280, 150, 25], 'String', ...
              'Umbral para la Apertura [#píxels]:');
    
    %----------------------------------------------------------------------
    
    % Etiqueta para el cuadro de procesado
    uicontrol('Style', 'text', 'Position', [395, 235, 140, 25], 'String', ...
              'Operaciones de procesado: ', 'FontWeight', 'bold');
    
    % Etiqueta para el cuadro de métricas
    uicontrol('Style', 'text', 'Position', [385, 130, 180, 25], 'String', ... 
              'Análisis de máscaras y métricas: ', 'FontWeight', 'bold');
    
    % Crear una casillas de verificación
    shadowsRemovalCheckbox = uicontrol('Style', 'checkbox', 'Position', ...
                                      [415, 220, 120, 20], 'String', ...
                                      'Eliminar Sombras', 'Value', ...
                                      shadowsRemoval, 'Callback', ...
                                      @toggleShadowsRemoval);
                                  
    fillingCheckbox = uicontrol('Style', 'checkbox', 'Position', ...
                                [415, 200, 120, 20], 'String', ...
                                'Habilitar Rellenado', 'Value', ...
                                filling, 'Callback', @toggleFilling);
                            
    smoothingCheckbox = uicontrol('Style', 'checkbox', 'Position', ...
                                  [415, 180, 120, 20], 'String', ...
                                  'Habilitar Suavizado', 'Value', ...
                                  smoothing, 'Callback', @toggleSmoothing);
                              
    createPlotCheckbox = uicontrol('Style', 'checkbox', 'Position', ...
                                   [415, 115, 140, 20], 'String', ...
                                   'Habilitar Gráficas Métricas', ...
                                   'Value', createPlot, 'Callback', ...
                                   @toggleCreatePlot);
    
    %----------------------------------------------------------------------
    
    function updateFScore(~, ~)
        % Recopilar el valor de umbralApertura del cuadro de edición
        umbralApertura = str2double(get(umbralAperturaEdit, 'String'));
        
        % Recopilar los valores de los cuadros de edición
        values  = getValues;

        % Obtener el dataset_type seleccionado
        datasetType = datasetTypeMenu.String{datasetTypeMenu.Value};

        % Llamar a algo3 con los valores recopilados y el dataset_type
        % Crear matrices points, points2, points3, points4 y points5
        points =  (values(1:4));
        points2 = (values(5:8));
        points3 = (values(9:12));
        points4 = (values(13:16));
        points5 = (values(17:20));
        
        % Definir la matriz points_matrix concatenando los vectores verticalmente
        points_matrix = [points; points2; points3; points4; points5];
        
        % Llamar a algo3 con los valores recopilados y el dataset_type
        algo3(points_matrix, datasetType, umbralApertura, ...
              [shadowsRemoval, filling, smoothing]);

        % Llamar a algo4 y capturar el F-Score
        FScore = algo4Graphics(datasetType, createPlot);

        % Actualizar el valor de F-Score en pantalla
        set(fscoreText, 'String', ['F-Score: ', num2str(FScore)]);
    end

    function generarHistogramas(~, ~)
        % Recopilar los valores de los cuadros de edición
        values  = getValues;
        
        % Llamar a algo1 con los valores de la sección 1
        algo1(values(1:4), datasetTypeMenu.String{datasetTypeMenu.Value});

        % Llamar a algo1 con los valores de la sección 2
        algo1(values(5:8), datasetTypeMenu.String{datasetTypeMenu.Value});

        % Llamar a algo1 con los valores de la sección 3
        algo1(values(9:12), datasetTypeMenu.String{datasetTypeMenu.Value});
        
        % Llamar a algo1 con los valores de la sección 4
        algo1(values(13:16), datasetTypeMenu.String{datasetTypeMenu.Value});
        
        % Llamar a algo1 con los valores de la sección 5
        algo1(values(17:20), datasetTypeMenu.String{datasetTypeMenu.Value});

    end

    function toggleShadowsRemoval(~, ~)
        % Cambiar el valor de shadowsRemoval según el estado de la 
        % casilla de verificación
        shadowsRemoval = get(shadowsRemovalCheckbox, 'Value');
    end

    function toggleFilling(~, ~)
        % Cambiar el valor de filling según el estado de la 
        % casilla de verificación
        filling = get(fillingCheckbox, 'Value');
    end

    function toggleSmoothing(~, ~)
        % Cambiar el valor de smoothing según el estado de la 
        % casilla de verificación
        smoothing = get(smoothingCheckbox, 'Value');
    end

    function toggleCreatePlot(~, ~)
        % Cambiar el valor de createPlot según el estado de la 
        % casilla de verificación
        createPlot = get(createPlotCheckbox, 'Value');
    end

    function values  = getValues(~, ~)
        % Recopilar los valores de los cuadros de edición
        values = zeros(1, 20);
        for i = 1:20
            values(i) = str2double(get(editBoxes(i), 'String'));
            if isnan(values(i))
                msgbox(['Por favor, ingrese valores numéricos válidos en ' ...
                    'todos los cuadros de edición.', 'Error', 'error']);
                return;
            end
        end
    end
end


