classdef FileTools
	properties(Constant)
		%
	end%const

	methods(Static)

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
            n_x = raw_data(:,4);
            n_y = raw_data(:,5);
            n_z = raw_data(:,6);
		end%func ImportGOMCrossSectionWithNormals
	end%Static Methods
end%class FileTools