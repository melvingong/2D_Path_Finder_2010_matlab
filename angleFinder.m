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

function theta = angleFinder(X1,Y1,varargin)
if isequal(nargin,2)
    Xo = 0; Yo = 0;
elseif isequal(nargin,4) %shifting
    Xo = varargin{1};
    Yo = varargin{2};
end
% 1. move the circle to Xo, Yo-coordinate of the obstacle
% 2. determine which coordinate it falls in
% 3. find out the theta of the two points
newX = X1-Xo; newY = Y1-Yo;
theta = zeros(length(newX),1);
for i=1:length(newX)
    if isequal(newX(i),0) && isequal(newY(i),0)
        error('ERROR: angleFinder');
    elseif isequal(newX(i),0)
        if newY(i) > 0
            theta(i) = 90;
        elseif newY(i) < 0
            theta(i) = 270;
        else
            error('ERROR: angleFinder');
        end
    elseif isequal(newY(i),0)
        if newX(i) > 0
            theta(i) = 0;
        elseif newX(i) < 0
            theta(i) = 180;
        else
            error('ERROR: angleFinder');
        end
    else
        thetaTemp = atand(newY(i)/newX(i));
        
        if newX(i) > 0 && newY(i) > 0 %coordinate I
            theta(i) = thetaTemp;
        elseif newX(i) < 0 && newY(i) > 0 %coordinate II
            theta(i) = thetaTemp+180;
        elseif newX(i) < 0 && newY(i) < 0 %coordinate III
            theta(i) = thetaTemp+180;
        elseif newX(i) > 0 && newY(i) < 0 %coordinate IV
            theta(i) = thetaTemp+360;
        else
            error('ERROR: angleFinder');
        end
    end
end
end