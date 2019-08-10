%%%%%%%% PRODCUED BY JUSTIN DAVIS AND ERIC MOLNAR
clear all
%find_temperature_range("Methane",50)
fuel = "Ethane";
dilution = 85;

%function temp_values = find_temperature_range(fuel, dilution)
pic = get_pic(fuel, dilution);
inlet_temp = 25;
A = imread(pic);
A_red = A(:,:,1);
A_green = A(:,:,2);
A_blue = A(:,:,3);
y_0 = 454;   %934
y_80 = 2698;  %3220
resolution = 80/(y_80 - y_0);

imshow(A)
roi = createMask(imfreehand);
position = wait(imfreehand);
[rows, columns] = find(roi);
y_range = [(min(rows) - y_0) * resolution, (max(rows)- y_0) * resolution];

flame_height = y_range(2) - y_range(1)
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
