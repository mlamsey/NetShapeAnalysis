function [dz_sigma_list,name_list] = AnalyzeSurfaceRoughness(directory_path)
	close all;
	% Get directory information
    dir_info = dir(directory_path);
    n_files = length(dir_info);

    dz_sigma_list = [];
    name_list = {};

    % iterator
    file_i = 1;

    % Loop through all files
    for i = 1:n_files
        file_name = dir_info(i).name;

        % check if filenames are NOT navigation targets
        if(~strcmp(file_name,'.') && ~strcmp(file_name,'..'))
            if(ispc)
                full_path = strcat(dir_info(i).folder,'\',file_name);
            else
                full_path = strcat(dir_info(i).folder,'/',file_name);
            end%if

            [x,y,z,dx,dy,dz,dev] = FileTools.ImportGOMComparison(full_path);

            dz_normalized = dz - mean(dz);
            figure;
            histogram(dz_normalized,20);
            title(file_name);
            xlabel('Deviation from Average (mm)');

            % Save Data
            dz_sigma_list(file_i) = std(dz_normalized);
            name_list{file_i} = file_name;

            % Iterate
            file_i = file_i + 1;
        end%if
    end%for i

end%func AnalyzeSurfaceRoughness