classdef ProcessSurfaceScan
	properties(Constant)
		keyence_minimum_value = -30; % mm
		keyence_maximum_value = 30; %mm
		keyence_scan_width = 40; % mm
	end%const

	methods(Static)
		function CoerceOutOfRangeProfileValues(scan)
			if(~isa(scan,'SurfaceScan'))
				fprintf('SurfaceScanProcessor::CoerceOutOfRangeProfileValues: Input not a SurfaceScan\n');
				return;
			end%if

			[n_rows, n_columns] = size(scan.scan_profile);
			for r = 1:n_rows
				for c = 1:n_columns
					if(scan.scan_profile(r,c) < SurfaceScanProcessor.keyence_minimum_value)
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
			    scan.(field_names{i}) = Utils.DecimateVector(scan.(field_names{i}),10);
			end%for i
		end%func DecimateScanByFactor
	end%static methods
end%class ProcessSurfaceScan