%% LA100 Analysis 3
% Performed after meeting with Dr. Hamel
% Intent: look into subsets of the build which are steady-state
% Intent: distill data into easily digestible charts and metrics

clearvars -except s;

% ===== Build Parameters ===== %
n_deposited_layers = 296; % from slicer
layer_height = 2.31; % mm - from GOM analysis

% ===== Build Flags ===== %
layer_overnight_pause = 169;
replaced_layer = 251;
% layer #, joint #, mm search
dynamic_load_errors = [193,1,0
					205,1,0
					207,1,-3.25
					211,6,-3.8
					212,6,-4
					213,1,-4.7
					223,1,-3
					244,6,-4.5
					247,1,-3.84];

dynamic_load_layers = dynamic_load_errors(:,1);

fin_error_start = 243;
fin_error_end = 250;
collision_layer = 274; % required tcp recalibration, fins reprinted

% ===== Overhang ===== %
% Based on slice plan

% DEGREE OVERHANG
degree_overhang = zeros(1,n_deposited_layers); % layer-wise

% Assign hard-coded torch angle values for NGA sections
degree_overhang(1:34) = 0;
degree_overhang(35:36) = 10;
degree_overhang(37:41) = 20;
degree_overhang(42:46) = 30;
degree_overhang(47:82) = 35;
degree_overhang(83:103) = 30;
degree_overhang(104:128) = 20;
degree_overhang(129:139) = 10;
degree_overhang(140:163) = 0;
degree_overhang(164:175) = -10;
degree_overhang(176:200) = -20;
degree_overhang(201:223) = -30;
degree_overhang(224:257) = -35;
degree_overhang(258:262) = -30;
degree_overhang(263:267) = -20;
degree_overhang(268:269) = -10;
degree_overhang(270:end) = 0;

% Generate flags for changing degree overhang
d_degree_overhang = diff(degree_overhang);
overhang_change_flags = 1:length(d_degree_overhang);
overhang_change_flags = overhang_change_flags(abs(d_degree_overhang) > 0);
overhang_change_flags(2:end+1) = overhang_change_flags(1:end);
overhang_change_flags(1) = 1;
overhang_change_flags(end+1) = length(degree_overhang) - 1;

% ===== Extract Initial Data ===== %
data = s.data;

x_range = [min(data.x),max(data.x)];
y_range = [min(data.y),max(data.y)];
z_range = [min(data.z),max(data.z)];

n_x_points = ceil((x_range(2) - x_range(1)) / layer_height);
n_y_points = ceil((y_range(2) - y_range(1)) / layer_height);
n_z_points = ceil((z_range(2) - z_range(1)) / layer_height);

x_steps = x_range(1) : layer_height : (x_range(1) + (n_x_points * layer_height));
y_steps = y_range(1) : layer_height : (y_range(1) + (n_y_points * layer_height));
z_steps = z_range(1) : layer_height : (z_range(1) + (n_z_points * layer_height));

n_layers = length(z_steps) - 1;
fprintf('Scan contains %i layers\n',n_layers);

% Get part geometry
top_of_part = z_range(2);
bottom_of_part = top_of_part - (n_layers * layer_height);
layer_height_vector = linspace(bottom_of_part,top_of_part,n_layers);
n_x_windows = ceil((x_range(2) - x_range(1)) / layer_height);

% ===== Analysis ===== %
Rz_values = zeros(1,n_layers);

fprintf('Calculating metrics for:\n');
for i = 1:n_layers
	fprintf('%i \\ %i layer',i,n_layers);
	z_min = z_steps(i);
	z_max = z_steps(i + 1);

	z_subset = ScanMethods.GetScanDataSubsetInRange(data,'z',z_min,z_max);
	Rz_temp = zeros(1,n_x_windows);

	for j = 1:n_x_windows
		x_min = x_steps(j);
		x_max = x_steps(j + 1);

		data_subset = ScanMethods.GetScanDataSubsetInRange(z_subset,'x',x_min,x_max);
		
		if(length(data_subset.dev) > 0)
			Rz_temp(j) = AnalysisMethods.QueryMetric(data_subset,'Rz');
		else
			Rz_temp(j) = 0;
		end%if

	end%for j

	Rz_values(i) = mean(Rz_temp);

	% Backspace progress
	if(i ~= n_layers)
		if(i < 10)
			fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b');
		elseif(i < 100)
			fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
		elseif(i < 1000)
			fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
		end%if
	else
		fprintf('\nDone!\n\n');
	end%if
end%for i

% ===== Plotting ===== %
angles = [0,10,20,30,35,30,20,10,0,-10,-20,-30,-35,-30,-20,-10,0];
angle_labels = {'0','10','20','30','35','30','20','10','0','-10','-20','-30','-35','-30','-20','-10','0'};

fprintf('Plotting...\n');

plot(Rz_values);

% Plot by angle
% hold on;
% for i = 1:length(overhang_change_flags) - 1
% 	plot()
% end%for i
% hold off;