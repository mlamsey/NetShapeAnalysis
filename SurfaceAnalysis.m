classdef SurfaceAnalysis
	methods(Static)
		function GenerateSurfaceRoughnessHistograms(directory_path)
			close all;
		    % Get directory information
		    dir_info = dir(directory_path);
		    n_files = length(dir_info);

            save_dir = 'Renders';
            if(~exist(save_dir,'dir'))
            	mkdir(save_dir);
            end%if

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
		            dz = -1.*dz;

		            dz_normalized = dz - mean(dz);
		            f = figure;
		            h = histogram(dz_normalized,100,'facecolor',[0.25,0.5,1]);
		            title(file_name(1:end-4));
		            xlabel('Deviation from Average (mm)');
		            ylabel('Number of Samples');
		            x_lim = max(abs(xlim));
		            xlim([-1*x_lim,x_lim]);
		            line([0,0],[0,max(ylim)],'color','k','linestyle','--','linewidth',2);
		            grid on;

		            str_sigma = '\sigma';
		            legend_string = sprintf(' = %1.4fmm',std(dz_normalized));
		            legend_string = strcat(str_sigma,legend_string);
		            legend(legend_string);

		            render_file_name = strcat(save_dir,'\',file_name(1:end-3),'png');
		            saveas(f,render_file_name);

		            % Iterate
		            file_i = file_i + 1;
		        end%if
		    end%for i

		end%func AnalyzeSurfaceRoughness

		function PrintStats(directory_path)
			% Get directory information
		    dir_info = dir(directory_path);
		    n_files = length(dir_info);

		    % Save
		    dz_sigma_list = [];
    		name_list = {};

		    % iterator
		    file_i = 1;

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
		            dz = -1.*dz;
		            dz_mean = mean(dz);

		            dz_normalized = dz - dz_mean;

		            % Save Data
		            dz_sigma = std(dz_normalized);
		            dz_sigma_list(file_i) = dz_sigma;
		            name_list{file_i} = file_name;

		            % Print
		            disp(file_name);
		            fprintf('dz mean: %1.4fmm\n',dz_mean);
		            fprintf('dz sigma: %1.4fmm\n',dz_sigma);
		        end%if
	        end%for i
		end%func
	end%static methods
end%class