classdef ProcessSurfaceScan
	properties(Constant)
		decimated_scan_shift_index = 19;
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