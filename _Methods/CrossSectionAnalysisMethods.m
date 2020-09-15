classdef CrossSectionAnalysisMethods
	properties(Constant)

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
				wall_height_vector(i) = CrossSectionAnalysisMethods.GetWallHeight(cross_section_set{i},height_axis);
			end%for i
		end%func GetWallHeightForSet

		function [slope_vector,intercept_vector] = GetWallCenterLinesForSet(cross_section_set,height_axis)
			n_points = length(cross_section_set);
			slope_vector = zeros(1,n_points);
			intercept_vector = slope_vector;

			for i = 1:n_points
				[line_slope,line_intercept] = CrossSectionAnalysisMethods.GetWallCenterLine(cross_section_set{i},'z',false);
				slope_vector(i) = line_slope;
				intercept_vector(i) = line_intercept;
			end%for i

		end%func GetWallCenterLinesForSet

		function [line_slope,line_intercept] = GetWallCenterLine(cross_section,height_axis,bool_plot)
			if(~isa(cross_section,'GOMCrossSection'))
				fprintf('CrossSectionMethods::GetWallCenterLine: Input not a GOMCrossSection\n');
				return;
			end%if
			if(nargin == 2)
				bool_plot = true;
			end%if

			cross_section_subset = CrossSectionMethods.GetCrossSectionSubsetInAxisRange(cross_section,height_axis);
			[top_half,bottom_half] = CrossSectionAnalysisMethods.GetTopAndBottomOfWall(cross_section_subset,height_axis);
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

			avg_z = [mean([bottom_z(1),top_z(1)]),mean([bottom_z(2),top_z(2)])];
			avg_y = avg_b + avg_m .* avg_z;

			if(bool_plot)
				fprintf('Top Line: y = %1.3fx + %1.3f, R2 = %1.3f\n',top_m,top_b,top_r2);
				fprintf('Bottom Line: y = %1.3fx + %1.3f, R2 = %1.3f\n',bottom_m,bottom_b,bottom_r2);
				fprintf('Center Line: y = %1.3fx + %1.3f\n',avg_m,avg_b);

				figure;
				plot(top_half.z,top_half.y,'k');
				hold on;
				plot(bottom_half.z,bottom_half.y,'b');
				plot(top_z,top_y,'r--');
				plot(bottom_z,bottom_y,'r--');
				plot(avg_z,avg_y,'m-');
				hold off;
				legend('Top','Bottom');
				title(cross_section_subset.file_path);
			end%if

			line_slope = avg_m;
			line_intercept = avg_b;
		end%func GetWallCenterLine

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

			% figure;
			% plot(distances);

			d_dist = abs(diff(distances));
			flags = find(d_dist > 1);
			flags = [1,flags,length(distances)];
			lengths = flags(2:end) - flags(1:end-1);

			if(length(lengths) < 2)
				[~,flag] = max(distances);
				top_half_indices = 1:flag;
				bottom_half_indices = flag+1:length(cross_section_subset.x);
			else
				[~,biggest_object_indices] = maxk(lengths,2);
				biggest_object_indices = biggest_object_indices + 1;

				top_half_indices = flags(biggest_object_indices(1)-1):flags(biggest_object_indices(1));
				bottom_half_indices = (flags(biggest_object_indices(2)-1) + 1):flags(biggest_object_indices(2));
			end%if

			% [~,flag] = max(distances);

			% if(length(flag) > 1)
			% 	fprintf('CrossSectionMethods::GetTopAndBottomOfWall: More than one flag!\n');
			% 	top_half = [];
			% 	bottom_half = [];
			% 	return;
			% end%if

			% top_half_indices = 1:flag;
			% bottom_half_indices = flag+1:length(cross_section_subset.x);

			top_half = CrossSectionMethods.CreateCrossSectionSubsetWithLogicalIndices(cross_section_subset,top_half_indices);
			bottom_half = CrossSectionMethods.CreateCrossSectionSubsetWithLogicalIndices(cross_section_subset,bottom_half_indices);
		end%func GetTopAndBottomOfWall
	end%static methods
end%class CrossSectionAnalysisMethods