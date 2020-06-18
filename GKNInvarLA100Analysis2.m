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
indices(end+1) = length(degree_overhang) - 1;

layer_roughness_matrix = zeros(8,n_layers - 1);


for i = 1:n_layers - 1
	layer_subset_indices = g.y > layer_height_vector(i) & g.y < layer_height_vector(i + 1);
	deviation_subset = g.dev(layer_subset_indices);
	deviation_subset = deviation_subset(abs(deviation_subset) < 5);

	layer_roughness_matrix(1,i) = SurfaceRoughnessCalculations.Ra(deviation_subset);
	layer_roughness_matrix(2,i) = SurfaceRoughnessCalculations.Rq(deviation_subset);
	layer_roughness_matrix(3,i) = SurfaceRoughnessCalculations.Rv(deviation_subset);
	layer_roughness_matrix(4,i) = SurfaceRoughnessCalculations.Rp(deviation_subset);
	layer_roughness_matrix(5,i) = SurfaceRoughnessCalculations.Rz(deviation_subset);
	layer_roughness_matrix(6,i) = SurfaceRoughnessCalculations.Rsk(deviation_subset);
	layer_roughness_matrix(7,i) = SurfaceRoughnessCalculations.Rku(deviation_subset);
	layer_roughness_matrix(8,i) = SurfaceRoughnessCalculations.RzJIS(deviation_subset);

	length(deviation_subset)
end%for i

plot_labels = {'Ra - Arithmetic Mean','Rq - RMS','Rv - Deepest Valley','Rp - Highest Peak','Rz - Max Height','Rsk - Skewness','Rku - Kurtosis','RzJIS - Max Height JIS'};
angle_labels = {'0','10','20','30','35','30','20','10','0','-10','-20','-30','-35','-30','-20','-10','0'};

for i = 8:8
	% subplot(2,4,i)
	hold on;
	for j = 1:length(indices)-1
		index_subset = indices(j):indices(j+1);
		plot(index_subset,layer_roughness_matrix(i,index_subset));
	end%for j
	ylabel('Metric (mm)');
	xlabel('Layer Number');
	title(plot_labels{i});
	grid on;
	legend(angle_labels);
	hold off;
end%for i