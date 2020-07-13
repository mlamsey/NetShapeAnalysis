classdef GOMScan
	properties
		x;
		y;
		z;
		dx;
		dy;
		dz;
		dev;
		file_path;
	end%properties
	methods
		function obj = GOMScan(file_path)
			[x,y,z,dx,dy,dz,dev] = FileTools.ImportGOMComparison(file_path);
			obj.x = x;
			obj.y = y;
			obj.z = z;
			obj.dx = dx;
			obj.dy = dy;
			obj.dz = dz;
			obj.dev = dev;
			obj.file_path = file_path;
		end%Constructor
	end%methods
end%class GOMScan