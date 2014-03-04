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

function pathArray = pathBot(sP,eP,obstacle,obstacleRound,varargin)
% sP: starting position [1-by-2]
% eP: endding position [1-by-2]
% mP: middle point on the path line
% obsRange: bot's obersering range
% cP: current position [1-by-2]
% pathArray: gives the path of the bot goes [m-by-2]

cP = sP; %initial current position
dcP2eP1 = distance2Point(cP(1),cP(2),eP(1),eP(2)); %distance b/w start and end point
if isequal(nargin,4)
    tol = 1;
    obsRange = dcP2eP1;
elseif isequal(nargin,5)
    tol = varargin{1};
    obsRange = dcP2eP1;
elseif isequal(nargin,6)
    tol = varargin{1};
    obsRange = max(min(varargin{2},dcP2eP1),tol);
else
    error('Incorrect number of input!');
end
counter = 0;
cObstacle = NaN; rObstacle = NaN;

if isequal(sP,eP) %pathArray is empty when start and end point are same
    pathArray = [];
else
    pathArray = cP;
    while ~isequal(counter,9000)
        cObstaclePrevious = cObstacle; rObstaclePrevious = rObstacle;
        [tPS1,tPE1,cObstacle1,rObstacle1,cPNew1,tPS2,tPE2,cObstacle2,rObstacle2,cPNew2,dcP2eP1]...
            = tanPathFinder(cP,eP,obstacle,obstacleRound,tol,obsRange,cObstacle,rObstacle);
        
        if dcP2eP1 < tol
            pathArray = vertcat(pathArray,eP);
            break;
        end
        
        if isnan(tPS1) %no intersaction within the detecting range
            % Since no obstacle detected, we move the current point one step
            % ahead toward the final endpoint
            if isnan(cObstacle1)
                tempP = eP - cP;
                if ~isequal(tempP(1),0) %correction for zero denominator
                    tempTheta = atand(tempP(2)/tempP(1));
                    if eP(1) < cP(1)
                        tempTheta = tempTheta+180;
                    end
                else
                    tempTheta = 90;
                    if eP(2) < cP(2)
                        tempTheta = 270;
                    end
                end
                tempP(1) = tol*cosd(tempTheta);
                tempP(2) = tol*sind(tempTheta);
                tempP(1) = tempP(1)+cP(1);
                tempP(2) = tempP(2)+cP(2);
                pathArray = vertcat(pathArray,tempP);
                cP = tempP;
                cObstacle = NaN;
                rObstacle = NaN;
            else
                arcPath = LOCALarcPath(cObstacle1,rObstacle1,pathArray(end,:),cP,tol);
                pathArray = vertcat(pathArray,arcPath);
                dArc2End = distance2Point(pathArray(end,1),pathArray(end,2),cP(1),cP(2));
                if dArc2End <= tol
                    pathArray = vertcat(pathArray,cP);
                    cObstacle = NaN;
                    rObstacle = NaN;
                end
            end
        elseif isnan(tPS2) %one intersaction b/w path line and obstacle
            % Since only one point touches, the bot MUST pass through this
            % point
            if isnan(cPNew1)
                cPNew1 = [];
            else
                cP = cPNew1;
            end
            
            boolTouch = LOCALRecursivePath(cP,tPS1,obstacle,obstacleRound,cObstacle1);
            if boolTouch
                pathArrayTemp = pathBot(cP,tPS1,obstacle,obstacleRound,tol); %,obsRange);
                arcPath = LOCALarcPath(cObstaclePrevious,rObstaclePrevious,pathArray(end,:),cPNew1);
                %pathArray = vertcat(pathArray,pathArrayTemp,arcPath,cPNew1,tPS1);
                pathArray = vertcat(pathArray,arcPath,cPNew1,pathArrayTemp,tPS1);
                cP = tPE1;
                cObstacle = cObstacle1;
                rObstacle = rObstacle1;
            else
                arcPath = LOCALarcPath(cObstaclePrevious,rObstaclePrevious,pathArray(end,:),cPNew1);
                pathArray = vertcat(pathArray,arcPath,cPNew1,tPS1);
                cP = tPE1;
                cObstacle = cObstacle1;
                rObstacle = rObstacle1;
            end
        else %two intersactions b/w path line and obstacle
            % total path length for first choice
            if isnan(cPNew1)
                cPNew1Temp = cP; cPNew2Temp = cP;
                cPNew1 = []; cPNew2 = [];
                cP2tPS1 = distance2Point(tPS1(1),tPS1(2),cP(1),cP(2)); %distance from cP to 1st tan point
                eP2tPE1 = distance2Point(tPE1(1),tPE1(2),eP(1),eP(2)); %distance from eP to 2nd tan point
                tPS12tPE1Temp = distance2Point(tPS1(1),tPS1(2),tPE1(1),tPE1(2));
                tPS12tPE1 = 2*rObstacle1*asin(tPS12tPE1Temp/(2*rObstacle1)); %arc length of first path
                DA = cP2tPS1+tPS12tPE1+eP2tPE1;
                
                %total path length for second choice
                cP2tPS2 = distance2Point(tPS2(1),tPS2(2),cP(1),cP(2));
                eP2tPE2 = distance2Point(tPE2(1),tPE2(2),eP(1),eP(2));
                tPS22tPE2Temp = distance2Point(tPS2(1),tPS2(2),tPE2(1),tPE2(2));
                tPS22tPE2 = 2*rObstacle2*asin(tPS22tPE2Temp/(2*rObstacle2));
                DB = cP2tPS2+tPS22tPE2+eP2tPE2;
            else
                cPNew1Temp = cPNew1; cPNew2Temp = cPNew2;
                DAplus = distance2Point(cPNew1(1),cPNew1(2),pathArray(end,1),pathArray(end,2));
                DBplus = distance2Point(cPNew2(1),cPNew2(2),pathArray(end,1),pathArray(end,2));
                
                cP2tPS1 = distance2Point(tPS1(1),tPS1(2),cPNew1(1),cPNew1(2)); %distance from cP to 1st tan point
                eP2tPE1 = distance2Point(tPE1(1),tPE1(2),eP(1),eP(2)); %distance from eP to 2nd tan point
                tPS12tPE1Temp = distance2Point(tPS1(1),tPS1(2),tPE1(1),tPE1(2));
                tPS12tPE1 = 2*rObstacle1*asin(tPS12tPE1Temp/(2*rObstacle1)); %arc length of first path
                DA = DAplus+cP2tPS1+tPS12tPE1+eP2tPE1;
                
                %total path length for second choice
                cP2tPS2 = distance2Point(tPS2(1),tPS2(2),cPNew2(1),cPNew2(2));
                eP2tPE2 = distance2Point(tPE2(1),tPE2(2),eP(1),eP(2));
                tPS22tPE2Temp = distance2Point(tPS2(1),tPS2(2),tPE2(1),tPE2(2));
                tPS22tPE2 = 2*rObstacle2*asin(tPS22tPE2Temp/(2*rObstacle2));
                DB = DBplus+cP2tPS2+tPS22tPE2+eP2tPE2;
            end
            
            if DA < DB %path DA < DB, choose path DA
                cP = cPNew1Temp;
                boolTouch = LOCALRecursivePath(cP,tPS1,obstacle,obstacleRound,cObstacle1);
                if boolTouch
                    pathArrayTemp = pathBot(cP,tPS1,obstacle,obstacleRound,tol); %,obsRange);
                    arcPath = LOCALarcPath(cObstaclePrevious,rObstaclePrevious,pathArray(end,:),cPNew1);
                    %pathArray = vertcat(pathArray,pathArrayTemp,arcPath,cPNew1,tPS1);
                    pathArray = vertcat(pathArray,arcPath,cPNew1,pathArrayTemp,tPS1);
                    cP = tPE1;
                    cObstacle = cObstacle1;
                    rObstacle = rObstacle1;
                else
                    arcPath = LOCALarcPath(cObstaclePrevious,rObstaclePrevious,pathArray(end,:),cPNew1);
                    pathArray = vertcat(pathArray,arcPath,cPNew1,tPS1);
                    cP = tPE1;
                    cObstacle = cObstacle1;
                    rObstacle = rObstacle1;
                end
            elseif DA > DB %path DA > DB, choose path DB
                cP = cPNew2Temp;
                boolTouch = LOCALRecursivePath(cP,tPS2,obstacle,obstacleRound,cObstacle2);
                if boolTouch
                    pathArrayTemp = pathBot(cP,tPS2,obstacle,obstacleRound,tol); %,obsRange);
                    arcPath = LOCALarcPath(cObstaclePrevious,rObstaclePrevious,pathArray(end,:),cPNew2);
                    %pathArray = vertcat(pathArray,pathArrayTemp,arcPath,cPNew2,tPS2);
                    pathArray = vertcat(pathArray,arcPath,cPNew2,pathArrayTemp,tPS2);
                    cP = tPE2;
                    cObstacle = cObstacle2;
                    rObstacle = rObstacle2;
                else
                    arcPath = LOCALarcPath(cObstaclePrevious,rObstaclePrevious,pathArray(end,:),cPNew2);
                    pathArray = vertcat(pathArray,arcPath,cPNew2,tPS2);
                    cP = tPE2;
                    cObstacle = cObstacle2;
                    rObstacle = rObstacle2;
                end
            else %path DA == DB
                % determine which midpoint is more closer to the initial
                % starting point because we want to minimize the path bot
                % travel
                sP2tPS1 = distance2Point(sP(1),sP(2),tPS1(1),tPS1(2));
                sP2tPS2 = distance2Point(sP(1),sP(2),tPS2(1),tPS2(2));
                
                % all conditions are same. randomly choose b/w two path
                if isequal(sP2tPS1,sP2tPS2)
                    sP2tPS1 = 2*(rand(1)>0.5)*sP2tPS1;
                end
                
                % consider the distance b/w start point and midpoint and which
                % one will give us smaller area under the curve
                if sP2tPS1 > sP2tPS2
                    cP = cPNew2Temp;
                    boolTouch = LOCALRecursivePath(cP,tPS2,obstacle,obstacleRound,cObstacle2);
                    if boolTouch
                        pathArrayTemp = pathBot(cP,tPS2,obstacle,obstacleRound,tol); %,obsRange);
                        arcPath = LOCALarcPath(cObstaclePrevious,rObstaclePrevious,pathArray(end,:),cPNew2);
                        %pathArray = vertcat(pathArray,pathArrayTemp,arcPath,cPNew2,tPS2);
                        pathArray = vertcat(pathArray,arcPath,cPNew2,pathArrayTemp,tPS2);
                        cP = tPE2;
                        cObstacle = cObstacle2;
                        rObstacle = rObstacle2;
                    else
                        arcPath = LOCALarcPath(cObstaclePrevious,rObstaclePrevious,pathArray(end,:),cPNew2);
                        pathArray = vertcat(pathArray,arcPath,cPNew2,tPS2);
                        cP = tPE2;
                        cObstacle = cObstacle2;
                        rObstacle = rObstacle2;
                    end
                elseif sP2tPS1 < sP2tPS2
                    cP = cPNew1Temp;
                    boolTouch = LOCALRecursivePath(cP,tPS1,obstacle,obstacleRound,cObstacle1);
                    if boolTouch
                        pathArrayTemp = pathBot(cP,tPS1,obstacle,obstacleRound,tol); %,obsRange);
                        arcPath = LOCALarcPath(cObstaclePrevious,rObstaclePrevious,pathArray(end,:),cPNew1);
                        %pathArray = vertcat(pathArray,pathArrayTemp,arcPath,cPNew1,tPS1);
                        pathArray = vertcat(pathArray,arcPath,cPNew1,pathArrayTemp,tPS1);
                        cP = tPE1;
                        cObstacle = cObstacle1;
                        rObstacle = rObstacle1;
                    else
                        arcPath = LOCALarcPath(cObstaclePrevious,rObstaclePrevious,pathArray(end,:),cPNew1);
                        pathArray = vertcat(pathArray,arcPath,cPNew1,tPS1);
                        cP = tPE1;
                        cObstacle = cObstacle1;
                        rObstacle = rObstacle1;
                    end
                end
            end
        end
        counter = counter +1;
    end
end
if ~isempty(pathArray)
    % delete the duplicate points
    pathArrayTemp1 = pathArray(2:end,:);
    pathArrayTemp2 = pathArray(1:end-1,:);
    idxDuplicate = sum(pathArrayTemp1==pathArrayTemp2,2)==2;
    pathArrayTemp1(idxDuplicate,:) = [];
    pathArray = vertcat(pathArray(1,:),pathArrayTemp1);
    
    % adjust maximum step-size to be size of tol
    k=1; szOutput = size(pathArray,1);
    while k < szOutput
        dk = distance2Point(pathArray((1:end-1),1),pathArray((1:end-1),2),pathArray((2:end),1),pathArray((2:end),2));
        if dk(k) > tol
            numADD = round(dk(k)./tol)+1;
            xk = linspace(pathArray(k,1),pathArray(k+1,1),numADD);
            yk = linspace(pathArray(k,2),pathArray(k+1,2),numADD);
            pathArray = vertcat(pathArray((1:k),:),transpose(vertcat(xk(2:end-1),...
                yk(2:end-1))),pathArray((k+1:end),:));
        end
        k = k+1; szOutput = size(pathArray,1);
    end
    
    if ~isequal((eP(1)-sP(1)),0) %correction for zero denominator
        pathArrayYY = smooth(pathArray(:,1),pathArray(:,2),0.05);
        pathArray = [pathArray(:,1),pathArrayYY];
    else
        pathArrayXX = smooth(pathArray(:,2),pathArray(:,1),0.05);
        pathArray = [pathArrayXX,pathArray(:,2)];
    end
    
    % delete the duplicate points
    pathArrayTemp1 = pathArray(2:end,:);
    pathArrayTemp2 = pathArray(1:end-1,:);
    idxDuplicate = sum(pathArrayTemp1==pathArrayTemp2,2)==2;
    pathArrayTemp1(idxDuplicate,:) = [];
    pathArray = vertcat(pathArray(1,:),pathArrayTemp1);
end
end

function boolTouch = LOCALRecursivePath(sP,eP,obstacle,obstacleRound,cObstacle)
boolTouch = false;
if ~isnan(cObstacle)
    cObstacleTemp = [cObstacle(1) 0;0 cObstacle(2)];
    cObstacle = ones(size(obstacle,1),2)*cObstacleTemp;
    % find eqn of the line y = ax + b
    a = (eP(2)-sP(2))./(eP(1)-sP(1)); %find slope
    b = sP(2)-a.*sP(1); %b=y-ax
    
    % determine if there are obstacle on the path line
    x = zeros(size(obstacle,1),2);
    for i=1:size(obstacle,1) %ith number of obstacle
        c = obstacle(i,1); d = obstacle(i,2); r = obstacleRound(i);
        az = (a^2+1);
        bz = 2*(a*b-c-a*d);
        cz = (b^2+c^2+d^2-2*b*d-r^2);
        x(i,1) = (-bz + sqrt(bz^2-4*az*cz))/(2*az);
        x(i,2) = (-bz - sqrt(bz^2-4*az*cz))/(2*az);
    end
    % delete obstacle that is current on
    idxCurrentOn = sum(cObstacle==obstacle,2)==2;
    x(idxCurrentOn,:) = [];
    
    % delete obstacle(s) that are NOT on the path
    idxImage = zeros(1,size(x,1));
    for j=1:size(x,1)
        idxImage(j) = ~isreal(x(j,1));
    end
    x(logical(idxImage),:) = [];
    
    % delete obstacle that is out-of-range
    x = sort(reshape(x,[1 numel(x)]));
    idxOutRange = (x-0.1 < min(sP(1),eP(1)) | x+0.1 > max(sP(1),eP(1)));
    x(idxOutRange) = [];
    
    if ~isempty(x)
        boolTouch = true;
    end
end
end

function arcPath = LOCALarcPath(cObstacle,rObstacle,P1,P2,varargin)
if isnan(cObstacle)
    arcPath = [];
else
    thetaP1 = angleFinder(P1(1),P1(2),cObstacle(1),cObstacle(2));
    thetaP2 = angleFinder(P2(1),P2(2),cObstacle(1),cObstacle(2));
    
    if thetaP2-thetaP1 < -180
        thetaP2 = thetaP2+360;
    elseif thetaP2-thetaP1 > 180
        thetaP2 = thetaP2-360;
    end
    
    if isequal(nargin,5)
        tol = varargin{1};
        thetaOneStep = (180.*tol)./(pi.*rObstacle);
        if thetaP1 < thetaP2
            thetaP2 = thetaP1+thetaOneStep;
        else
            thetaP2 = thetaP1-thetaOneStep;
        end
    end
    
    numDataPoint = round(abs(thetaP2-thetaP1));
    theta = linspace(thetaP1,thetaP2,numDataPoint);
    x = transpose(rObstacle.*cosd(theta)+cObstacle(1));
    y = transpose(rObstacle.*sind(theta)+cObstacle(2));
    
    arcPath = horzcat(x,y);
end
end