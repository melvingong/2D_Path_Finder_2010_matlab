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

function [cObsOverlap,rObsOverlap,O2L,R2L] = overlapObs(O1,R1,O2,R2)
cObsOverlapNew = [];
rObsOverlapNew = [];
O2L = O2; R2L = R2;

O2Temp1 = O2; R2Temp1 = R2;
d = distance2Point(O1(1),O1(2),O2(:,1),O2(:,2));
r = R1+R2;

% detele the same obstacle
idxSame = (d==0);
O2Temp1(idxSame,:) = [];
R2Temp1(idxSame) = [];
O2L(idxSame,:) = [];
R2L(idxSame) = [];
d(idxSame) = [];
r(idxSame) = [];

O2Temp2 = O2Temp1; R2Temp2 = R2Temp1;
% overlap obstacle(s) list
idxOverlap = (r-d)>=0;
O2Temp2(~idxOverlap,:) = [];
R2Temp2(~idxOverlap) = [];

cObsOverlap = vertcat(O2Temp2,cObsOverlapNew);
rObsOverlap = vertcat(R2Temp2,rObsOverlapNew);
end