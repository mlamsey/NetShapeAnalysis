classdef PlotSurfaceScan
	properties(Constant)
		
	end%const

	methods(Static)
		function axes_ref = Plot(scan)
			if(~isa(scan,'SurfaceScan'))
				fprintf('PlotSurfaceScan::Plot: Input not a Surface Scan\n');
				axes_ref = null;
				return;
			end%if

			f = figure;
			axes_ref = axes('parent',f);
			grid on;
			view(45,25);
			xlabel('X (mm) - Scan Travel')
			ylabel('Y (mm) - Keyence Plane')
			zlabel('Z (mm) - Offset')

			hold on;

			for i = 1:length(scan.scan_profile(:,1))
				scan_y = scan.robot_y(i);
				y_offset = KeyenceConst.keyence_scan_width / 2;
				y_range = linspace(scan_y - y_offset, scan_y + y_offset, ...
				KeyenceConst.keyence_n_points);
				x_range = scan.robot_x(i) .* ones(KeyenceConst.keyence_n_points,1);
				
				plot3(x_range,y_range,scan.scan_profile(i,:),'.k',...
					'markersize',2);
				% pause
			end%for i
			hold off;

		end%func Plot
	end%static methods
end%class PlotSurfaceScan