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

classdef UserControls < handle
    properties (Hidden = true)
        text1 % Title for Control Box
        text2 % Vehicle Start Title
        text3 % Vehicle X-Start String
        text4 % Vehicle Y-Start String
        text5 % Destination Title
        text6 % Vehicle X-Destination String
        text7 % Vehicle Y-Destination String
        text8 % Obstacle Properties Title
        text9 % New-X Label
        text10 % New Y-Label
        text11 % New Radius Label
        text12 % Edit-X Label
        text13 % Edit-Y Label
        text14 % Edit-Radius Label
        text15 % No. to Edit
        text16 % No. to Delete
        text17 % Current Vehicle Time Title
        text18 % Current Vehicle Position Title
        text19 % Current Vehicle Time
        text20  % Current Vehicle Position
        
        frame1 % X-Start Frame
        frame2 % Y-Start Frame
        frame3 % X-Destination Frame
        frame4 % Y-Destination Frame
        frame5 % Create New Obstacle Frame
        frame6 % New Obstacle X-Position Frame
        frame7 % New Obstacle Y-Position
        frame8 % New Obstacle Radius
        frame9 % Edit Obstacle X-Position
        frame10 % Edit Obstacle Y-Position
        frame11 % Edit Obstacle Radius
        currentframe
        
        edit5 % New X-Position
        edit6 % New Y-Position
        edit7 % New Radius Position
        edit8 % Edit X-Position
        edit9 % Edit Y-Position
        edit10 % Edit Radius
        
        button1 % Reset Start Position Button
        button2 % Reset Destination Position Button
        button3 % Add Obstacle Button
        button4 % Edit Obstacle Button
        button5 % Delete Obstacle Button
        button6 % Accept Create Obstacle Button
        button7 % Cancel Create Obstacle Button
        button8 % Accept Edit Obstacle Button
        button9 % Cancel Edit Obstacle Button
        button10 % Accept Delete Obstacle Button
        button11 % Cancel Delete Obstacle Button
        
        dropdown1 % Select No. to Edit
        dropdown2 % Select No. to Delete
        
        ControlFrame % User Control Frame
        Advancedbutton % Advanced Options Button
        Startbutton % Start Simulation Button
        Pausebutton % Pause Simulation Button
        Resetbutton % Reset Simulation Button
        import % Button to import from Excel
        
        importtext % Text in import box
        importedit % Field to enter location of Excel file
        importbrowse % Button to browse for file
        importaccept % Button to accpet location
        importback % Button to go back to create obstacle
        importcancel % Cancel Creation of Obstacle(s)
        
        % Default Values for Advanced Options: All these values act as
        % temporary values, which are then updated to permanent varaibles
        % when the user saves changes.
        VelocityCheck = 1;
        AccelerationCheck = 1;
        DecelerationCheck = 1;
        COFCheck = 1;
        VisionCheck = 0;
        SeeVisionCheck = 0;
        SeePathCheck = 0;
        WayPointCheck = 0;
        
        % Handles to Advanced Options uicontrols
        advcheck1 % Check Max Velocity
        advcheck2 % Check Max Acceleration
        advcheck3 % Check Max Deceleration
        advcheck4 % Check COF
        advcheck5 % Check Vision Range
        advcheck6 % Check See Vision Range
        advcheck7 % Check Display Path
        advcheck8 % Check WayPoints
        
        advtext1 % Max Velocity text1
        advtext2 % Max Velocity text2
        advtext3 % Max Velocity units
        advtext4 % Max Acceleration text1
        advtext5 % Max Acceleration text2
        advtext6 % Max Acceleration units
        advtext7 % Max Deceleration text1
        advtext8 % Max Deceleration text2
        advtext9 % Max Deceleration units
        advtext10 % COF text1
        advtext11 % COF text2
        advtext12 % Vision Range text1
        advtext13 % Vision Range text2
        advtext14 % Vision Range text3
        advtext15 % Vision Range Units
        advtext16 % Display Path text
        advtext17 % Buffer Zone text1
        advtext18 % Buffer Zone text2
        advtext19 % WayPoint text
        advtextnote % Note to signify difference between vision range and buffer value
        advtextturningrate
        advtextturningrate2
        
        advtable1 % WayPoint Data
        
        advedit1 % Max Velocity
        advedit2 % Max Acceleration
        advedit3 % Max Deceleration
        advedit4 % COF
        advedit5 % Vision Range
        advedit6 % Buffer Zone
        adveditturningrate
        
        advstartvelocitytext
        advstartvelocityedit
        advstartvelocitytext2
        advendvelocitytext
        advendvelocityedit
        advendvelocitytext2
        advwayvelocitytext
        advwayvelocityedit
        advwayvelocitytext2
        
        
        NewWayXtext % New Way X-Position text
        NewWayXedit % New Way X-Position edit
        NewWayYtext % New Way Y-Position text
        NewWayYedit % New Way Y-Position edit
        AcceptNewWay % New Way Accept
        ImportNewWay % New Way Import
        ClearWays % New Way Clear
        
        advimporttext % Import File, text1
        advimportframe % Import File, frame
        advimportedit % Import File, edit
        advimportbrowse % Import File, browse
        advimportaccept % Import File, accept
        advimportback % Import File, back
        
        advsave % Save Changes made in the AdvControls
        advapply % Apply Changes made in AdvControls
        advcancel % Cancel Changes made in AdvControls
        
        pathplot% plot of vehicle path
    end
    properties (Access = protected)
    AdvancedFig % Advanced Options Figure
    end    
    properties (SetObservable = true, Access = private)
        edit1 % X-Start Field
        edit2 % Y-Start Field
        edit3 % X-Destination Field
        edit4 % Y-Destination Field
        table1 % Obstacle Table
    end
    properties (SetObservable = true)
        StartPosition = [100,100];
        EndPosition = [900,900];
        ObstacleData = [];
        WayPoint = [];
    end
    properties
        MaxVelocity = 100;
        MaxAcceleration = 25;
        MaxDeceleration = 60;
        COF = 1;
        out1;
        out2;
        VisionRange = inf;
        SeeVisionRange = false;
        DisplayPath = false;
        BufferZone = 10;
        MaxTurningRate = 30;
        StartVelocity = 0;
        EndVelocity = 0;
        WayVelocity = 0;
        timetextH;
        postextH;
    end
    
    methods (Hidden = true)
%% Create the main graphics objects (uicontrols) 
        function obj = UserControls          

            FS = get(gcf,'Position'); % Figure Size
            % Create User Control Frame
            obj.ControlFrame = uicontrol('Style','Frame','Position',[FS(3)-298 0 300 FS(4)+2]);
            % Create Title for Control Box
            obj.text1 = uicontrol('Style','Text','Position',[FS(3)-217 FS(4)-50 150 40],...
                'String','User Controls','FontSize',13,'FontWeight','Bold');
            % Create Vehicle Start Position Control Title
            obj.text2 = uicontrol('Style','Text','Position',[FS(3)-289 FS(4)-100 180 40],...
                'String','Vehicle Starting Position','FontSize',10,'FontWeight','Bold');
            % Create Vehicle Start X-Position Control
            obj.text3 = uicontrol('Style','Text','Position',[FS(3)-274 FS(4)-110 20 18],...
                'String','X: ','FontSize',10,'FontWeight','Bold');
            obj.frame1 = uicontrol('Style','Frame','Position',[FS(3)-254 FS(4)-110 60 20]);
            obj.edit1 = uicontrol('Style','Edit','Position',[FS(3)-253 FS(4)-109 58 18],...
                'String','100','backgroundcolor','w','KeyPressFcn',{@LOCALkeypress obj});
            % Create Vehicle Start Y-Position Control
            obj.text4 = uicontrol('Style','Text','Position',[FS(3)-184 FS(4)-110 20 18],...
                'String','Y: ','FontSize',10,'FontWeight','Bold');
            obj.frame2 = uicontrol('Style','Frame','Position',[FS(3)-164 FS(4)-110 60 20]);
            obj.edit2 = uicontrol('Style','Edit','Position',[FS(3)-163 FS(4)-109 58 18],...
                'String','100','backgroundcolor','w','KeyPressFcn',{@LOCALkeypress obj});
            % Create Start Position reset Button
            obj.button1 = uicontrol('Style','Pushbutton','Position',[FS(3)-84 FS(4)-110 60 20],...
                'String','Refresh','KeyPressFcn',{@LOCALkeypress obj});

            % Create Destination Position Title
            obj.text5 = uicontrol('Style','Text','Position',[FS(3)-289 FS(4)-175 149 40],...
                'String','Destination Postion','FontSize',10,'FontWeight','Bold');
            % Create Destination X-Position Control
            obj.text6 = uicontrol('Style','Text','Position',[FS(3)-274 FS(4)-185 20 18],...
                'String','X: ','FontSize',10,'FontWeight','Bold');
            obj.frame3 = uicontrol('Style','Frame','Position',[FS(3)-254 FS(4)-185 60 20]);
            obj.edit3 = uicontrol('Style','Edit','Position',[FS(3)-253 FS(4)-184 58 18],...
                'String','900','backgroundcolor','w','KeyPressFcn',{@LOCALkeypress obj});
            % Create Destination Y-Position Control
            obj.text7 = uicontrol('Style','Text','Position',[FS(3)-184 FS(4)-185 20 18],...
                'String','Y: ','FontSize',10,'FontWeight','Bold');
            obj.frame4 = uicontrol('Style','Frame','Position',[FS(3)-164 FS(4)-185 60 20]);
            obj.edit4 = uicontrol('Style','Edit','Position',[FS(3)-163 FS(4)-184 58 18],...
                'String','900','backgroundcolor','w','KeyPressFcn',{@LOCALkeypress obj});
            % Create Start Position reset Button
            obj.button2 = uicontrol('Style','Pushbutton','Position',[FS(3)-84 FS(4)-185 60 20],...
                'String','Refresh','KeyPressFcn',{@LOCALkeypress obj});

            % Create Static Obstacles Title
            obj.text8 = uicontrol('Style','Text','Position',[FS(3)-289 FS(4)-250 149 40],...
                'String','Obstacle Properties','FontSize',10,'FontWeight','Bold');
            obj.table1 = uitable('ColumnName',{'X-Pos' 'Y-Pos' 'Radius'},'Data',[],...
                'Position',[FS(3)-286 FS(4)-440 277 200],'enable','inactive');

            % Create Edit Tables Button
            obj.button3 = uicontrol('Style','Pushbutton','Position',[FS(3)-285 FS(4)-475 85 28],...
                'String','Add Obstacle','KeyPressFcn',{@LOCALkeypress obj});
            obj.button4 = uicontrol('Style','Pushbutton','Position',[FS(3)-190 FS(4)-475 85 28],...
                'String','Edit Obstacle','KeyPressFcn',{@LOCALkeypress obj});
            obj.button5 = uicontrol('Style','Pushbutton','Position',[FS(3)-95 FS(4)-475 85 28],...
                'String','Delete Obstacle','KeyPressFcn',{@LOCALkeypress obj});
            
            % Create Current Vehicle Position
            obj.currentframe = uicontrol('Style','Frame','Position',[FS(3)-285 FS(4)-585 275 100],...
                'Visible','off');
            obj.text17 = uicontrol('style','text','position',[FS(3)-275 FS(4)-525 167-40 18],...
                'String','Current Travel Time:','fontsize',10,'visible','off');
            obj.text18 = uicontrol('style','text','position',[FS(3)-275 FS(4)-560 150-40 18],...
                'String','Current Position:','fontsize',10,'visible','off');
            obj.text19 = uicontrol('style','text','position',[FS(3)-115-15 FS(4)-525 50+30 18],...
                'String','0 sec.','fontsize',10,'visible','off',...
                'HorizontalAlignment','right');
            obj.text20 = uicontrol('style','text','position',[FS(3)-120-15 FS(4)-560 40+80 18],...
                'String','[X,Y]','fontsize',10,'visible','off',...
                'HorizontalAlignment','right');


            % Control for Adding Obstacle
            obj.frame5 = uicontrol('Style','Frame','Position',[FS(3)-285 FS(4)-585 275 100],...
                'Visible','off');
            obj.text9 = uicontrol('Style','Text','Position',[FS(3)-275 FS(4)-515 20 18],...
                'String','X: ','FontSize',10,'FontWeight','Bold','Visible','Off');
            obj.frame6 = uicontrol('Style','Frame','Position',[FS(3)-255 FS(4)-515 80 20],...
                'Visible','off');
            obj.edit5 = uicontrol('Style','Edit','Position',[FS(3)-254 FS(4)-514 78 18],...
                'Visible','off','backgroundcolor','w','KeyPressFcn',{@LOCALkeypress obj});

            obj.text10 = uicontrol('Style','Text','Position',[FS(3)-275 FS(4)-545 20 18],...
                'String','Y: ','FontSize',10,'FontWeight','Bold','Visible','off');
            obj.frame7 = uicontrol('Style','Frame','Position',[FS(3)-255 FS(4)-545 80 20],...
                'Visible','off');
            obj.edit6 = uicontrol('Style','Edit','Position',[FS(3)-254 FS(4)-544 78 18],...
                'Visible','off','backgroundcolor','w','KeyPressFcn',{@LOCALkeypress obj});

            obj.text11 = uicontrol('Style','Text','Position',[FS(3)-275 FS(4)-575 20 18],...
                'String','R: ','FontSize',10,'FontWeight','Bold','Visible','off');
            obj.frame8 = uicontrol('Style','Frame','Position',[FS(3)-255 FS(4)-575 80 20],...
                'Visible','off');
            obj.edit7 = uicontrol('Style','Edit','Position',[FS(3)-254 FS(4)-574 78 18],...
                'Visible','off','backgroundcolor','w','KeyPressFcn',{@LOCALkeypress obj});

            obj.button6 = uicontrol('Style','Pushbutton','Position',[FS(3)-135 FS(4)-519 100 28],...
                'String','Accept','Visible','off','KeyPressFcn',{@LOCALkeypress obj});
            obj.import = uicontrol('Style','Pushbutton','Position',[FS(3)-135 FS(4)-549 100 28],...
                'String','Import','Visible','off','KeyPressFcn',{@LOCALkeypress obj});
            obj.button7 = uicontrol('Style','Pushbutton','Position',[FS(3)-135 FS(4)-579 100 28],...
                'String','Cancel','Visible','off','KeyPressFcn',{@LOCALkeypress obj});

            % Control for Editing Obstacle: Use frame5
            obj.text12 = uicontrol('Style','Text','Position',[FS(3)-275 FS(4)-534 20 18],...
                'String','X: ','FontSize',10,'FontWeight','Bold','Visible','off');
            obj.frame9 = uicontrol('Style','Frame','Position',[FS(3)-255 FS(4)-534 80 20],...
                'Visible','off');
            obj.edit8 = uicontrol('Style','Edit','Position',[FS(3)-254 FS(4)-533 78 18],...
                'Visible','off','backgroundcolor','w','KeyPressFcn',{@LOCALkeypress obj});

            obj.text13 = uicontrol('Style','Text','Position',[FS(3)-275 FS(4)-558 20 18],...
                'String','Y: ','FontSize',10,'FontWeight','Bold','Visible','off');
            obj.frame10 = uicontrol('Style','Frame','Position',[FS(3)-255 FS(4)-558 80 20],...
                'Visible','off');
            obj.edit9 = uicontrol('Style','Edit','Position',[FS(3)-254 FS(4)-557 78 18],...
                'Visible','off','backgroundcolor','w','KeyPressFcn',{@LOCALkeypress obj});

            obj.text14 = uicontrol('Style','Text','Position',[FS(3)-275 FS(4)-582 20 18],...
                'String','R: ','FontSize',10,'FontWeight','Bold','Visible','off');
            obj.frame11 = uicontrol('Style','Frame','Position',[FS(3)-255 FS(4)-582 80 20],...
                'Visible','off');
            obj.edit10 = uicontrol('Style','Edit','Position',[FS(3)-254 FS(4)-581 78 18],...
                'Visible','off','backgroundcolor','w','KeyPressFcn',{@LOCALkeypress obj});

            obj.text15 = uicontrol('Style','Text','Position',[FS(3)-275 FS(4)-512 25 18],...
                'String','No.  ','FontSize',10,'FontWeight','Bold','Visible','off');
            obj.dropdown1 = uicontrol('Style','popupmenu','Position',[FS(3)-255 FS(4)-509 80 20],...
                'Visible','off','String',{'Select'},'backgroundcolor','w');

            obj.button8 = uicontrol('Style','Pushbutton','Position',[FS(3)-135 FS(4)-529 100 28],...
                'String','Accept Changes','Visible','off','KeyPressFcn',{@LOCALkeypress obj});
            obj.button9 = uicontrol('Style','Pushbutton','Position',[FS(3)-135 FS(4)-569 100 28],...
                'String','Cancel','Visible','off','KeyPressFcn',{@LOCALkeypress obj});
    
            % Control for Deleting Obstacles: Use Frame5
            obj.text16 = uicontrol('Style','text','Position',[FS(3)-265 FS(4)-547 22 18],...
                'String','No.  ','Fontsize',10,'Fontweight','bold','Visible','off');
            obj.dropdown2 = uicontrol('Style','edit','Position',[FS(3)-241 FS(4)-545 80 20],...
                'String','','Visible','off','backgroundcolor','w','HorizontalAlignment','left',...
                'KeyPressFcn',{@LOCALkeypress obj});

            obj.button10 = uicontrol('Style','Pushbutton','Position',[FS(3)-135 FS(4)-529 100 28],...
                'String','Delete','Visible','off','KeyPressFcn',{@LOCALkeypress obj});
            obj.button11 = uicontrol('Style','Pushbutton','Position',[FS(3)-135 FS(4)-569 100 28],...
                'String','Cancel','Visible','off','KeyPressFcn',{@LOCALkeypress obj});

            % Advanced Options Button
            obj.Advancedbutton = uicontrol('Style','Pushbutton','Position',[FS(3)-210 60 125 28],...
                'String','Advanced Options','KeyPressFcn',{@LOCALkeypress obj});

            % Create Start, Stop, and Reset All Buttons
            obj.Startbutton = uicontrol('Style','Pushbutton','Position',[FS(3)-273 20 120 30],...
                'String','START','KeyPressFcn',{@LOCALkeypress obj});
            obj.Resetbutton = uicontrol('Style','Pushbutton','Position',[FS(3)-143 20 120 30],...
                'String','RESET','enable','off','KeyPressFcn',{@LOCALkeypress obj});
            obj.Pausebutton = uicontrol('Style','Pushbutton','Position',[FS(3)-273 20 120 30],...
                'String','PAUSE','visible','off','KeyPressFcn',{@LOCALkeypress obj});
            
            % Create Controls for import
            obj.importtext = uicontrol('style','text','position',[FS(3)-272 FS(4)-520 185 20],...
                'string','Specify location of Excel file to import:','visible','off');
            obj.importedit = uicontrol('style','edit','position',[FS(3)-275 FS(4)-545 160 20],...
                'backgroundcolor','w','HorizontalAlignment','left','visible','off');
            obj.importbrowse = uicontrol('Style','pushbutton','position',[FS(3)-109 FS(4)-547 90 24],...
                'string','Browse...','visible','off','visible','off',...
                'KeyPressFcn',{@LOCALkeypress obj});
            obj.importaccept = uicontrol('style','pushbutton','position',[FS(3)-276 FS(4)-576 83 24],...
                'String','Import','visible','off','KeyPressFcn',{@LOCALkeypress obj});
            obj.importback = uicontrol('style','pushbutton','position',[FS(3)-189 FS(4)-576 83 24],...
                'String','Back','visible','off','KeyPressFcn',{@LOCALkeypress obj});
            obj.importcancel = uicontrol('style','pushbutton','position',[FS(3)-102 FS(4)-576 83 24],...
                'String','Cancel','visible','off','KeyPressFcn',{@LOCALkeypress obj});
            
%% Assign the Callbacks

            % Rest Start Position
            set(obj.button1,'Callback',{@LOCALrefreshstart obj})
            % Reset Goal Posiition
            set(obj.button2,'Callback',{@LOCALrefreshgoal obj})
            % Open Create New Obstacle
            set(obj.button3,'Callback',{@LOCALopennewobstacle obj});
            % Open Edit Obstacle
            set(obj.button4,'Callback',{@LOCALopeneditobstacle obj})
            % Open Delete  Obstacle
            set(obj.button5,'Callback',{@LOCALopendeleteobstacle obj})
            % Confirm Creation
            set(obj.button6,'Callback',{@LOCALcreateobstacle obj})
            % Cancel Creation
            set(obj.button7,'Callback',{@LOCALcancelobstacle obj})
            % Confirm Edit
            set(obj.button8,'Callback',{@LOCALeditobstacle obj})
            % Cancel Edit
            set(obj.button9,'Callback',{@LOCALcanceledit obj})
            % Confirm Delete
            set(obj.button10,'Callback',{@LOCALdeleteobstacle obj})
            % Cancel Delete
            set(obj.button11,'Callback',{@LOCALcanceldelete obj})
            % Advanced Button
            set(obj.Advancedbutton,'Callback',{@LOCALadvanced obj});
            % Start Button
            set(obj.Startbutton,'Callback',{@LOCALstart obj});
            % Pause Button
            set(obj.Pausebutton,'Callback',{@LOCALpause obj});
            % Reset Button
            set(obj.Resetbutton,'Callback',{@LOCALreset obj});
            % Import Button
            set(obj.import,'Callback',{@LOCALimport obj});
            % Import Browse
            set(obj.importbrowse,'Callback',{@LOCALbrowse obj});
            % Import Accept
            set(obj.importaccept,'Callback',{@LOCALimportaccept obj});
            % Import Back
            set(obj.importback,'Callback',{@LOCALimportback obj});
            %Import Cancel
            set(obj.importcancel,'Callback',{@LOCALimportcancel obj});
            
%% Set the Value Properties of UserControls
            obj.VelocityCheck = 1;
            obj.AccelerationCheck = 1;
            obj.DecelerationCheck = 1;
            obj.COFCheck = 1;
            obj.VisionCheck = 0;
            obj.SeeVisionCheck = 0;
            obj.SeePathCheck = 0;
            obj.WayPointCheck = 0;
            
            obj.StartPosition = [50,100];
            obj.EndPosition = [800,900];
            obj.ObstacleData = [];
            obj.WayPoint = [];
            obj.MaxVelocity = 100;
            obj.MaxAcceleration = 25;
            obj.MaxDeceleration = 60;
            obj.COF = 1;
            obj.VisionRange = inf;
            obj.SeeVisionRange = false;
            obj.DisplayPath = false;
            obj.BufferZone = 10;
            obj.MaxTurningRate = 30;
            obj.StartVelocity = 0;
            obj.EndVelocity = 0;
            obj.WayVelocity = 0;
%% Create Listeners for changes to Start, End, Obstacles, and WayPoints

            addlistener(obj,'StartPosition','PostSet',@UserControls.ChangeStart);
            addlistener(obj,'EndPosition','PostSet',@UserControls.ChangeEnd);
            addlistener(obj,'ObstacleData','PostSet',@UserControls.ChangeObstacles);
            addlistener(obj,'WayPoint','PostSet',@UserControls.ChangeWayPoints);
        end % End the Constructer Method

        function obj = LOCALkeypress(Esrc,Edata,obj)
            % Determine which object property the key is being pressed for
            switch Esrc
                case obj.edit1
                    switch Edata.Key
                        case 'return'
                            uicontrol(obj.button1)
                            obj = LOCALrefreshstart(Esrc,Edata,obj);
                    end
                case obj.edit2
                    switch Edata.Key
                        case 'return'
                            uicontrol(obj.button1)
                            obj = LOCALrefreshstart(Esrc,Edata,obj);
                    end
                case obj.button1
                    switch Edata.Key
                        case 'return'
                            obj = LOCALrefreshstart(Esrc,Edata,obj);
                    end
                case obj.edit3
                    switch Edata.Key
                        case 'return'
                            uicontrol(obj.button2)
                            obj = LOCALrefreshgoal(Esrc,Edata,obj);
                    end
                case obj.edit4
                    switch Edata.Key
                        case 'return'
                            uicontrol(obj.button2)
                            obj = LOCALrefreshgoal(Esrc,Edata,obj);
                    end
                case obj.button2
                    switch Edata.Key
                        case 'return'
                            obj = LOCALrefreshgoal(Esrc,Edata,obj);
                    end
                case obj.button3
                    switch Edata.Key
                        case 'leftarrow'
                            uicontrol(obj.button5)
                        case 'rightarrow'
                            uicontrol(obj.button4)
                        case 'return'
                            obj = LOCALopennewobstacle(Esrc,Edata,obj);
                    end
                case obj.button4
                    switch Edata.Key
                        case 'leftarrow'
                            uicontrol(obj.button3)
                        case 'rightarrow'
                            uicontrol(obj.button5)
                        case 'return'
                            obj = LOCALopeneditobstacle(Esrc,Edata,obj);
                    end
                case obj.button5
                    switch Edata.Key
                        case 'leftarrow'
                            uicontrol(obj.button4)
                        case 'rightarrow'
                            uicontrol(obj.button3)
                        case 'return'
                            obj = LOCALopendeleteobstacle(Esrc,Edata,obj);
                    end
                case obj.edit5
                    switch Edata.Key
                        case 'downarrow'
                            uicontrol(obj.edit6)
                        case 'uparrow'
                            uicontrol(obj.edit7)
                        case 'return'
                            obj = LOCALcreateobstacle(Esrc,Edata,obj);
                    end
                case obj.edit6
                    switch Edata.Key
                        case 'downarrow'
                            uicontrol(obj.edit7)
                        case 'uparrow'
                            uicontrol(obj.edit5)
                        case 'return'
                            obj = LOCALcreateobstacle(Esrc,Edata,obj);
                    end
                case obj.edit7
                    switch Edata.Key
                        case 'downarrow'
                            uicontrol(obj.edit5)
                        case 'uparrow'
                            uicontrol(obj.edit6)
                        case 'return'
                            obj = LOCALcreateobstacle(Esrc,Edata,obj);
                    end
                case obj.button6
                    switch Edata.Key
                        case 'downarrow'
                            uicontrol(obj.import)
                        case 'uparrow'
                            uicontrol(obj.button7)
                        case 'return'
                            obj = LOCALcreateobstacle(Esrc,Edata,obj);
                    end
                case obj.import
                    switch Edata.Key
                        case 'downarrow'
                            uicontrol(obj.button7)
                        case 'uparrow'
                            uicontrol(obj.button6)
                        case 'return'
                            obj = LOCALimport(Esrc,Edata,obj);
                    end
                case obj.button7
                    switch Edata.Key
                        case 'downarrow'
                            uicontrol(obj.button6)
                        case 'uparrow'
                            uicontrol(obj.import)
                        case 'return'
                            obj = LOCALcancelobstacle(Esrc,Edata,obj);
                    end
                case obj.importbrowse
                    switch Edata.Key
                        case 'return'
                            obj = LOCALbrowse(Esrc,Edata,obj);
                        case 'downarrow'
                            uicontrol(obj.importcancel)
                    end
                case obj.importaccept
                    switch Edata.Key
                        case 'return'
                            obj = LOCALimportaccept(Esrc,Edata,obj);
                        case 'leftarrow'
                            uicontrol(obj.importcancel)
                        case 'rightarrow'
                            uicontrol(obj.importback)
                        case 'uparrow'
                            uicontrol(obj.importbrowse)
                    end
                case obj.importback
                    switch Edata.Key
                        case 'return'
                            obj = LOCALimportback(Esrc,Edata,obj);
                        case 'leftarrow'
                            uicontrol(obj.importaccept)
                        case 'rightarrow'
                            uicontrol(obj.importcancel)
                        case 'uparrow'
                            uicontrol(obj.importbrowse)
                    end
                case obj.importcancel
                    switch Edata.Key
                        case 'reutrn'
                            obj = LOCALimportcancel(Esrc,Edata,obj);
                        case 'leftarrow'
                            uicontrol(obj.importback)
                        case 'rightarrow'
                            uicontrol(obj.importaccept)
                        case 'uparrow'
                            uicontrol(obj.importbrowse)
                    end
                case obj.edit8
                    switch Edata.Key
                        case 'downarrow'
                            uicontrol(obj.edit9)
                        case 'uparrow'
                            uicontrol(obj.edit10)
                        case 'return'
                            obj = LOCALeditobstacle(Esrc,Edata,obj);
                    end
                case obj.edit9
                    switch Edata.Key
                        case 'downarrow'
                            uicontrol(obj.edit10)
                        case 'uparrow'
                            uicontrol(obj.edit8)
                        case 'return'
                            obj = LOCALeditobstacle(Esrc,Edata,obj);
                    end
                case obj.edit10
                    switch Edata.Key
                        case 'downarrow'
                            uicontrol(obj.edit8)
                        case 'uparrow'
                            uicontrol(obj.edit9)
                        case 'return'
                            obj = LOCALeditobstacle(Esrc,Edata,obj);
                    end
                case obj.button8
                    switch Edata.Key
                        case 'uparrow'
                            uicontrol(obj.button9)
                        case 'downarrow'
                            uicontrol(obj.button9)
                        case 'return'
                            obj = LOCALeditobstacle(Esrc,Edata,obj);
                    end
                case obj.button9
                    switch Edata.Key
                        case 'uparrow'
                            uicontrol(obj.button8)
                        case 'downarrow'
                            uicontrol(obj.button8)
                        case 'return'
                            obj = LOCALcanceledit(Esrc,Edata,obj);
                    end
                case obj.button10
                    switch Edata.Key
                        case 'uparrow'
                            uicontrol(obj.button11)
                        case 'downarrow'
                            uicontrol(obj.button11)
                        case 'return'
                            obj = LOCALdeleteobstacle(Esrc,Edata,obj);
                    end
                case obj.button11
                    switch Edata.Key
                        case 'uparrow'
                            uicontrol(obj.button10)
                        case 'downarrow'
                            uicontrol(obj.button10)
                        case 'return'
                            obj = LOCALcanceldelete(Esrc,Edata,obj);
                    end
                case obj.Advancedbutton
                    switch Edata.Key
                        case 'downarrow'
                            uicontrol(obj.Startbutton)
                        case 'return'
                            obj = LOCALadvanced(Esrc,Edata,obj);
                    end
                case obj.Startbutton
                    switch Edata.Key
                        case 'return'
                            obj = LOCALstart(Esrc,Edata,obj);
                        case 'leftarrow'
                            if strcmp(get(obj.Resetbutton,'enable'),'on')
                                uicontrol(obj.Resetbutton)
                            end
                        case 'rightarrow'
                            if strcmp(get(obj.Resetbutton,'enable'),'on')
                                uicontrol(obj.Resetbutton)
                            end
                        case 'uparrow'
                            if strcmp(get(obj.Advancedbutton,'enable'),'on')
                                uicontrol(obj.Advancedbutton)
                            end
                    end
                case obj.Pausebutton
                    switch Edata.Key
                        case 'return'
                            obj = LOCALpause(Esrc,Edata,obj);
                    end
                case obj.Resetbutton
                    switch Edata.Key
                        case 'return'
                            obj = LOCALReset(Esrc,Edata,obj);
                        case 'leftarrow'
                            uicontrol(obj.Startbutton)
                        case 'rightarrow'
                            uicontrol(obj.Startbutton)
                    end
                case obj.dropdown2
                    switch Edata.Key
                        case 'return'
                            uicontrol(obj.button11)
                            obj = LOCALdeleteobstacle(Esrc,Edata,obj);
                        case 'rightarrow'
                            uicontrol(obj.button11)
                    end
            end
        end
        
        function obj = LOCALkeycloseerror(~,~,obj)
            close(gcf)
        end

        function obj = LOCALrefreshstart(~,~,obj)
            Value1 = str2double(get(obj.edit1,'String'));
            Value2 = str2double(get(obj.edit2,'String'));
            if Value1 < 0 || Value1 > 1000 || Value2 < 0 || Value2 > 1000 || isnan(Value1) || isnan(Value2)
                scrnsz = get(0,'ScreenSize');
                figure('Position',[scrnsz(3)/2-225 scrnsz(4)/2-100 450 200],'Menubar','none',...
                    'resize','off')
                uicontrol('Style','text','String',['ERROR: All inputs must be real numerical',...
                    ' values between 0 and 1000.'],'Position',[25 50 400 100],...
                    'fontsize',12,'backgroundcolor',[.8 .8 .8]);
                temp = uicontrol('Style','Pushbutton','Position',[185 45 80 25],'String','OK','Callback','close(gcf)',...
                    'KeyPressFcn',{@LOCALkeycloseerror obj});
                uicontrol(temp);
            else
                obj.StartPosition = [Value1,Value2];
                obj.startPosition = [Value1,Value2];
                uicontrol(obj.button1);
            end
        end
        
        function obj = LOCALrefreshgoal(~,~,obj)
            Value1 = str2double(get(obj.edit3,'String'));
            Value2 = str2double(get(obj.edit4,'String'));
            if Value1 < 0 || Value1 > 1000 || Value2 < 0 || Value2 > 1000 || isnan(Value1) || isnan(Value2)
                scrnsz = get(0,'ScreenSize');
                figure('Position',[scrnsz(3)/2-225 scrnsz(4)/2-100 450 200],'Menubar','none',...
                    'resize','off')
                uicontrol('Style','text','String',['ERROR: All inputs must be real numerical',...
                    ' values between 0 and 1000.'],'Position',[25 50 400 100],...
                    'fontsize',12,'backgroundcolor',[.8 .8 .8])
                temp = uicontrol('Style','Pushbutton','Position',[185 45 80 25],'String','OK','Callback','close(gcf)',...
                    'KeyPressFcn',{@LOCALkeycloseerror obj});
                uicontrol(temp)
            else            
                obj.EndPosition = [Value1,Value2];
                obj.destPosition = [Value1,Value2];
                uicontrol(obj.button2);
            end
        end
                  
        function obj = LOCALopennewobstacle(~,~,obj)
            set(obj.button3,'enable','off')
            set(obj.button4,'enable','off')
            set(obj.button5,'enable','off')
            set(obj.frame5,'visible','on')
            set(obj.frame6,'visible','on')
            set(obj.frame7,'visible','on')
            set(obj.frame8,'visible','on')
            set(obj.edit5,'visible','on')
            set(obj.edit6,'visible','on')
            set(obj.edit7,'visible','on')
            set(obj.text9,'visible','on')
            set(obj.text10,'visible','on')
            set(obj.text11,'visible','on')
            set(obj.button6,'visible','on')
            set(obj.button7,'visible','on')
            set(obj.import','visible','on')
            set(obj.Startbutton,'enable','off')
            set(obj.Advancedbutton,'enable','off')
            uicontrol(obj.edit5);
        end

        function obj = LOCALcreateobstacle(Esrc,Edata,obj)
            uicontrol(obj.button6)
            newx = get(obj.edit5,'String');
            newy = get(obj.edit6,'String');
            newr = get(obj.edit7,'String');
            newx = str2double(newx); newy = str2double(newy); newr = str2double(newr);
            if isnan(newx) || isnan (newy) || isnan(newr) || newx < 0 || newx > 1000 || newy < 0 || newy > 1000 || newr <= 0 || newr > 100
                scrnsz = get(0,'ScreenSize');
                figure('Position',[scrnsz(3)/2-225 scrnsz(4)/2-100 450 200],'Menubar','none',...
                    'resize','off')
                uicontrol('Style','text','String',['ERROR: All inputs must be real numerical',...
                    ' values. X and Y position values must be between 0 and 1000 and the radius',...
                    ' must be valued between 0 and 100.'],'Position',[25 50 400 100],...
                    'fontsize',12,'backgroundcolor',[.8 .8 .8])
                temp = uicontrol('Style','Pushbutton','Position',[185 45 80 25],'String','OK','Callback','close(gcf)',...
                    'KeyPressFcn',{@LOCALkeycloseerror obj});
                uicontrol(temp);
            else
                tabledata = get(obj.table1,'Data');
                sz = size(tabledata); height = sz(1);
                tabledata(height+1,:) = [newx newy newr];
                set(obj.table1,'Data',tabledata);
                obj.ObstacleData = tabledata;
                LOCALcancelobstacle(Esrc,Edata,obj);
                uicontrol(obj.button3);
            end
        end
        
        function obj = LOCALimport(Esrc,Edata,obj)
            LOCALcancelobstacle(Esrc,Edata,obj);
            set(obj.frame5,'visible','on');
            set(obj.button3,'enable','off');
            set(obj.button4,'enable','off');
            set(obj.button5,'enable','off');
            set(obj.Advancedbutton,'enable','off');
            set(obj.Startbutton,'enable','off');
            set(obj.importtext,'visible','on');
            set(obj.importedit,'visible','on');
            set(obj.importbrowse,'visible','on');
            set(obj.importaccept,'visible','on');
            set(obj.importback,'visible','on');
            set(obj.importcancel,'visible','on');
            uicontrol(obj.importbrowse);
        end
        
        function obj = LOCALbrowse(~,~,obj)
            [FileName,PathName] = uigetfile({'*.xlsx';'*.xls'},'Select File to Import');
            if isa(FileName,'char')
                if isempty(regexp(FileName,'.xlsx?$','once'))
                    set(obj.importedit,'string','Error: File must be ''.xlsx'' or ''.xls''',...
                    'ForegroundColor','r','ButtonDownFcn',{@LOCALupdateimport obj},...
                    'enable','inactive')
                % There appears to be a bug in this version of Matlab (7.9.0
                % R2009b) that requires 'enable' to be set to 'inactive' in
                % order to make the left click for 'ButtonDownFcn' work. The
                % Mathworks website claims this is fixed in a later version.
                uicontrol(obj.importbrowse);
                else
                    set(obj.importedit,'string',[PathName,FileName])
                    uicontrol(obj.importaccept);
                end
            end
        end
        
        function obj = LOCALupdateimport(~,~,obj)
            set(obj.importedit,'foregroundcolor','k','ButtonDownFcn','',...
                'String','','enable','on');            
        end
        
        function obj = LOCALimportaccept(Esrc,Edata,obj)
            try
                Data = xlsread(get(obj.importedit,'string'));
                sz = size(Data); sz = sz(1)*sz(2);
                Count = 0;
                for i = 1:sz
                    if isnan(Data(i)) || length(Data(1,:)) ~= 3
                        scrnsz = get(0,'ScreenSize');
                        figure('Position',[scrnsz(3)/2-225 scrnsz(4)/2-100 450 200],'Menubar','none',...
                            'resize','off')
                        uicontrol('Style','text','String',['ERROR: The data extraced from the ',...
                            ' Excel worksheet must have numerical values in an N-by-3 array.',...
                            ' The given imported data has unreal elements.'],'Position',[25 50 400 100],...
                            'fontsize',12,'backgroundcolor',[.8 .8 .8])
                        temp = uicontrol('Style','Pushbutton','Position',[185 45 80 25],'String','OK','Callback','close(gcf)',...
                        'KeyPressFcn',{@LOCALkeycloseerror obj});
                        uicontrol(temp);
                        break
                    end
                    Count = Count+1;
                end
                if Count == sz % Then all elements are real and array is N-by-3
                    tabledata = get(obj.table1,'Data');
                    height = size(tabledata); height = height(1);
                    importheight = length(Data(:,1));
                    tabledata(height+1:height+importheight,:) = Data;
                    set(obj.table1,'Data',tabledata);
                    obj.ObstacleData = tabledata;
                    set(obj.importedit,'String','');
                    LOCALimportcancel(Esrc,Edata,obj);
                end
            catch
                scrnsz = get(0,'ScreenSize');
                figure('Position',[scrnsz(3)/2-225 scrnsz(4)/2-100 450 200],'Menubar','none',...
                    'resize','off')
                uicontrol('Style','text','String',['ERROR: The data extraced from the ',...
                    ' Excel worksheet must have numerical values in an N-by-3 array.',...
                    ' The given imported data has unreal elements.'],'Position',[25 50 400 100],...
                    'fontsize',12,'backgroundcolor',[.8 .8 .8])
                temp = uicontrol('Style','Pushbutton','Position',[185 45 80 25],'String','OK','Callback','close(gcf)',...
                'KeyPressFcn',{@LOCALkeycloseerror obj});
                uicontrol(temp);
            end
        end
        
        function LOCALimportback(Esrc,Edata,obj)
            LOCALimportcancel(Esrc,Edata,obj);
            LOCALopennewobstacle(Esrc,Edata,obj);
        end
        
        function LOCALimportcancel(~,~,obj)
            set(obj.importedit,'String','');
            set(obj.frame5,'visible','off');
            set(obj.importtext,'visible','off');
            set(obj.importedit,'visible','off');
            set(obj.importbrowse,'visible','off');
            set(obj.importaccept,'visible','off');
            set(obj.importback,'visible','off');
            set(obj.importcancel,'visible','off');
            set(obj.button3,'enable','on');
            set(obj.button4,'enable','on');
            set(obj.button5,'enable','on');
            set(obj.Advancedbutton,'enable','on');
            set(obj.Startbutton,'enable','on');
        end
            
        function obj = LOCALcancelobstacle(~,~,obj)
            set(obj.edit5,'String','')
            set(obj.edit6,'String','')
            set(obj.edit7,'String','')
            set(obj.frame5,'Visible','off')
            set(obj.frame6,'Visible','off')
            set(obj.frame7,'Visible','off')
            set(obj.frame8,'Visible','off')
            set(obj.edit5,'Visible','off')
            set(obj.edit6,'Visible','off')
            set(obj.edit7,'Visible','off')
            set(obj.button6,'Visible','off')
            set(obj.button7,'Visible','off')
            set(obj.import,'visible','off')
            set(obj.button3,'enable','on')
            set(obj.button4,'enable','on')
            set(obj.button5,'enable','on')
            set(obj.text9,'visible','off')
            set(obj.text10,'visible','off')
            set(obj.text11,'visible','off')
            set(obj.Startbutton,'enable','on')
            set(obj.Advancedbutton,'enable','on')
            uicontrol(obj.button3);
        end

        function obj = LOCALopeneditobstacle(~,~,obj,i1)
            tabledata = get(obj.table1,'Data');
            sz = size(tabledata); height = sz(1);
            dd1 = get(obj.dropdown1,'String');
            for i = 1:height
                dd1{i+1} = i;
            end
            if length(dd1) == 1
                scrnsz = get(0,'ScreenSize');
                figure('Position',[scrnsz(3)/2-225 scrnsz(4)/2-100 450 200],'Menubar','none')
                uicontrol('Style','text','String',['ERROR: There are no '...
                    'obstacles to edit.'],'Position',[25 50 400 100],...
                    'fontsize',12,'backgroundcolor',[.8 .8 .8])
                temp = uicontrol('Style','Pushbutton','Position',[185 45 80 25],'String','OK',...
                    'Callback','close(gcf)',...
                    'KeyPressFcn',{@LOCALkeycloseerror obj});
                uicontrol(temp);
            else
                set(obj.dropdown1,'String',dd1)
                set(obj.dropdown1,'Callback',{@LOCALupdateedit obj})
                if nargin == 4
                    set(obj.dropdown1,'Value',i1+1)
                    tabledata = get(obj.table1,'Data');
                    set(obj.edit8,'String',num2str(tabledata(i1,1)))
                    set(obj.edit9,'String',num2str(tabledata(i1,2)))
                    set(obj.edit10,'String',num2str(tabledata(i1,3)))
                end
                set(obj.button3,'enable','off')
                set(obj.button4,'enable','off')
                set(obj.button5,'enable','off')
                set(obj.frame5,'visible','on')
                set(obj.frame9,'visible','on')
                set(obj.frame10,'visible','on')
                set(obj.frame11,'visible','on')
                set(obj.edit8,'visible','on')
                set(obj.edit9,'visible','on')
                set(obj.edit10,'visible','on')
                set(obj.dropdown1,'visible','on')
                set(obj.text12,'visible','on')
                set(obj.text13,'visible','on')
                set(obj.text14,'visible','on')
                set(obj.text15,'visible','on')
                set(obj.button8,'visible','on')
                set(obj.button9,'visible','on')
                set(obj.Startbutton,'enable','off')
                set(obj.Advancedbutton,'enable','off')
            end
        end

        function obj = LOCALupdateedit(~,~,obj)
            val = get(obj.dropdown1,'Value');
            tabledata = get(obj.table1,'Data');
            if val >= 2
                data = tabledata(val-1,:);
                set(obj.edit8,'String',num2str(data(1)))
                set(obj.edit9,'String',num2str(data(2)))
                set(obj.edit10,'String',num2str(data(3)))
            end
        end

        function obj = LOCALeditobstacle(Esrc,Edata,obj)
            uicontrol(obj.button8)
            newx = get(obj.edit8,'String');
            newy = get(obj.edit9,'String');
            newr = get(obj.edit10,'String');
            val = get(obj.dropdown1,'Value');
            if val == 1
                scrnsz = get(0,'ScreenSize');
                figure('Position',[scrnsz(3)/2-225 scrnsz(4)/2-100 450 200],'Menubar','none')
                uicontrol('Style','text','String',['ERROR: Please select an '...
                    'obstacle to edit.'],'Position',[25 50 400 100],...
                    'fontsize',12,'backgroundcolor',[.8 .8 .8])
                temp = uicontrol('Style','Pushbutton','Position',[185 45 80 25],'String','OK',...
                    'Callback','close(gcf)',...
                    'KeyPressFcn',{@LOCALkeycloseerror obj});
                uicontrol(temp);
            else
                newx = str2double(newx); newy = str2double(newy); newr = str2double(newr);
                if isnan(newx) || isnan (newy) || isnan(newr) || newx < 0 || newx > 1000 || newy < 0 || newy > 1000 || newr <= 0 || newr > 100
                    scrnsz = get(0,'ScreenSize');
                    figure('Position',[scrnsz(3)/2-225 scrnsz(4)/2-100 450 200],'Menubar','none')
                    uicontrol('Style','text','String',['ERROR: All inputs must be real numerical',...
                        ' values. X and Y position values must be between 0 and 1000 and the radius',...
                        ' must be valued between 0 and 100.'],'Position',[25 50 400 100],...
                        'fontsize',12,'backgroundcolor',[.8 .8 .8])
                    temp = uicontrol('Style','Pushbutton','Position',[185 45 80 25],'String','OK',...
                        'Callback','close(gcf)',...
                    'KeyPressFcn',{@LOCALkeycloseerror obj});
                    uicontrol(temp);
                else
                    tabledata = get(obj.table1,'Data');
                    tabledata(val-1,:) = [newx newy newr];
                    set(obj.table1,'Data',tabledata);
                    obj.ObstacleData = tabledata;
                    LOCALcanceledit(Esrc,Edata,obj);
                end
            end
        end

        function obj = LOCALcanceledit(~,~,obj)
            set(obj.edit8,'String','')
            set(obj.edit9,'String','')
            set(obj.edit10,'String','')
            set(obj.frame5,'Visible','off')
            set(obj.frame9,'Visible','off')
            set(obj.frame10,'Visible','off')
            set(obj.frame11,'Visible','off')
            set(obj.edit8,'Visible','off')
            set(obj.edit9,'Visible','off')
            set(obj.edit10,'Visible','off')
            set(obj.button8,'Visible','off')
            set(obj.button9,'Visible','off')
            set(obj.button3,'enable','on')
            set(obj.button4,'enable','on')
            set(obj.button5,'enable','on')
            set(obj.text12,'visible','off')
            set(obj.text13,'visible','off')
            set(obj.text14,'visible','off')
            set(obj.text15,'visible','off')
            set(obj.dropdown1,'visible','off')
            set(obj.dropdown1,'value',1)
            set(obj.Startbutton,'enable','on')
            set(obj.Advancedbutton,'enable','on')
            uicontrol(obj.button4);
        end

        function obj = LOCALopendeleteobstacle(~,~,obj)
            tabledata = get(obj.table1,'Data');
            sz = size(tabledata); height = sz(1);
            
            if height == 0
                scrnsz = get(0,'ScreenSize');
                figure('Position',[scrnsz(3)/2-225 scrnsz(4)/2-100 450 200],'Menubar','none')
                uicontrol('Style','text','String',['ERROR: There are no '...
                    'obstacles to delete.'],'Position',[25 50 400 100],...
                    'fontsize',12,'backgroundcolor',[.8 .8 .8])
                temp = uicontrol('Style','Pushbutton','Position',[185 45 80 25],'String','OK',...
                    'Callback','close(gcf)',...
                    'KeyPressFcn',{@LOCALkeycloseerror obj});
                uicontrol(temp);
            else
                set(obj.frame5,'visible','on')
                set(obj.text16,'visible','on')
                set(obj.dropdown2,'visible','on')
                set(obj.button10,'visible','on')
                set(obj.button11,'visible','on')
                set(obj.button3,'enable','off')
                set(obj.button4,'enable','off')
                set(obj.button5,'enable','off')
                set(obj.Startbutton,'enable','off')
                set(obj.Advancedbutton,'enable','off')
                uicontrol(obj.dropdown2)
            end
        end

        function obj = LOCALdeleteobstacle(Esrc,Edata,obj,i1)
            str = get(obj.dropdown2,'String');
            Val = regexp(str,'[^\d,-]+','match');
            opHan_cell = obj.obsHandle_cell;
            for i2 = 1:length(opHan_cell)
                set(opHan_cell{i2},'FaceColor',[1 0 0])
            end            
            DeleteData = [];
            if ~isempty(Val) || isempty(str) && nargin == 3
                scrnsz = get(0,'ScreenSize');
                figure('Position',[scrnsz(3)/2-225 scrnsz(4)/2-100 450 200],'Menubar','none')
                uicontrol('Style','text','String',['ERROR: Please list obstacles '...
                    'with commas to them and dashes to indicate ranges.'],...
                    'Position',[25 50 400 100],'fontsize',12,'backgroundcolor',[.8 .8 .8])
                temp = uicontrol('Style','Pushbutton','Position',[185 45 80 25],'String','OK',...
                    'Callback','close(gcf)',...
                    'KeyPressFcn',{@LOCALkeycloseerror obj});
                uicontrol(temp);
            else
                Val = regexp(str,'[^,]+','match');
                for i = 1:length(Val)
                    Val2 = regexp(Val{i},'-','match');
                    if ~isempty(Val2)
                        Val3 = regexp(Val{i},'\d+','match');
                        % Should Receive two values only
                        input1 = str2double(Val3{1});
                        input2 = str2double(Val3{2});
                        DeleteData = [DeleteData input1:input2];
                    else
                        DeleteData = [DeleteData str2double(Val{i})];
                    end      
                end
            end
            if nargin == 4
                set(obj.dropdown1,'Value',1)
                set(obj.dropdown1,'Visible','off')
                set(obj.edit8,'String','')
                set(obj.edit8,'Visible','off')
                set(obj.edit9,'String','')
                set(obj.edit9,'Visible','off')
                set(obj.edit10,'String','')
                set(obj.edit10,'Visible','off')
                set(obj.button8,'Visible','off')
                set(obj.button9,'Visible','off')
                set(obj.text12,'Visible','off')
                set(obj.text13,'Visible','off')
                set(obj.text14,'Visible','off')
                set(obj.text15,'Visible','off')
                set(obj.frame9,'Visible','off')
                set(obj.frame10,'Visible','off')
                set(obj.frame11,'Visible','off')
                DeleteData = i1;
            end
            tabledata = get(obj.table1,'Data');
            Count = 0;
            for i = 1:length(DeleteData)
                if DeleteData(i) > length(tabledata(:,1))
                    scrnsz = get(0,'ScreenSize');
                    figure('Position',[scrnsz(3)/2-225 scrnsz(4)/2-100 450 200],'Menubar','none')
                    uicontrol('Style','text','String',['ERROR: Please list obstacles '...
                        'with commas to separate them and dashes to indicate ranges.'],...
                        'Position',[25 50 400 100],'fontsize',12,'backgroundcolor',[.8 .8 .8])
                    temp = uicontrol('Style','Pushbutton','Position',[185 45 80 25],'String','OK',...
                        'Callback','close(gcf)',...
                        'KeyPressFcn',{@LOCALkeycloseerror obj});
                    uicontrol(temp);
                    Count = 1;
                    break
                end
            end
            if Count == 0
                for i = 1:length(DeleteData)
                    if DeleteData(i) == 1
                            tabledata = tabledata(2:end,:);
                    elseif DeleteData(i) == length(tabledata(:,1))
                        tabledata = tabledata(1:end-1,:);
                    else
                        tabledata = [tabledata(1:DeleteData(i)-1,:);tabledata(DeleteData(i)+1:end,:)];
                    end
                    for n = 1:length(DeleteData)
                        if DeleteData(n) > DeleteData(i)
                            DeleteData(n) = DeleteData(n)-1;
                        end
                    end                    
                end
                set(obj.table1,'Data',tabledata)
                obj.ObstacleData = tabledata;
                obj = LOCALcanceldelete(Esrc,Edata,obj);
            end
            
        end

        function obj = LOCALcanceldelete(~,~,obj)
            set(obj.frame5,'Visible','off')
            set(obj.button10,'Visible','off')
            set(obj.button11,'Visible','off')
            set(obj.table1,'enable','inactive')
            set(obj.button3,'enable','on')
            set(obj.button4,'enable','on')
            set(obj.button5,'enable','on')
            set(obj.text16,'visible','off')
            set(obj.dropdown2,'visible','off')
            set(obj.dropdown2,'string','')
            set(obj.dropdown1,'String',{'Select'})
            set(obj.Startbutton,'enable','on')
            set(obj.Advancedbutton,'enable','on')
            uicontrol(obj.button5);
        end

        function obj = LOCALstart(~,~,obj)
            Start = obj.StartPosition;
            End = obj.EndPosition;
            [a b] = size(obj.WayPoint);
            vi = [obj.StartVelocity;ones(a,1)*obj.WayVelocity;obj.EndVelocity];
            opHan_cell = obj.obsHandle_cell;
            wpHan_cell = obj.wayHandle_cell;            
            if isempty(obj.WayPoint)
                WayData = zeros(0,2);
            else
                WayData = obj.WayPoint;
            end
            if ~isempty(opHan_cell)
                for i=1:length(opHan_cell)
                    set(opHan_cell{i},'FaceColor',[1 0 0]);
                end
            end
            if ~isempty(wpHan_cell)
                for i=1:length(wpHan_cell)
                    set(wpHan_cell{i},'FaceColor',[1 1 0]);
                end
            end
            if obj.GoFlag == 0 % Paused
                Start = obj.Path(obj.out2.i,1:2);                
                ni = obj.out1.ni(2:end-1);
                ni2 = ni;
                vi1 = vi(2:end);
                if ~isempty(ni)
                    for i = 1:length(ni)
                        if obj.out2.i >= ni2(i)
                            ni(1) = [];
                            vi1(1) = [];
                        end
                    end
                    WayData = obj.Path(ni,:);
%                     ni = [obj.out2.i;ni1];
                    vi = [obj.StartVelocity;vi1];
                end
                obj.GoFlag = 1;
            end
            if ~isempty(obj.out2)
                delete(obj.out2.p1);
                delete(obj.out2.p2);
                delete(obj.out2.p3);
                delete(obj.out2.speedo);
                delete(obj.out2.angleo);
                delete(obj.out2.vehicleH);
                if ~isempty(obj.out2.pathH)
                    delete(obj.out2.pathH);
                    obj.out2.pathH = [];
                end
                if ~isempty(obj.out2.visionH)
                    delete(obj.out2.visionH);
                    obj.out2.visionH = [];
                end
            end
            set(obj.edit1,'string',num2str(Start(1)));
            set(obj.edit2,'String',num2str(Start(2)));
            set(obj.edit3,'String',num2str(End(1)));
            set(obj.edit4,'String',num2str(End(2)));
            set(obj.edit1,'enable','off');
            set(obj.edit2,'enable','off');
            set(obj.edit3,'enable','off');
            set(obj.edit4,'enable','off');
            set(obj.button1,'enable','off');
            set(obj.button2,'enable','off');
            set(obj.button3,'enable','off');
            set(obj.button4,'enable','off');
            set(obj.button5,'enable','off');
            set(obj.Advancedbutton,'enable','off');
            set(obj.Resetbutton,'enable','off');
            
            set(obj.currentframe,'visible','on');
            set(obj.text17,'visible','on');
            set(obj.text18,'visible','on');
            set(obj.text19,'visible','on');
            set(obj.text20,'visible','on');
            set(obj.Startbutton,'visible','off');
            set(obj.Pausebutton,'visible','on');
            uicontrol(obj.Pausebutton);
            if isempty(obj.ObstacleData)
                ObsData = zeros(0,3);
            else
                ObsData = obj.ObstacleData;
            end

            if strcmp(get(obj.Resetbutton,'enable'),'off')
                [obj.Path,ni] = mainProgram(Start,WayData,obj.EndPosition,...
                    ObsData(:,1:2),ObsData(:,3)+obj.BufferZone,...
                    1,obj.VisionRange-obj.BufferZone);

                obj.out1 = mechanics(obj.Path(:,1),obj.Path(:,2),obj.MaxVelocity,...
                    obj.MaxAcceleration,obj.MaxDeceleration,obj.COF,obj.MaxTurningRate,...
                    ni,vi,obj);
                obj.out2 = Move(obj,obj.Path,obj.out1.Speed,obj.VisionRange,...
                    obj.SeeVisionRange,obj.DisplayPath,obj.out1.Angle,obj.speedaxesH,obj.angleaxesH);
                set(obj.Pausebutton,'visible','off')
                set(obj.Startbutton,'visible','on')
                set(obj.Resetbutton,'enable','on')
            end
        end

        function obj = LOCALpause(~,~,obj)
            set(obj.Pausebutton,'visible','off')
            set(obj.Startbutton,'visible','on')
            set(obj.Resetbutton,'enable','on')
            set(obj.edit1,'enable','on')
            set(obj.edit2,'enable','on')
            set(obj.edit3,'enable','on')
            set(obj.edit4,'enable','on')
            set(obj.button1,'enable','on')
            set(obj.button2,'enable','on')
            set(obj.button3,'enable','on')
            set(obj.button4,'enable','on')
            set(obj.button5,'enable','on') 
            set(obj.Advancedbutton,'enable','on')
            obj.GoFlag = 0;
            uicontrol(obj.Startbutton)
        end

        function obj = LOCALreset(~,~,obj)
            obj.GoFlag = 1;
            if ~isempty(obj.out2)
                delete(obj.out2.p1);
                delete(obj.out2.p2);
                delete(obj.out2.p3);
                delete(obj.out2.speedo);
                delete(obj.out2.angleo);
                delete(obj.out2.vehicleH);
                if ~isempty(obj.out2.pathH)
                    delete(obj.out2.pathH);
                    obj.out2.pathH = [];
                end
                if ~isempty(obj.out2.visionH)
                    delete(obj.out2.visionH);
                    obj.out2.visionH = [];
                end
                obj.out2 = [];
            end
            set(obj.edit1,'enable','on')
            set(obj.edit2,'enable','on')
            set(obj.edit3,'enable','on')
            set(obj.edit4,'enable','on')
            set(obj.button1,'enable','on')
            set(obj.button2,'enable','on')
            set(obj.button3,'enable','on')
            set(obj.button4,'enable','on')
            set(obj.button5,'enable','on')
            set(obj.Advancedbutton,'enable','on')
            set(obj.Resetbutton,'enable','off')

            set(obj.currentframe,'visible','off')
            set(obj.text17,'visible','off')
            set(obj.text18,'visible','off')
            set(obj.text19,'visible','off')
            set(obj.text20,'visible','off')
            delete(obj.pathplot)
        end
        
        function obj = LOCALadvanced(~,~,obj)
            set(obj.edit1,'enable','off')
            set(obj.edit2,'enable','off')
            set(obj.edit3,'enable','off')
            set(obj.edit4,'enable','off')
            set(obj.button1,'enable','off')
            set(obj.button2,'enable','off')
            set(obj.button3,'enable','off')
            set(obj.button4,'enable','off')
            set(obj.button5,'enable','off')
            set(obj.Advancedbutton,'enable','off')
            set(obj.Startbutton,'enable','off')
            set(gcf,'CloseRequestFcn','')
            
            scrnsz = get(0,'Screensize');
            obj.AdvancedFig = figure('Position',[scrnsz(3)/2-375 scrnsz(4)/2-270 750 540],...
                'MenuBar','none','resize','off','CloseRequestFcn',{@LOCALcanceladvanced obj});
            FigSize = get(obj.AdvancedFig,'position');
            uicontrol('style','text','Position',[FigSize(3)/2-100 FigSize(4)-50 200 30],...
                'String','Advanced Options','fontsize',12,'fontweight','bold',...
                'backgroundcolor',[.8 .8 .8])
            if obj.VelocityCheck == 1
                val = 1;
                opp = 'off';
            else
                val = 0;
                opp = 'on';
            end
            if obj.AccelerationCheck == 1
                val2 = 1;
                opp2 = 'off';
            else
                val2 = 0;
                opp2 = 'on';
            end
            if obj.DecelerationCheck == 1
                val3 = 1;
                opp3 = 'off';
            else
                val3 = 0;
                opp3 = 'on';
            end
            if obj.COFCheck == 1
                val4 = 1;
                opp4 = 'off';
            else
                val4 = 0;
                opp4 = 'on';
            end
            if obj.VisionCheck == 1
                val5 = 1;
                opp5 = 'on';
            else
                val5 = 0;
                opp5 = 'off';
            end
            if obj.SeeVisionCheck == 1;
                val6 = 1;
            else
                val6 = 0;
            end
            if obj.SeePathCheck == 1;
                val7 = 1;
            else
                val7 = 0;
            end
            if obj.WayPointCheck == 1;
                val8 = 1;
                opp8 = 'on';
                opp9 = 'inactive';
            else
                val8 = 0;
                opp8 = 'off';
                opp9 = 'off';
            end

            obj.advcheck1 = uicontrol('style','checkbox','position',[30 FigSize(4)-70 20 20],...
                'backgroundcolor',[.8 .8 .8],'Value',val,'Callback',...
                {@LOCAL_CheckVelocity obj});
            obj.advtext1 = uicontrol('style','text','position',[50 FigSize(4)-70 300 18],...
                'String','Use Default Value for Maximum Vehicle Velocity',...
                'fontsize',10,'backgroundcolor',[.8 .8 .8]);
            obj.advtext2 = uicontrol('style','text','position',[50 FigSize(4)-95 178 18],...
                'String','Maximum Vehicle Velocity:','fontsize',10,...
                'backgroundcolor',[.8 .8 .8],'enable',opp);
            obj.advedit1 = uicontrol('style','edit','position',[230 FigSize(4)-95 60 20],...
                'String',num2str(obj.MaxVelocity),'enable',opp);
            obj.advtext3 = uicontrol('style','text','position',[290 FigSize(4)-95 60 18],...
                'String','units/sec','fontsize',10,'backgroundcolor',[.8 .8 .8],...
                'enable',opp);

            obj.advcheck2 = uicontrol('style','checkbox','position',[30 FigSize(4)-130 20 20],...
                'backgroundcolor',[.8 .8 .8],'Value',val2,...
                'Callback',{@LOCAL_CheckAccel obj});
            obj.advtext4 = uicontrol('style','text','position',[52 FigSize(4)-130 260 18],...
                'String','Use Default Value for Vehicle Acceleration',...
                'fontsize',10,'backgroundcolor',[.8 .8 .8]);
            obj.advtext5 = uicontrol('style','text','position',[50 FigSize(4)-155 181 18],...
                'String','Vehicle Acceleration Value:','fontsize',10,...
                'backgroundcolor',[.8 .8 .8],'enable',opp2);
            obj.advedit2 = uicontrol('style','edit','position',[230 FigSize(4)-155 60 20],...
                'String',num2str(obj.MaxAcceleration),'enable',opp2);
            obj.advtext6 = uicontrol('style','text','position',[290 FigSize(4)-155 72 18],...
                'String','units/sec^2','fontsize',10,'backgroundcolor',[.8 .8 .8],...
                'enable',opp2);
            
            obj.advcheck3 = uicontrol('style','checkbox','position',[30 FigSize(4)-190 20 20],...
                'backgroundcolor',[.8 .8 .8],'Value',val3,...
                'Callback',{@LOCAL_CheckDecel obj});
            obj.advtext7 = uicontrol('style','text','position',[52 FigSize(4)-190 260 18],...
                'String','Use Default Value for Vehicle Deceleration',...
                'fontsize',10,'backgroundcolor',[.8 .8 .8]);
            obj.advtext8 = uicontrol('style','text','position',[50 FigSize(4)-215 181 18],...
                'String','Vehicle Deceleration Value:','fontsize',10,...
                'backgroundcolor',[.8 .8 .8],'enable',opp3);
            obj.advedit3 = uicontrol('style','edit','position',[230 FigSize(4)-215 60 20],...
                'String',num2str(obj.MaxDeceleration),'enable',opp3);
            obj.advtext9 = uicontrol('style','text','position',[290 FigSize(4)-215 72 18],...
                'String','units/sec^2','fontsize',10,'backgroundcolor',[.8 .8 .8],...
                'enable',opp3);

            obj.advcheck4 = uicontrol('style','checkbox','position',[30 FigSize(4)-250 20 20],...
                'backgroundcolor',[.8 .8 .8],'Value',val4,...
                'Callback',{@LOCAL_CheckCOF obj});
            obj.advtext10 = uicontrol('style','text','position',[53 FigSize(4)-250 260 18],...
                'String','Use Default Value for Coefficient of Friction',...
                'fontsize',10,'backgroundcolor',[.8 .8 .8]);
            obj.advtext11 = uicontrol('style','text','position',[50 FigSize(4)-275 181 18],...
                'String','Coefficient of Friction Value:','fontsize',10,...
                'backgroundcolor',[.8 .8 .8],'enable',opp4);
            obj.advedit4 = uicontrol('style','edit','position',[230 FigSize(4)-275 60 20],...
                'String',num2str(obj.COF),'enable',opp4);
            
            obj.advcheck5 = uicontrol('style','checkbox','position',[30 FigSize(4)-310 20 20],...
                'backgroundcolor',[.8 .8 .8],'Value',val5,...
                'Callback',{@LOCAL_CheckVision obj});
            obj.advtext12 = uicontrol('style','text','position',[38 FigSize(4)-310 300 18],...
                'String','Limit Radius of Vision (of Path Planner Only)',...
                'fontsize',10,'backgroundcolor',[.8 .8 .8]);
            obj.advcheck6 = uicontrol('style','checkbox','position',[59 FigSize(4)-335 20 20],...
                'backgroundcolor',[.8 .8 .8],'Value',val6,'enable',opp5);
            obj.advtext13 = uicontrol('style','text','position',[75 FigSize(4)-335 200 18],...
                'String','Display Radius of Vision on Map',...
                'fontsize',10,'backgroundcolor',[.8 .8 .8],'enable',opp5);
            obj.advtext14 = uicontrol('style','text','position',[28 FigSize(4)-360 160 18],...
                'String','Radius of Vision:','fontsize',10,...
                'backgroundcolor',[.8 .8 .8],'enable',opp5);
            if obj.VisionRange == inf
                temp = [];
            else
                temp = obj.VisionRange;
            end
            obj.advedit5 = uicontrol('style','edit','position',[166 FigSize(4)-360 60 20],...
                'String',num2str(temp),'enable',opp5,'backgroundcolor','w');
            obj.advtext15 = uicontrol('style','text','position',[229 FigSize(4)-360 30 18],...
                'String','units','fontsize',10,'backgroundcolor',[.8 .8 .8],...
                'enable',opp5);
            obj.advtextnote = uicontrol('style','text','position',[60 FigSize(4)-390 300 30],...
                'String','Note: Vehicle Vision must be at least 10 units greater than the buffer zone.',...
                'fontsize',8,'backgroundcolor',[.8 .8 .8],'HorizontalAlignment','left','visible','off');
            
            obj.advcheck7 = uicontrol('style','checkbox','position',[400 FigSize(4)-70 20 20],...
                'backgroundcolor',[.8 .8 .8],'Value',val7);
            obj.advtext16 = uicontrol('style','text','position',[420 FigSize(4)-70 155 18],...
                'String','Display Path of Vehicle',...
                'fontsize',10,'backgroundcolor',[.8 .8 .8]);
            
            obj.advtext17 = uicontrol('style','text','position',[354 FigSize(4)-100 350 18],...
                'String','Buffer Zone Between Vehicle and Obstacles:',...
                'fontsize',10,'backgroundcolor',[.8 .8 .8]);
            obj.advedit6 = uicontrol('style','edit','position',[660 FigSize(4)-100 40 20],...
                'String',num2str(obj.BufferZone));
            obj.advtext18 = uicontrol('style','text','position',[703 FigSize(4)-100 30 18],...
                'String','units','fontsize',10,'backgroundcolor',[.8 .8 .8]);
            
            obj.advtextturningrate = uicontrol('style','text','position',[375 FigSize(4)-125 250 18],...
                'String','Maximum Turning Rate of Vehicle:',...
                'fontsize',10,'backgroundcolor',[.8 .8 .8]);
            obj.adveditturningrate = uicontrol('style','edit','position',[605 FigSize(4)-125 60 20],...
                'String',num2str(obj.MaxTurningRate),'backgroundcolor','w');
            obj.advtextturningrate2 = uicontrol('style','text','position',[665 FigSize(4)-125 80 18],...
                'String','degrees/sec','backgroundcolor',[.8 .8 .8],'fontsize',10);
            
            obj.advcheck8 = uicontrol('style','checkbox','position',[400 FigSize(4)-160 20 20],...
                'backgroundcolor',[.8 .8 .8],'Value',val8,...
                'Callback',{@LOCAL_CheckWayPoint obj});
            obj.advtext19 = uicontrol('style','text','position',[423 FigSize(4)-160 150 18],...
                'String','Add Way Points to Map','fontsize',10,'backgroundcolor',[.8 .8 .8]);
            obj.advtable1 = uitable('ColumnName',{'X-Pos' 'Y-Pos'},'Data',obj.WayPoint,...
                'Position',[401 160 203 203],'enable',opp9);
            
            obj.NewWayXtext = uicontrol('style','text','position',[610 335 20 18],...
                'string','X: ','fontsize',10,'fontweight','bold','backgroundcolor',[.8 .8 .8],...
                'enable',opp8);
            obj.NewWayXedit = uicontrol('style','edit','position',[630 335 80 20],...
                'enable',opp8,'KeyPressFcn',{@LOCALkeypressadvanced obj});
            obj.NewWayYtext = uicontrol('style','text','position',[610 305 20 18],...
                'string','Y: ','fontsize',10,'fontweight','bold','backgroundcolor',[.8 .8 .8],...
                'enable',opp8);
            obj.NewWayYedit = uicontrol('style','edit','position',[630 305 80 20],...
                'enable',opp8,'KeyPressFcn',{@LOCALkeypressadvanced obj});
            obj.AcceptNewWay = uicontrol('style','pushbutton','position',[610 265 120 30],...
                'string','Add Way Point','backgroundcolor',[.8 .8 .8],...
                'enable',opp8,'Callback',{@LOCALacceptway obj},'KeyPressFcn',{@LOCALkeypressadvanced obj});
            obj.ImportNewWay = uicontrol('style','pushbutton','position',[610 220 120 30],...
                'string','Import Way Point(s)','backgroundcolor',[.8 .8 .8],...
                'enable',opp8,'Callback',{@LOCALimportway obj},'KeyPressFcn',{@LOCALkeypressadvanced obj});
            obj.ClearWays = uicontrol('style','pushbutton','position',[610 175 120 30],...
                'string','Clear Way Points','backgroundcolor',[.8 .8 .8],...
                'enable',opp8,'Callback',{@LOCALclearway obj},'KeyPressFcn',{@LOCALkeypressadvanced obj});
            
            obj.advimportframe = uicontrol('style','frame','position',[610 215 120 148],...
                'Visible','off');
            obj.advimporttext = uicontrol('style','text','position',[611 339 118 20],...
                'String',' Specify Excel File:','HorizontalAlignment','left',...
                'Visible','off');
            obj.advimportedit = uicontrol('Style','edit','position',[613 319 114 20],...
                'HorizontalAlignment','left','Visible','off','backgroundcolor','w');
            obj.advimportbrowse = uicontrol('Style','pushbutton','position',...
                [616 294 108 23],'String','Browse...','Callback',{@LOCALadvbrowse obj},...
                'Visible','off','KeyPressFcn',{@LOCALkeypressadvanced obj});
            obj.advimportaccept = uicontrol('Style','pushbutton','position',...
                [616 246 108 23],'String','Accept','Callback',{@LOCALadvaccept obj},...
                'Visible','off','KeyPressFcn',{@LOCALkeypressadvanced obj});
            obj.advimportback = uicontrol('Style','pushbutton','position',...
                [616 221 108 23],'String','Back','Callback',{@LOCALadvback obj},...
                'Visible','off','KeyPressFcn',{@LOCALkeypressadvanced obj});

            obj.advsave = uicontrol('style','pushbutton','position',[FigSize(3)/2-190 30 120 30],...
                'String','OK','Callback',{@LOCALsaveadvanced obj},'KeyPressFcn',...
                {@LOCALkeypressadvanced obj});
            obj.advapply = uicontrol('style','pushbutton','position',[FigSize(3)/2-60 30 120 30],...
                'String','APPLY','Callback',{@LOCALapplyadvanced obj},'KeyPressFcn',...
                {@LOCALkeypressadvanced obj});
            obj.advcancel = uicontrol('style','pushbutton','position',[FigSize(3)/2+70 30 120 30],...
                'String','CANCEL','Callback',{@LOCALcanceladvanced obj},'KeyPressFcn',...
                {@LOCALkeypressadvanced obj});
            uicontrol(obj.advsave);
            
            obj.advstartvelocitytext = uicontrol('style','text','position',[50 125 200 20],...
                'String','Vehicle Start Position Velocity:','fontsize',10,'backgroundcolor',[.8 .8 .8]);
            obj.advstartvelocityedit = uicontrol('style','edit','position',[245 126 60 20],...
                'String',num2str(obj.StartVelocity),'backgroundcolor','w');
            obj.advstartvelocitytext2 = uicontrol('style','text','position',[305 125 60 20],...
                'String','units/sec','fontsize',10,'backgroundcolor',[.8 .8 .8]);
            
            obj.advendvelocitytext = uicontrol('style','text','position',[47 100 200 20],...
                'String','Vehicle End Position Velocity:','fontsize',10,'backgroundcolor',[.8 .8 .8]);
            obj.advendvelocityedit = uicontrol('style','edit','position',[245 101 60 20],...
                'String',num2str(obj.EndVelocity),'backgroundcolor','w');
            obj.advendvelocitytext2 = uicontrol('style','text','position',[305 100 60 20],...
                'String','units/sec','fontsize',10,'backgroundcolor',[.8 .8 .8]);
            
            obj.advwayvelocitytext = uicontrol('style','text','position',[400 125 200 20],...
                'String','Velocity at Way Points:','fontsize',10,'backgroundcolor',[.8 .8 .8],...
                'HorizontalAlignment','left','enable',opp9);
            obj.advwayvelocityedit = uicontrol('style','edit','position',[545 126 60 20],...
                'String',num2str(obj.WayVelocity),'backgroundcolor','w','enable',opp9);
            obj.advwayvelocitytext2 = uicontrol('style','text','position',[605 125 60 20],...
                'String','units/sec','fontsize',10,'backgroundcolor',[.8 .8 .8],'enable',opp9);
            
        end
        
        function obj = LOCALkeypressadvanced(Esrc,Edata,obj)
            switch Esrc
                case obj.advsave
                    switch Edata.Key
                        case 'return'
                            obj = LOCALsaveadvanced(Esrc,Edata,obj);
                        case 'rightarrow'
                            uicontrol(obj.advapply)
                        case 'leftarrow'
                            uicontrol(obj.advcancel)
                    end
                case obj.advapply
                    switch Edata.Key
                        case 'return'
                            obj = LOCALapplyadvanced(Esrc,Edata,obj);
                        case 'rightarrow'
                            uicontrol(obj.advcancel)
                        case 'leftarrow'
                            uicontrol(obj.advsave)
                    end
                case obj.advcancel
                    switch Edata.Key
                        case 'return'
                            obj = LOCALcanceladvanced(Esrc,Edata,obj);
                        case 'rightarrow'
                            uicontrol(obj.advsave)
                        case 'leftarrow'
                            uicontrol(obj.advapply)
                    end
                case obj.NewWayXedit
                    switch Edata.Key
                        case 'return'
                            uicontrol(obj.AcceptNewWay)
                            obj = LOCALacceptway(Esrc,Edata,obj);
                        case 'downarrow'
                            uicontrol(obj.NewWayYedit)
                    end
                case obj.NewWayYedit
                    switch Edata.Key
                        case 'return'
                            uicontrol(obj.AcceptNewWay)
                            obj = LOCALacceptway(Esrc,Edata,obj);
                        case 'downarrow'
                            uicontrol(obj.AcceptNewWay)
                        case 'uparrow'
                            uicontrol(obj.NewWayXedit)
                    end
                case obj.AcceptNewWay
                    switch Edata.Key
                        case 'return'
                            obj = LOCALacceptway(Esrc,Edata,obj);
                        case 'downarrow'
                            uicontrol(obj.ImportNewWay)
                        case 'uparrow'
                            uicontrol(obj.NewWayYedit)
                    end
                case obj.ImportNewWay
                    switch Edata.Key
                        case 'return'
                            obj = LOCALimportway(Esrc,Edata,obj);
                        case 'downarrow'
                            uicontrol(obj.ClearWays)
                        case 'uparrow'
                            uicontrol(obj.AcceptNewWay)
                    end
                case obj.ClearWays
                    switch Edata.Key
                        case 'return'
                            obj = LOCALclearway(Esrc,Edata,obj);
                        case 'uparrow'
                            uicontrol(obj.ImportNewWay)
                    end
                case obj.advimportbrowse
                    switch Edata.Key
                        case 'return';
                            obj = LOCALadvbrowse(Esrc,Edata,obj);
                        case 'downarrow'
                            uicontrol(obj.advimportaccept)
                    end
                case obj.advimportaccept
                    switch Edata.Key
                        case 'return'
                            obj = LOCALadvaccept(Esrc,Edata,obj);
                        case 'downarrow'
                            uicontrol(obj.advimportback)
                        case 'uparrow'
                            uicontrol(obj.advimportbrowse)
                    end
                case obj.advimportback
                    switch Edata.Key
                        case 'return'
                            obj = LOCALadvback(Esrc,Edata,obj);
                        case 'uparrow'
                            uicontrol(obj.advimportaccept)
                        case 'downarrow'
                            uicontrol(obj.advsave)
                    end
            end
        end
        
        function obj = LOCAL_CheckVelocity(~,~,obj)
            if get(obj.advcheck1,'Value') == 1
                set(obj.advtext2,'enable','off');
                set(obj.advedit1,'enable','off');
                set(obj.advedit1,'String','100')
                set(obj.advtext3,'enable','off');
            else
                set(obj.advtext2,'enable','on');
                set(obj.advedit1,'enable','on');
                set(obj.advtext3,'enable','on');
            end
        end
        
        function obj = LOCAL_CheckAccel(~,~,obj)
            if get(obj.advcheck2,'Value') == 1
                set(obj.advtext5,'enable','off');
                set(obj.advedit2,'enable','off');
                set(obj.advedit2,'String','25')
                set(obj.advtext6,'enable','off');
            else
                set(obj.advtext5,'enable','on');
                set(obj.advedit2,'enable','on');
                set(obj.advtext6,'enable','on');
            end
        end
        
        function obj = LOCAL_CheckDecel(~,~,obj)
            if get(obj.advcheck3,'Value') == 1
                set(obj.advtext8,'enable','off');
                set(obj.advedit3,'enable','off');
                set(obj.advedit3,'String','60')
                set(obj.advtext9,'enable','off');
            else
                set(obj.advtext8,'enable','on');
                set(obj.advedit3,'enable','on');
                set(obj.advtext9,'enable','on');
            end
        end
        
        function obj = LOCAL_CheckCOF(~,~,obj)
            if get(obj.advcheck4,'Value') == 1
                set(obj.advtext11,'enable','off');
                set(obj.advedit4,'enable','off');
                set(obj.advedit4,'String','1');
            else
                set(obj.advtext11,'enable','on');
                set(obj.advedit4,'enable','on');
            end
        end
        
        function obj = LOCAL_CheckVision(~,~,obj)
            if get(obj.advcheck5,'Value') == 1
                set(obj.advcheck6,'enable','on');
                set(obj.advtext13,'enable','on');
                set(obj.advtext14,'enable','on');
                set(obj.advedit5,'enable','on');
                set(obj.advtext15,'enable','on');
                set(obj.advtextnote,'visible','on')
            else
                set(obj.advcheck6,'enable','off');
                set(obj.advcheck6,'Value',0);
                set(obj.advtext13,'enable','off');
                set(obj.advtext14,'enable','off');
                set(obj.advedit5,'String','');
                set(obj.advedit5,'enable','off');
                set(obj.advtext15,'enable','off');
                set(obj.advtextnote,'visible','off')
            end
        end
        
        function obj = LOCAL_CheckWayPoint(~,~,obj)
            if get(obj.advcheck8,'Value') == 1
                set(obj.advtable1,'enable','inactive')
                set(obj.NewWayXtext,'enable','on')
                set(obj.NewWayXedit,'enable','on')
                set(obj.NewWayYtext,'enable','on')
                set(obj.NewWayYedit,'enable','on')
                set(obj.AcceptNewWay,'enable','on')
                set(obj.ImportNewWay,'enable','on')
                set(obj.ClearWays,'enable','on') 
                set(obj.advwayvelocitytext,'enable','on')
                set(obj.advwayvelocityedit,'enable','on')
                set(obj.advwayvelocitytext2,'enable','on')
                uicontrol(obj.NewWayXedit)
            else
                set(obj.advtable1,'enable','off')
                set(obj.NewWayXtext,'enable','off')
                set(obj.NewWayXedit,'enable','off')
                set(obj.NewWayYtext,'enable','off')
                set(obj.NewWayYedit,'enable','off')
                set(obj.AcceptNewWay,'enable','off')
                set(obj.ImportNewWay,'enable','off')
                set(obj.advwayvelocitytext,'enable','off')
                set(obj.advwayvelocityedit,'enable','off')
                set(obj.advwayvelocitytext2,'enable','off')
                set(obj.advwayvelocityedit,'String','0')
                set(obj.ClearWays,'enable','off')
            end
        end
        
        function obj = LOCALsaveadvanced(Esrc,Edata,obj)
            obj = LOCALapplyadvanced(Esrc,Edata,obj);
            obj = LOCALcanceladvanced(Esrc,Edata,obj);
        end
        
        function obj = LOCALapplyadvanced(~,~,obj)
            if isnan(str2double(get(obj.advstartvelocityedit,'String'))) || isnan(str2double(get(obj.advendvelocityedit,'String'))) || isnan(str2double(get(obj.advwayvelocityedit,'String'))) || isnan(str2double(get(obj.adveditturningrate,'String'))) || isnan(str2double(get(obj.advedit1,'String'))) || str2double(get(obj.advedit1,'String')) <= 0 || isnan(str2double(get(obj.advedit2,'String'))) || str2double(get(obj.advedit2,'String')) <= 0 || isnan(str2double(get(obj.advedit3,'String'))) || str2double(get(obj.advedit3,'String')) <= 0 || isnan(str2double(get(obj.advedit4,'String'))) || str2double(get(obj.advedit4,'String')) <= 0 || isnan(str2double(get(obj.advedit6,'String'))) || str2double(get(obj.advedit6,'String')) <= 0
                temp = uicontrol('style','text','String',['ERROR: All entries ',...
                    'must be positive numerical values.'],'position',...
                    [125 70 500 20],'foregroundcolor','r','fontsize',10,'fontweight','bold',...
                    'backgroundcolor',[.8 .8 .8]);
                pause(4);
                Objects = findobj;
                for i = 1:length(Objects)
                    if Objects(i) == obj.AdvancedFig
                        delete(temp);
                        break
                    end
                end
            elseif get(obj.advcheck5,'Value') == 1 && (isnan(str2double(get(obj.advedit5,'String'))) || str2double(get(obj.advedit5,'String')) <= 0)
                temp = uicontrol('style','text','String',['ERROR: All entries ',...
                'must be positive numerical values.'],'position',...
                [125 70 500 20],'foregroundcolor','r','fontsize',10,'fontweight','bold',...
                'backgroundcolor',[.8 .8 .8]);
                pause(4);
                Objects = findobj;
                for i = 1:length(Objects)
                    if Objects(i) == obj.AdvancedFig
                        delete(temp);
                        break
                    end
                end
            elseif str2double(get(obj.advedit5,'string'))-10 < str2double(get(obj.advedit6,'string'))
                temp = uicontrol('style','text','String',['ERROR: Vision Range must ',...
                    'be greater than Buffer Zone by at least 10.'],'position',...
                    [125 70 500 20],'foregroundcolor','r','fontsize',10,'fontweight','bold',...
                    'backgroundcolor',[.8 .8 .8]);
                pause(4);
                Objects = findobj;
                for i = 1:length(Objects)
                    if Objects(i) == obj.AdvancedFig
                        delete(temp);
                        break
                    end
                end
            elseif str2double(get(obj.advedit6,'string')) < 5 || str2double(get(obj.advedit6,'String')) > 20
                temp = uicontrol('style','text','String',['ERROR: Buffer zone must be between ',...
                    'the values of 5 and 20.'],'position',...
                    [125 70 500 20],'foregroundcolor','r','fontsize',10,'fontweight','bold',...
                    'backgroundcolor',[.8 .8 .8]);
                pause(4);
                Objects = findobj;
                for i = 1:length(Objects)
                    if Objects(i) == obj.AdvancedFig
                        delete(temp);
                        break
                    end
                end
            elseif str2double(get(obj.adveditturningrate,'string')) <= 0 || str2double(get(obj.adveditturningrate,'String')) >= 90
                temp = uicontrol('style','text','String',['ERROR: Turning Rate must be ',...
                    'positive values between 0 and 90 degrees.'],'position',...
                    [125 70 500 20],'foregroundcolor','r','fontsize',10,'fontweight','bold',...
                    'backgroundcolor',[.8 .8 .8]);
                pause(4);
                Objects = findobj;
                for i = 1:length(Objects)
                    if Objects(i) == obj.AdvancedFig
                        delete(temp);
                        break
                    end
                end
            elseif str2double(get(obj.advstartvelocityedit,'String')) < 0 || str2double(get(obj.advstartvelocityedit,'String')) > str2double(get(obj.advedit1,'String'))
                temp = uicontrol('style','text','String',['ERROR: Start Velocity value ',...
                    'must be between 0 and Max Velocity Value.'],'position',...
                    [125 70 500 20],'foregroundcolor','r','fontsize',10,'fontweight','bold',...
                    'backgroundcolor',[.8 .8 .8]);
                pause(4);
                Objects = findobj;
                for i = 1:length(Objects)
                    if Objects(i) == obj.AdvancedFig
                        delete(temp);
                        break
                    end
                end
            elseif str2double(get(obj.advendvelocityedit,'String')) < 0 || str2double(get(obj.advendvelocityedit,'String')) > str2double(get(obj.advedit1,'String'))
                temp = uicontrol('style','text','String',['ERROR: End Velocity value ',...
                    'must be between 0 and Max Velocity Value.'],'position',...
                    [125 70 500 20],'foregroundcolor','r','fontsize',10,'fontweight','bold',...
                    'backgroundcolor',[.8 .8 .8]);
                pause(4);
                Objects = findobj;
                for i = 1:length(Objects)
                    if Objects(i) == obj.AdvancedFig
                        delete(temp);
                        break
                    end
                end
            elseif get(obj.advcheck8,'Value') && str2double(get(obj.advwayvelocityedit,'String')) < 0 || str2double(get(obj.advwayvelocityedit,'String')) > str2double(get(obj.advedit1,'String'))
                temp = uicontrol('style','text','String',['ERROR: Way Point Velocity value ',...
                    'must be between 0 and Max Velocity Value.'],'position',...
                    [125 70 500 20],'foregroundcolor','r','fontsize',10,'fontweight','bold',...
                    'backgroundcolor',[.8 .8 .8]);
                pause(4);
                Objects = findobj;
                for i = 1:length(Objects)
                    if Objects(i) == obj.AdvancedFig
                        delete(temp);
                        break
                    end
                end
            else
                obj.MaxVelocity = str2double(get(obj.advedit1,'String'));
                obj.VelocityCheck = get(obj.advcheck1,'Value');
                obj.MaxAcceleration = str2double(get(obj.advedit2,'String'));
                obj.AccelerationCheck = get(obj.advcheck2,'Value');
                obj.MaxDeceleration = str2double(get(obj.advedit3,'String'));
                obj.DecelerationCheck = get(obj.advcheck3,'Value');
                obj.COF = str2double(get(obj.advedit4,'String'));
                obj.COFCheck = get(obj.advcheck4,'Value');
                obj.VisionRange = str2double(get(obj.advedit5,'String'));
                if isnan(obj.VisionRange)
                    obj.VisionRange = inf;
                end
                obj.VisionCheck = get(obj.advcheck5,'Value');
                obj.SeeVisionCheck = get(obj.advcheck6,'Value');
                obj.SeeVisionRange = logical(get((obj.advcheck6),'Value'));
                obj.SeePathCheck = get(obj.advcheck7,'Value');
                obj.DisplayPath = logical(get(obj.advcheck7,'Value'));
                obj.BufferZone = str2double(get(obj.advedit6,'String'));
                obj.MaxTurningRate = str2double(get(obj.adveditturningrate,'String'));
                obj.StartVelocity = str2double(get(obj.advstartvelocityedit,'String'));
                obj.EndVelocity = str2double(get(obj.advendvelocityedit,'String'));
                obj.WayPointCheck = get(obj.advcheck8,'Value');
                if get(obj.advcheck8,'Value') == 1
                    obj.WayPoint = get(obj.advtable1,'Data');
                    obj.WayVelocity = str2double(get(obj.advwayvelocityedit,'String'));
                else
                    obj.WayPoint = [];
                    obj.WayVelocity = 0;
                end
                figure(obj.AdvancedFig)
            end
        end
        
        function obj = LOCALcanceladvanced(~,~,obj)
            delete(obj.AdvancedFig);
            set(obj.edit1,'enable','on')
            set(obj.edit2,'enable','on')
            set(obj.edit3,'enable','on')
            set(obj.edit4,'enable','on')
            set(obj.button1,'enable','on')
            set(obj.button2,'enable','on')
            set(obj.button3,'enable','on')
            set(obj.button4,'enable','on')
            set(obj.button5,'enable','on')
            set(obj.Advancedbutton,'enable','on')
            set(obj.Startbutton,'enable','on')
            set(gcf,'CloseRequestFcn','closereq')
            uicontrol(obj.Advancedbutton)
        end
        
        function obj = LOCALacceptway(~,~,obj)
            TableData = get(obj.advtable1,'Data');
            XVal = str2double(get(obj.NewWayXedit,'String'));
            YVal = str2double(get(obj.NewWayYedit,'String'));
            if isnan(XVal) || isnan (YVal) || XVal < 0 || XVal > 1000 || YVal < 0 || YVal > 1000
                scrnsz = get(0,'ScreenSize');
                figure('Position',[scrnsz(3)/2-225 scrnsz(4)/2-100 450 200],'Menubar','none',...
                    'resize','off')
                uicontrol('Style','text','String',['ERROR: X and Y positions must be',...
                    ' numerical values between 0 and 1000.'],'Position',[25 50 400 100],...
                    'fontsize',12,'backgroundcolor',[.8 .8 .8])
                temp = uicontrol('Style','Pushbutton','Position',[185 45 80 25],'String','OK','Callback','close(gcf)',...
                    'KeyPressFcn',{@LOCALkeycloseerror obj});
                uicontrol(temp);
            else
                sz = size(TableData); height = sz(1);
                TableData(height+1,:) = [XVal YVal];
                set(obj.advtable1,'Data',TableData);
                set(obj.NewWayXedit,'String','');
                set(obj.NewWayYedit,'String','');
                uicontrol(obj.NewWayXedit)
            end
        end
        
        function obj = LOCALimportway(~,~,obj)
            set(obj.NewWayXedit,'String','');
            set(obj.NewWayYedit,'String','');
            set(obj.NewWayXtext,'visible','off');
            set(obj.NewWayXedit,'visible','off');
            set(obj.NewWayYtext,'visible','off');
            set(obj.NewWayYedit,'visible','off');
            set(obj.AcceptNewWay,'visible','off');
            set(obj.ImportNewWay,'visible','off');
            set(obj.advimportframe,'visible','on');
            set(obj.advimporttext,'visible','on');
            set(obj.advimportedit,'visible','on');
            set(obj.advimportbrowse,'visible','on');
            set(obj.advimportaccept,'visible','on');
            set(obj.advimportback,'visible','on');
            uicontrol(obj.advimportbrowse)
        end
        
        function obj = LOCALadvbrowse(~,~,obj)
            [FileName,PathName] = uigetfile({'*.xlsx';'*.xls'},'Select File to Import');
            if isa(FileName,'char')
                if isempty(regexp(FileName,'.xlsx?$','once'))
                    set(obj.advimportedit,'string','Must be ''.xlsx'' or ''.xls''',...
                    'ForegroundColor','r','ButtonDownFcn',{@LOCALupdateadvimport obj},...
                    'enable','inactive')
                % There appears to be a bug in this version of Matlab (7.9.0
                % R2009b) that requires 'enable' to be set to 'inactive' in
                % order to make the left click for 'ButtonDownFcn' work. The
                % Mathworks website claims this is fixed in a later version.
                else
                    set(obj.advimportedit,'string',[PathName,FileName])
                end
            end
        end
        
        function LOCALupdateadvimport(~,~,obj)
            set(obj.advimportedit,'foregroundcolor','k','ButtonDownFcn','',...
                'String','','enable','on');
        end
        
        function obj = LOCALadvaccept(Esrc,Edata,obj)
            try
                Data = xlsread(get(obj.advimportedit,'string'));
                sz = size(Data); sz = sz(1)*sz(2);
                Count = 0;
                for i = 1:sz
                    if isnan(Data(i)) || length(Data(1,:)) ~= 2
                        scrnsz = get(0,'ScreenSize');
                        figure('Position',[scrnsz(3)/2-225 scrnsz(4)/2-100 450 200],'Menubar','none',...
                            'resize','off')
                        uicontrol('Style','text','String',['ERROR: The data extraced from the ',...
                            ' Excel worksheet must have numerical values in an N-by-2 array.',...
                            ' The given imported data has unreal elements.'],'Position',[25 50 400 100],...
                            'fontsize',12,'backgroundcolor',[.8 .8 .8])
                        temp = uicontrol('Style','Pushbutton','Position',[185 45 80 25],'String','OK','Callback','close(gcf)',...
                        'KeyPressFcn',{@LOCALkeycloseerror obj});
                        uicontrol(temp);
                        break
                    end
                    Count = Count+1;
                end
                if Count == sz % Then all elements are real and array is N-by-3
                    tabledata = get(obj.advtable1,'Data');
                    height = size(tabledata); height = height(1);
                    importheight = length(Data(:,1));
                    tabledata(height+1:height+importheight,:) = Data;
                    set(obj.advtable1,'Data',tabledata);
                    set(obj.advimportedit,'String','');
                    LOCALadvback(Esrc,Edata,obj);
                end
            catch
                scrnsz = get(0,'ScreenSize');
                figure('Position',[scrnsz(3)/2-225 scrnsz(4)/2-100 450 200],'Menubar','none',...
                    'resize','off')
                uicontrol('Style','text','String',['ERROR: The data extraced from the ',...
                    ' Excel worksheet must have numerical values in an N-by-2 array.',...
                    ' The given imported data has unreal elements.'],'Position',[25 50 400 100],...
                    'fontsize',12,'backgroundcolor',[.8 .8 .8])
                temp = uicontrol('Style','Pushbutton','Position',[185 45 80 25],'String','OK','Callback','close(gcf)',...
                'KeyPressFcn',{@LOCALkeycloseerror obj});
                uicontrol(temp);
            end
        end
        
        function obj = LOCALadvback(~,~,obj)
            set(obj.advimportedit,'String','');
            set(obj.advimportframe,'visible','off');
            set(obj.advimporttext,'visible','off');
            set(obj.advimportedit,'visible','off');
            set(obj.advimportbrowse,'visible','off');
            set(obj.advimportaccept,'visible','off');
            set(obj.advimportback,'visible','off');
            set(obj.NewWayXtext,'visible','on');
            set(obj.NewWayXedit,'visible','on');
            set(obj.NewWayYtext,'visible','on');
            set(obj.NewWayYedit,'visible','on');
            set(obj.AcceptNewWay,'visible','on');
            set(obj.ImportNewWay,'visible','on');
        end
        
        function obj = LOCALclearway(~,~,obj)
            set(obj.advtable1,'Data',[]);
        end

    end
    methods (Static = true, Hidden = true)
        function ChangeStart(~,Edata)
            Val = Edata.AffectedObject.StartPosition;
            Str1 = num2str(Val(1)); Str2 = num2str(Val(2));
            set(Edata.AffectedObject.edit1,'String',Str1);
            set(Edata.AffectedObject.edit2,'String',Str2);
        end
        function ChangeEnd(~,Edata)
            Val = Edata.AffectedObject.EndPosition;
            Str1 = num2str(Val(1)); Str2 = num2str(Val(2));
            set(Edata.AffectedObject.edit3,'String',Str1);
            set(Edata.AffectedObject.edit4,'String',Str2);
        end
        function ChangeObstacles(~,Edata)
            Val = Edata.AffectedObject.ObstacleData;
            set(Edata.AffectedObject.table1,'Data',Val);
        end
        function ChangeWayPoints(~,Edata)
            Val = Edata.AffectedObject.WayPoint;
            temp = 0;
            AdvFig = Edata.AffectedObject.AdvancedFig;
            figs = findobj('type','figure');
            for i = 1:length(figs)
                if figs(i) == AdvFig
                    temp = 1;
                    break
                end
            end
            if temp == 1
                set(Edata.AffectedObject.advtable1,'Data',Val);
            end
        end
    end
end