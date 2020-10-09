classdef GOMDeviationSection
	properties
		file_path;
		x;
		y;
		z;
		n_x;
		n_y;
		n_z;
		dx;
		dy;
		dz;
		dev;
	end%properties

	methods
		function obj = GOMDeviationSection(file_path)
			[x,y,z,n_x,n_y,n_z,dx,dy,dz,dev] = FileTools.ImportGOMDeviationSection(file_path);
			obj.file_path = file_path;
			obj.x = x;
			obj.y = y;
			obj.z = z;
			obj.n_x = n_x;
			obj.n_y = n_y;
			obj.n_z = n_z;
			obj.dx = dx;
			obj.dy = dy;
			obj.dz = dz;
			obj.dev = dev;
		end%Constructor
	end%methods
end%class