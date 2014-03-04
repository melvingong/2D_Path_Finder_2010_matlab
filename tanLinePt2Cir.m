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

function [tPS1 tPS2] = tanLinePt2Cir(P,O,r)
d = distance2Point(P(1),P(2),O(:,1),O(:,2));
R = sqrt(d.^2-r.^2);
theta = angleFinder(P(1),P(2),O(:,1),O(:,2));
gamma = 90-acosd(R./d);

phi1 = theta+gamma;
phi2 = theta-gamma;
tPS1 = [r.*cosd(phi1)+O(:,1) r.*sind(phi1)+O(:,2)];
tPS2 = [r.*cosd(phi2)+O(:,1) r.*sind(phi2)+O(:,2)];
end