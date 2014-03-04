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

function [output,idxWayPoint] = mainProgram(sP,waypoint,eP,obstacle,obstacleRound,varargin)
dcP2eP1 = distance2Point(sP(1),sP(2),eP(1),eP(2)); %distance b/w start and end point
tol = 1;
obsRange = dcP2eP1;
MaxPointLimit = [];
if isequal(nargin,5)
elseif isequal(nargin,6)
    tol = varargin{1};
elseif isequal(nargin,7)
    tol = varargin{1};
    obsRange = max(min(varargin{2},dcP2eP1),tol);
elseif isequal(nargin,8)
    tol = varargin{1};
    obsRange = max(min(varargin{2},dcP2eP1),tol);
    MaxPointLimit = varargin{3};
else
    error('Incorrect number of input!');
end
obsRange = obsRange-1;

% sorting obstacle(s) in order to process
if ~isempty(obstacle)
    dsPObs = distance2Point(sP(1),sP(2),obstacle(:,1),obstacle(:,2));
    dsPObs = dsPObs - obstacleRound;
    [~,IX] = sort(dsPObs);
    obstacle = obstacle(IX,:);
    obstacleRound = obstacleRound(IX,:);
end

% waypoint process
waypointTemp = vertcat(waypoint,eP);
if isequal(obsRange,Inf)
    obsRange = distance2Point(sP(1),sP(2),eP(1),eP(2));
end

output = zeros(10000,2);
output(1,:) = NaN;
idxWayPoint = zeros(size(waypointTemp,1),1);
for i=1:size(waypointTemp,1)
    if isequal(sP(1),waypointTemp(i,1))
        [outputData,outputeP,thetaeP] = transPeP(sP,waypointTemp(i,:),obstacle,[]);
        outputTempTemp = pathBot(sP,outputeP,outputData,obstacleRound,tol,obsRange);
        outputTemp = transPeP(sP,outputTempTemp(end,:),outputTempTemp(2:end-1,:),thetaeP);
        sP = outputTemp(end,:);
    else
        outputTemp = pathBot(sP,waypointTemp(i,:),obstacle,obstacleRound,tol,obsRange);
        sP = outputTemp(end,:);
    end
    
    idxEnd = find(isnan(output(:,1)),true);
    szAddOut = size(outputTemp,1);
    if (idxEnd+szAddOut) >= size(output,1)
        outputAllocate = zeros(2*(size(output,1)),2);
        outputAllocate((1:size(output,1)),:) = output;
        output = outputAllocate;
    end
    output(idxEnd:(idxEnd+szAddOut-1),:) = outputTemp;
    output((idxEnd+szAddOut),:) = NaN;
    idxWayPoint(i) = (idxEnd+szAddOut-1);
end
idxEnd = find(isnan(output(:,1)),true);
output((idxEnd:end),:) = [];
idxWayPoint = vertcat(1,idxWayPoint);

% delete the duplicate points
outputTemp1 = output(2:end,:);
outputTemp2 = output(1:end-1,:);
idxDuplicate = sum(outputTemp1==outputTemp2,2)==2;
outputTemp1(idxDuplicate,:) = [];
output = vertcat(output(1,:),outputTemp1);

% points limitation
if isempty(MaxPointLimit)
    MaxPointLimit = round(size(output,1)/2);
end
idxNoDelete = size(idxWayPoint,1);
stepLimit = round((size(output,1)-idxNoDelete)/(MaxPointLimit-idxNoDelete));
idxStepLimit = true(size(output,1),1);
countStepLimit = 1;
for d=1:size(output,1)
    if logical(sum(d==idxWayPoint))
        idxStepLimit(d) = false;
    else
        if isequal(rem(countStepLimit,stepLimit),0)
            idxStepLimit(d) = false;
        end
        countStepLimit = countStepLimit+1;
    end
end
idxWayPointAA = zeros(size(output,1),1);
idxWayPointAA(idxWayPoint) = 1;

idxWayPointAA(idxStepLimit,:) = [];
idxWayPoint = find(idxWayPointAA==1);
output(idxStepLimit,:) = [];
end