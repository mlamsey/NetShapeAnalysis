classdef GOMSurfaceComparisonPoint < handle & matlab.mixin.Copyable
	properties
		x;
		y;
		z;
		dx;
		dy;
		dz;
		dev;
	end
	methods
		function obj = GOMSurfaceComparisonPoint(x,y,z,dx,dy,dz,dev)
			obj.x = x;
			obj.y = y;
			obj.z = z;
			obj.dx = dx;
			obj.dy = dy;
			obj.dz = dz;
			obj.dev = dev;
		end%Constructor
	end%methods
end%class GOMSurfaceComparisonPoint