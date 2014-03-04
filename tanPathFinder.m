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

function [sPtanPath1,ePtanPath1,cObstacle1,rObstacle1,cPtanPath1,...
    sPtanPath2,ePtanPath2,cObstacle2,rObstacle2,cPtanPath2,...
    rs] = tanPathFinder(sP,eP,obstacle,obstacleRound,tol,...
    obsRange,cObstacleNew,rObstacleNew)
% Input: obsMidFinder(sP,eP,obstacle,obstacleRound,tol,obsRange)
% sP: initial starting point of the object [1-by-2]
% eP: destination of the object going [1-by-2]
% obstacle: position of all obstacles [n-by-2]
% obstacleRound: radius of all obstacles [n-by-1]
% obsRange: tell the radius of the object can see
% tol: accuracy range

% sPtanPath1: first tangent point of the obstacle from start point [1-by-2]
% sPtanPath2: second tangent point of the obstacle from start point [1-by-2]
% ePtanPath1: first tangent point of the obstacle from end point [1-by-2]
% ePtanPath2: second tangent point of the obstacle from end point [1-by-2]
% cObstacle: current obstacle that vehicle is on [1-by-2]
% rObstacle: current obstacle radius [1-by-1]
sPtanPath1 = NaN; sPtanPath2 = NaN; ePtanPath2 = NaN; ePtanPath1 = NaN;
cObstacle1 = NaN; rObstacle1 = NaN; cObstacle2 = NaN; rObstacle2 = NaN;
cPtanPath1 = NaN; cPtanPath2 = NaN;
obstacleAll = obstacle; obstacleRoundAll = obstacleRound;


rs = distance2Point(sP(1),sP(2),eP(1),eP(2));
if rs > tol %procees only if current position and ending position is greater than tol
    % find eqn of the line y = ax + b
    a = (eP(2)-sP(2))./(eP(1)-sP(1)); %find slope
    b = sP(2)-a.*sP(1); %b=y-ax
    
    % 1. find the joint points by y=ax+b and (x-c)^2+(y-d)^2 = r^2
    % 2. find the corresponding y value from touching x points
    % 3. delte the unwanted data point
    x = zeros(size(obstacle,1),2); y = zeros(size(x,1),2);
    idxNonTou = zeros(1,size(obstacle,1)); idxNonTou(1) = NaN;
    for i=1:size(obstacle,1) %ith number of obstacle
        c = obstacle(i,1); d = obstacle(i,2); r = obstacleRound(i);
        az = (a^2+1);
        bz = 2*(a*b-c-a*d);
        cz = (b^2+c^2+d^2-2*b*d-r^2);
        x(i,1) = (-bz + sqrt(bz^2-4*az*cz))/(2*az);
        x(i,2) = (-bz - sqrt(bz^2-4*az*cz))/(2*az);
        if ~isreal(x(i,1)) %non-real solution
            m = find(isnan(idxNonTou));
            idxNonTou(m) = i;
            idxNonTou(m+1) = NaN;
        else
            y(i,1) = a*x(i,1)+b;
            y(i,2) = a*x(i,2)+b;
            r1 = distance2Point(x(i,1),y(i,1),sP(1),sP(2)); %distance from touch pt1 to start
            r2 = distance2Point(x(i,2),y(i,2),sP(1),sP(2)); %distance from touch pt2 to start
            
            if (min(r1,r2) > obsRange) || (max(r1,r2) < tol) %*****
                m = find(isnan(idxNonTou));
                idxNonTou(m) = i;
                idxNonTou(m+1) = NaN;
            end
        end
    end
    
    % delete the extra pre-allocated memory space
    idxNan = find(isnan(idxNonTou));
    idxNan = idxNan - 1;
    idxNonTou = idxNonTou(1:idxNan);
    
    % delete all unwanted data including
    % 1. obstacle(s) that doesn't touch straight path
    % 2. obstacle(s) that are out of seeing range
    % 3. current point is too close to endpoint (>tol)
    obstacle(idxNonTou,:) = [];
    obstacleRound(idxNonTou) = [];
    x(idxNonTou,:) = [];
    y(idxNonTou,:) = [];
    
    % delete all obstacle that is out-of-range (out of path range)
    idxOutRange= (min(x(:,1),x(:,2))<min(sP(1),eP(1)))|(max(x(:,1),x(:,2))>max(sP(1),eP(1)))...
        |(min(y(:,1),y(:,2))<min(sP(2),eP(2)))|(max(y(:,1),y(:,2))>max(sP(2),eP(2)));
    obstacle(idxOutRange,:) = [];
    obstacleRound(idxOutRange) = [];
    x(idxOutRange,:) = [];
    y(idxOutRange,:) = [];
    
    % delete cross points that is on endpoint
    dcrossP2eP = reshape(distance2Point(reshape(x,numel(x),1),reshape(y,numel(y),1),eP(1),eP(2)),(numel(x)/2),2);
    idxCrossPt = logical(sum(dcrossP2eP<tol,2)>=1);
    obstacle(idxCrossPt,:) = [];
    obstacleRound(idxCrossPt) = [];
    x(idxCrossPt,:) = [];
    y(idxCrossPt,:) = [];
    
    % 1. determine if line through 0,1 or 2 point on the circle
    % 2. determind the tangent point(s) of the path
    %    a. point to circle path
    %    b. circle to circle path
    if ~isempty(x) %process only if there is obstacle on path      
        % finding all overlap obstacle
        cObsOverlap = cell(size(obstacle,1),1);
        rObsOverlap = cell(size(obstacle,1),1);
        for m=1:size(obstacle,1)
            cObsOverlap{m} = obstacle(m,:); rObsOverlap{m} = obstacleRound(m);
            [cObsO,rObsO,O2L,R2L] = overlapObs(obstacle(m,:),obstacleRound(m),obstacleAll,obstacleRoundAll);
            cObsOverlap{m} = vertcat(cObsOverlap{m},cObsO);
            rObsOverlap{m} = vertcat(rObsOverlap{m},rObsO);
            n=2; %number of overlap obstacle process
            while ~isempty(cObsO) || n<=size(cObsOverlap{m},1)
                for s=1:size(cObsO,1)
                    idxcObsO = cObsO(s,1)==O2L(:,1)&cObsO(s,2)==O2L(:,2);
                    O2L(idxcObsO,:) = [];
                    R2L(idxcObsO,:) = [];
                end
                [cObsO,rObsO,O2L,R2L] = overlapObs(cObsOverlap{m}(n,:),rObsOverlap{m}(n),O2L,R2L);
                cObsOverlap{m} = vertcat(cObsOverlap{m},cObsO);
                rObsOverlap{m} = vertcat(rObsOverlap{m},rObsO);
                n = n+1;
            end
        end
        
        % delete duplicate series of overlap obstacle
        idxDuplicate = false(size(cObsOverlap,1),1);
        for q=1:(size(cObsOverlap,1)-1)
            if sum((cObsOverlap{q}(1,1)==cObsOverlap{q+1}(:,1))&(cObsOverlap{q}(1,2)==cObsOverlap{q+1}(:,2)))
                idxDuplicate(q+1) = true;
            end
        end
        cObsOverlap(idxDuplicate,:) = [];
        rObsOverlap(idxDuplicate,:) = [];
        
        % delete obstacle that is currently on
        if ~isnan(cObstacleNew)
            for q=1:(size(cObsOverlap,1))
                idxCurrentOn = (cObstacleNew(1)==cObsOverlap{q}(:,1))&(cObstacleNew(2)==cObsOverlap{q}(:,2));
                cObsOverlap{q}(idxCurrentOn,:) = [];
                rObsOverlap{q}(idxCurrentOn) = [];
            end
        end
        
        if isnan(cObstacleNew) %point to circle path
            tPS1 = zeros(size(cObsOverlap,1),2);
            tPE1 = zeros(size(cObsOverlap,1),2);
            cObstacle1 = zeros(size(cObsOverlap,1),2);
            rObstacle1 = zeros(size(cObsOverlap,1),1);
            tPS2 = zeros(size(cObsOverlap,1),2);
            tPE2 = zeros(size(cObsOverlap,1),2);
            cObstacle2 = zeros(size(cObsOverlap,1),2);
            rObstacle2 = zeros(size(cObsOverlap,1),1);
            angleObstacle = zeros(size(cObsOverlap,1),2);
            
            for k=1:size(cObsOverlap,1)
                cObsOverlapOne = cObsOverlap{k};
                rObsOverlapOne = rObsOverlap{k};
                
                % the vehicle can travel two different paths
                [tPS1One tPS2One] = tanLinePt2Cir(sP,cObsOverlapOne,rObsOverlapOne);
                [tPE2One tPE1One] = tanLinePt2Cir(eP,cObsOverlapOne,rObsOverlapOne);
                
                % the vehicle can travel one path
                idxOnePath = x(k,1)==x(k,2);
                tPS1One(idxOnePath,:) = [x(idxOnePath,1) y(idxOnePath,1)];
                tPS2One(idxOnePath,:) = NaN;
                tPE1One(idxOnePath,:) = [x(idxOnePath,1) y(idxOnePath,1)];
                tPE2One(idxOnePath,:) = NaN;
                
                ak = (eP(2)-sP(2))/(eP(1)-sP(1)); %***********************
                ck = eP(2)-ak*eP(1);
                trans_tPS1 = 2.*((ak.*tPS1One(:,1)+ck) < tPS1One(:,2))-1;
                trans_tPS2 = 2.*((ak.*tPS2One(:,1)+ck) < tPS2One(:,2))-1;
                
                % finding the perpendicular distance from point to line (y)
                dk_tPS1 = abs(ak*tPS1One(:,1)-tPS1One(:,2)+ck)/sqrt(ak^2+1);
                dk_tPS2 = abs(ak*tPS2One(:,1)-tPS2One(:,2)+ck)/sqrt(ak^2+1);
                
                % finding distance from sP to all tangent point (r)
                D_tPS1 = distance2Point(sP(1),sP(2),tPS1One(:,1),tPS1One(:,2));
                D_tPS2 = distance2Point(sP(1),sP(2),tPS2One(:,1),tPS2One(:,2));
                
                % finding angle respect to the sP to eP line
                alpha = asind(dk_tPS1./D_tPS1).*trans_tPS1;
                beta = asind(dk_tPS2./D_tPS2).*trans_tPS2;
                omaga = vertcat(alpha,beta);
                idxSlope = (max(omaga)==omaga) + (min(omaga)==omaga);
                idxSlope = logical(reshape(idxSlope,length(alpha),2));
                tPS1One(~idxSlope(:,1),:) = [];
                tPE1One(~idxSlope(:,1),:) = [];
                alpha(~idxSlope(:,1),:) = [];
                tPS2One(~idxSlope(:,2),:) = [];
                tPE2One(~idxSlope(:,2),:) = [];
                beta(~idxSlope(:,2),:) = [];
                
                cObsOverlapOneTemp1 = cObsOverlapOne;
                cObsOverlapOneTemp2 = cObsOverlapOne;
                cObsOverlapOneTemp1(~idxSlope(:,1),:) = [];
                cObsOverlapOneTemp2(~idxSlope(:,2),:) = [];
                
                rObsOverlapOneTemp1 = rObsOverlapOne;
                rObsOverlapOneTemp2 = rObsOverlapOne;
                rObsOverlapOneTemp1(~idxSlope(:,1),:) = [];
                rObsOverlapOneTemp2(~idxSlope(:,2),:) = [];
                
                tPS1(k,:) = tPS1One;
                tPE1(k,:) = tPE1One;
                cObstacle1(k,:) = cObsOverlapOneTemp1;
                rObstacle1(k,:) = rObsOverlapOneTemp1;
                
                if ~isempty(tPS2One)
                    tPS2(k,:) = tPS2One;
                    tPE2(k,:) = tPE2One;
                    cObstacle2(k,:) = cObsOverlapOneTemp2;
                    rObstacle2(k,:) = rObsOverlapOneTemp2;
                else
                    tPS2(k,:) = NaN;
                    tPE2(k,:) = NaN;
                    cObstacle2(k,:) = NaN;
                    rObstacle2(k,:) = NaN;
                end
                
                angleObstacle(k,:) = horzcat(alpha,beta);
            end
            
            angleObstacleTemp = angleObstacle(1,:); idxangleObstacle = 1;
            for s=2:size(angleObstacle,1)
                if (max(angleObstacleTemp) < max(angleObstacle(s,:)))&&...
                    (min(angleObstacleTemp) > min(angleObstacle(s,:)))
                    angleObstacleTemp = angleObstacle(s,:);
                    idxangleObstacle = s;
                end
            end
        else %circle to circle path
            cPNew1 = zeros(size(cObsOverlap,1),2);
            tPS1 = zeros(size(cObsOverlap,1),2);
            tPE1 = zeros(size(cObsOverlap,1),2);
            cObstacle1 = zeros(size(cObsOverlap,1),2);
            rObstacle1 = zeros(size(cObsOverlap,1),1);
            cPNew2 = zeros(size(cObsOverlap,1),2);
            tPS2 = zeros(size(cObsOverlap,1),2);
            tPE2 = zeros(size(cObsOverlap,1),2);
            cObstacle2 = zeros(size(cObsOverlap,1),2);
            rObstacle2 = zeros(size(cObsOverlap,1),1);
            angleObstacle = zeros(size(cObsOverlap,1),2);
            
            for k=1:size(cObsOverlap,1)
                cObsOverlapOne = cObsOverlap{k};
                rObsOverlapOne = rObsOverlap{k};
                
                [cPNew1One cPNew2One tPS1One tPS2One] = tanLineCir2Cir(cObstacleNew,rObstacleNew,cObsOverlapOne,rObsOverlapOne,sP);
                [tPETemp1 tPETemp2] = tanLinePt2Cir(eP,cObsOverlapOne,rObsOverlapOne);
                
                tPE1One = zeros(size(tPETemp1,1),2); tPE2One = zeros(size(tPETemp1,1),2);
                dtPS12tPETemp1 = distance2Point(tPS1One(:,1),tPS1One(:,2),tPETemp1(:,1),tPETemp1(:,2));
                dtPS12tPETemp2 = distance2Point(tPS1One(:,1),tPS1One(:,2),tPETemp2(:,1),tPETemp2(:,2));
                dtPS22tPETemp1 = distance2Point(tPS2One(:,1),tPS2One(:,2),tPETemp1(:,1),tPETemp1(:,2));
                dtPS22tPETemp2 = distance2Point(tPS2One(:,1),tPS2One(:,2),tPETemp2(:,1),tPETemp2(:,2));
                dAlltPStPE = horzcat(dtPS12tPETemp1,dtPS12tPETemp2,dtPS22tPETemp1,dtPS22tPETemp2);
                minTanD = min(dAlltPStPE,[],2);
                for j=1:size(minTanD,1)
                    idxminTanD = find(dAlltPStPE(j,:)==minTanD(j));
                    switch idxminTanD
                        case 1
                            tPE1One(j,:) = tPETemp1(j,:);
                            tPE2One(j,:) = tPETemp2(j,:);
                        case 2
                            tPE1One(j,:) = tPETemp2(j,:);
                            tPE2One(j,:) = tPETemp1(j,:);
                        case 3
                            tPE1One(j,:) = tPETemp2(j,:);
                            tPE2One(j,:) = tPETemp1(j,:);
                        case 4
                            tPE1One(j,:) = tPETemp1(j,:);
                            tPE2One(j,:) = tPETemp2(j,:);
                        otherwise
                            error('tanPathFinder: endpoint error');
                    end
                end
                
                % overlap obstacles
                ak = (eP(2)-sP(2))/(eP(1)-sP(1));
                ck = eP(2)-ak*eP(1);
                trans_tPS1 = 2.*((ak.*tPS1One(:,1)+ck) < tPS1One(:,2))-1;
                trans_tPS2 = 2.*((ak.*tPS2One(:,1)+ck) < tPS2One(:,2))-1;
                
                % finding the perpendicular distance from point to line (y)
                dk_tPS1 = abs(ak*tPS1One(:,1)-tPS1One(:,2)+ck)/sqrt(ak^2+1);
                dk_tPS2 = abs(ak*tPS2One(:,1)-tPS2One(:,2)+ck)/sqrt(ak^2+1);
                
                % finding distance from sP to all tangent point (r)
                D_tPS1 = distance2Point(sP(1),sP(2),tPS1One(:,1),tPS1One(:,2));
                D_tPS2 = distance2Point(sP(1),sP(2),tPS2One(:,1),tPS2One(:,2));
                
                % finding angle respect to the sP to eP line
                alpha = asind(dk_tPS1./D_tPS1).*trans_tPS1;
                beta = asind(dk_tPS2./D_tPS2).*trans_tPS2;
                omaga = vertcat(alpha,beta);
                idxSlope = (max(max(omaga))==omaga) + (min(min(omaga))==omaga);
                idxSlope = logical(reshape(idxSlope,length(alpha),2));
                cPNew1One(~idxSlope(:,1),:) = [];
                tPS1One(~idxSlope(:,1),:) = [];
                tPE1One(~idxSlope(:,1),:) = [];
                alpha(~idxSlope(:,1),:) = [];
                cPNew2One(~idxSlope(:,2),:) = [];
                tPS2One(~idxSlope(:,2),:) = [];
                tPE2One(~idxSlope(:,2),:) = [];
                beta(~idxSlope(:,2),:) = [];
                
                cObsOverlapOneTemp1 = cObsOverlapOne;
                cObsOverlapOneTemp2 = cObsOverlapOne;
                cObsOverlapOneTemp1(~idxSlope(:,1),:) = [];
                cObsOverlapOneTemp2(~idxSlope(:,2),:) = [];
                
                rObsOverlapOneTemp1 = rObsOverlapOne;
                rObsOverlapOneTemp2 = rObsOverlapOne;
                rObsOverlapOneTemp1(~idxSlope(:,1),:) = [];
                rObsOverlapOneTemp2(~idxSlope(:,2),:) = [];
                
                tPS1(k,:) = tPS1One;
                tPE1(k,:) = tPE1One;
                cPNew1(k,:) = cPNew1One;
                cObstacle1(k,:) = cObsOverlapOneTemp1;
                rObstacle1(k) = rObsOverlapOneTemp1;
                
                if ~isempty(tPS2One)
                    tPS2(k,:) = tPS2One;
                    tPE2(k,:) = tPE2One;
                    cPNew2(k,:) = cPNew2One;
                    cObstacle2(k,:) = cObsOverlapOneTemp2;
                    rObstacle2(k) = rObsOverlapOneTemp2;
                else
                    tPS2(k,:) = NaN;
                    tPE2(k,:) = NaN;
                    cPNew2(k,:) = NaN;
                    cObstacle2(k,:) = NaN;
                    rObstacle2(k) = NaN;
                end
                angleObstacle(k,:) = horzcat(alpha,beta);
            end
            
            angleObstacleTemp = angleObstacle(1,:); idxangleObstacle = 1;
            for s=2:size(angleObstacle,1)
                if (max(angleObstacleTemp) < max(angleObstacle(s,:)))&&...
                    (min(angleObstacleTemp) > min(angleObstacle(s,:)))
                    angleObstacleTemp = angleObstacle(s,:);
                    idxangleObstacle = s;
                end
            end
            
            cPtanPath1 = cPNew1(idxangleObstacle,:);
            cPtanPath2 = cPNew2(idxangleObstacle,:);
        end
        
        if ~isempty(tPS1) && ~isempty(tPS2)
            % two points that touch the path line
            sPtanPath1 = tPS1(idxangleObstacle,:);
            ePtanPath1 = tPE1(idxangleObstacle,:);
            cObstacle1 = cObstacle1(idxangleObstacle,:);
            rObstacle1 = rObstacle1(idxangleObstacle,:);
            
            sPtanPath2 = tPS2(idxangleObstacle,:);
            ePtanPath2 = tPE2(idxangleObstacle,:);
            cObstacle2 = cObstacle2(idxangleObstacle,:);
            rObstacle2 = rObstacle2(idxangleObstacle,:);
        end     
    elseif ~isnan(cObstacleNew)
        cObstacle1 = cObstacleNew;
        rObstacle1 = rObstacleNew;
        cObstacle2 = cObstacleNew;
        rObstacle2 = rObstacleNew;
    end
end
end