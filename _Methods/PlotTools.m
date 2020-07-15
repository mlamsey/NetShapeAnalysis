classdef PlotTools

	properties(Constant)
		number_of_histogram_bins = 100;
	end%const

	methods(Static)

		function PlotScanPoints(scan_data)
			if(~isa(scan_data,'GOMScanData'))
				fprintf('PlotTools::PlotScanPoints: Input not a GOMScanData\n');
				return;
			end%if

			a = axes;
			plot3(scan_data.x,scan_data.y,scan_data.z,'k.','parent',a);
			xlabel('X (mm)');
			ylabel('Y (mm)');
			zlabel('Z (mm)');
			grid on;
			PlotTools.SquareAxes3(a);

		end%func PlotScanPoints

		function SquareAxes2(axes_ref)
			x_lim = xlim(axes_ref);
			y_lim = ylim(axes_ref);
			min_bound = min([x_lim,y_lim]);
			max_bound = max([x_lim,y_lim]);
			xlim(axes_ref,[min_bound,max_bound]);
			ylim(axes_ref,[min_bound,max_bound]);
		end%func SquareAxes2

		function SquareAxes3(axes_ref)
			x_lim = xlim(axes_ref);
			y_lim = ylim(axes_ref);
			z_lim = zlim(axes_ref);
			min_bound = min([x_lim,y_lim,z_lim]);
			max_bound = max([x_lim,y_lim,z_lim]);
			xlim(axes_ref,[min_bound,max_bound]);
			ylim(axes_ref,[min_bound,max_bound]);
			zlim(axes_ref,[min_bound,max_bound]);
		end%func SquareAxes3

		function histogram_ref = PlotSurfaceDeviationHistogram(scan_data)
			if(~isa(scan_data,'GOMScanData'))
				fprintf('PlotTools::PlotSurfaceDeviationHistogram: Input not a GOMScanData\n');
				histogram_ref = [];
				return;
			end%if

			% Extract metrics
			avg = mean(scan_data.dev);
			stddev = std(scan_data.dev);

			% Plot
			f = figure('Position',[300,300,700,500]);
			histogram_ref = histogram(scan_data.dev,PlotTools.number_of_histogram_bins);
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