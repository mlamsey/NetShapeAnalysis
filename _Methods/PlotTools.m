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

		function DefaultPlot3Setup(axes_ref)
            axes_ref.XLabel.String = 'X (mm)';
            axes_ref.YLabel.String = 'Y (mm)';
            axes_ref.ZLabel.String = 'Z (mm)';
            axes_ref.XGrid = true;
            axes_ref.YGrid = true;
            axes_ref.ZGrid = true;
            PlotTools.SquareAxes3AboutOrigin(axes_ref);
            view(45,45);
        end%func DefaultPlotSetup

        function ref = BufferPlotAxes(ax,percent_buffer)
            x_lim = xlim(ax);
            y_lim = ylim(ax);
            z_lim = zlim(ax);

            x_range = x_lim(2) - x_lim(1);
            y_range = y_lim(2) - y_lim(1);
            z_range = z_lim(2) - z_lim(1);

            x_inc = percent_buffer * x_range;
            y_inc = percent_buffer * y_range;
            z_inc = percent_buffer * z_range;

            xlim([x_lim(1) - x_inc, x_lim(2) + x_inc]);
            ylim([y_lim(1) - y_inc, y_lim(2) + y_inc]);
            zlim([z_lim(1) - z_inc, z_lim(2) + z_inc]);

        end%func BufferPlotAxes

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

            % Find max range for an axis
            x_range = max(x_lim) - min(x_lim);
            y_range = max(y_lim) - min(y_lim);
            z_range = max(z_lim) - min(z_lim);
            axis_range = max([x_range,y_range,z_range]);

            % Create new axes centered on plot axes
            x_limits = [mean(x_lim) - 0.5*axis_range,mean(x_lim) + 0.5*axis_range];
            y_limits = [mean(y_lim) - 0.5*axis_range,mean(y_lim) + 0.5*axis_range];
            z_limits = [mean(z_lim) - 0.5*axis_range,mean(z_lim) + 0.5*axis_range];

            xlim(axes_ref,[x_limits(1),x_limits(2)]);
            ylim(axes_ref,[y_limits(1),y_limits(2)]);
            zlim(axes_ref,[z_limits(1),z_limits(2)]);
        end%func SquareAxes3

        function SquareAxes3AboutOrigin(axes_ref)
            x_lim = xlim(axes_ref);
            y_lim = ylim(axes_ref);
            z_lim = zlim(axes_ref);

            bound = max(abs([x_lim,y_lim,z_lim]));

            limits = [-1 * bound, bound];

            xlim(axes_ref,[limits(1),limits(2)]);
            ylim(axes_ref,[limits(1),limits(2)]);
            zlim(axes_ref,[limits(1),limits(2)]);
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

		function PlotCrossSection(cross_section)
			if(~isa(cross_section,'GOMCrossSection'))
				fprintf('PlotTools::PlotCrossSection: Input not a GOMCrossSection\n');
				return;
			end%if

			plot3(cross_section.x,cross_section.y,cross_section.z,'k.');
		end%func PlotCrossSection

		function PlotCrossSectionSet(cross_section_set)
			hold on;
			for i = 1:length(cross_section_set)
				PlotTools.PlotCrossSection(cross_section_set{i});
			end%for i
			hold off;

			view(45,45);
			grid on;
			xlabel('X (mm)');
			ylabel('Y (mm)');
			zlabel('Z (mm)');
		end%func PlotCrossSectionSet
	end%static methods
end%class PlotTools