classdef GOMScanData < handle
	properties
		x;
		y;
		z;
		dx;
		dy;
		dz;
		dev;
	end%properties
	methods
		function obj = GOMScanData(x,y,z,dx,dy,dz,dev)
			obj.x = x;
			obj.y = y;
			obj.z = z;
			obj.dx = dx;
			obj.dy = dy;
			obj.dz = dz;
			obj.dev = dev;
		end%Constructor
	end%methods
end%class GOMScan