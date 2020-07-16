classdef TestMethods
	properties(Constant)

	end%const
	methods(Static)
		function varargout = TestWindowSizes(scan)
			if(~isa(scan,'GOMScan'))
				fprintf('TestMethods::TestWindowSizes: Input not a GOMScan\n');
				varargout = [];
				return;
			end%if

			data = scan.data;
		end%func TestWindowSizes

		function varargout = TestSquareWindows(scan,window_length_mm)
			if(~isa(scan,'GOMScan'))
				fprintf('TestMethods::TestSquareWindows: Input 1 not a GOMScan\n');
				varargout = [];
				return;
			end%if

			data = scan.data;

			x_range = [min(data.x),max(data.x)];
			y_range = [min(data.y),max(data.y)];
			z_range = [min(data.z),max(data.z)];

			n_x_points = ceil((x_range(2) - x_range(1)) / window_length_mm);
			n_y_points = ceil((y_range(2) - y_range(1)) / window_length_mm);
			n_z_points = ceil((z_range(2) - z_range(1)) / window_length_mm);

			x_steps = x_range(1) : window_length_mm : (x_range(1) + (n_x_points * window_length_mm));
			y_steps = y_range(1) : window_length_mm : (y_range(1) + (n_y_points * window_length_mm));
			z_steps = z_range(1) : window_length_mm : (z_range(1) + (n_z_points * window_length_mm));

			% Looking at square 2D windows in the XZ Plane
			roughness_values = zeros(n_z_points,n_x_points);
			n_windows_without_points = 0;
			metric_threshold = 5;

			for i = 1:n_z_points
				z_min = z_steps(i);
				z_max = z_steps(i + 1);
				
				z_subset = ScanMethods.GetScanDataSubsetInRange(data,'z',z_min,z_max);

				for j = 1:n_x_points
					x_min = x_steps(j);
					x_max = x_steps(j + 1);

					xz_subset = ScanMethods.GetScanDataSubsetInRange(z_subset,'x',x_min,x_max);

					if(length(xz_subset.x) <= 0)
						metric = 0;
						n_windows_without_points = n_windows_without_points + 1;
					else
						metric = SurfaceRoughnessCalculations.RzJIS(xz_subset.dev);
					end%if

					if(metric > metric_threshold)
						metric = metric_threshold;
					elseif(metric < -1 * metric_threshold)
						metric = -1 * metric_threshold;
					end%if

					roughness_values(i,j) = metric;
					
				end%for j
			end%for i

			fprintf('%i of %i windows contain no points.\n',n_windows_without_points,n_x_points * n_z_points);
			varargout = {roughness_values};

			% Plot
			f = figure('position',[100,100,1000,800]);
			a = axes('parent',f);
			surf(flip(x_steps(1:end-1)),z_steps(1:end-1),roughness_values,'parent',a);
			shading interp;
			colormap jet;
			colorbar;
			view(0,90);
			PlotTools.SquareAxes2(a);

		end%func TestSquareWindows

		function varargout = TestRectangularWindows(scan,window_height_mm,window_length_mm)
			if(~isa(scan,'GOMScan'))
				fprintf('TestMethods::TestRectangularWindows: Input 1 not a GOMScan\n');
				varargout = [];
				return;
			end%if

			data = scan.data;

			x_range = [min(data.x),max(data.x)];
			z_range = [min(data.z),max(data.z)];

			n_x_points = ceil((x_range(2) - x_range(1)) / window_length_mm);
			n_z_points = ceil((z_range(2) - z_range(1)) / window_height_mm);

			x_steps = x_range(1) : window_length_mm : (x_range(1) + (n_x_points * window_length_mm));
			z_steps = z_range(1) : window_height_mm : (z_range(1) + (n_z_points * window_height_mm));

			% Looking at square 2D windows in the XZ Plane
			roughness_values = zeros(n_z_points,n_x_points);
			n_windows_without_points = 0;
			metric_threshold = 0.5;

			for i = 1:n_z_points
				z_min = z_steps(i);
				z_max = z_steps(i + 1);
				
				z_subset = ScanMethods.GetScanDataSubsetInRange(data,'z',z_min,z_max);

				for j = 1:n_x_points
					x_min = x_steps(j);
					x_max = x_steps(j + 1);

					xz_subset = ScanMethods.GetScanDataSubsetInRange(z_subset,'x',x_min,x_max);

					if(length(xz_subset.x) <= 0)
						metric = 0;
						n_windows_without_points = n_windows_without_points + 1;
					else
						metric = SurfaceRoughnessCalculations.Stddev(xz_subset.dev);
					end%if

					if(metric > metric_threshold)
						metric = metric_threshold;
					elseif(metric < -1 * metric_threshold)
						metric = -1 * metric_threshold;
					end%if

					roughness_values(i,j) = metric;
					
				end%for j
			end%for i

			fprintf('%i of %i windows contain no points.\n',n_windows_without_points,n_x_points * n_z_points);
			varargout = {roughness_values};

			% Plot
			f = figure('position',[100,100,1000,800]);
			a = axes('parent',f);
			surf(flip(x_steps(1:end-1)),z_steps(1:end-1),roughness_values,'parent',a);
			shading interp;
			colormap jet;
			colorbar;
			view(0,90);
			PlotTools.SquareAxes2(a);

		end%func TestRectangularWindows
	end%static methods
end%class TestMethods