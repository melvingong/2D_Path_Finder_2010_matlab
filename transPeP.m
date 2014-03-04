function [outputData,outputeP,thetaeP] = transPeP(sP,eP,data,thetaeP_b4)
if isempty(thetaeP_b4)
    thetaeP = angleFinder(eP(1),eP(2),sP(1),sP(2));
    reP = distance2Point(eP(1),eP(2),sP(1),sP(2));
    outputeP = [reP+sP(1),sP(2)];
    thetaData = angleFinder(data(:,1),data(:,2),sP(1),sP(2));
    rData = distance2Point(data(:,1),data(:,2),sP(1),sP(2));
    thetaDataNew = thetaData-thetaeP;
    outputData = [rData.*cosd(thetaDataNew),rData.*sind(thetaDataNew)];
    outputData = [outputData(:,1)+sP(1),outputData(:,2)+sP(2)];
else
    thetaeP = [];
    reP = distance2Point(eP(1),eP(2),sP(1),sP(2));
    outputeP = [reP.*cosd(thetaeP_b4),reP.*sind(thetaeP_b4)];
    outputeP = [outputeP(1)+sP(1),outputeP(2)+sP(2)];
    thetaData = angleFinder(data(:,1),data(:,2),sP(1),sP(2));
    rData = distance2Point(data(:,1),data(:,2),sP(1),sP(2));
    thetaDataNew = thetaData+thetaeP_b4;
    outputData = vertcat(sP,[rData.*cosd(thetaDataNew)+sP(1),...
        rData.*sind(thetaDataNew)+sP(2)],outputeP);
    outputeP = [];
end
end