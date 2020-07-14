classdef GOMCrossSection
	properties
		file_path;
		x;
		y;
		z;
		n_x;
		n_y;
		n_z;
	end%properties

	methods
		function obj = GOMCrossSection(file_path)
			[x,y,z,n_x,n_y,n_z] = FileTools.ImportGOMCrossSectionWithNormals(file_path);
			obj.file_path = file_path;
			obj.x = x;
			obj.y = y;
			obj.z = z;
			obj.n_x = n_x;
			obj.n_y = n_y;
			obj.n_z = n_z;
		end%Constructor
	end%methods
end%class