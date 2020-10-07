classdef ExperimentalCrossSectionAnalysisMethods
	methods(Static)
		function [slope_vector,intercept_vector] = GetWallCenterLinesForSet(cross_section_set,height_axis,lower_offset,upper_offset)
			n_points = length(cross_section_set);
			slope_vector = zeros(1,n_points);
			intercept_vector = slope_vector;

			for i = 1:n_points
				[line_slope,line_intercept] = ExperimentalCrossSectionAnalysisMethods.GetWallCenterLine(cross_section_set{i},'z',lower_offset,upper_offset,false);
				slope_vector(i) = line_slope;
				intercept_vector(i) = line_intercept;
			end%for i

		end%func GetWallCenterLinesForSet

		function [line_slope,line_intercept] = GetWallCenterLine(cross_section,height_axis,lower_offset,upper_offset,bool_plot)
			if(~isa(cross_section,'GOMCrossSection'))
				fprintf('CrossSectionMethods::GetWallCenterLine: Input not a GOMCrossSection\n');
				return;
			end%if
			if(nargin == 4)
				bool_plot = true;
			end%if

			cross_section_subset = CrossSectionMethods.GetCustomCrossSectionSubsetInAxisRange(cross_section,height_axis,lower_offset,upper_offset);
			[top_half,bottom_half] = CrossSectionAnalysisMethods.GetTopAndBottomOfWall(cross_section_subset,height_axis);
			if(length(top_half.x) > 0 && length(bottom_half.x) > 0)
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
			else
				fprintf('ExperimentalCrossSectionAnalysisMethods::GetWallCenterLine: Top and Bottom Halves not recognized\n');
				line_slope = NaN;
				line_intercept = NaN;
			end%if
		end%func GetWallCenterLine
	end%static methods
end%class