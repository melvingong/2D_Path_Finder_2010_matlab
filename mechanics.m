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

classdef mechanics
    properties
        Path
        DeltaT
        DeltaDist
        Time
        Speed
        Warning_Speedlim
        Acc
        Angle
        AbsAngle
        Turning_Rate
        Distance_Traveled
        ni
        vi
        R
    end

    methods 
        function output = mechanics(x, y, v_max, a_acc, a_dec, u, max_turnrate, ni, vi,map)
            format long
            n = length(x);
            if ni(end)>n
                e1 = find(map.EndPosition(1,1)==map.Path(:,1));
                e2 = find(map.EndPosition(1,2)==map.Path(:,2));
                if length(e1)==1
                    endidx = e1;
                elseif length(e2)==1
                    endidx = e2(end);
                else 
                    n=n+1;
                    x(n,1) = map.EndPosition(1,1);
                    y(n,1) = map.EndPosition(1,2);
                    map.Path = [map.Path;map.EndPosition];
                    endidx =n;
                end
                if length(ni)>2 % waypoints exist
                    wi1 = zeros(length(ni)-2,1);
                    for i = length(ni)-2:-1:1
                        w1 = find(map.WayPoint(i,1)==map.Path(:,1));
                        w2 = find(map.WayPoint(i,2)==map.Path(:,2));
                        if length(w1)==1
                            wi1(i,1) = w1;
                        elseif length(w2)==1
                            wi1(i,1) = w2;
                        else
                            wi1(i,1) = ni(i+1);
                        end
                    end
                end
                ni = [1;wi1;endidx];
            end
            dist = zeros(n-1,1);
            dist_traveled = zeros(n,1);
            a = zeros(n-2,1);
            angle_rate = zeros(n-2,1);
            t = zeros(n,1); % time elapsed
            dt = zeros(n-1,1); % delta time
            angle = zeros(n-1,1); % turning angle
            absangle = zeros(n-1,1); % absolute value of turning angle
            maxv = zeros(n,1); % start, waypoint, and end point (at ni'th) have velocity of vi.
            warning_maxv = zeros(n,1); % warning maximum velocity (given only deceleration and curvature limits).
            r = inf(n-1,1); % radius of curvature
            wi = ni(2:end-1);
            
            for i = 1:length(ni)
                    maxv(ni(i)) = vi(i);
            end

            for i = 1:n-1
                % distance of each increment
                dist(i) = sqrt((y(i+1)-y(i))^2 + (x(i+1)-x(i))^2);

                % distance traveled along the path
                dist_traveled(i+1) = sum(dist(1:i));

                % angle between the horizon and the length of two points
                if y(i+1)-y(i) > 0
                    angle_h(i) = acos((x(i+1)-x(i))/(dist(i)))*180/pi;
                else 
                    angle_h(i) = -acos((x(i+1)-x(i))/(dist(i)))*180/pi;
                end
                % cos(a) = dx/dist
            end
            
            for k = 2:n-1
                    % angle between the two points
                    angle(k) = angle_h(k) - angle_h(k-1);
                    absangle(k) = abs(angle(k));

                    % radius of curvature
                    c = sqrt(dist(k-1)^2 + dist(k)^2 - 2*dist(k-1)*dist(k)*cos((180-absangle(k))*pi/180));
                    r(k) = c/2/sin(absangle(k)*pi/180);

                    % maximum velocity through a curve, restrained by the curvature
                    maxv(k) = sqrt(abs(u*9.8*r(k)));
            end

            for i = 1:n-2
                if maxv(i) > max_turnrate*dist(i)./abs(angle(i+1)-angle(i)) 
                    maxv(i) = max_turnrate*dist(i)./abs(angle(i+1)-angle(i));
                end
            end
            
            if ~isempty(wi)
                for i = 1:n
                    if ~isempty(find(i==wi)) % way point, up the next speed
                        maxv(i+1) = sqrt(maxv(i)^2+2*a_acc*dist(i));
                        maxv(i-1) = sqrt(maxv(i)^2+2*a_dec*dist(i-1));
                    end
                end
            end
            
            
            
            for i = 1:n % max velocity limit
                if maxv(i)>v_max
                    maxv(i) = v_max;
                end
            end                    
            
            maxv1 = maxv;
            
            for i = n:-1:2
                if maxv(i-1)^2 > maxv(i)^2+2*a_dec*dist(i-1) % previous speed cannot be maintained, drop the previous speed
                    maxv(i-1) = sqrt(maxv(i)^2+2*a_dec*dist(i-1));
                end
            end
            
%             for i = 1:n-1
%                 dt1(i) = dist(i)*2./(maxv(i)+maxv(i+1));
%             end
            
            warning_maxv = maxv;
            
            for i = 1:n-2
                if maxv(i+1)^2 > maxv(i)^2+2*a_acc*dist(i) % next speed cannot be achieved, drop the next speed
                    maxv(i+1) = sqrt(maxv(i)^2+2*a_acc*dist(i));
                end
            end
            v = maxv;
%             if ~isempty(wi)
%                 for i = 1:length(wi)
                    

            for k = 1:n-1
                dt(k) = dist(k)*2./(v(k)+v(k+1));
            end
            
            for i = n:-1:2
                if warning_maxv(i)+a_dec*dt(i-1)<maxv1(i-1) && isempty(find(i==ni))
                    warning_maxv(i-1) = warning_maxv(i)+a_dec*dt(i-1);
                elseif isempty(find(i==ni)) 
                    warning_maxv(i-1) = maxv1(i-1);
                end
            end
            
            for k = 2:n
                % time
                t(k) = sum(dt(1:k-1));
            end
            
            
            
            for k = 1:n-2
                % angle rate
                angle_rate(k) = (angle(k+1)-angle(k))/dist(k)*v(k);
            end
            for k = 1:n-1
                % acceleration
                % a(k) = (v(k+1)-v(k)) / time(k);
                a(k) = (v(k+1) - v(k))./dt(k);
            end
            
            output.Path = [x y];
            output.DeltaT = dt;
            output.DeltaDist = dist;
            output.Time = t;
            output.Speed = v;
            output.Warning_Speedlim = warning_maxv;
            output.Acc = a;
            output.Angle = angle;
            output.AbsAngle = absangle;
            output.Turning_Rate = angle_rate;
            output.Distance_Traveled = dist_traveled;
            output.ni = ni;
            output.vi = vi;
            output.R = r;
        end
        
    end % methods
end % class
