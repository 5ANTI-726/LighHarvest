clc; clf;

%Sunrise time
sunrise = [06,10,00];
sunrise = sunrise(1) + sunrise(2)/60 + sunrise(3)/3600;

%Latitude
latitude = 0;

t = linspace(0,24,2400);
%Sun's position
s = (90-latitude)*sind(360*(t-sunrise)/24);
s = s;

%Atmospheric propagation
prop = sind(s);

%Fixed panel AOE over horizontal
fixed = 0;
og = abs(sind((90-latitude)*sind(360*(t-sunrise)/24) - fixed).*(s>0)).*prop;

%Fixed panel
tracking = linspace(1,1,size(t,2)).*(s>0).*prop;

%Tracking surface
plot(t(), og(),'DisplayName', 'Fixed orientation panel'); hold on;
%Tracking panel
plot(t(), tracking(),'DisplayName', 'Perfect tracking panel');
%Solar noon
xline(sunrise + 6, 'LineStyle','--');
title('Power coefficient');
legend();
xlim([0 24]);
ylim([0 1.1]);

og_relative_production = power(og,t)/power(tracking,t);
inefficiency = (power(tracking,t)-power(og,t))/power(og,t);

fprintf('Power of tracking panel: %f kWh/m2\n', 2026.0*og_relative_production)
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