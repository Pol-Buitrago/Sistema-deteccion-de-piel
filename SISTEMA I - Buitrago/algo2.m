function skin_mask = algo2(input_image, points)
    %--------------------------------------------------------------------------
    %
    % algo2 - Genera una máscara de piel en una imagen dada.
    %
    %--------------------------------------------------------------------------
    %
    % Entradas:
    %   - input_image: Imagen de entrada en formato RGB.
    %   - points: Vector de 4 puntos de control [Cb_min, Cb_max, Cr_min, Cr_max].
    %
    %--------------------------------------------------------------------------
    %
    % Explicación de la función:
    % La función algo2 toma una imagen en formato RGB y un vector de 4 puntos de
    % control que definen los rangos de color de piel en el espacio de color YCbCr.
    % La función crea una máscara binaria que identifica los píxeles de piel en la
    % imagen original según los rangos especificados por los puntos de control.
    %
    %--------------------------------------------------------------------------
    %
    % Ejemplo de uso:
    %   input_image = imread('imagen.jpg');  % Carga la imagen en formato RGB
    %   points = [Cb_min, Cb_max, Cr_min, Cr_max];  % Define los puntos de control
    %   skin_mask = algo2(input_image, points);  % Genera una máscara de piel
    %
    %-------------------------------------------------------------------------%
    % Salida:
    %   - skin_mask: Máscara binaria que indica los píxeles de piel 
    %                (1: piel, 0: no piel).
    %
    %--------------------------------------------------------------------------
  
    
    % Verificar si se proporcionaron los valores de Cb_min, Cb_max, Cr_min y Cr_max
    if nargin < 2
        error(['Debes proporcionar un vector de puntos de control' ...
            '[Cb_min, Cb_max, Cr_min, Cr_max].']);
    end

    % Asegurarse de que el vector de puntos tenga 4 elementos
    if numel(points) ~= 4
        error('El vector de puntos de control debe contener exactamente 4 valores.');
    end
    
    Cb_min = points(1);
    Cb_max = points(2);
    Cr_min = points(3);
    Cr_max = points(4);
    
    % Inicializar la máscara con ceros
    skin_mask = zeros(size(input_image, 1), size(input_image, 2));
    
    % Transformar la imagen a YCbCr
    im_ycbcr = rgb2ycbcr(input_image);
    
    % Crear máscara basada en los rangos de color de piel
    skin_mask((im_ycbcr(:,:,2) >= Cb_min & im_ycbcr(:,:,2) <= Cb_max) & ...
         (im_ycbcr(:,:,3) >= Cr_min & im_ycbcr(:,:,3) <= Cr_max)) = 1; 
end

