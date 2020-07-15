classdef ScanMethods
	properties

	end%properties
	
	methods(Static)
		function SwitchScanDataAxes(scan_data,axis_label_1,axis_label_2)
			if(~isa(scan_data,'GOMScanData'))
				fprintf('ScanMethods::SwitchScanDataAxes: Input 1 not a GOMScanData\n');
				return;
			end%if

			axis_1 = ScanMethods.GetAxis(scan_data,axis_label_1);
			axis_2 = ScanMethods.GetAxis(scan_data,axis_label_2);

			ScanMethods.SetAxis(scan_data,axis_label_1,axis_2);
			ScanMethods.SetAxis(scan_data,axis_label_2,axis_1);

		end%func SwitchScanDataAxes

		function TranslateScanDataToOrigin(scan_data)
			if(~isa(scan_data,'GOMScanData'))
				fprintf('ScanMethods::TranslateScanDataToOrigin: Input not a GOMScanData\n');
				return;
			end%if

			scan_data.x = scan_data.x - min(scan_data.x);
			scan_data.y = scan_data.y - min(scan_data.y);
			scan_data.z = scan_data.z - min(scan_data.z);
			
		end%func TranslateScanDataToOrigin
		
		function scan_data_subset = GetScanDataSubsetInRange(scan_data,coordinate_axis,axis_min,axis_max)
			if(~isa(scan_data,'GOMScanData'))
				fprintf('ScanMethods::GetScanDataSubsetInRange: Input 1 not a GOMScanData\n');
				scan_data_subset = scan_data;
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

		function RemovePointsOutsideOfDeviationRange(scan_data,deviation_min,deviation_max)
			if(~isa(scan_data,'GOMScanData'))
				fprintf('ScanMethods::RemovePointsOutsideOfDeviationRange: Input 1 not a GOMScanData\n');
				scan_data_subset = scan_data;
				return;
			end%if

			points_to_keep = scan_data.dev >= deviation_min & scan_data.dev <= deviation_max;
			scan_data.x = scan_data.x(points_to_keep);
			scan_data.y = scan_data.y(points_to_keep);
			scan_data.z = scan_data.z(points_to_keep);
			scan_data.dx = scan_data.dx(points_to_keep);
			scan_data.dy = scan_data.dy(points_to_keep);
			scan_data.dz = scan_data.dz(points_to_keep);
			scan_data.dev = scan_data.dev(points_to_keep);

		end%func RemovePointsOutsideOfDeviationRange

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

		function axis_values = GetAxis(scan_data,axis_name)
			switch axis_name
				case 'x'
					axis_values = scan_data.x;
				case 'X'
					axis_values = scan_data.x;
				case 'y'
					axis_values = scan_data.y;
				case 'Y'
					axis_values = scan_data.y;
				case 'z'
					axis_values = scan_data.z;
				case 'Z'
					axis_values = scan_data.z;
				otherwise
					fprintf('ScanMethods::GetAxis: Invalid Axis Name\n');
			end%switch
		end%func GetAxis

		function SetAxis(scan_data,axis_name,values)
			switch axis_name
				case 'x'
					scan_data.x = values;
				case 'X'
					scan_data.x = values;
				case 'y'
					scan_data.y = values;
				case 'Y'
					scan_data.y = values;
				case 'z'
					scan_data.z = values;
				case 'Z'
					scan_data.z = values;
				otherwise
					fprintf('ScanMethods::SetAxis: Invalid axis name\n');
			end%switch
		end%func SetAxis
	end%private methods
end%class ScanMethods