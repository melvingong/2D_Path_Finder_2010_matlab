% E177, Advanced Programming with Matlab, Engineering, UC Berkeley.
% Copyright Christopher Bulpitt, Andy Tsai, Melvin Gong, Charlie Cheuk, 2010.
% This work is licensed under the Creative Commons Attribution 3.0 Unported
% License. To view a copy of this license, visit
% http://creativecommons.org/licenses/by/3.0/ or send a letter to Creative
% Commons, 543 Howard Street, 5th Floor, San Francisco, California, 94105,
% USA.

% Christopher Bulpitt, Andy Tsai, Melvin Gong, Charlie Cheuk
% University of California, Berkeley
% Engineering 177, Advanced Programming with Matlab
% May 13, 2010

function output = DisplayPlots(Esrc,Edata,map)
sz = get(0,'Screensize');

figure('Position',[sz(3)/2-400 sz(4)/2-300 800 600])
subplot(2,2,1)
p1 = plot(map.out1.Time,map.out1.Speed);  
hold on              
p2 = plot(map.out1.Time,map.out1.Warning_Speedlim,'-.r');
title('Speed vs. Time','FontWeight','Bold')
xlabel('Time [sec]')
ylabel('Speed [units/s]')

subplot(2,2,2)
plot(map.out1.Time(1:end-1),map.out1.Acc);
title('Acceleration vs. Time','FontWeight','Bold')
xlabel('Time [sec]')
ylabel('Acceleration [units/s^2]')

subplot(2,2,3)
plot(map.out1.Time(1:end-1),map.out1.Angle);  
title('Angle vs. Time','FontWeight','Bold')
xlabel('Time [sec]')
ylabel('Angle [deg]') 

subplot(2,2,4)
plot(map.out1.Time(1:end-2),map.out1.Turning_Rate);
title('Turning Rate vs. Time','FontWeight','Bold')
xlabel('Time [sec]')
ylabel('Turning Rate [deg/s]')