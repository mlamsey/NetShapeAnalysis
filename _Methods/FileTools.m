classdef FileTools
	properties(Constant)
		%
	end%const

	methods(Static)

		function scan = PromptForScanImport
            msg = questdlg('Please select a file containing a scan from GOM','INFO','OK','OK');
            [file_path,directory] = uigetfile;
            file_path = strcat(directory,file_path);

            if(~file_path)
                fprintf('FileTools::PromptForPartImportFromGOM: No file selected!\n');
                scan = [];
            else
                scan = GOMScan(file_path);
            end%if

        end%func PromptForPartImportFromGOM

		function [x,y,z,dx,dy,dz,dev] = ImportGOMComparison(file_path)
			raw_data = dlmread(file_path,' ',0,0);
            x = raw_data(:,1);
            y = raw_data(:,2);
            z = raw_data(:,3);
            dx = raw_data(:,4);
            dy = raw_data(:,5);
            dz = raw_data(:,6);
            dev = raw_data(:,7);
		end%func ImportGOMComparison

		function [x,y,z,n_x,n_y,n_z] = ImportGOMCrossSectionWithNormals(file_path)
			raw_data = dlmread(file_path,' ',0,0);
			x = raw_data(:,1);
            y = raw_data(:,2);
            z = raw_data(:,3);

            import_size = size(raw_data);
            if(import_size(2) > 3)
                n_x = raw_data(:,4);
                n_y = raw_data(:,5);
                n_z = raw_data(:,6);
            else
                l = import_size(1);
                n_x = zeros(l,1);
                n_y = zeros(l,1);
                n_z = zeros(l,1);
            end%if
		end%func ImportGOMCrossSectionWithNormals

        function cross_section_vector = ImportCrossSectionSetFromDirectory(directory_path)
            dir_info = dir(directory_path);
            n_files = length(dir_info);
            %fprintf('%i files found\n',n_files);

            % Instantiate bonus iterators
            n_files_read = 0;
            contour_i = 1;

            % Loop through all files
            for i = 1:n_files
                file_name = dir_info(i).name;

                % check if filenames are NOT navigation targets
                if(~strcmp(file_name,'.') && ~strcmp(file_name,'..'))
                    % Generate path, import contour data, assign contour in set
                    if(ispc)
                        full_path = strcat(dir_info(i).folder,'\',file_name);
                    else
                        full_path = strcat(dir_info(i).folder,'/',file_name);
                    end%if

                    % Assign contour
                    cross_section_vector{contour_i} = GOMCrossSection(full_path);

                    % iterate
                    contour_i = contour_i + 1;
                    n_files_read = n_files_read + 1;
                end

            end%for i
        end%func ImportCrossSectionSetFromDirectory

        % function PadFileNameZerosForPlaneOffset(filename_prefix,directory)
        %     % Pads filenames for the output from GOM's planar slice export
        %     % filename_prefix specifies to only pad files containing that substring
        %     working_dir = dir(directory);
        %     if(length(working_dir) == 0)
        %         fprintf('FileTools::PadFileNameZeros: Directory not found\n');
        %         return;
        %     end%if

        %     mm_delimiter = '-';
        %     end_delimiter = ' ';

        %     % Find maximum order of magnitude
        %     mm_values = [];

        %     for i = 1:length(working_dir)
        %         filename = working_dir(i).name;
        %         if(contains(filename,filename_prefix))
        %             mm_index = strfind(filename,mm_delimiter) + 1;
        %             mm_index = mm_index(end);
        %             end_number_index = strfind(filename(mm_index:end),end_delimiter) + mm_index - 1;
        %             mm_values = [mm_values,str2num(filename(mm_index:end_number_index))];
        %         end%if
        %     end%for i

        %     max_mm_order = floor(log10(max(mm_values)));

        %     % Pad files
        %     for i = 1:length(working_dir)
        %         filename = working_dir(i).name;
        %         old_file_string = strcat(working_dir(i).folder,'\',filename);

        %         if(contains(filename,filename_prefix))
        %             mm_index = strfind(filename,mm_delimiter) + 1;
        %             mm_index = mm_index(end);
        %             end_number_index = strfind(filename(mm_index:end),end_delimiter) + mm_index - 1;
        %             mm_value = str2num(filename(mm_index:end_number_index));

        %             mm_order = floor(log10(mm_value));
        %             if(mm_order < 0)
        %                 mm_order = 0;
        %             end%if

        %             while(mm_order < max_mm_order)
        %                 filename = strcat(filename(1:mm_index-1),'0',filename(mm_index:end));
        %                 % filename = filename{1};
        %                 mm_order = mm_order + 1;
        %             end%while

        %             new_file_string = strcat(working_dir(i).folder,'\',filename);

        %             if(~strcmp(old_file_string,new_file_string))
        %                 movefile(old_file_string,new_file_string);
        %             end%if
        %         end%if
        %     end%for i

        % end%func PadFileNameZeros

        function PadFileNameZerosForPlaneOffset(filename_prefix,directory)
            % Pads filenames for the output from GOM's planar slice export
            % filename_prefix specifies to only pad files containing that substring
            working_dir = dir(directory);
            if(length(working_dir) == 0)
                fprintf('FileTools::PadFileNameZeros: Directory not found\n');
                return;
            end%if

            mm_delimiter = '_';
            end_delimiter = ' ';

            % Find maximum order of magnitude
            mm_values = [];

            for i = 1:length(working_dir)
                filename = working_dir(i).name;
                if(contains(filename,filename_prefix))
                    mm_index = strfind(filename,mm_delimiter) + 2;
                    mm_index = mm_index(end);
                    end_number_index = strfind(filename(mm_index:end),end_delimiter) + mm_index - 1;
                    mm_values = [mm_values,str2num(filename(mm_index:end_number_index))];
                end%if
            end%for i

            max_mm_order = floor(log10(max(mm_values)));

            % Pad files
            for i = 1:length(working_dir)
                filename = working_dir(i).name;
                old_file_string = strcat(working_dir(i).folder,'\',filename);

                if(contains(filename,filename_prefix))
                    mm_index = strfind(filename,mm_delimiter) + 2;
                    mm_index = mm_index(end);
                    end_number_index = strfind(filename(mm_index:end),end_delimiter) + mm_index - 1;
                    mm_value = str2num(filename(mm_index:end_number_index));

                    mm_order = floor(log10(mm_value));
                    if(mm_order < 0)
                        mm_order = 0;
                    end%if

                    while(mm_order < max_mm_order)
                        filename = strcat(filename(1:mm_index-1),{' '},'0',filename(mm_index:end));
                        filename = filename{1};
                        mm_order = mm_order + 1;
                    end%while

                    new_file_string = strcat(working_dir(i).folder,'\',filename);

                    if(~strcmp(old_file_string,new_file_string))
                        movefile(old_file_string,new_file_string);
                    end%if
                end%if
            end%for i

        end%func PadFileNameZeros
	end%Static Methods
end%class FileTools