slopes_45 = [3.8160    0.5206    1.7890    1.0664    0.9957    0.2982   -0.3724   -1.7684   -3.7887];
slopes_65 = [5.0104    1.6408    1.7580   -0.2640    0.3316   -0.2880   -1.4654   -2.2708   -6.5830];
slopes_90 = [3.2954    1.5269    1.1231    0.4031    0.7008   -0.2271   -0.9838   -4.3342   -8.0856];

angles = flip(-40:10:40);

figure;
plot(angles,slopes_45,angles,slopes_65,angles,slopes_90);
grid on;
xlabel('Torch Angle (degrees)');
ylabel('Slope (degrees)');
l = legend({'45^{\circ} Base','65^{\circ} Base','90^{\circ} Base'});
set(l,'location','northwest');
title('Wall Slope vs Torch Angle');

sep45 = [1.941, 0.9158, 0.611, -0.221, 0.3329, 0.8196, 0.1263, -0.4002, -1.978];
sep65 = [4.8369, 3.8607, 2.0646, 0.4356, 0.8402, 0.4972, -0.3417, -0.6770, -3.2889];
sep90 = [-0.3549, -0.1903, -0.1488, -0.0152, 0.8907, 1.5158, 2.0144, 1.5433, 0.2923];

figure;
plot(angles,sep45,angles,sep65,angles,sep90)
grid on
xlabel('Torch Angle (degrees)');
ylabel('Deviation from CAD Centerline (mm)');
title('Deviation from CAD vs Torch Angle');
l = legend('45^{\circ} Base','65^{\circ} Base','90^{\circ} Base');
set(l,'location','northwest');