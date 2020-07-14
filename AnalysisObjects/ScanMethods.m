classdef ScanMethods
	properties

	end%properties
	
	methods(Static)
		
		function scan_data_subset = GetScanDataSubsetInRange(scan_data,coordinate_axis,axis_min,axis_max)
			if(~isa(scan_data,'GOMScanData'))
				fprintf('ScanMethods::GetScanDataSubsetInRange: Input 1 not a GOMScanData\n');
				scan_data_subset = [];
				return;
			end%if

			logical_indices = ScanMethods.GetIndicesForPositionRange(scan_data,coordinate_axis,axis_min,axis_max);
			subset_x = scan_data.x(logical_indices);
			subset_y = scan_data.y(logical_indices);
			subset_z = scan_data.z(logical_indices);
			subset_dx = scan_data.dx(logical_indices);
			subset_dy = scan_data.dy(logical_indices);
			subset_dz = scan_data.dz(logical_indices);
			subset_dev = scan_data.dev(logical_indices);

			scan_data_subset = GOMScanData(subset_x,subset_y,subset_z,...
				subset_dx,subset_dy,subset_dz,subset_dev);

		end%func GetScanDataSubsetInRange

	end%static methods

	methods(Static, Access = private)
		function logical_indices = GetIndicesForPositionRange(scan_data,coordinate_axis,axis_min,axis_max)
			if(~isa(scan_data,'GOMScanData'))
				fprintf('ScanMethods::GetIndicesForPositionRange: Input 1 not a GOMScanData\n');
				logical_indices = [];
				return;
			end%if

			if(axis_min > axis_max)
				fprintf('ScanMethods::GetIndicesForPositionRange: axis min > axis max\n');
				logical_indices = [];
				return;
			end%if

			switch coordinate_axis
				case 'x'
					logical_indices = scan_data.x >= axis_min & scan_data.x <= axis_max;
				case 'X'
					logical_indices = scan_data.x >= axis_min & scan_data.x <= axis_max;
				case 'y'
					logical_indices = scan_data.y >= axis_min & scan_data.y <= axis_max;
				case 'Y'
					logical_indices = scan_data.y >= axis_min & scan_data.y <= axis_max;
				case 'z'
					logical_indices = scan_data.z >= axis_min & scan_data.z <= axis_max;
				case 'Z'
					logical_indices = scan_data.z >= axis_min & scan_data.z <= axis_max;
				otherwise
					fprintf('ScanMethods::GetIndicesForPositionRange: Incorrect coordinate axis char\n');
					logical_indices = [];
			end%switch
		end%func GetIndicesForPositionRange
	end%private methods
end%class ScanMethods