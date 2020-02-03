classdef GOMSurfaceComparison < handle & matlab.mixin.Copyable
	properties
		points;
	end%properties
	methods
		function obj = GOMSurfaceComparison(file_path)
			[x,y,z,dx,dy,dz,dev] = FileTools.ImportGOMComparison(file_path);
			for i = 1:length(x)
				obj.points{i} = GOMSurfaceComparisonPoint(x(i),y(i),z(i),dx(i),dy(i),dz(i),dev(i));
			end%for i
		end%Constructor
	end%methods
end%class GOMSurfaceComparison