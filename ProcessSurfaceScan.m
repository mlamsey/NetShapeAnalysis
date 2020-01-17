classdef ProcessSurfaceScan
	properties(Constant)
		
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
			logical_index = scan.weld_on;

			field_names = fieldnames(scan);
			for i = 1:numel(field_names)
		    	current_field = scan.(field_names{i});
		    	scan.(field_names{i}) = current_field(logical_index,:);
			end%for i
		end%func FilterByWeldOn
	end%static methods
end%class ProcessSurfaceScan