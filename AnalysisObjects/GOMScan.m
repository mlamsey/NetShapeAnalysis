classdef GOMScan
	properties
		data;
		file_path;
	end%properties
	methods
		function obj = GOMScan(file_path)
			[x,y,z,dx,dy,dz,dev] = FileTools.ImportGOMComparison(file_path);
			obj.data = GOMScanData(x,y,z,dx,dy,dz,dev);
			obj.file_path = file_path;
		end%Constructor
	end%methods
end%class GOMScan