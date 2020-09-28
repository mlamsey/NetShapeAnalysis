slopes_45 = [3.8160    0.5206    1.7890    1.0664    0.9957    0.2982   -0.3724   -1.7684   -3.7887];
slopes_65 = [5.0104    1.6408    1.7580   -0.2640    0.3316   -0.2880   -1.4654   -2.2708   -6.5830];
slopes_90 = [3.2954    1.5269    1.1231    0.4031    0.7008   -0.2271   -0.9838   -4.3342   -8.0856];

slopes_45_shifted = [4.3984    2.8264    2.9773    1.1464    1.1200    0.7933   -0.2869   -1.7441   -3.0415];
slopes_65_shifted = [6.3597    4.8561    3.6123    2.4023    1.7288    0.6269   -0.9721   -2.9176   -6.4027];
slopes_90_shifted = [4.1048    2.5760    2.5146    1.2186   -0.5181   -0.7933   -2.2327   -4.6821  -10.0337];

angles = flip(-40:10:40);

% figure;
% plot(angles,slopes_45,angles,slopes_65,angles,slopes_90);
% grid on;
% xlabel('Torch Angle (degrees)');
% ylabel('Slope (degrees)');
% l = legend({'45^{\circ} Base','65^{\circ} Base','90^{\circ} Base'});
% set(l,'location','northwest');
% title('Wall Slope vs Torch Angle');

sep45 = -1 .* [1.941, 0.9158, 0.611, -0.221, 0.3329, 0.8196, 0.1263, -0.4002, -1.978];
sep65 = -1 .* [4.8369, 3.8607, 2.0646, 0.4356, 0.8402, 0.4972, -0.3417, -0.6770, -3.2889];
sep90 = -1 .* [-0.3549, -0.1903, -0.1488, -0.0152, 0.8907, 1.5158, 2.0144, 1.5433, 0.2923];

sep45_shifted = -1 .* [1.1304    1.0024    1.2628    0.6926   -0.5649   -1.6460   -1.2013   -0.9352    0.4593];
sep65_shifted = -1 .* [0.0389    0.0731    1.1623    1.9266    1.6969    0.0613    0.3316    0.2368    1.1065];
sep90_shifted = -1 .* [3.3679    2.2354    2.5307    2.1418   -0.5211   -0.8571   -1.3835   -1.1995   -1.7564];

figure;
plot(angles,sep45,angles,sep65,angles,sep90);
grid on;
xlabel('Torch Angle (degrees)');
ylabel('Slope (degrees)');
l = legend({'45^{\circ} Base','65^{\circ} Base','90^{\circ} Base'});
set(l,'location','northeast');
title('Deviation from CAD Centerline (mm)');

figure;
plot(angles,sep45,'color','k','linestyle','-');
hold on;
plot(angles,sep45_shifted,'color','k','linestyle','--');
plot(angles,sep65,'color','b','linestyle','-');
plot(angles,sep65_shifted,'color','b','linestyle','--');
plot(angles,sep90,'color','r','linestyle','-');
plot(angles,sep90_shifted,'color','r','linestyle','--');
hold off;
grid on
xlabel('Torch Angle (degrees)');
ylabel('Deviation from CAD Centerline (mm)');
title('Deviation from CAD vs Torch Angle');
l = legend('45^{\circ} 1','45^{\circ} 2','65^{\circ} 1','65^{\circ} 2','90^{\circ} 1','90^{\circ} 2');
set(l,'location','northeast');

figure;
plot(angles,slopes_45,'color','k','linestyle','-');
hold on;
plot(angles,slopes_45_shifted,'color','k','linestyle','--');
plot(angles,slopes_65,'color','b','linestyle','-');
plot(angles,slopes_65_shifted,'color','b','linestyle','--');
plot(angles,slopes_90,'color','r','linestyle','-');
plot(angles,slopes_90_shifted,'color','r','linestyle','--');
hold off;
l = legend('45^{\circ} 1','45^{\circ} 2','65^{\circ} 1','65^{\circ} 2','90^{\circ} 1','90^{\circ} 2');
set(l,'location','northwest');
grid on
xlabel('Torch Angle (degrees)');
ylabel('Slope (degrees)');
title('Wall Slope Trial Comparison');