clc; clf;

days = linspace(1,365,365);
day_horizontal_power = [];
day_tracking_power = [];
day_latitude = [];
for k=1:365
    %Sunrise time
    sunrise = [06,10,00];
    sunrise = sunrise(1) + sunrise(2)/60 + sunrise(3)/3600;
    
    %Ecliptic angle
    latitude = 12.8433*sind(days(k)+98) + 12.8433;
    day_latitude(end+1)=latitude;
    
    t = linspace(0,24,2400);
    %Sun's position
    s = (90-latitude)*sind(360*(t-sunrise)/24);
    
    %Atmospheric propagation
    prop = sind(s);
    
    %Fixed panel AOE over horizontal
    fixed = 0;
    og = abs(sind((90-latitude)*sind(360*(t-sunrise)/24) - fixed).*(s>0)).*prop;
    
    %Fixed panel
    tracking = linspace(1,1,size(t,2)).*(s>0).*prop;

    day_horizontal_power(end+1) = power(og,t);
    day_tracking_power(end+1) = power(tracking,t);
end

relative_annual_horizontal_production = power(day_horizontal_power,days)/power(day_tracking_power,days);
inefficiency = (power(day_tracking_power,days)-power(day_horizontal_power,days))/power(day_horizontal_power,days);

%Tracking surface
plot(days(), day_horizontal_power(),'DisplayName', 'Panel plano'); hold on;
%Tracking panel
plot(days(), day_tracking_power(),'DisplayName', 'Panel con seguimiento solar');
%Solar solstice
xline(172, 'LineStyle','--', 'DisplayName', 'Solsticio solar (21 de junio)');
title('Coeficiente de potencia');
legend();
xlim([0 365]);
ylim([0 1.1]*max(day_tracking_power));
xlabel('Día del año')

fprintf('Power of tracking panel: %f kWh/m2\n', 2026.0*relative_annual_horizontal_production)
disp('Power of fixed orientation panel: 2026.0 kWh/m2')
fprintf('Additional power generation: %f%%\n', 100*inefficiency)

function sum = power(array, space)
    sum = 0;
    for i=1:size(array,2)
        sum = sum + array(i);
    end
    delta = space(2) - space(1);
    sum = sum*delta*(1 - 1/size(array,2));
end