classdef CrossSectionMethods
	properties(Constant)
		wall_center_line_buffer_bounds = 0.025; % percent 0-1
	end%const

	methods(Static)
		function wall_height = GetWallHeight(cross_section,height_axis)
			if(~isa(cross_section,'GOMCrossSection'))
				fprintf('CrossSectionMethods::GetWallHeight: Input not a GOMCrossSection\n');
				return;
			end%if

			height_axis = lower(height_axis);
			switch height_axis
				case 'x'
					wall_height = max(cross_section.x) - min(cross_section.x);
				case 'y'
					wall_height = max(cross_section.y) - min(cross_section.y);
				case 'z'
					wall_height = max(cross_section.z) - min(cross_section.z);
				otherwise
					fprintf('CrossSectionMethods::GetWallHeight: Height Axis input not recognized\n');
			end%switch
		end%func GetWallHeight

		function wall_height_vector = GetWallHeightForSet(cross_section_set,height_axis)
			n_points = length(cross_section_set);
			wall_height_vector = zeros(1,n_points);

			for i = 1:n_points
				wall_height_vector(i) = CrossSectionMethods.GetWallHeight(cross_section_set{i},height_axis);
			end%for i
		end%func GetWallHeightForSet

		function argout = GetWallCenterLine(cross_section,height_axis)
			if(~isa(cross_section,'GOMCrossSection'))
				fprintf('CrossSectionMethods::GetWallCenterLine: Input not a GOMCrossSection\n');
				return;
			end%if

			argout = CrossSectionMethods.GetCrossSectionSubsetInAxisRange(cross_section,height_axis);

		end%func GetWallCenterLine

	end%static methods

	methods(Static, Access = 'private')
		function cross_section_subset = GetCrossSectionSubsetInAxisRange(cross_section,height_axis)
			switch height_axis
				case 'x'
					cross_section_axis = cross_section.x;
				case 'y'
					cross_section_axis = cross_section.y;
				case 'z'
					cross_section_axis = cross_section.z;
				otherwise
					fprintf('CrossSectionMethods::GetCrossSectionSubsetInAxisRange: Height Axis input not recognized\n');
			end%switch

			cross_section_min = min(cross_section_axis);
			cross_section_max = max(cross_section_axis);

			cross_section_range = cross_section_max - cross_section_min;

			subset_min = cross_section_min + CrossSectionMethods.wall_center_line_buffer_bounds * cross_section_range;
			subset_max = cross_section_max - CrossSectionMethods.wall_center_line_buffer_bounds * cross_section_range;

			logical_indices = cross_section_axis > subset_min & cross_section_axis < subset_max;

			cross_section_subset = CrossSectionMethods.CreateCrossSectionSubsetWithLogicalIndices(cross_section,logical_indices);
		end%func GetCrossSectionSubsetInRange

		function cross_section_subset = CreateCrossSectionSubsetWithLogicalIndices(cross_section,logical_indices)
			cross_section_subset = cross_section; % copy

			cross_section_subset.x = cross_section_subset.x(logical_indices);
			cross_section_subset.y = cross_section_subset.y(logical_indices);
			cross_section_subset.z = cross_section_subset.z(logical_indices);
			cross_section_subset.n_x = cross_section_subset.n_x(logical_indices);
			cross_section_subset.n_y = cross_section_subset.n_y(logical_indices);
			cross_section_subset.n_z = cross_section_subset.n_z(logical_indices);
		end%func CreateCrossSectionSubsetWithLogicalIndices
	end%private methods
end%class CrossSectionAnalysis