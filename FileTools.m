classdef FileTools
	properties(Constant)
		%
	end%const

	methods(Static)
		function WriteScanToCSV(scan,file_path)
			if(~isa(scan,'SurfaceScan'))
				fprintf('FileTools::WriteScanToCSV: Input 1 not a scan\n');
				return;
			end%if

			file_id = fopen(file_path,'w');
			if(file_id == -1)
				fprintf('PathFileWriter::Write: File failed to open.\n');
				return;
			end%if

			% Write header
			fprintf(file_id,'X (mm),Y (mm),Z (mm)\n');

			n_points = length(scan.robot_x);
			for i = 1:n_points
				if(rem(i,10) == 0)
					fprintf('%i / %i\n',i,n_points);
				end%if
				[x,y,z] = ProcessSurfaceScan.GetScanProfileAtIndex(scan,i);

				for j = 1:length(x)
					if(~isnan(z(j)))
						x_str = num2str(x(j),'%1.3f');
						y_str = num2str(y(j),'%1.3f');
						z_str = num2str(z(j),'%1.3f');
						scan_string = strcat(x_str,',',y_str,',',z_str,'\n');
						fprintf(file_id,scan_string);
					end%if
				end%for j
			end%for i

			fprintf('Done!\n\n');

			fclose(file_id);
		end%func WriteScanToCSV

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
	end%Static Methods
end%class FileTools