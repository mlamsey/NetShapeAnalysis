classdef ProcessSurfaceScan
	properties(Constant)
		decimated_scan_shift_index = 20;
	end%const

	methods(Static)
		function StandardCleanup(scan)
			if(~isa(scan,'SurfaceScan'))
				fprintf('ProcessSurfaceScan::StandardCleanup: Input not a SurfaceScan\n');
				return;
			end%if

			ProcessSurfaceScan.DecimateScanByFactor(scan,10);
			ProcessSurfaceScan.CoerceOutOfRangeProfileValues(scan);
			ProcessSurfaceScan.ShiftScanProfileToRobotTaskSpace(scan);
			ProcessSurfaceScan.FilterByWeldOn(scan);
			ProcessSurfaceScan.ShiftScanByPoints(scan,ProcessSurfaceScan.decimated_scan_shift_index);
			ProcessSurfaceScan.RemoveScanOverlaps(scan);
		end%func StandardCleanup

		function CoerceOutOfRangeProfileValues(scan)
			if(~isa(scan,'SurfaceScan'))
				fprintf('SurfaceScanProcessor::CoerceOutOfRangeProfileValues: Input not a SurfaceScan\n');
				return;
			end%if

			[n_rows, n_columns] = size(scan.scan_profile);
			for r = 1:n_rows
				for c = 1:n_columns
					if(scan.scan_profile(r,c) < KeyenceConst.keyence_minimum_value)
						scan.scan_profile(r,c) = NaN;
					end%if
				end%for c
			end%for r

		end%func CoerceOutOfRangeProfileValues

		function ShiftScanProfileToRobotTaskSpace(scan)
			if(~isa(scan,'SurfaceScan'))
				fprintf('SurfaceScanProcessor::ShiftScanProfileToRobotTaskSpace: Input not a SurfaceScan\n');
				return;
			end%if

			[n_rows, n_columns] = size(scan.scan_profile);
			for r = 1:n_rows
				scan.scan_profile(r,:) = scan.scan_profile(r,:) + scan.robot_z(r);
			end%for r

		end%func ShiftScanProfileToRobotTaskSpace

		function DecimateScanByFactor(scan,decimation_factor)
			if(~isa(scan,'SurfaceScan'))
				fprintf('ProcessSurfaceScan::DecimateScanByFactor: Input 1 not a SurfaceScan\n');
				return;
			end%if

			if(decimation_factor > length(scan.robot_x))
				fprintf('ProcessSurfaceScan::DecimateScanByFactor: Decimation factor larger than scan length!\n');
			end%if

			field_names = fieldnames(scan);
			for i = 1:numel(field_names)
				original_class = class(scan.(field_names{i}));
		    	scan.(field_names{i}) = Utils.DecimateVector(scan.(field_names{i}),decimation_factor);
		    	new_class = class(scan.(field_names{i}));
		    	
		    	if(~strcmp(original_class,new_class))
		    		scan.(field_names{i}) = cast(scan.(field_names{i}),original_class);
		    	end%if
			end%for i
		end%func DecimateScanByFactor

		function FilterByWeldOn(scan)
			if(~isa(scan,'SurfaceScan'))
				fprintf('ProcessSurfaceScan::FilterByWeldOn: Input not a SurfaceScan\n');
				return;
			end%if

			logical_index = scan.weld_on;

			field_names = fieldnames(scan);
			for i = 1:numel(field_names)
		    	current_field = scan.(field_names{i});
		    	scan.(field_names{i}) = current_field(logical_index,:);
			end%for i
		end%func FilterByWeldOn

		function ShiftScanByPoints(scan,n_points)
			if(~isa(scan,'SurfaceScan'))
				fprintf('ProcessSurfaceScan::ShiftScanByPoints: Input not a SurfaceScan\n');
				return;
			end%if

			field_names = fieldnames(scan);
			for i = 1:numel(field_names)
				if(~strcmp(field_names{i},'scan_profile'))
					original_field = scan.(field_names{i});
					scan.(field_names{i}) = original_field(n_points:end);
				else
					original_field = scan.scan_profile;
					scan.scan_profile = scan.scan_profile(1:end-n_points + 1,:);
				end%if
			end%for i
		end%func ShiftScanByPoints

		function RemoveScanOverlaps(scan)
			if(~isa(scan,'SurfaceScan'))
				fprintf('ProcessSurfaceScan::RemoveScanOverlaps: Input not a SurfaceScan\n');
				return;
			end%if

			% Find gaps between scans using change in y
			delta_y = abs(diff(scan.robot_y));
			logical_index = delta_y > 4 * mean(delta_y);
			scan_flags = [1;find(logical_index);length(scan.robot_y)];
			y_offset = KeyenceConst.keyence_scan_width / 2;

			for i = 2:length(scan_flags) - 1
				previous_scan_index_range = scan_flags(i-1):scan_flags(i);
				previous_average_y = mean(scan.robot_y(previous_scan_index_range));
				previous_y_min = previous_average_y - y_offset;

				current_scan_index_range = scan_flags(i):scan_flags(i+1);
				current_average_y = mean(scan.robot_y(current_scan_index_range));
				current_y_range = linspace(current_average_y - y_offset,current_average_y + y_offset,KeyenceConst.keyence_n_points);
				current_logical_index = current_y_range < (previous_y_min + 4.3); % weird offset idk

				for j = 1:length(current_scan_index_range)
					scan_index = current_scan_index_range(j);
					scan.scan_profile(scan_index,~current_logical_index) = NaN;
				end%for j

			end%for i
			
		end%func RemoveScanOverlaps

		function [x_vector,y_vector,z_vector] = GetScanProfileAtIndex(scan,index)
			if(~isa(scan,'SurfaceScan'))
				fprintf('ProcessSurfaceScan::GetScanProfileAtIndex: Input not a SurfaceScan\n');
				x_vector = [];
				y_vector = [];
				z_vector = [];
				return;
			end%if

			scan_y = scan.robot_y(index);
			y_offset = KeyenceConst.keyence_scan_width / 2;
			y_vector = linspace(scan_y - y_offset, scan_y + y_offset, ...
			KeyenceConst.keyence_n_points);

			x_vector = scan.robot_x(index) .* ones(KeyenceConst.keyence_n_points,1);

			z_vector = scan.scan_profile(index,:);
		end%func GetScanProfileAtIndex
	end%static methods
end%class ProcessSurfaceScan