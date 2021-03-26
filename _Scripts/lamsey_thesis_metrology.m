% Lamsey Thesis Analysis
clc, close all, clear all
bool_plot = true;
bool_surf = false;

% Import
% la100_scan = GOMScan('/Users/mlamsey/Documents/MATLAB/welding/NetShapeAnalysis/_Data/[P] Full Res Tool Mold Surface.asc');
la100_scan = GOMScan('C:\Users\pty883\Documents\MATLAB\ARC\NetShapeAnalysis\_Data\[P] Full Res Tool Mold Surface.asc');
ScanMethods.SwitchScanDataAxes(la100_scan.data,'y','z');

% Useful Stuff
x_range = max(la100_scan.data.x) - min(la100_scan.data.x);
z_range = max(la100_scan.data.z) - min(la100_scan.data.z);

% Configure
layer_height = 2.31; % mm
window_height = 20 * layer_height; % based on waviness wavelength = 2*l
n_horizontal_windows = 50;
window_width = x_range / n_horizontal_windows;

% Sampling
n_x_points = ceil(x_range / window_width);
n_z_points = ceil(z_range / window_height);

x_steps = min(la100_scan.data.x) : window_width : min(la100_scan.data.x) + (n_x_points * window_width);
z_steps = min(la100_scan.data.z) : window_height : min(la100_scan.data.z) + (n_z_points * window_height);

% Condense sampling
x_inset = 0;
x_steps = x_steps(1+x_inset:end-x_inset);

% mean_values = zeros(1,length(z_steps) - 1);
mean_values = zeros(length(x_steps) - 1,length(z_steps) - 1);
stddev_values = mean_values;
Ra_values = mean_values;
Rq_values = mean_values;
Rv_values = mean_values;
Rp_values = mean_values;
Rz_values = mean_values;
Rsk_values = mean_values;
Rku_values = mean_values;
RzJIS_values = mean_values;

for j = 1:length(x_steps) - 1
	x_set = ScanMethods.GetScanDataSubsetInRange(la100_scan.data,'x',x_steps(j),x_steps(j+1));

	for i = 1:length(z_steps) - 1
		subset = ScanMethods.GetScanDataSubsetInRange(x_set,'z',z_steps(i),z_steps(i+1));
		
		if(length(subset.dev) > 0)
			mean_values(j,i) = SurfaceRoughnessCalculations.Mean(subset.dev);
			stddev_values(j,i) = SurfaceRoughnessCalculations.Stddev(subset.dev);
			Ra_values(j,i) = SurfaceRoughnessCalculations.Ra(subset.dev);
			Rq_values(j,i) = SurfaceRoughnessCalculations.Rq(subset.dev);
			Rv_values(j,i) = SurfaceRoughnessCalculations.Rv(subset.dev);
			Rp_values(j,i) = SurfaceRoughnessCalculations.Rp(subset.dev);
			Rz_values(j,i) = SurfaceRoughnessCalculations.Rz(subset.dev);
			Rsk_values(j,i) = SurfaceRoughnessCalculations.Rsk(subset.dev);
			Rku_values(j,i) = SurfaceRoughnessCalculations.Rku(subset.dev);
			RzJIS_values(j,i) = SurfaceRoughnessCalculations.RzJIS(subset.dev);
		else
			mean_values(j,i) = 0;
			stddev_values(j,i) = 0;
			Ra_values(j,i) = 0;
			Rq_values(j,i) = 0;
			Rv_values(j,i) = 0;
			Rp_values(j,i) = 0;
			Rz_values(j,i) = 0;
			Rsk_values(j,i) = 0;
			Rku_values(j,i) = 0;
			RzJIS_values(j,i) = 0;
		end%if
	end%for i
end%for j

mean_vector = zeros(1,length(z_steps)-1);
stddev_vector = mean_vector;
Ra_vector = mean_vector;
Rq_vector = mean_vector;
Rv_vector = mean_vector;
Rp_vector = mean_vector;
Rz_vector = mean_vector;
Rsk_vector = mean_vector;
Rku_vector = mean_vector;
RzJIS_vector = mean_vector;

for i = 1:length(z_steps) - 1
	mean_vector(i) = mean(mean_values(:,i));
	stddev_vector(i) = mean(stddev_values(:,i));
	Ra_vector(i) = mean(Ra_values(:,i));
	Rq_vector(i) = mean(Rq_values(:,i));
	Rv_vector(i) = mean(Rv_values(:,i));
	Rp_vector(i) = mean(Rp_values(:,i));
	Rz_vector(i) = mean(Rz_values(:,i));
	Rsk_vector(i) = mean(Rsk_values(:,i));
	Rku_vector(i) = mean(Rku_values(:,i));
	RzJIS_vector(i) = mean(RzJIS_values(:,i));
end%for i

% xlim([min(la100_scan.data.x),max(la100_scan.data.x)]);
% daspect([1,1,1]);

% Plot
if(bool_plot)
	f = figure('units','normalized','position',[0.3,0.1,0.4,0.8]);
	% subplot(2,5,1)
	subplot(5,2,1)
	plot(z_steps(1:end-1),mean_vector);
	title('Mean');
	xlabel('Height (mm)');
	ylabel('Value (mm)');
	grid on;
	% subplot(2,5,2)
	subplot(5,2,2)
	plot(z_steps(1:end-1),stddev_vector);
	title('Stddev');
	xlabel('Height (mm)');
	ylabel('Value (mm)');
	grid on;
	% ylim([0,0.3]);
	% subplot(2,5,3)
	subplot(5,2,3)
	plot(z_steps(1:end-1),Ra_vector);
	title('W_{a}');
	xlabel('Height (mm)');
	ylabel('Value (mm)');
	grid on;
	% subplot(2,5,4)
	subplot(5,2,4)
	plot(z_steps(1:end-1),Rq_vector);
	title('W_{q}');
	xlabel('Height (mm)');
	ylabel('Value (mm)');
	grid on;
	% subplot(2,5,5)
	subplot(5,2,5)
	plot(z_steps(1:end-1),Rv_vector);
	title('W_{v}');
	xlabel('Height (mm)');
	ylabel('Value (mm)');
	grid on;
	% subplot(2,5,6)
	subplot(5,2,6)
	plot(z_steps(1:end-1),Rp_vector);
	title('W_{p}');
	xlabel('Height (mm)');
	ylabel('Value (mm)');
	grid on;
	% subplot(2,5,7)
	subplot(5,2,7)
	plot(z_steps(1:end-1),Rz_vector);
	title('W_{z}');
	xlabel('Height (mm)');
	ylabel('Value (mm)');
	grid on;
	% subplot(2,5,8)
	subplot(5,2,8)
	plot(z_steps(1:end-1),Rsk_vector);
	title('W_{sk}');
	xlabel('Height (mm)');
	ylabel('Value (mm)');
	grid on;
	% subplot(2,5,9)
	subplot(5,2,9)
	plot(z_steps(1:end-1),Rku_vector);
	title('W_{ku}');
	xlabel('Height (mm)');
	ylabel('Value (mm)');
	grid on;
	% subplot(2,5,10)
	subplot(5,2,10)
	plot(z_steps(1:end-1),RzJIS_vector);
	title('W_{zJIS}');
	xlabel('Height (mm)');
	ylabel('Value (mm)');
	grid on;
end%if

if(bool_surf)
	x_vector = squeeze(x_steps(1:end-1)');
	z_vector = squeeze(z_steps(1:end-1)');
	[x_vector,z_vector] = meshgrid(x_vector,z_vector);

	f = figure;
	set(f, 'Units', 'Normalized', 'OuterPosition', [0, 0.5, 0.2, 0.45]);
	surf(x_vector,z_vector,mean_values');
	daspect([1,1,0.1]);
	view(0,90);
	colorbar;
	xlabel('X (mm)');
	ylabel('Z (mm)');
	title('Deviation Mean (mm)');

	f = figure;
	set(f, 'Units', 'Normalized', 'OuterPosition', [0.2, 0.5, 0.2, 0.45]);
	surf(x_vector,z_vector,stddev_values');
	daspect([1,1,0.1]);
	view(0,90);
	colorbar;
	xlabel('X (mm)');
	ylabel('Z (mm)');
	title('Deviation Stddev (mm)');

	f = figure;
	set(f, 'Units', 'Normalized', 'OuterPosition', [0.4, 0.5, 0.2, 0.45]);
	surf(x_vector,z_vector,Ra_values');
	daspect([1,1,0.1]);
	view(0,90);
	colorbar;
	xlabel('X (mm)');
	ylabel('Z (mm)');
	title('Deviation W_{a} (mm)');

	f = figure;
	set(f, 'Units', 'Normalized', 'OuterPosition', [0.6, 0.5, 0.2, 0.45]);
	surf(x_vector,z_vector,Rq_values');
	daspect([1,1,0.1]);
	view(0,90);
	colorbar;
	xlabel('X (mm)');
	ylabel('Z (mm)');
	title('Deviation W_{q} (mm)');

	f = figure;
	set(f, 'Units', 'Normalized', 'OuterPosition', [0.8, 0.5, 0.2, 0.45]);
	surf(x_vector,z_vector,Rv_values');
	daspect([1,1,0.1]);
	view(0,90);
	colorbar;
	xlabel('X (mm)');
	ylabel('Z (mm)');
	title('Deviation W_{v} (mm)');

	f = figure;
	set(f, 'Units', 'Normalized', 'OuterPosition', [0, 0.05, 0.2, 0.45]);
	surf(x_vector,z_vector,Rp_values');
	daspect([1,1,0.1]);
	view(0,90);
	colorbar;
	xlabel('X (mm)');
	ylabel('Z (mm)');
	title('Deviation W_{p} (mm)');

	f = figure;
	set(f, 'Units', 'Normalized', 'OuterPosition', [0.2, 0.05, 0.2, 0.45]);
	surf(x_vector,z_vector,Rz_values');
	daspect([1,1,0.1]);
	view(0,90);
	colorbar;
	xlabel('X (mm)');
	ylabel('Z (mm)');
	title('Deviation W_{z} (mm)');

	f = figure;
	set(f, 'Units', 'Normalized', 'OuterPosition', [0.4, 0.05, 0.2, 0.45]);
	surf(x_vector,z_vector,Rsk_values');
	daspect([1,1,0.1]);
	view(0,90);
	colorbar;
	xlabel('X (mm)');
	ylabel('Z (mm)');
	title('Deviation W_{sk} (mm)');

	f = figure;
	set(f, 'Units', 'Normalized', 'OuterPosition', [0.6, 0.05, 0.2, 0.45]);
	surf(x_vector,z_vector,Rku_values');
	daspect([1,1,0.1]);
	view(0,90);
	colorbar;
	xlabel('X (mm)');
	ylabel('Z (mm)');
	title('Deviation W_{ku} (mm)');

	f = figure;
	set(f, 'Units', 'Normalized', 'OuterPosition', [0.8, 0.05, 0.2, 0.45]);
	surf(x_vector,z_vector,RzJIS_values');
	daspect([1,1,0.1]);
	view(0,90);
	colorbar;
	xlabel('X (mm)');
	ylabel('Z (mm)');
	title('Deviation W_{zJIS} (mm)');
end%if