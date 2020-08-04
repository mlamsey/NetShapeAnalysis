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

			cross_section_subset = CrossSectionMethods.GetCrossSectionSubsetInAxisRange(cross_section,height_axis);
			[top_half,bottom_half] = CrossSectionMethods.GetTopAndBottomOfWall(cross_section_subset,height_axis);
			top_mdl = fitlm(top_half.z,top_half.y);
			bottom_mdl = fitlm(bottom_half.z,bottom_half.y);

			% y = mx + b
			top_b = top_mdl.Coefficients.Estimate(1);
			top_m = top_mdl.Coefficients.Estimate(2);
			top_r2 = top_mdl.Rsquared.Ordinary;
			bottom_b = bottom_mdl.Coefficients.Estimate(1);
			bottom_m = bottom_mdl.Coefficients.Estimate(2);
			bottom_r2 = bottom_mdl.Rsquared.Ordinary;

			avg_b = (top_b + bottom_b) / 2;
			avg_m = (top_m + bottom_m) / 2;

			top_z = [min(top_half.z),max(top_half.z)];
			top_y = top_b + top_m .* top_z;

			bottom_z = [min(top_half.z),max(top_half.z)];
			bottom_y = bottom_b + bottom_m .* bottom_z;

			plot(top_half.z,top_half.y,'k');
			hold on;
			plot(bottom_half.z,bottom_half.y,'k');
			plot(top_z,top_y,'r--');
			plot(bottom_z,bottom_y,'r--');
			hold off;
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

		function [top_half,bottom_half] = GetTopAndBottomOfWall(cross_section_subset,height_axis)
			if(~isa(cross_section_subset,'GOMCrossSection'))
				fprintf('CrossSectionMethods::GetTopAndBottomOfWall: Input not a GOMCrossSection\n');
				top_half = [];
				bottom_half = [];
				return;
			end%if

			n_points = length(cross_section_subset.x) - 1;
			distances = zeros(1,n_points);
			for i = 1:n_points
				x1 = cross_section_subset.x(i);
				y1 = cross_section_subset.y(i);
				z1 = cross_section_subset.z(i);
				x2 = cross_section_subset.x(i+1);
				y2 = cross_section_subset.y(i+1);
				z2 = cross_section_subset.z(i+1);
				distances(i) = Utils.Distance3(x1,y1,z1,x2,y2,z2);
			end%for i

			distance_mean = mean(distances);
			flag = Utils.GetFlagsForLogicalIndices(distances > 10 * distance_mean);

			if(length(flag) > 1)
				fprintf('CrossSectionMethods::GetTopAndBottomOfWall: More than one flag!\n');
				top_half = [];
				bottom_half = [];
				return;
			end%if

			top_half_indices = 1:flag;
			bottom_half_indices = flag+1:length(cross_section_subset.x);

			top_half = CrossSectionMethods.CreateCrossSectionSubsetWithLogicalIndices(cross_section_subset,top_half_indices);
			bottom_half = CrossSectionMethods.CreateCrossSectionSubsetWithLogicalIndices(cross_section_subset,bottom_half_indices);
		end%func GetTopAndBottomOfWall
	end%private methods
end%class CrossSectionAnalysis