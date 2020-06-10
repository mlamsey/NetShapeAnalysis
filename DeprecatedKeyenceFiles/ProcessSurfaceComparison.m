classdef ProcessSurfaceComparison
	properties(Constant)

	end%const

	methods(Static)
		function stats = DeviationStatistics(comparison)
			if(~isa(comparison,'GOMSurfaceComparison'))
				fprintf('ProcessSurfaceComparison::DeviationStatistics: Input not a GOMSurfaceScan\n');
				stats = null(1);
				return;
			end%if

			fprintf('Processing Surface Comparison: %i points\n',length(comparison.x));
			data = comparison.dev(comparison.dev>5);
			% normalized_data = (data - min(data)) ./ (max(data) - min(data));
			normalized_data = data - mean(data);
			figure;
			histogram(normalized_data,20,'FaceColor',[0.3,0.3,0.3]);
			x_lim = max(abs(xlim));
			xlim([-1*x_lim,x_lim]);
			grid on;
			xlabel('Deviation from Average (mm)');
			stats = fitdist(normalized_data,'Normal');
		end%func DeviationStatistics
	end%static methods
end%class ProcessSurfaceComparison