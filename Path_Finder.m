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

function Path_Finder
% close all
% clear all
% clear
% close all
clc
% Create the Figure Window
ScrnSize = get(0,'ScreenSize'); % Screen Size
% Figure Handle
FigHan = figure('Position',[40 54 1201 689]); %29
FS = get(FigHan,'Position'); % Figure Size
% Control Frame

a = 1280-420;
b = 800-210;
c1 = min([a b]); % makes the axis of the 2-D map a square
XMIN=0;
XMAX=1000;
YMIN=0;
YMAX=1000;
axis([XMIN XMAX YMIN YMAX]);
AxesHan=gca;
set(AxesHan,'Units','pixels');
set(AxesHan,'Position',[65 55 c1 c1]);
xlabel('X')
ylabel('Y')
th=title('Path Planning');
set(th,'FontSize',16,'FontWeight','bold');

% create dragable objects: starting point, destination, and obstacles;
% This sets the 2-D map of interest;
varargin = {100,100,900,900,[]};
    
% varargin = (start position x, start y, destination position x, dest y, 
% n by 2 array of way point positions, n by 2 array of obstacle positions, 
% column vector of obstacle radius)
map = setmap(varargin{:});

% ConFrame.StartPosition = map.startPosition;
% ConFrame.EndPosition = map.destPosition;
destP = map.destPosition;
d = destP-map.startPosition;
c = 1./d;
% arrow function is downloaded from mathworks.com
startH = map.startHandle;
destH = map.destHandle;
wpHan_cell = map.wayHandle_cell;
opHan_cell = map.obsHandle_cell;
vehicleH = map.vehicleHandle;

% legend
a = axes('Color',[0.941176 0.941176 0.941176],'Box','on');
set(a,'Units','pixels');
set(a,'Position',[c1+115 80+c1*7/10 150 c1*3/10]);
r = 1000/c1*150;
set(a,'YColor',[0 0 0]);
set(a,'XColor',[0 0 0]);
set(a,'YLim',[0 300]);
set(a,'XLim',[0 r]);

Radius = 10;  % start and end point radius     
t =(0:100)*2*pi/100;
start_pos = [50 230];
sx=Radius*cos(t)+start_pos(1);
sy=Radius*sin(t)+start_pos(2);
dest_pos = [50 180];
dx = Radius*cos(t)+dest_pos(1);
dy = Radius*sin(t)+dest_pos(2);
spHan = patch(sx,sy,'blue');
dpHan = patch(dx,dy,'green');
aHan = get(spHan,'Parent'); % get axes handle
fHan = get(aHan,'Parent');

r = 7; % waypoint radius
wx = r*cos(t)+50;
wy = r*sin(t)+130;
wpHan = patch(wx,wy,'yellow');

r = 10; % obstacle radius
wx = r*cos(t)+50;
wy = r*sin(t)+80;
opHan = patch(wx,wy,'red');

theta = pi/4;
R = 12;
t1 = [theta; theta+2.5; theta-2.5];
sx=R*cos(t1)+55;
sy=R*sin(t1)+40;
A = patch(sx,sy,[0 1 1]);

vehicleH1 = A;

text(85,270,'Legend','FontSize',11,'FontWeight','bold');

text(95,230,'Starting Point','FontSize',9);
text(95,180,'End Point','FontSize',9);
text(95,130,'Way Points','FontSize',9);
text(95,80,'Obstacles','FontSize',9);
text(95,33,'Vehicle','FontSize',9);

set(a,'YTick',[]);
set(a,'XTick',[]);

Path_lit = 0;


% Creating the display Plots button
DispPlots = uicontrol('style','pushbutton','position',[c1+130 20 120 30],...
    'String','Detailed Figures','backgroundcolor',[.8 .8 .8],'Callback',{@DisplayPlots map});
end
