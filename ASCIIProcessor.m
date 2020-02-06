classdef ASCIIProcessor
	methods(Static)
		function [raw_data,decimated_data] = DecimateASCII(file_path,decimation_factor)
			fprintf('Importing Data from %s\n',file_path);
			tic;
			raw_data = dlmread(file_path,'\t',0,0);
			data_size = size(raw_data);
			fprintf('Completion time: %1.2f seconds\n',toc);
			fprintf('Data imported with %i rows, %i columns\n',data_size(2),data_size(1));

			new_col_count = floor(data_size(1) ./ decimation_factor);
			decimated_data = zeros(new_col_count,3);

			fprintf('Decimating to %i points\n',new_col_count);

			file_name = file_path(1:end-4); % remove extension
			write_path = strcat(file_name,'_',num2str(decimation_factor),file_path(end-3:end));
			file_id = fopen(write_path,'w');

			if(file_id == -1)
				fprintf('ASCIIProcessor::DecimateASCII: File failed to open.\n');
				return;
			end%if

			tic;
			for i = 1:new_col_count
				if(rem(i,100000) == 0)
					fprintf('%i/%i\n',i,new_col_count);
				end%if

				raw_i = decimation_factor * i;
				decimated_data(i,:) = raw_data(raw_i,1:3);

				x_str = num2str(decimated_data(i,1),'%1.6f');
				y_str = num2str(decimated_data(i,2),'%1.6f');
				z_str = num2str(decimated_data(i,3),'%1.6f');
				point_string = strcat(x_str,'\t',y_str,'\t',z_str,'\n');
				fprintf(file_id,point_string);
			end%for i

			fprintf('File written in %1.2f seconds\n',toc);
		end%func DecimateASCII
	end%methods
end%class ASCIIProcessor