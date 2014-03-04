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

classdef setmap < UserControls
% a handle class of dragable objects;
% this class sets the start, destination, waypoints, and obstacle properties

    properties
        startPosition = [50 100]; % 1 by 2 double array
        destPosition = [800 900];
        vehiclePosition = [50 100];
        waypointPosition = []; % way point positions, each row is a way point position
        obsPosition = []; % obstacles positions, each row is an obstacle position
        obsRad = []; % column array with obstacle radius
        Nobs = 0; % number of obstacles
        MoveCallback = {}; % cell-array callback, executed with each move;
        % EventSource is drag object's handle, EventData is Position
        % property value
        StopMoveCallback = {};% cell-array callback, executed at the end of mouse up
        ConstrainX = NaN; % 1 by 1 logical
        ConstrainY = NaN; % 1 by 1 logical
        Visible = 'on';% on or off
        Path = [];
        Speed = [];
        Acc = [];
        Angle = [];
        Turning_Rate = [];
        Time = [];
        GoFlag = 1;
    end
        
    properties (SetAccess=private)
        speedaxesH
        angleaxesH
        DetailedFiguresButtonH
        DetailedFigH
        startHandle  % 1 by 1 double HandleGraphics handle, not publically settable
        vehicleHandle
        destHandle
        wayHandle_cell
        waytextH_cell
        obsHandle_cell
        opcm
        wpcm
    end
   
methods
    
    % Radius of the starting point and destination will be 10, and the
    % radius of the obstacle will be set
    function output = setmap(varargin)

        Radius = 10;        
        t =(0:100)*2*pi/100;
        start_pos = [varargin{1} varargin{2}];
        sx=Radius*cos(t)+start_pos(1);
        sy=Radius*sin(t)+start_pos(2);
        dest_pos = [varargin{3} varargin{4}];
        dx = Radius*cos(t)+dest_pos(1);
        dy = Radius*sin(t)+dest_pos(2);
        spHan = patch(sx,sy,'blue');
        dpHan = patch(dx,dy,'green');
        aHan = get(spHan,'Parent'); % get axes handle
        fHan = get(aHan,'Parent');
        
        if nargin==7
            wayP = varargin{5};
            [a b] = size(wayP);
            for i=1:a
                r = 7;
                wx = r*cos(t)+wayP(i,1);
                wy = r*sin(t)+wayP(i,2);
                wpHan = patch(wx,wy,'yellow');
                wtHan = text(wayP(i,1),wayP(i,2)+15,num2str(i),'FontSize',7);
                wtHan_cell{i} = wtHan;
                wpHan_cell{i} = wpHan;
            end
            output.waypointPosition = wayP;
            obs_pos = varargin{6};
            obs_rad = varargin{7};
            N_obs = length(varargin{7});
            for i=1:N_obs
                r = obs_rad(i);
                obsi_pos = obs_pos(i,1:2);
                ox = r*cos(t)+obsi_pos(1);
                oy = r*sin(t)+obsi_pos(2);
                opHan = patch(ox,oy,'red');
                opHan_cell{i} = opHan;
            end
        elseif nargin==6
            obs_pos = varargin{5};
            obs_rad = varargin{6};
            wayP = []
            N_obs = length(varargin{6});
            for i=1:N_obs
                r = obs_rad(i);
                obsi_pos = obs_pos(i,1:2);
                ox = r*cos(t)+obsi_pos(1);
                oy = r*sin(t)+obsi_pos(2);
                opHan = patch(ox,oy,'red');
                opHan_cell{i} = opHan;
            end
        elseif nargin==5
            wayP = varargin{5};
            [a b] = size(wayP);
            c = a*b;
            if c == 0
                wpHan_cell = {};
                wtHan_cell = {};
            else
                for i=1:a
                    r = 7; 
                    wx = r*cos(t)+wayP(i,1);
                    wy = r*sin(t)+wayP(i,2);
                    wpHan = patch(wx,wy,'yellow');
                    wtHan = text(wayP(i,1),wayP(i,2)+15,num2str(i),'FontSize',7);
                    wtHan_cell{i} = wtHan;
                    wpHan_cell{i} = wpHan;
                end
            end
            output.waypointPosition = wayP;
            N_obs = 0;
            opHan_cell = {};
            obs_pos = []; % no obstacles
            obs_rad = []; 
        else
            obs_pos = [];
            obs_rad = [];
            N_obs = 0;
            opHan = [];
            opHan_cell = {};
            wayP = [];
        end
        ddist = dest_pos - start_pos;
%         theta = pi/4;
%         R = 12;
%         t1 = [theta; theta+2.5; theta-2.5];
%         sx=R*cos(t1)+start_pos(1,1);
%         sy=R*sin(t1)+start_pos(1,2);
%         A = patch(sx,sy,[0 1 1]);
%         
% %         output.DetailedFiguresButtonH = uicontrol('Style','Pushbutton','Position',[764 50 50 15],...
% %                 'String','Detailed Figures','KeyPressFcn',{@LOCALkeyDetailedFiguresbutton output});
%         
%         output.vehicleHandle = A;
        output.startPosition = start_pos;
        output.StartPosition = start_pos;
        output.vehiclePosition = start_pos;
        START = start_pos;
        output.destPosition = dest_pos;
        output.EndPosition = dest_pos;
        END = dest_pos;
        output.obsPosition = obs_pos;
        output.ObstacleData = [obs_pos obs_rad];
        OBSTACLE = [obs_pos obs_rad];
        output.obsRad = obs_rad;
        output.startHandle = spHan;
        output.destHandle = dpHan;
        output.obsHandle_cell = opHan_cell;
        output.WayPoint = wayP;
        WAYPOINT = wayP;
        output.wayHandle_cell = wpHan_cell;
        output.waytextH_cell = wtHan_cell;
        output.Nobs = N_obs; % 1 obstacle first, drag this one will duplice the obstacle

        
%         set(output.DetailedFiguresButton,'Callback',{@LOCALDetailedFigures obj});
        set(spHan,'ButtonDownFcn',{@LOCALtextbuttondown_start output});
        set(dpHan,'ButtonDownFcn',{@LOCALtextbuttondown_dest output});
        if nargin==5
            for i=1:a
                wpHan = wpHan_cell{i};
                set(wpHan,'ButtonDownFcn',{@LOCALtextbuttondown_way output wpHan});
            end
        elseif nargin==7
            for i=1:a
                wpHan = wpHan_cell{i};
                set(wpHan,'ButtonDownFcn',{@LOCALtextbuttondown_way output wpHan});
            end
        end
        if nargin>=6 % no way point
            for i=1:N_obs
                opHan = opHan_cell{i};
                set(opHan,'ButtonDownFcn',{@LOCALtextbuttondown_obs output opHan});
            end
        elseif nargin==5 % no obstacle
        else
            set(opHan,'ButtonDownFcn',{@LOCALtextbuttondown_obs output});
        end
        
        c1 = 590;
        % Speed figure
        b = axes('ButtonDownFcn',{@LOCALplotspeed output});
        set(b,'Units','pixels');
        set(b,'Position',[c1+115 80+c1*3.8/10 180 c1*2.6/10]);
        % v = plot(0,0,'or');
        title('Speed vs. Time','FontWeight','Bold')
        xlabel('Time [sec]','FontSize',8)
        y = ylabel('Speed [units/s]','FontSize',8);
        %set(y,'Position',[-0.14 0.4948 1]);
        hold on

        % Turning Angle figure
        c = axes('ButtonDownFcn',{@LOCALplotangle output});
        set(c,'Units','pixels');
        set(c,'Position',[c1+115 80+c1*0.2/10 180 c1*2.6/10]);
        % ta = plot(0,0,'or');
        title('Turning Angle vs. Time','FontWeight','Bold')
        xlabel('Time [sec]','FontSize',8)
        y = ylabel('Turning Angle [deg]','FontSize',8);
        %set(y,'Position',[-0.14 0.4948 1]);
        hold on
        output.speedaxesH = b;
        output.angleaxesH = c;
        
        addlistener(output,'ObstacleData','PostSet',@setmap.LOCALUpdateObstacle);
        addlistener(output,'WayPoint','PostSet',@setmap.LOCALUpdateWayPoint);
        
    end
    
    function obj = LOCALplotspeed(Esrc,Edata,obj)
        figure
        p1 = plot(obj.out1.Time,obj.out1.Speed);  
        hold on              
        p2 = plot(obj.out1.Time,obj.out1.Warning_Speedlim,'-.r');
        title('Speed vs. Time','FontWeight','Bold')
        xlabel('Time [sec]')
        ylabel('Speed [units/s]')
        legend('Bot Speed','Warning Speed Limit')
    end
    
    function obj = LOCALplotangle(Esrc,Edata,obj)
        figure
        p1 = plot(obj.out1.Time(1:end-1),obj.out1.Angle);  
        title('Turning Angle vs. Time','FontWeight','Bold')
        xlabel('Time [sec]')
        ylabel('Angle [deg]')     
    end
    
    function ToolH = set.Visible(ToolH,X)
        if strcmp(X,'on')||strcmp(X,'On')||strcmp(X,'ON')
            ToolH.Visible='on';
            set(ToolH.startHandle,'Visible','on')
        elseif strcmp(X,'off')||strcmp(X,'Off')||strcmp(X,'OFF')
            ToolH.Visible='off';
            set(ToolH.startHandle,'Visible','off')
        end
    end
    
    function ToolH = set.startPosition(ToolH,newP)
        ToolH.startPosition = newP;

        % a = get(ToolH.startHandle,'XData');
        % b = get(ToolH.startHandle,'YData');
        % original xstart = a(1)-10;
        % ystart = b(1);
        Radius = 10;  
        t =(0:100)*2*pi/100;
        sx=Radius*cos(t)+newP(1);
        sy=Radius*sin(t)+newP(2);
        set(ToolH.startHandle,'XData',sx);
        set(ToolH.startHandle,'YData',sy);
    end
    
    function ToolH = set.destPosition(ToolH,newP)
        ToolH.destPosition=newP;
        Radius = 10;  
        t =(0:100)*2*pi/100;
        dx=Radius*cos(t)+newP(1);
        dy=Radius*sin(t)+newP(2);
        set(ToolH.destHandle,'XData',dx);
        set(ToolH.destHandle,'YData',dy);
    end
    
    
    function LOCALtextbuttondown_start(Esrc,Edata,ToolH)
        aHan = get(ToolH.startHandle,'Parent'); % get axes handle
        fHan = get(aHan,'Parent');
        set(fHan,'WindowButtonMotionFcn',{@LOCALmotion1 ToolH});
        set(fHan,'WindowButtonUpFcn',{@LOCALstop1 ToolH});
    end
    
    function LOCALmotion1(Esrc,Edata,ToolH)
        aHan = get(ToolH.startHandle,'Parent'); % get current axis handle
        fHan = get(aHan,'Parent');
        spHan = ToolH.startHandle;
        dpHan = ToolH.destHandle;
        opHan_cell = ToolH.obsHandle_cell;
        % Get CurrentPoint of AXES, assume 2-d, pull of [X Y]
        tmpcp = get(aHan,'CurrentPoint');
        cp = tmpcp(1,1:2);
        % Get AXES limits (which limits within the axes by default)
        xlim = get(aHan,'XLim');
        ylim = get(aHan,'YLim');
        % Enforce the AXES limits (eg, Xlim(1) <= cp(1) <= XLim(2))
        cp = max([xlim(1) ylim(1);cp],[],1);
        cp = min([xlim(2) ylim(2);cp],[],1);
        % Find which directions are constrained
        cs = [ToolH.ConstrainX ToolH.ConstrainY];
        ConstrainIdx = find(~isnan(cs));
        % Get current position of Start object
        Radius = 10;  
        a = get(spHan,'XData');
        b = get(spHan,'YData');
        sx = a(1)-Radius;
        sy = b(1);
        startP = [sx(1) sy(1)];
        % Overwrite position of constrained directions to current position
        cp(ConstrainIdx) = startP(ConstrainIdx);
        % Move text by setting its Position property
        startP = cp;
        Radius=10;
        t=(0:100)*2*pi/100;
        sx=Radius*cos(t)+startP(1);
        sy=Radius*sin(t)+startP(2);
        set(spHan,'XData',sx);
        set(spHan,'YData',sy);
        ToolH.startPosition = startP;
        Start_Position = startP;
        ToolH.StartPosition = startP;
        ToolH.startHandle = spHan;
        % Run any user-callback
        pmcb = ToolH.MoveCallback;
         if ~isempty(pmcb)
           if isa(pmcb,'cell')
              pmcb{1}(ToolH,cp,pmcb{2:end});
           elseif isa(pmcb,'char');
              evalin('base',pmcb);
           end
         end
    end

    function LOCALstop1(Esrc,Edata,ToolH)
        aHan = get(ToolH.startHandle,'Parent'); % get current axis handle
        fHan = get(aHan,'Parent');
        spHan = ToolH.startHandle;
        set(fHan,'WindowButtonMotionFcn','');
        set(fHan,'WindowButtonUpFcn','');
        psmcb = ToolH.StopMoveCallback;
         if ~isempty(psmcb)
           if isa(psmcb,'cell')
              psmcb{1}(ToolH,cp,psmcb{2:end});
           elseif isa(pmcb,'char');
              evalin('base',psmcb);
           end
         end
    end
    
    function LOCALtextbuttondown_dest(Esrc,Edata,ToolH)
        aHan = get(ToolH.destHandle,'Parent'); % get axes handle
        fHan = get(aHan,'Parent');
        set(fHan,'WindowButtonMotionFcn',{@LOCALmotion2 ToolH});
        set(fHan,'WindowButtonUpFcn',{@LOCALstop2 ToolH});
    end
    
    function LOCALmotion2(Esrc,Edata,ToolH)
        aHan = get(ToolH.startHandle,'Parent'); % get current axis handle
        fHan = get(aHan,'Parent');
        spHan = ToolH.startHandle;
        dpHan = ToolH.destHandle;
        opHan_cell = ToolH.obsHandle_cell;
        % Get CurrentPoint of AXES, assume 2-d, pull of [X Y]
        tmpcp = get(aHan,'CurrentPoint');
        cp = tmpcp(1,1:2);
        % Get AXES limits (which limits within the axes by default)
        xlim = get(aHan,'XLim');
        ylim = get(aHan,'YLim');
        % Enforce the AXES limits (eg, Xlim(1) <= cp(1) <= XLim(2))
        cp = max([xlim(1) ylim(1);cp],[],1);
        cp = min([xlim(2) ylim(2);cp],[],1);
        % Find which directions are constrained
        cs = [ToolH.ConstrainX ToolH.ConstrainY];
        ConstrainIdx = find(~isnan(cs));
        % Get current position of TEXT object
        Radius = 10;  
        a = get(dpHan,'XData');
        b = get(dpHan,'YData');
        dx = a(1)-Radius;
        dy = b(1);
        destP = [dx(1) dy(1)];
        % Overwrite position of constrained directions to current position
        cp(ConstrainIdx) = destP(ConstrainIdx);
        % Move text by setting its Position property
        destP = cp;
        Radius=10;
        t = (0:100)*2*pi/100;
        dx = Radius*cos(t)+destP(1);
        dy = Radius*sin(t)+destP(2);
        set(dpHan,'XData',dx);
        set(dpHan,'YData',dy);
        ToolH.destPosition = destP;
        End_Position = destP;
        ToolH.EndPosition = destP;
        ToolH.destHandle = dpHan;
        % Run any user-callback
        pmcb = ToolH.MoveCallback;
         if ~isempty(pmcb)
           if isa(pmcb,'cell')
              pmcb{1}(ToolH,cp,pmcb{2:end});
           elseif isa(pmcb,'char');
              evalin('base',pmcb);
           end
         end
    end

    function LOCALstop2(Esrc,Edata,ToolH)
        aHan = get(ToolH.destHandle,'Parent'); % get current axis handle
        fHan = get(aHan,'Parent');
        dpHan = ToolH.destHandle;
        set(fHan,'WindowButtonMotionFcn','');
        set(fHan,'WindowButtonUpFcn','');
        psmcb = ToolH.StopMoveCallback;
         if ~isempty(psmcb)
           if isa(psmcb,'cell')
              psmcb{1}(ToolH,cp,psmcb{2:end});
           elseif isa(pmcb,'char');
              evalin('base',psmcb);
           end
         end
    end
    
    function LOCALtextbuttondown_obs(Esrc,Edata,ToolH,opHan)
        aHan = get(ToolH.startHandle,'Parent'); % get axes handle
        fHan = get(aHan,'Parent');
        opHan_cell = ToolH.obsHandle_cell;
        wpHan_cell = ToolH.wayHandle_cell;
        for i=1:length(opHan_cell)
            set(opHan_cell{i},'FaceColor',[1 0 0]);
        end
        for i=1:length(wpHan_cell)
            set(wpHan_cell{i},'FaceColor',[1 1 0]);
        end
        set(opHan,'FaceColor',[0.6 0 0]);
        set(fHan,'WindowButtonMotionFcn',{@LOCALmotion3 ToolH opHan});
        set(fHan,'WindowButtonUpFcn',{@LOCALstop3 ToolH opHan});
    end
    
    function LOCALmotion3(Esrc,Edata,ToolH,opHan)
        aHan = get(ToolH.startHandle,'Parent'); % get current axis handle
        fHan = get(aHan,'Parent');
        spHan = ToolH.startHandle;
        dpHan = ToolH.destHandle;
        opHan_cell = ToolH.obsHandle_cell;

        % Get CurrentPoint of AXES, assume 2-d, pull of [X Y]
        tmpcp = get(aHan,'CurrentPoint');
        cp = tmpcp(1,1:2);
        % Get AXES limits (which limits within the axes by default)
        xlim = get(aHan,'XLim');
        ylim = get(aHan,'YLim');
        % Enforce the AXES limits (eg, Xlim(1) <= cp(1) <= XLim(2))
        cp = max([xlim(1) ylim(1);cp],[],1);
        cp = min([xlim(2) ylim(2);cp],[],1);
        % Find which directions are constrained
        cs = [ToolH.ConstrainX ToolH.ConstrainY];
        ConstrainIdx = find(~isnan(cs));
        % Get current position of TEXT object
        a = get(opHan,'XData');
        Radius = (max(a)-min(a))/2;
        b = get(opHan,'YData');
        ox = a(1)-Radius;
        oy = b(1);
        obsP = [ox(1) oy(1)];
        % Overwrite position of constrained directions to current position
        cp(ConstrainIdx) = obsP(ConstrainIdx);
        % Move text by setting its Position property
        obsP = cp;
        t=(0:100)*2*pi/100;
        ox=Radius*cos(t)+obsP(1);
        oy=Radius*sin(t)+obsP(2);
        for i=1:length(opHan_cell)
            opHan1 = opHan_cell{i};
            if opHan1 == opHan
                set(opHan,'XData',ox);
                set(opHan,'YData',oy);
                opHan_cell{i} = opHan;
                ToolH.obsHandle_cell = opHan_cell;
                ToolH.obsPosition(i,1:2) = obsP;
                ConFrame.ObstacleData(i,1:2) = obsP;
                ToolH.ObstacleData(i,1:2) = obsP;
            end
        end

        % Run any user-callback
        pmcb = ToolH.MoveCallback;
         if ~isempty(pmcb)
           if isa(pmcb,'cell')
              pmcb{1}(ToolH,cp,pmcb{2:end});
           elseif isa(pmcb,'char');
              evalin('base',pmcb);
           end
         end
    end
    

    function LOCALstop3(Esrc,Edata,ToolH,opHan)
        aHan = get(ToolH.startHandle,'Parent'); % get current axis handle
        fHan = get(aHan,'Parent');
        spHan = ToolH.startHandle;
        set(fHan,'WindowButtonMotionFcn','');
        set(fHan,'WindowButtonUpFcn','');
        psmcb = ToolH.StopMoveCallback;
         if ~isempty(psmcb)
           if isa(psmcb,'cell')
              psmcb{1}(ToolH,cp,psmcb{2:end});
           elseif isa(pmcb,'char');
              evalin('base',psmcb);
           end
         end
    end
    
    function LOCALtextbuttondown_way(Esrc,Edata,ToolH,wpHan)
        aHan = get(ToolH.startHandle,'Parent'); % get axes handle
        fHan = get(aHan,'Parent');
        wpHan_cell = ToolH.wayHandle_cell;
        opHan_cell = ToolH.obsHandle_cell;
        for i=1:length(wpHan_cell)
            set(wpHan_cell{i},'FaceColor',[1 1 0]);
        end
        for i = 1:length(opHan_cell)
            set(opHan_cell{i},'FaceColor',[1 0 0]);
        end
        set(wpHan,'FaceColor',[0.6 0.6 0]);
        set(fHan,'WindowButtonMotionFcn',{@LOCALmotion4 ToolH wpHan});
        set(fHan,'WindowButtonUpFcn',{@LOCALstop4 ToolH wpHan});
    end
    
    function LOCALmotion4(Esrc,Edata,ToolH,wpHan)
        aHan = get(ToolH.startHandle,'Parent'); % get current axis handle
        fHan = get(aHan,'Parent');
        spHan = ToolH.startHandle;
        dpHan = ToolH.destHandle;
        opHan_cell = ToolH.obsHandle_cell;
        wpHan_cell = ToolH.wayHandle_cell;
        wtHan_cell = ToolH.waytextH_cell;

        % Get CurrentPoint of AXES, assume 2-d, pull of [X Y]
        tmpcp = get(aHan,'CurrentPoint');
        cp = tmpcp(1,1:2);
        % Get AXES limits (which limits within the axes by default)
        xlim = get(aHan,'XLim');
        ylim = get(aHan,'YLim');
        % Enforce the AXES limits (eg, Xlim(1) <= cp(1) <= XLim(2))
        cp = max([xlim(1) ylim(1);cp],[],1);
        cp = min([xlim(2) ylim(2);cp],[],1);
        % Find which directions are constrained
        cs = [ToolH.ConstrainX ToolH.ConstrainY];
        ConstrainIdx = find(~isnan(cs));
        % Get current position of TEXT object
        a = get(wpHan,'XData');
        Radius = (max(a)-min(a))/2;
        b = get(wpHan,'YData');
        ox = a(1)-Radius;
        oy = b(1);
        wayP = [ox(1) oy(1)];
        % Overwrite position of constrained directions to current position
        cp(ConstrainIdx) = wayP(ConstrainIdx);
        % Move text by setting its Position property
        wayP = cp;
        t=(0:100)*2*pi/100;
        ox=Radius*cos(t)+wayP(1);
        oy=Radius*sin(t)+wayP(2);
        for i=1:length(wpHan_cell)
            wpHan1 = wpHan_cell{i};
            wtHan = wtHan_cell{i};
            if wpHan1 == wpHan
                set(wpHan,'XData',ox);
                set(wpHan,'YData',oy);
                wpHan_cell{i} = wpHan;
                wtHan_cell{i} = wtHan;
                set(wtHan,'Position',wayP+[0 15]);
                ToolH.wayHandle_cell = wpHan_cell;
                ToolH.waypointPosition(i,1:2) = wayP;
                ToolH.WayPoint(i,1) = wayP(1);
                ToolH.WayPoint(i,2) = wayP(2);
            end
        end

        % Run any user-callback
        pmcb = ToolH.MoveCallback;
         if ~isempty(pmcb)
           if isa(pmcb,'cell')
              pmcb{1}(ToolH,cp,pmcb{2:end});
           elseif isa(pmcb,'char');
              evalin('base',pmcb);
           end
         end
    end
    

    function LOCALstop4(Esrc,Edata,ToolH,opHan)
        aHan = get(ToolH.startHandle,'Parent'); % get current axis handle
        fHan = get(aHan,'Parent');
        spHan = ToolH.startHandle;
        set(fHan,'WindowButtonMotionFcn','');
        set(fHan,'WindowButtonUpFcn','');
        psmcb = ToolH.StopMoveCallback;
        if ~isempty(psmcb)
           if isa(psmcb,'cell')
              psmcb{1}(ToolH,cp,psmcb{2:end});
           elseif isa(pmcb,'char');
              evalin('base',psmcb);
           end
         end
    end
    
    function LOCALduplicateobstacle(Esrc,Edata,ToolH,i)
        [a b] = size(ToolH.ObstacleData);
        ToolH.ObstacleData = [ToolH.ObstacleData;ToolH.ObstacleData(i,:)+[5 0 0]];
        opHan_cell = ToolH.obsHandle_cell;
        for i1 = 1:length(opHan_cell)
            set(opHan_cell{i1},'FaceColor',[1 0 0]);
        end
        set(opHan_cell{a+1},'FaceColor',[0.6 0 0]);
    end
    
    function LOCALduplicatewaypoint(Esrc,Edata,ToolH,i)
        [a b] = size(ToolH.WayPoint);
        ToolH.WayPoint = [ToolH.WayPoint;ToolH.WayPoint(i,:)+[5 0]];
        wpHan_cell = ToolH.wayHandle_cell;
        for i1 = 1:length(wpHan_cell)
            set(wpHan_cell{i1},'FaceColor',[1 1 0]);
        end
        set(wpHan_cell{a+1},'FaceColor',[0.6 0.6 0]);
    end
    
    function LOCALdeletewaypoint(Esrc,Edata,ToolH,i)
        [a b] = size(ToolH.WayPoint);
        wpHan_cell = ToolH.wayHandle_cell;
        opHan_cell = ToolH.obsHandle_cell;
        for i1 = 1:length(wpHan_cell)
            set(wpHan_cell{i1},'FaceColor',[1 1 0]);
        end
        for i1 = 1:length(opHan_cell)
            set(opHan_cell{i1},'FaceColor',[1 0 0]);
        end
        if i==1 && a ==1
            ToolH.WayPoint = [];
        elseif i==1
            ToolH.WayPoint = ToolH.WayPoint(2:a,:);
        elseif i==a
            ToolH.WayPoint = ToolH.WayPoint(1:a-1,:);
        else
            ToolH.WayPoint = [ToolH.WayPoint(1:i-1,:);ToolH.WayPoint(i+1:end,:)];
        end
    end
    
   end %methods
    
    methods (Static = true)
        function LOCALUpdateObstacle(Esrc,Edata)
            ObsData = Edata.AffectedObject.ObstacleData;
            
            if isempty(ObsData)
                ObsData = zeros(0,3);
            end     
            output = Edata.AffectedObject;
            output.obsPosition = ObsData(:,1:2);
            output.obsRad = ObsData(:,3);
            opHan_cell = output.obsHandle_cell; % old handles
            
            aHan = get(output.startHandle,'Parent');
            
            set(get(aHan,'Parent'),'CurrentAxes',get(output.startHandle,'Parent'));
            
            obs_pos = output.obsPosition;
            obs_rad = output.obsRad;
            [a b] = size(obs_rad);
            N_obs = a*b;
            N_old_obs = length(opHan_cell);
            t =(0:100)*2*pi/100;           
            
            if N_obs == 0
                for i=1:N_old_obs
                    delete(opHan_cell{i});
                end
                opHan_cell = {};
            elseif N_obs>=N_old_obs
                for i=1:N_old_obs
                    r = obs_rad(i);
                    obsi_pos = obs_pos(i,1:2);
                    ox = r*cos(t)+obsi_pos(1);
                    oy = r*sin(t)+obsi_pos(2);
                    opHan = opHan_cell{i};
                    set(opHan,'XData',ox);
                    set(opHan,'YData',oy);
                end
                if N_obs>N_old_obs
                    temp = N_obs - N_old_obs;
                    opHan_cell(N_old_obs+1:N_obs) = cell(1,temp);
                    for i=N_old_obs+1:N_obs
                        r = obs_rad(i);
                        obsi_pos = obs_pos(i,1:2);
                        ox = r*cos(t)+obsi_pos(1);
                        oy = r*sin(t)+obsi_pos(2);
                        opHan = patch(ox,oy,'red');
                        cm = uicontextmenu;
                        set(opHan,'uicontextmenu',cm);
                        m1 = uimenu(cm,'Label','Edit');
                        m2 = uimenu(cm,'Label','Duplicate');
                        m3 = uimenu(cm,'Label','Delete');
                        opHan_cell{i} = opHan;
                        output.opcm{i} = cm;
                        set(m1,'Callback',{@LOCALopeneditobstacle output i});
                        set(m2,'Callback',{@LOCALduplicateobstacle output i});
                        set(m3,'Callback',{@LOCALdeleteobstacle output i});
                    end
                end
                output.obsHandle_cell = opHan_cell;
                for i=1:N_obs
                    opHan = opHan_cell{i};
                    set(opHan,'ButtonDownFcn',{@LOCALtextbuttondown_obs output opHan});
                end
            else
                opHan_cell1= opHan_cell;
                opHan_cell = cell(1,N_obs);
                for i=1:N_obs
                    r = obs_rad(i);
                    obsi_pos = obs_pos(i,1:2);
                    ox = r*cos(t)+obsi_pos(1);
                    oy = r*sin(t)+obsi_pos(2);
                    opHan = opHan_cell1{i};
                    set(opHan,'XData',ox);
                    set(opHan,'YData',oy);
                    opHan_cell{i} = opHan;
                end
                for i=N_obs+1:N_old_obs
                    delete(opHan_cell1{i});
                end
                for i=1:N_obs
                    opHan = opHan_cell{i};
                    set(opHan,'ButtonDownFcn',{@LOCALtextbuttondown_obs output opHan});
                end
            end
            output.obsHandle_cell = opHan_cell;
            
        end
        
        function LOCALUpdateWayPoint(Esrc,Edata)
            WayData = Edata.AffectedObject.WayPoint;
            
            if isempty(WayData)
                WayData = zeros(0,2);
            end     
            output = Edata.AffectedObject;
            output.waypointPosition = WayData(:,1:2);
            wpHan_cell = output.wayHandle_cell; % old handles
            wtHan_cell = output.waytextH_cell;
            
            aHan = get(output.startHandle,'Parent');
            fHan = get(aHan,'Parent');
            
            set(0,'CurrentFigure',fHan);
            set(get(aHan,'Parent'),'CurrentAxes',aHan);
            
            way_pos = output.WayPoint;
            output.waypointPosition = output.WayPoint;
            [a b] = size(way_pos);
            N_way = a*b/2;
            N_old_way = length(wpHan_cell);
            t =(0:100)*2*pi/100;           
            
            if N_way == 0
                for i=1:N_old_way
                    delete(wpHan_cell{i});
                    delete(wtHan_cell{i});
                end
                wpHan_cell = {};
                wtHan_cell = {};
            elseif N_way>=N_old_way
                for i=1:N_old_way
                    r = 7;
                    wayi_pos = way_pos(i,1:2);
                    wx = r*cos(t)+wayi_pos(1);
                    wy = r*sin(t)+wayi_pos(2);
                    wpHan = wpHan_cell{i};
                    wtHan = wtHan_cell{i};
                    set(wpHan,'XData',wx);
                    set(wpHan,'YData',wy);
                    set(wtHan,'String',num2str(i),'FontSize',7);
                    set(wtHan,'Position',wayi_pos+[0 15]);
                end
                if N_way>N_old_way
                    temp = N_way - N_old_way;
                    wpHan_cell(N_old_way+1:N_way) = cell(1,temp);
                    wtHan_cell(N_old_way+1:N_way) = cell(1,temp);
                    for i=N_old_way+1:N_way
                        r = 7;
                        wayi_pos = way_pos(i,1:2);
                        wx = r*cos(t)+wayi_pos(1);
                        wy = r*sin(t)+wayi_pos(2);
                        wpHan = patch(wx,wy,'yellow');
                        cm = uicontextmenu;
                        set(wpHan,'uicontextmenu',cm);
                        m1 = uimenu(cm,'Label','Duplicate');
                        m2 = uimenu(cm,'Label','Delete');
                        output.wpcm = cm;
                        wpHan_cell{i} = wpHan;
                        wp = wayi_pos+[0 15];
                        wtHan = text(wp(1),wp(2),num2str(i),'FontSize',7);
                        wtHan_cell{i} = wtHan;
                        set(m1,'Callback',{@LOCALduplicatewaypoint output i})
                        set(m2,'Callback',{@LOCALdeletewaypoint output i})
                    end
                end
                output.wayHandle_cell = wpHan_cell;
                for i=1:N_way
                    wpHan = wpHan_cell{i};
                    set(wpHan,'ButtonDownFcn',{@LOCALtextbuttondown_way output wpHan});
                end
            else
                wpHan_cell1 = wpHan_cell;
                wpHan_cell = cell(1,N_way);
                wtHan_cell1 = wtHan_cell;
                wtHan_cell = cell(1,N_way);
                for i=1:N_way
                    r = 7;
                    wayi_pos = way_pos(i,1:2);
                    wx = r*cos(t)+wayi_pos(1);
                    wy = r*sin(t)+wayi_pos(2);
                    wpHan = wpHan_cell1{i};
                    wtHan = wtHan_cell1{i};
                    set(wpHan,'XData',wx);
                    set(wpHan,'YData',wy);
                    set(wtHan,'Position',wayi_pos+[0 15]);
                    wpHan_cell{i} = wpHan;
                    wtHan_cell{i} = wtHan;
                end
                for i=N_way+1:N_old_way
                    delete(wpHan_cell1{i});
                    delete(wtHan_cell1{i});
                end
                for i=1:N_way
                    wpHan = wpHan_cell{i};
                    set(wpHan,'ButtonDownFcn',{@LOCALtextbuttondown_way output wpHan});
                end
            end
            output.wayHandle_cell = wpHan_cell;
            output.waytextH_cell = wtHan_cell;
            
            AdvFig = Edata.AffectedObject.AdvancedFig;
            temp = 0;
            figs = findobj('type','figure');
            for i = 1:figs
                if figs(i) == AdvFig
                    temp = 1;
                    break
                end
            end
            if temp == 1
                set(0,'CurrentFigure',output.AdvancedFig)
            end
            
        end    
        
        function output = LOCALkeyDetailedFiguresbutton(Esrc,Edata,output)
            Str = Edata.Key;
            if strcmp(Str,'return')
                output = LOCALDetailedFigures(Esrc,Edata,output);
            elseif strcmp(Str,'downarrow') || strcmp(Str,'uparrow')
                uicontrol(output.button1)
            end
        end
        
         function obj = LOCALDetailedFigures(Esrc,Edata,obj)
            scrnsz = get(0,'Screensize');
            obj.DetailedFigH = figure('Position',[scrnsz(3)/2-300 scrnsz(4)/2-225 700 700],...
                'resize','off');
            
            subplot(2,2,1)
            plot(obj.Time,obj.Speed)
            title('Speed vs. Time')
            xlabel('Time [sec]')
            ylabel('Speed [m/s]')
            subplot(2,2,2)
            plot(obj.Time,obj.Acc)
            title('Acceleration vs. Time')
            xlabel('Time [sec]')
            ylabel('Acceleration [m/s^2]')
            subplot(2,2,3)
            plot(obj.Time,obj.Angle)
            title('Turning Angle vs. Time')
            xlabel('Time [sec]')
            ylabel('Turning Angle [deg]')
            subplot(2,2,4)
            plot(obj.Time,obj.Turning_Rate)
            title('Rate of Turning Angle vs. Time')
            xlabel('Time [sec]')
            ylabel('Rate of Turning Angle [deg/s]')
            
         end
         
         
    end % methods
    
end %classdef