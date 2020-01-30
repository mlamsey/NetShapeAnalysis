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
				[x,y,z] = ProcessSurfaceScan.GetScanProfileAtIndex(scan,i);
				plot3(x,y,z,'.k','markersize',2);
				% pause
			end%for i
			hold off;

		end%func Plot
	end%static methods
end%class PlotSurfaceScan