classdef GOMSurfaceComparison < handle & matlab.mixin.Copyable
	properties
		file_path;
		x;
		y;
		z;
		dx;
		dy;
		dz;
		dev;
	end%properties
	methods
		function obj = GOMSurfaceComparison(file_path)
			[x,y,z,dx,dy,dz,dev] = FileTools.ImportGOMComparison(file_path);
			obj.file_path = file_path;
			obj.x = x;
			obj.y = y;
			obj.z = z;
			obj.dx = dx;
			obj.dy = dy;
			obj.dz = dz;
			obj.dev = dev;
		end%Constructor
	end%methods
end%class GOMSurfaceComparison