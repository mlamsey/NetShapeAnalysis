% close all;

% % Hard coded stuff
% n_layers = 296; % from slicer
% layer_height = 2.3; % mm - from GOM analysis

% top_of_part = max(s.data.z);
% bottom_of_part = top_of_part - (n_layers * layer_height);
% layer_height_vector = linspace(bottom_of_part,top_of_part,n_layers);

% % DEGREE OVERHANG
% degree_overhang = zeros(1,n_layers);

% % Assign hard-coded torch angle values for NGA sections
% degree_overhang(1:34) = 0;
% degree_overhang(35:36) = 10;
% degree_overhang(37:41) = 20;
% degree_overhang(42:46) = 30;
% degree_overhang(47:82) = 35;
% degree_overhang(83:103) = 30;
% degree_overhang(104:128) = 20;
% degree_overhang(129:139) = 10;
% degree_overhang(140:163) = 0;
% degree_overhang(164:175) = -10;
% degree_overhang(176:200) = -20;
% degree_overhang(201:223) = -30;
% degree_overhang(224:257) = -35;
% degree_overhang(258:262) = -30;
% degree_overhang(263:267) = -20;
% degree_overhang(268:269) = -10;
% degree_overhang(270:end) = 0;

% angles = [0,10,20,30,35,30,20,10,0,-10,-20,-30,-35,-30,-20,-10,0];

% d_degree_overhang = diff(degree_overhang);
% indices = 1:length(d_degree_overhang);
% indices = indices(abs(d_degree_overhang) > 0);
% indices(2:end+1) = indices(1:end);
% indices(1) = 1;
% indices(end+1) = length(degree_overhang) - 1;

% % define metric matrices
% window_length_mm = layer_height;
% window_height_mm = layer_height;

% x_range = [min(s.data.x),max(s.data.x)];
% z_range = [min(s.data.z),max(s.data.z)];

% value_vector_size_1 = ceil((x_range(2) - x_range(1)) / window_length_mm);
% value_vector_size_2 = ceil((z_range(2) - z_range(1)) / window_height_mm);

% mean_values = zeros(value_vector_size_1,value_vector_size_2);
% stddev_values = mean_values;
% Ra_values = mean_values;
% Rq_values = mean_values;
% Rv_values = mean_values;
% Rp_values = mean_values;
% Rz_values = mean_values;
% Rsk_values = mean_values;
% Rku_values = mean_values;
% RzJIS_values = mean_values;

% -----------------------------------------------------

s = GOMScan('C:\Users\pty883\University of Tennessee\UT_MABE_Welding - Documents\GKN Invar\Scans\GOM\Export\[P] Full Res Tool Mold Surface.asc');
ScanMethods.SwitchScanDataAxes(s.data,'y','z');

n_deposited_layers = 296;
mm_removed_bandsaw = 7; % mm, approximate

layer_height = 2.31;

% make square window
window_height_mm = layer_height;
window_length_mm = window_height_mm;

% make containers
x_range = [min(s.data.x),max(s.data.x)];
z_range = [min(s.data.z),max(s.data.z)];

value_vector_size_1 = ceil((x_range(2) - x_range(1)) / window_length_mm);
value_vector_size_2 = ceil((z_range(2) - z_range(1)) / window_height_mm);

mean_values = zeros(1,value_vector_size_2);
stddev_values = mean_values;
Ra_values = mean_values;
Rq_values = mean_values;
Rv_values = mean_values;
Rp_values = mean_values;
Rz_values = mean_values;
Rsk_values = mean_values;
Rku_values = mean_values;
RzJIS_values = mean_values;

data = s.data;

x_range = [min(data.x),max(data.x)];
y_range = [min(data.y),max(data.y)];
z_range = [min(data.z),max(data.z)];

n_x_points = ceil((x_range(2) - x_range(1)) / window_length_mm);
n_y_points = ceil((y_range(2) - y_range(1)) / window_length_mm);
n_z_points = ceil((z_range(2) - z_range(1)) / window_length_mm);

x_steps = x_range(1) : window_length_mm : (x_range(1) + (n_x_points * window_length_mm));
y_steps = y_range(1) : window_length_mm : (y_range(1) + (n_y_points * window_length_mm));
z_steps = z_range(1) : window_length_mm : (z_range(1) + (n_z_points * window_length_mm));

n_layers = length(z_steps) - 1;
fprintf('Calculating for %i layers...\n',n_layers);

tic;
for i = 1:n_layers
	fprintf('%i \\ %i layer',i,n_layers);
	z_min = z_steps(i);
	z_max = z_steps(i + 1);

	mean_temp = zeros(1,value_vector_size_1);
	stddev_temp = mean_temp;
	Ra_temp = mean_temp;
	Rq_temp = mean_temp;
	Rv_temp = mean_temp;
	Rp_temp = mean_temp;
	Rz_temp = mean_temp;
	Rsk_temp = mean_temp;
	Rku_temp = mean_temp;
	RzJIS_temp = mean_temp;

	z_subset = ScanMethods.GetScanDataSubsetInRange(data,'z',z_min,z_max);

	for j = 1:value_vector_size_1
		x_min = x_steps(j);
		x_max = x_steps(j + 1);

		% subset = ScanMethods.GetScanDataSubsetInWindow(data,'z',[z_min,z_max],'x',[x_min,x_max]);
		subset = ScanMethods.GetScanDataSubsetInRange(z_subset,'x',x_min,x_max);

		if(length(subset.dev) > 0)
			mean_temp(j) = SurfaceRoughnessCalculations.Mean(subset.dev);
			stddev_temp(j) = SurfaceRoughnessCalculations.Stddev(subset.dev);
			Ra_temp(j) = SurfaceRoughnessCalculations.Ra(subset.dev);
			Rq_temp(j) = SurfaceRoughnessCalculations.Rq(subset.dev);
			Rv_temp(j) = SurfaceRoughnessCalculations.Rv(subset.dev);
			Rp_temp(j) = SurfaceRoughnessCalculations.Rp(subset.dev);
			Rz_temp(j) = SurfaceRoughnessCalculations.Rz(subset.dev);
			Rsk_temp(j) = SurfaceRoughnessCalculations.Rsk(subset.dev);
			Rku_temp(j) = SurfaceRoughnessCalculations.Rku(subset.dev);
			RzJIS_temp(j) = SurfaceRoughnessCalculations.RzJIS(subset.dev);
		else
			mean_temp(j) = 0;
			stddev_temp(j) = 0;
			Ra_temp(j) = 0;
			Rq_temp(j) = 0;
			Rv_temp(j) = 0;
			Rp_temp(j) = 0;
			Rz_temp(j) = 0;
			Rsk_temp(j) = 0;
			Rku_temp(j) = 0;
			RzJIS_temp(j) = 0;
		end%if
	end%for j

	mean_values(i) = mean(mean_temp);
	stddev_values(i) = mean(stddev_temp);
	Ra_values(i) = mean(Ra_temp);
	Rq_values(i) = mean(Rq_temp);
	Rv_values(i) = mean(Rv_temp);
	Rp_values(i) = mean(Rp_temp);
	Rz_values(i) = mean(Rz_temp);
	Rsk_values(i) = mean(Rsk_temp);
	Rku_values(i) = mean(Rku_temp);
	RzJIS_values(i) = mean(RzJIS_temp);

	if(i < 10)
		fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b');
	elseif(i < 100)
		fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
	elseif(i < 1000)
		fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
	end%if
end%for i
fprintf('Metrics calculated in %1.3f seconds\n',toc);

% subplot(2,5,1)
subplot(5,2,1)
plot(mean_values);
title('Mean');
xlabel('Layer Number');
ylabel('Value (mm)');
grid on;
% subplot(2,5,2)
subplot(5,2,2)
plot(stddev_values);
title('Stddev');
xlabel('Layer Number');
ylabel('Value (mm)');
grid on;
ylim([0,0.3]);
% subplot(2,5,3)
subplot(5,2,3)
plot(Ra_values);
title('W_{a}');
xlabel('Layer Number');
ylabel('Value (mm)');
grid on;
% subplot(2,5,4)
subplot(5,2,4)
plot(Rq_values);
title('W_{q}');
xlabel('Layer Number');
ylabel('Value (mm)');
grid on;
% subplot(2,5,5)
subplot(5,2,5)
plot(Rv_values);
title('W_{v}');
xlabel('Layer Number');
ylabel('Value (mm)');
grid on;
% subplot(2,5,6)
subplot(5,2,6)
plot(Rp_values);
title('W_{p}');
xlabel('Layer Number');
ylabel('Value (mm)');
grid on;
% subplot(2,5,7)
subplot(5,2,7)
plot(Rz_values);
title('W_{z}');
xlabel('Layer Number');
ylabel('Value (mm)');
grid on;
% subplot(2,5,8)
subplot(5,2,8)
plot(Rsk_values);
title('W_{sk}');
xlabel('Layer Number');
ylabel('Value (mm)');
grid on;
% subplot(2,5,9)
subplot(5,2,9)
plot(Rku_values);
title('W_{ku}');
xlabel('Layer Number');
ylabel('Value (mm)');
grid on;
% subplot(2,5,10)
subplot(5,2,10)
plot(RzJIS_values);
title('W_{zJIS}');
xlabel('Layer Number');
ylabel('Value (mm)');
grid on;