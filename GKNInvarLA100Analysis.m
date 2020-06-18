% Script to process LA 100 demonstrator
close all;

if(~isa(g,'GOMSurfaceComparison'))
	fprintf('ERROR: GKNInvarLA100Analysis: variable g not defined as a GOMSurfaceComparison\n');
	return;
end%if

n_layers = 296; % from slicer
layer_height = 2.29; % mm - from GOM analysis

top_of_part = max(g.y);
bottom_of_part = top_of_part - (n_layers * layer_height);
layer_height_vector = linspace(bottom_of_part,top_of_part,n_layers);

% DEGREE OVERHANG
degree_overhang = zeros(1,n_layers);

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

angles = [0,10,20,30,35,30,20,10,0,-10,-20,-30,-35,-30,-20,-10,0];

d_degree_overhang = diff(degree_overhang);
indices = 1:length(d_degree_overhang);
indices = indices(abs(d_degree_overhang) > 0);
indices(2:end+1) = indices(1:end);
indices(1) = 1;
indices(end+1) = length(degree_overhang);

n_angles = length(d_degree_overhang(abs(d_degree_overhang) > 0)) + 1;
mean_vector = zeros(1,n_angles);
stddev_vector = zeros(1,n_angles);

% f_angles = figure;
% % hold on;

% for i = 1:n_angles
% 	current_angle = angles(i);
% 	subset_indices = indices(i):indices(i+1);
	
% 	layer_height_subset = layer_height_vector(subset_indices);

% 	indices_within_layers_of_interest = g.y > min(layer_height_subset) & g.y < max(layer_height_subset);

% 	deviation_subset = g.dev(indices_within_layers_of_interest);

% 	% angle_subset = current_angle .* ones(1,length(deviation_subset));
% 	% plot(angle_subset,deviation_subset,'.');
% 	% plot(current_angle,std(deviation_subset),'.');
% 	mean_vector(i) = mean(deviation_subset);
% 	stddev_vector(i) = std(deviation_subset);
% end%for i

% % Plot Average !
% subplot(2,2,1)
% hold on;
% plot(angles(1:2),mean_vector(1:2),'g');
% plot(angles(2:end),mean_vector(2:end),'k');
% hold off;
% grid on;
% xlabel('Angle (Degrees)');
% ylabel('Avg Deviation of Surface Deviation (mm)');
% title('mean(deviation) vs Torch Angle');
% line([min(xlim),max(xlim)],[0,0],'color','k');

% subplot(2,2,3)
% plot(layer_height_vector(indices(1:end-1)),mean_vector,'k');
% grid on;
% xlabel('Build Height Progression (mm)');
% ylabel('Avg of Surface Deviation (mm)');
% title('mean(deviation) vs Build Progression');
% line([min(xlim),max(xlim)],[0,0],'color','k');

% % Plot stddev !!
% subplot(2,2,2)
% hold on;
% plot(angles(1:2),stddev_vector(1:2),'g');
% plot(angles(2:end),stddev_vector(2:end),'k');
% hold off;
% grid on;
% xlabel('Angle (Degrees)');
% ylabel('stddev Deviation of Surface Deviation (mm)');
% title('std(deviation) vs Torch Angle');

% subplot(2,2,4)
% plot(layer_height_vector(indices(1:end-1)),stddev_vector,'k');
% grid on;
% xlabel('Build Height Progression (mm)');
% ylabel('stddev of Surface Deviation (mm)');
% title('std(deviation) vs Build Progression');

% Layer-wise Analysis

layer_mean_vector = zeros(1,n_layers - 1);
layer_stddev_vector = layer_mean_vector;

for i = 1:n_layers - 1
	layer_subset_indices = g.y > layer_height_vector(i) & g.y < layer_height_vector(i + 1);
	deviation_subset = g.dev(layer_subset_indices);

	layer_mean_vector(i) = mean(deviation_subset);
	layer_stddev_vector(i) = std(deviation_subset);

	if(i == 1)
		layer_1_deviation = deviation_subset;
	end%if
end%for i

f_layer = figure;

subplot(1,2,1)
plot(1:n_layers - 1,layer_mean_vector);
xlabel('Layer Number');
ylabel('Mean Deviation');
title('Mean Deviation');
grid on;

subplot(1,2,2)
plot(1:n_layers - 1,layer_stddev_vector);
xlabel('Layer Number');
ylabel('stddev');
title('stddev Deviation');
grid on;

% % Refined
% f_trend = figure;
% plot(angles,stddev_vector,'ko');
% grid on;