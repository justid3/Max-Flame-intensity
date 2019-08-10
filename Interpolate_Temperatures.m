% Interpolate Temperatures
y_low = 28.7;
y_high = 49.3;
dilution = 67/100;
fuel = "Methane";
inlet_temp = 25;

%ethane 0%
[F, D, P ,T]= extract('FlameFrontTemps.csv', fuel, dilution, inlet_temp);
T = radcorrect(T,170e-6,2);
T = transpose(T);
raw_data = [P;T];
raw_data = raw_data(:,all(~isnan(raw_data))); 
y_values = [y_low, y_high];
temp_values = temp_range(raw_data, y_values);

temp_values

function range = temp_range(raw_data, y)
     range = interp1(raw_data(1,:), raw_data(2,:),y);
     y_range = y(1):.1:y(2);
     range(1) = max(interp1(raw_data(1,:), raw_data(2,:),y_range));
end
