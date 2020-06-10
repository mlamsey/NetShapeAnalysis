clear variables; close all; clc;
%% Import Data from File
fileName = 'OverhangSurfaceRoughness\NGA110Back.txt';
data = importdata(fileName,',');
Time = data(:,1);
RobX = data(:,2);
RobY = data(:,3);
RobZ = data(:,4);
RobA = data(:,5);
RobB = data(:,6);
RobC = data(:,7);
Voltage = data(:,8);
Current = data(:,9);
WeldOn = data(:,10);
Profile = data(:,11:end);
[r,c] = size(Profile);

%% Replace all values outside of Keyence range to minimum Keyence value
counter = 0;
for i = 1:r
    for j= 1:c
        if Profile(i,j) < -30
            Profile(i,j) = NaN;
        end
    end
end

%% Find Scan Start and End Points
startFound = 0;
countOn = 1;
countOff = 1;
for i = 1:length(WeldOn)-1
    if WeldOn(i+1) > WeldOn(i)
        ScanStart(countOn) = i+1;
        countOn = countOn+1;
        startFound = 1;
    end
    if WeldOn(i+1) < WeldOn(i)
        ScanEnd(countOff) = i;
        countOff = countOff+1;
    end
end
for i = 1:length(ScanStart)
    avgY = mean(RobY(ScanStart(i):ScanEnd(i)));
    Y(:,i) = linspace(-20+avgY,20+avgY,800);
end

%% Plot Robot Trajectory in Space
figure('Name','Robot Trajectory')
% plot3(RobX,RobY,RobZ)
% hold on
% plot3(RobX(ScanStart),RobY(ScanStart),RobZ(ScanStart),'*g')
% plot3(RobX(ScanEnd),RobY(ScanEnd),RobZ(ScanEnd),'*r')
% grid on

%% Shift Profile Values to be in Robot Task Space
for k = 1:length(ScanStart)
    for i = ScanStart(k):ScanEnd(k)
        for j = 1:c
            Profile(i,j) = Profile(i,j)+RobZ(i);
        end
    end
end

%% Plot Profiles
% figure('Name','Measured Geometry')
meshX = RobX(ScanStart(1):ScanEnd(1));
meshY = Y(:,1);
meshZ = Profile(ScanStart(1):ScanEnd(1),:)';
mesh(meshX,meshY,meshZ)
hold on
grid on
for i = 2:length(ScanStart)
    meshX = RobX(ScanStart(i):ScanEnd(i));
    meshY = Y(:,i);
    meshZ = Profile(ScanStart(i):ScanEnd(i),:)';
    mesh(meshX,meshY,meshZ)
end
xlabel('X [mm]')
ylabel('Y [mm]')
zlabel('Z [mm]')
% xlim([0 450])
% ylim([400 750])
% zlim([0 600])
