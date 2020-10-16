%% GKN Invar Preform Cross Section Analysis
clc, close all, clear all

overhang_flags = 	[1,0
					36,0
					38,10
					43,20
					48,30
					86,35
					108,30
					130,20
					146,10
					171,0
					184,-10
					210,-20
					234,-30
					270,-35
					275,-30
					279,-20
					282,-10
					311,0];

file_path = 'C:\Users\pty883\University of Tennessee\UT_MABE_Welding - Documents\GKN Invar\Scans\Invar\[P] Cross Section Deviation.asc';

% Extract part
g = GOMDeviationSection(file_path);
subset = g.z > 0;
x = g.x(subset);
z = g.z(subset);
dev = g.dev(subset);

% Part stats
layer_height = 2.2; % mm
bottom_z = min(z);
[top_z,top_of_part_index] = max(z);
part_height = top_z - bottom_z;

% Layer flags
n_layers = floor(part_height / layer_height);
height_flags = layer_height .* (0:n_layers);

% Front and Back extraction
back_indices = 1:top_of_part_index;
front_indices = (top_of_part_index+1):length(z);

front_x = x(front_indices);
front_z = z(front_indices);
back_x = x(back_indices);
back_z = z(back_indices);

front_dev = dev(front_indices);
back_dev = dev(back_indices);

% Layer-wise deviation
front_deviation_layers = zeros(1,n_layers);
back_deviation_layers = front_deviation_layers;

for i = 1:n_layers
	height_min = height_flags(i);
	height_max = height_flags(i+1);
	front_subset_indices = front_z > height_min & front_z <= height_max;
	front_dev_subset = front_dev(front_subset_indices);
	back_subset_indices = back_z > height_min & back_z <= height_max;
	back_dev_subset = back_dev(back_subset_indices);

	front_deviation_layers(i) = mean(front_dev_subset);
	back_deviation_layers(i) = mean(back_dev_subset);
end%for i

figure;
plot(front_deviation_layers,1:n_layers,'k')
grid on;
ylabel('Layer Number');
xlabel('Average Deviation (mm)');
line([mean(front_dev),mean(front_dev)],[0,350],'color','k','linestyle','--');
line([0,0],[0,350],'color','k');
legend('Front Deviation','Mean')

figure;
plot(back_deviation_layers,1:n_layers,'k');
grid on;
ylabel('Layer Number');
xlabel('Average Deviation (mm)');
line([mean(back_dev),mean(back_dev)],[0,350],'color','k','linestyle','--');
line([0,0],[0,350],'color','k');
legend('Back Deviation','Mean');

% Overhang-wise deviation
overhang_flag_size = size(overhang_flags);
n_overhangs = overhang_flag_size(1) - 1;
front_overhang_deviation_vector = zeros(1,n_overhangs);

for i = 1:n_overhangs
	index_range = overhang_flags(i,1):overhang_flags(i+1,1);
	front_overhang_deviation_vector(i) = mean(front_deviation_layers(index_range));
	back_overhang_deviation_vector(i) = mean(back_deviation_layers(index_range));
end%for i

angles = [0,10,20,30,35,30,20,10,0,-10,-20,-30,-35,-30,-20,-10,0];

figure;
plot(angles,front_overhang_deviation_vector,'k',angles,back_overhang_deviation_vector,'r');
grid on;
xlabel('Overhang Angle (degrees)');
ylabel('Average Deviation (mm)');
legend('Front Deviation','Back Deviation');

% Plotting
bool_plot = false;
if(bool_plot)
	plot(front_x,front_z,'k');
	hold on;
	plot(back_x,back_z,'r');
	hold off;
end%if