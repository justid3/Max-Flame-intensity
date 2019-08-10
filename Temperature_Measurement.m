%%%%%%%% PRODCUED BY JUSTIN DAVIS AND ERIC MOLNAR
clear all
%find_temperature_range("Methane",50)
fuel = "Ethylene";
dilution = 90;

%function temp_values = find_temperature_range(fuel, dilution)
pic = get_pic(fuel, dilution);
inlet_temp = 25;
A = imread(pic);
A_red = A(:,:,1);
A_green = A(:,:,2);
A_blue = A(:,:,3);

ruler = ruler_coords(fuel);   %934
resolution = 80/(ruler(2) - ruler(1));

max_intensity = max(max(A_red));
threshold = 0.18;   %higher is fewer pixels
dimensions = numel(A_red);
all_pixels = zeros(1,dimensions);
for i = 1:dimensions
   all_pixels(i) = A_red(i);
end

all_pixels = unique(all_pixels);
all_pixels = sort(all_pixels);
final_pixels = all_pixels(1,round(numel(all_pixels)*threshold):numel(all_pixels));
A_red_after = zeros(size(A_red));

for i = 1:numel(final_pixels)
    [l,m] = find(A_red == final_pixels(i));
    for j = 1:numel(l)
        A_red_after(l(j),m(j)) = 255;
    end
end

imshow(A_red_after)
roi = createMask(imfreehand);
position = wait(imfreehand);
[rows, columns] = find(roi);
y_range = [(min(rows) - ruler(1)) * resolution, (max(rows)- ruler(1)) * resolution];

%% Interpolate Temperatures
y_low = y_range(1);
y_high = y_range(2);
[F, D, P ,T]= extract('FlameFrontTemps.csv', fuel, dilution/100, inlet_temp);
T = radcorrect(T, 170e-6, 2);
T = transpose(T);
raw_data = [P;T];
raw_data = raw_data(:,all(~isnan(raw_data))); 
y_values = [y_low, y_high];
temp_values = temp_range(raw_data, y_values);

[temp_values(2) temp_values(1)]

%end
function pic = get_pic(fuel, dilution)
    if strcmp("Ethylene",fuel)
        pic = "C2H4_DIL" + dilution  + ".jpg";
    elseif strcmp("Ethane",fuel)
        pic = "C2H6_DIL" + dilution  +".jpg";
    else
        pic = "CH4_DIL" + dilution + ".jpg";
    end
end

function y = ruler_coords(fuel)
    if strcmp("Ethylene",fuel)
        y = [987 3232];
    elseif strcmp("Ethane",fuel)
        y = [1018 3244];
    else
        y = [1018 3244];
    end
end

function range = temp_range(raw_data, y)
    if y(2) > max(raw_data(1,:))
        y(2) = max(raw_data(1,:))
    end
    range = interp1(raw_data(1,:), raw_data(2,:),y);
    y_range = y(1):.1:y(2);
    range(1) = max(interp1(raw_data(1,:), raw_data(2,:), y_range));
end