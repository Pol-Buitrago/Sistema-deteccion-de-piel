% Crear un elemento estructurante en forma de disco con radio 5
SE = strel('disk', 10);

% Obtener la matriz de elementos del elemento estructurante
se_elements = SE.Neighborhood;

% Definir ejes X e Y
x_axis = 1:size(se_elements, 2);
y_axis = 1:size(se_elements, 1);

% Mostrar el elemento estructurante con números de píxeles en los ejes
figure;
imagesc(x_axis, y_axis, se_elements);
colormap('gray'); % Establecer el mapa de colores en escala de grises
title('Elemento Estructurante 2D (Disco)');
xlabel('Eje X (píxeles)');
ylabel('Eje Y (píxeles)');
colorbar; % Agregar barra de colores para la escala de grises
axis on; % Mostrar ejes

