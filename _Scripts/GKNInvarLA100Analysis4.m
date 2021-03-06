%% LA100 Analysis 4
% Performed after meeting with Dr. Hamel
% Intent: look into subsets of the build which are steady-state
% Intent: distill data into easily digestible charts and metrics

% matt's file_path = /Users/mlamsey/Documents/MATLAB/welding/NetShapeAnalysis/Scans
% front = [P] LA100 Full Res Center Front.asc
% back = [P] LA100 Full Res Center Back.asc

close all;
clearvars -except s;

if(~exist('s','var'))
    s = FileTools.PromptForScanImport;
    ScanMethods.SwitchScanDataAxes(s.data,'y','z');
end%if

% f = figure('position',[0,0,1400,800],'name','Resolution Comparison');
% x_step_increments = [2.3,5,10,15,20,30];
x_step_increments = 2.3;
for resolution_i = 1:length(x_step_increments)

	% ===== Build Parameters ===== %
	n_deposited_layers = 296; % from slicer
	layer_height = 2.31; % mm - from GOM analysis

	% ===== Analysis Parameters ===== %
	layer_end_offset = 10;

	% ===== Build Flags ===== %
	layer_overnight_pause = 169;
	replaced_layer = 251;
	% layer #, error position (see figure), mm search
	dynamic_load_errors = [39,6,0
						42,2,0
						61,3,0
						75,6,0
						82,2,0
						86,6,0
						88,1,0
						89,6,0
						90,6,0
						91,3,0
						92,1,0
						94,1,0
						95,6,0
						96,1,0
						97,6,0
						102,2,0
						103,2,0
						107,1,0
						109,6,0
						110,2,0
						112,2,0
						113,1,0
						116,6,0
						117,1,0
						118,1,0
						124,1,0
						193,1,0
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

	% ===== Extract Initial Data ===== %
	data = s.data;
	% x_window_size = 1 * layer_height;
	x_window_size = x_step_increments(resolution_i);

	x_range = [min(data.x),max(data.x)];
	y_range = [min(data.y),max(data.y)];
	z_range = [min(data.z),max(data.z)];

	n_x_points = ceil((x_range(2) - x_range(1)) / x_window_size);
	n_y_points = ceil((y_range(2) - y_range(1)) / layer_height);
	n_z_points = ceil((z_range(2) - z_range(1)) / layer_height);

	x_steps = x_range(1) : x_window_size : (x_range(1) + (n_x_points * x_window_size));
	y_steps = y_range(1) : layer_height : (y_range(1) + (n_y_points * layer_height));
	z_steps = z_range(1) : layer_height : (z_range(1) + (n_z_points * layer_height));

	n_layers = length(z_steps) - 1;
	fprintf('Scan contains %i layers\n',n_layers);

	% Recalculate build flags
	if(n_layers ~= n_deposited_layers)
		layer_shift = (n_deposited_layers - n_layers);
		fprintf('Number of scanned layers (%i) ~= number of deposited layers (%i)\nShifting irregularity flags by %i layers\n',...
			n_layers,n_deposited_layers,layer_shift);

		dynamic_load_errors(:,1) = dynamic_load_errors(:,1) - layer_shift;
		dynamic_load_layers = dynamic_load_errors(:,1);
		fin_error_start = fin_error_start - layer_shift;
		fin_error_end = fin_error_end - layer_shift;
		collision_layer = collision_layer - layer_shift;
	end%if

	% Get part geometry
	top_of_part = z_range(2);
	bottom_of_part = top_of_part - (n_layers * layer_height);
	layer_height_vector = linspace(bottom_of_part,top_of_part,n_layers);
	n_x_windows = ceil((x_range(2) - x_range(1)) / x_window_size);

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

	% Layer subset range
	degree_overhang_inside_range = layer_end_offset + 1:(n_deposited_layers - layer_end_offset);
	degree_overhang = degree_overhang(degree_overhang_inside_range);

	% Recalculate degree_overhang
	if(n_layers ~= n_deposited_layers)
		fprintf('Shifting degree overhang changes by %i layers\n',layer_shift);
		degree_overhang = degree_overhang((n_deposited_layers - n_layers):end);
	end%if

	% Generate flags for changing degree overhang
	d_degree_overhang = diff(degree_overhang);
	overhang_change_flags = 1:length(d_degree_overhang);
	overhang_change_flags = overhang_change_flags(abs(d_degree_overhang) > 0);
	overhang_change_flags(2:end+1) = overhang_change_flags(1:end);
	overhang_change_flags(1) = 1;
	overhang_change_flags(end+1) = length(degree_overhang) - 1;

	% ===== Analysis ===== %
	% ----- Layer-wise ----- %
	metric_values = zeros(1,n_layers);
	metric_string = 'stddev';

	fprintf('\nCalculating %s for:\n',metric_string);
	for i = 1:n_layers
		fprintf('%i \\ %i layer',i,n_layers);
		z_min = z_steps(i);
		z_max = z_steps(i + 1);

		z_subset = ScanMethods.GetScanDataSubsetInRange(data,'z',z_min,z_max);
		metric_temp = zeros(1,n_x_windows);

		for j = 1:n_x_windows
			x_min = x_steps(j);
			x_max = x_steps(j + 1);

			data_subset = ScanMethods.GetScanDataSubsetInRange(z_subset,'x',x_min,x_max);
			
			if(length(data_subset.dev) > 0)
				metric_temp(j) = SurfaceAnalysisMethods.QueryMetric(data_subset,metric_string);
			else
				metric_temp(j) = 0;
			end%if

		end%for j

		metric_values(i) = mean(metric_temp);

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
	recalc = false;

	% ----- Angle-wise ----- %
	angles = [0,10,20,30,35,30,20,10,0,-10,-20,-30,-35,-30,-20,-10,0];

	metric_averages = zeros(1,length(overhang_change_flags) - 1);
	for i = 1:length(metric_averages)
		index_range = (overhang_change_flags(i) : overhang_change_flags(i + 1)) + layer_end_offset;
		metric_subset = metric_values(index_range);
		metric_averages(i) = mean(metric_subset);
	end%for i

	ga_angles = [0,10,20,30,35];
	nga_angles = [-10,-20,-30,-35];
	metric_ga_averages = zeros(1,length(ga_angles));
	metric_ga_stddev = metric_ga_averages;
	metric_nga_averages = zeros(1,length(nga_angles));
	metric_nga_stddev = metric_nga_averages;

	for i = 1:length(ga_angles)
		subset_indices = degree_overhang == ga_angles(i);
		metric_ga_averages(i) = mean(metric_values(subset_indices));
		metric_ga_stddev(i) = std(metric_values(subset_indices));
	end%for i
	for i = 1:length(nga_angles)
		subset_indices = degree_overhang == nga_angles(i);
		metric_nga_averages(i) = mean(metric_values(subset_indices));
		metric_nga_stddev(i) = std(metric_values(subset_indices));
	end%for i

	% ===== Plotting ===== %
	angle_labels = {'0','10','20','30','35','30','20','10','0','-10','-20','-30','-35','-30','-20','-10','0'};

	fprintf('Plotting...\n');
	% f = figure('position',[0,0,1400,800],'name',sprintf('2.3mm x %1.1fmm windows',x_window_size));
	% subplot(2,2,1)
	% hold on;
	% % Plot by layer - using angle change flags
	% for i = 1:length(overhang_change_flags) - 1
	% 	index_range = (overhang_change_flags(i) : overhang_change_flags(i + 1)) + layer_end_offset;
	% 	metric_subset = metric_values(index_range);
	% 	plot(index_range,metric_subset);
	% end%for i

	% % plot dynamic load errors
	% plot(dynamic_load_layers,metric_values(dynamic_load_layers),'ko');

	% % plot start/stop line
	% line([layer_overnight_pause,layer_overnight_pause],[min(ylim),max(ylim)],'color','k','linestyle','--');

	% % legend
	% legend_labels = angle_labels;
	% legend_labels{end + 1} = 'Dynamic Load Errors';
	% legend_labels{end + 1} = 'Overnight Stop';

	% legend(legend_labels,'location','eastoutside','orientation','vertical');
	% title(metric_string);
	% xlabel('Layer Number');
	% ylabel('Metric Value');
	% hold off;
	% grid on;

	% % plot by angle
	% subplot(2,2,3)
	% hold on;
	% % GA
	% ga_points = [1:9,length(angles)];
	% plot(abs(angles(ga_points)),metric_averages(ga_points),'k-o');
	% % NGA
	% nga_points = 10:length(angles)-1;
	% plot(abs(angles(nga_points)),metric_averages(nga_points),'r-o');
	% hold off;
	% grid on;
	% legend('GA Slope','NGA Overhang');
	% title(metric_string);
	% xlabel('Layer Number');
	% ylabel('Metric Value');

	% subplot(2,2,4)
	% hold on;
	% % GA
	% ascending_ga_points = [1:5];
	% % descending_ga_points = [6:9,length(angles)];
	% descending_ga_points = 6:9;
	% plot(abs(angles(ascending_ga_points)),metric_averages(ascending_ga_points),'k-o');
	% plot(abs(angles(descending_ga_points)),metric_averages(descending_ga_points),'r-o');
	% % NGA
	% increasing_nga_points = 10:13;
	% decreasing_nga_points = 14:length(angles)-1;
	% plot(abs(angles(increasing_nga_points)),metric_averages(increasing_nga_points),'g-o');
	% plot(abs(angles(decreasing_nga_points)),metric_averages(decreasing_nga_points),'m-o');
	% hold off;
	% grid on;
	% legend('GA Increasing Slope','GA Decreasing Slope','NGA Increasing Overhang','NGA Degreasing Overhang');
	% title(metric_string);
	% xlabel('Layer Number');
	% ylabel('Metric Value');

	% Error bars
	% subplot(2,3,resolution_i)
	hold on;
	errorbar(ga_angles,metric_ga_averages,metric_ga_stddev,'k-o');
	errorbar(abs(nga_angles),metric_nga_averages,metric_nga_stddev,'r-o');
	hold off;
	grid on;
	legend('GA Slope','NGA Overhang');
	title(strcat(metric_string,{' '},sprintf('2.3mm x %1.1fmm Windows',x_window_size)));
	xlabel('Slope Angle [Degrees]');
	ylabel('Metric Value [ f(mm) ]');
end%for resolution_i


