classdef PlotTools

	properties(Constant)
		number_of_histogram_bins = 100;
	end%const

	methods(Static)
		function SquareAxes(axes_ref)
			x_lim = xlim(axes_ref);
			y_lim = ylim(axes_ref);
			min_bound = min([x_lim,y_lim]);
			max_bound = max([x_lim,y_lim]);
			xlim(axes_ref,[min_bound,max_bound]);
			ylim(axes_ref,[min_bound,max_bound]);
		end%func SquareAxes

		function histogram_ref = PlotSurfaceDeviationHistogram(surface_comparison)
			if(~isa(surface_comparison,'GOMSurfaceComparison'))
				fprintf('PlotTools::PlotSurfaceDeviationHistogram: Input not a GOMSurfaceComparison\n');
				histogram_ref = [];
				return;
			end%if

			% Extract metrics
			avg = mean(surface_comparison.dev);
			stddev = std(surface_comparison.dev);

			% Plot
			f = figure('Position',[300,300,700,500]);
			histogram_ref = histogram(surface_comparison.dev,PlotTools.number_of_histogram_bins);
			average_line = line([avg,avg],[min(ylim),max(ylim)],'color','k',...
				'linestyle','--');

			% Configure plot
			grid on;
			xlabel('Deviation from Nominal Surface (mm)');
			ylabel('Number of Points');

			% Label features with metrics
			avg_label = strcat('Mean = ',{' '},num2str(avg,4),{' '},'mm');
			stddev_label = strcat('\sigma = ',{' '},num2str(stddev,4),{' '},'mm');
			legend([stddev_label,avg_label]);

		end%func PlotSurfaceDeviationHistogram

	end%static methods
end%class PlotTools