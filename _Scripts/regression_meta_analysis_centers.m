%% Meta Analysis of Overhang Regression Parameter Selection
clc, close all, clear all

fprintf('Select Parent Folder\n');
parent_dir_path = uigetdir;
disp(parent_dir_path);

parent_dir_info = dir(parent_dir_path);
parent_n_files = length(parent_dir_info);

min_vector = 2.25 .* (1:8); % layer offsets from 1:8

for dir_i = 1:parent_n_files
	parent_sub_dir_name = parent_dir_info(dir_i).name;

	if(~strcmp(parent_sub_dir_name,'.') && ~strcmp(parent_sub_dir_name,'..'))
		if(ispc)
	        parent_sub_path = strcat(parent_dir_info(dir_i).folder,'\',parent_sub_dir_name);
	    else
	        parent_sub_path = strcat(parent_dir_info(dir_i).folder,'/',parent_sub_dir_name);
	    end%if

		fprintf('\nFOLDER: %s\n',parent_sub_dir_name);

		dir_info = dir(parent_sub_path);
		n_files = length(dir_info);

		angle_matrix = zeros(9,length(min_vector));
		intercept_matrix = angle_matrix;

		for parameter_i = 1:length(min_vector)
			fprintf('TRIAL FOR LOWER OFFSET = %1.2fmm | ',min_vector(parameter_i));
			% Instantiate bonus iterators
			file_i = 1;
			angle_averages = zeros(1,9);
			intercept_averages = angle_averages;
			wall_sets = {};

			% Loop through all files
			for i = 1:n_files
			    sub_dir_name = dir_info(i).name;

			    % check if filenames are NOT navigation targets
			    if(contains(sub_dir_name,'wall'))
			        % Generate path, import contour data, assign contour in set
			        if(ispc)
			            sub_path = strcat(dir_info(i).folder,'\',sub_dir_name);
			        else
			            sub_path = strcat(dir_info(i).folder,'/',sub_dir_name);
			        end%if

			        wall_sets{file_i} = FileTools.ImportCrossSectionSetFromDirectory(sub_path);

			        % Fix Wall 5
			        if(strcmp(sub_dir_name,'wall5'))
			            temp_set = wall_sets{file_i};
			            wall_subset = {temp_set{1:50}};
			            wall_subset = flip(wall_subset);
			            
			            for k = 1:50
			                temp_set{k} = wall_subset{k};
			            end%for i

			            wall_sets{file_i} = temp_set;
			        end%if
			        file_i = file_i + 1;
			    end%if
			end%for i

			n_walls = length(wall_sets);
			slope_vector_list = cell(1,n_walls);
			intercept_vector_list = slope_vector_list;

			fprintf('Calculating Center Lines: Wall ');
			for i = 1:n_walls
			    fprintf('%i ',i);
			    lower_offset = min_vector(parameter_i);
			    upper_offset = 2.5; % mm

			    this_set = wall_sets{i};
			    index_offset = 25; % mm
			    wall_subset = this_set{1+index_offset : end-index_offset};
			    [slope_vector,intercept_vector] = ExperimentalCrossSectionAnalysisMethods.GetWallCenterLinesForSet(wall_sets{i},'z',lower_offset,upper_offset);
			    angle_vector = atan(slope_vector) .* 180 ./ pi;
			    angle_averages(i) = mean(angle_vector,'omitnan');
			    intercept_averages(i) = mean(intercept_vector,'omitnan');

			    if (i == n_walls)
			    	fprintf('\n');
			    end%if
			end%for i

			angle_matrix(:,parameter_i) = angle_averages;
			intercept_matrix(:,parameter_i) = intercept_averages;

		end%for parameter_i

		% Print
		fprintf('Angles:\n');
		for i = 1:length(min_vector)
			offset_value = 2.25 * i;
			fprintf('%1.2f:\t',offset_value);
			angle_row = angle_matrix(:,i);
			for j = 1:9
				angle_value = angle_row(j);
				fprintf('%1.4f\t',angle_value);
			end%for j
			fprintf('\n');
		end%for i

		fprintf('Intercepts:\n');
		for i = 1:length(min_vector)
			offset_value = 2.25 * i;
			fprintf('%1.2f:\t',offset_value);
			intercept_row = intercept_matrix(:,i);
			for j = 1:9
				intercept_value = intercept_row(j);
				fprintf('%1.4f\t',intercept_value);
			end%for j
			fprintf('\n');
		end%for i

	end%if
end%for dir_i