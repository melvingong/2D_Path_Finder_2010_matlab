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

function [tPSout tPSin tPEout tPEin] = tanLineCir2Cir(O1,R1,O2,R2,cP)
if isequal(size(O1,1),1)
    O1 = [O1(1) 0;0 O1(2)];
    O1 = ones(size(O2,1),2)*O1;
end
d = distance2Point(O1(:,1),O1(:,2),O2(:,1),O2(:,2));
theta1 = angleFinder(O1(:,1),O1(:,2),O2(:,1),O2(:,2));
theta2 = theta1-180;

% outer tangent line angle
alpha = asind(abs(R2-R1)./d);
if R1 <= R2
    phi1 = theta1+90-alpha; %tPE2
    phi2 = theta1-90+alpha; %tPE1
    phi3 = theta2+90+alpha; %tPS1
    phi4 = theta2-90-alpha; %tPS2
else
    phi1 = theta1+90+alpha; %tPE2
    phi2 = theta1-90-alpha; %tPE1
    phi3 = theta2+90-alpha; %tPS1
    phi4 = theta2-90+alpha; %tPS2
end

% inner tangent line angle
gamma = acosd((R2+R1)./d);
for i=1:length(gamma)
    if ~isreal(gamma(i))
        gamma(i) = NaN;
    end
end
omega1 = theta1+gamma;
omega2 = theta1-gamma;
omega3 = theta2+gamma;
omega4 = theta2-gamma;

tPS1 = [R1.*cosd(phi3)+O1(:,1) R1.*sind(phi3)+O1(:,2)];
tPS2 = [R1.*cosd(phi4)+O1(:,1) R1.*sind(phi4)+O1(:,2)];
tPS3 = [R1.*cosd(omega3)+O1(:,1) R1.*sind(omega3)+O1(:,2)];
tPS4 = [R1.*cosd(omega4)+O1(:,1) R1.*sind(omega4)+O1(:,2)];

tPE1 = [R2.*cosd(phi2)+O2(:,1) R2.*sind(phi2)+O2(:,2)];
tPE2 = [R2.*cosd(phi1)+O2(:,1) R2.*sind(phi1)+O2(:,2)];
tPE3 = [R2.*cosd(omega1)+O2(:,1) R2.*sind(omega1)+O2(:,2)];
tPE4 = [R2.*cosd(omega2)+O2(:,1) R2.*sind(omega2)+O2(:,2)];

% find out which side the current vehicle is on
angcP = angleFinder(cP(1),cP(2),O1(:,1),O1(:,2));
angtPS1 = angleFinder(tPS1(:,1),tPS1(:,2),O1(:,1),O1(:,2));
angtPS2 = angleFinder(tPS2(:,1),tPS2(:,2),O1(:,1),O1(:,2));
idxtPDelete1 = abs(angtPS1-angcP) > abs(angtPS2-angcP);
idxtPDelete2 = ~idxtPDelete1;
tPS1 = tPS1.*horzcat(idxtPDelete2,idxtPDelete2);
tPS2 = tPS2.*horzcat(idxtPDelete1,idxtPDelete1);
tPS3 = tPS3.*horzcat(idxtPDelete2,idxtPDelete2);
tPS4 = tPS4.*horzcat(idxtPDelete1,idxtPDelete1);
tPSout = tPS1+tPS2;
tPSin = tPS3+tPS4;

tPE1 = tPE1.*horzcat(idxtPDelete2,idxtPDelete2);
tPE2 = tPE2.*horzcat(idxtPDelete1,idxtPDelete1);
tPE3 = tPE3.*horzcat(idxtPDelete2,idxtPDelete2);
tPE4 = tPE4.*horzcat(idxtPDelete1,idxtPDelete1);
tPEout = tPE1+tPE2;
tPEin = tPE3+tPE4;
end