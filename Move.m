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

classdef Move < handle
    properties
        i
        currentPosition
        TotalDirectDistance;
        TotalPathDistance;
        TotalTime;
        DeltaT;
        Time;
        Speed;
        Angle;
        % GoFlag = 1;
%         timetext
%         positiontext
    end
    properties
        p1
        p2
        p3
        pathH
        vehicleH
        visionH
        speedo
        angleo
    end


    methods 
            function output = Move(map,path,speed,R_vision,Vision_on,Path_lit,angle,speedaxesH,angleaxesH)
                % input is a setmap class object with all the 2-D Map properties;
                % path is a n by 2 arrays of all the positions along the path;
                % speed is a n-1 column vector of the speed at each nth position;
                % Move will show a series of motion picture simulating the vehicle going
                % from the start position to destination position

                format long
                % startPosition = input.startPosition;
                % destPosition = input.destPosition;

                n = length(speed); % total number of index
                x = path(:,1);
                y = path(:,2);
                DeltaT = zeros(n-1,1);

                for i = 1:n-1
                    % distance of each increment
                    d(i) = sqrt((y(i+1)-y(i))^2 + (x(i+1)-x(i))^2);

                    % distance traveled along the path
                    dist_traveled(i+1) = sum(d(1:i));
                    
                    DeltaT(i) = d(i)*2./(speed(i)+speed(i+1));
                end
                
                GoFlag = 1;

                c = path(end,1:2)-path(1,1:2);
                total_ddist = (c(1)^2+c(2)^2)^0.5; % total direct distance
                total_dist = sum(abs(d)); % total path distance

                output.TotalDirectDistance = total_ddist;
                output.TotalPathDistance = total_dist;
                output.TotalTime = sum(DeltaT);
                output.DeltaT = DeltaT;

                Time = zeros(n,1);
        
                for i = 2:n
                    Time(i) = sum(DeltaT(1:i-1));
                end

                output.Time = Time;
                output.Speed = speed;
                output.Angle = angle;
                
                aHan = get(map.startHandle,'Parent');
                fHan = get(aHan,'Parent');
            
                set(0,'CurrentFigure',fHan);
                set(fHan,'CurrentAxes',aHan);
                hold on
                if Path_lit == 1 
                    % draws the entire pathway
                    P = plot(path(:,1),path(:,2),'-.k');
                    output.pathH = P;
                    drawnow;
                end

                
                % arrow function is downloaded from mathworks.com; This arrow represents
                % the vehicle
                dist = path(2,1:2) - path(1,1:2);
                di = sqrt(dist(1)^2+dist(2)^2);
                if dist(2) > 0
                    theta = acos(dist(1)/di);
                else
                    theta = -acos(dist(1)/di);
                end
                R = 12;
                t1 = [theta; theta+2.5; theta-2.5];
                sx=R*cos(t1)+path(1,1);
                sy=R*sin(t1)+path(1,2);
                A = patch(sx,sy,[0 1 1]);
                
                output.vehicleH = A;
                t =(0:100)*2*pi/100;
                output.currentPosition = path(1,1:2);
                output.i=1;
                if R_vision<total_ddist && Vision_on==1
                    vx = R_vision*cos(t)+path(1,1);
                    vy = R_vision*sin(t)+path(1,2);
                    B = plot(vx,vy,'--m');
                    output.visionH = B;
                end
                drawnow;
                
                set(fHan,'CurrentAxes',speedaxesH);
                p1 = plot(Time,speed);     
                hold on              
                p2 = plot(Time,map.out1.Warning_Speedlim,'-.r');
             
                speedo = plot(Time(1),speed(1),'or');
                
                set(fHan,'CurrentAxes',angleaxesH);
                p3 = plot(Time(1:end-1),angle);

                set(angleaxesH,'YLim',[-90 90]);
                hold on
                angleo = plot(Time(1),angle(1),'or');
                
                output.p1 = p1;
                output.p2 = p2;
                output.p3 = p3;
                output.speedo = speedo;
                output.angleo = angleo;
                output.vehicleH = A;
                set(fHan,'CurrentAxes',aHan);
                
                set(map.text19,'String',[num2str(map.out1.Time(1)) ' sec']);
                set(map.text20,'String',['[' num2str(map.Path(1,1)) ...
                    ',' num2str(map.Path(1,2)) ']']);
                
%                 output.timetext = uicontrol('style','text','position',[FS(3)-120 FS(4)-525 90 18],...
%                 'String','seconds','fontsize',10,'visible','off',...
%                 'HorizontalAlignment','right');
%                 output.positiontext = uicontrol('style','text','position',[FS(3)-120 FS(4)-560 40 18],...
%                 'String','(x,y)','fontsize',10,'visible','off',...
%                 'HorizontalAlignment','right');
%                 i=1;
%                 set(output.timetext,'String',[num2str(map.out1.Time(i)) 'sec.'])
%                 set(output.positiontext,'String',['(' num2str(map.Path(i,1)) ',' num2str(map.Path(i,2)) ')'])
%                 pause(.1)
%                 set(output.timetext,'String','')
%                 set(output.positiontext,'String','')
                i=2;
                % if GoFlag=1 and i<=n, moves on
                while map.GoFlag && i<=n 
                    pause(DeltaT(i-1)-0.018) % On average, it takes 0.018 sec to run each loop on my computer
                    %set(fHan,'CurrentAxes',aHan);
                    if i<n
                        dist = path(i+1,1:2) - path(i,1:2);
                        di = sqrt(dist(1)^2+dist(2)^2);
                        if dist(2) > 0
                            theta = acos(dist(1)/di);
                        else
                            theta = -acos(dist(1)/di);
                        end
                        t1 = [theta; theta+2.5; theta-2.5];
                        sx=R*cos(t1)+path(i,1);
                        sy=R*sin(t1)+path(i,2);
                        set(A,'Vertices',[sx sy]);
                        output.i = i;
                        if  Vision_on==1
                          vx = R_vision*cos(t)+path(i,1);
                          vy = R_vision*sin(t)+path(i,2);
                          set(B,'XData',vx);
                          set(B,'YData',vy);
                        end
                        drawnow;
%                         set(fHan,'CurrentAxes',speedaxesH)
                        set(speedo,'XData',Time(i))
                        set(speedo,'YData',speed(i))
                        
                        set(angleo,'XData',Time(i))
                        set(angleo,'YData',angle(i))
                        set(map.text19,'String',[num2str(map.out1.Time(i)) ' sec']);
                        set(map.text20,'String',['[' num2str(map.Path(i,1)) ...
                        ',' num2str(map.Path(i,2)) ']']);
                    else
                        dist = path(i,1:2) - path(i-1,1:2);
                        di = sqrt(dist(1)^2+dist(2)^2);
                        if dist(2) > 0
                            theta = acos(dist(1)/di);
                        else
                            theta = -acos(dist(1)/di);
                        end
                        t1 = [theta; theta+2.5; theta-2.5];
                        sx=R*cos(t1)+path(i,1);
                        sy=R*sin(t1)+path(i,2);
                        set(A,'Vertices',[sx sy]);
                        output.currentPosition = path(i,1:2);
                        output.i = i;
                        if R_vision<total_dist
                              vx = R_vision*cos(t)+path(i,1);
                              vy = R_vision*sin(t)+path(i,2);
                              set(B,'XData',vx);
                              set(B,'YData',vy);
                        end
                        drawnow;
                        set(speedo,'XData',Time(i))
                        set(speedo,'YData',speed(i))
                        set(map.text19,'String',[num2str(map.out1.Time(i)) ' sec']);
                        set(map.text20,'String',['[' num2str(map.Path(i,1)) ...
                        ',' num2str(map.Path(i,2)) ']']);
                    end
                    i = i+1;


                end

            end
            
    end % methods
    
end % class