classdef AnalysisMethods
	properties(Constant)

	end%const

	methods(Static)

		function metric_value = QueryMetric(data,metric_string)
			switch metric_string
				case 'Mean'
					metric_value = SurfaceRoughnessCalculations.Mean(data);
				case 'Stddev'
					metric_value = SurfaceRoughnessCalculations.Stddev(data);
				case 'Ra'
					metric_value = SurfaceRoughnessCalculations.Ra(data);
				case 'Rq'
					metric_value = SurfaceRoughnessCalculations.Rq(data);
				case 'Rv'
					metric_value = SurfaceRoughnessCalculations.Rv(data);
				case 'Rp'
					metric_value = SurfaceRoughnessCalculations.Rp(data);
				case 'Rz'
					metric_value = SurfaceRoughnessCalculations.Rz(data);
				case 'Rsk'
					metric_value = SurfaceRoughnessCalculations.Rsk(data);
				case 'Rku'
					metric_value = SurfaceRoughnessCalculations.Rku(data);
				case 'RzJIS'
					metric_value = SurfaceRoughnessCalculations.RzJIS(data);
				case 'RzPercent'
					metric_value = SurfaceRoughnessCalculations.RzPercent(data);
				otherwise
					fprintf('AnalysisMethods::QueryMetric: Input metric string not recognized.\n');
					metric_value = [];
			end%switch
		end%func QueryMetric

		function metric_vector = GetMetricForEachLayer(scan,metric_string,layer_height)

			part_height = max(scan.data.z) - min(scan.data.z);
			n_layers = ceil(part_height / layer_height);
			layer_height_vector = AnalysisMethods.GetLayerHeightVector(scan.data,n_layers);

			metric_vector = zeros(1,n_layers);

			for i = 1:n_layers
				metric_vector(i) = AnalysisMethods.GetLayerMetric(scan,metric_string,layer_height_vector(i),layer_height_vector(i + 1));
			end%for i

		end%func GetRzForEachLayer

		function metric = GetLayerMetric(scan,metric_string,z_min,z_max)
			if(~isa(scan,'GOMScan'))
				fprintf('AnalysisMethods::GetLayerRz: Input 1 not a GOMScan\n');
			end%if
			data = scan.data;
			subset = ScanMethods.GetScanDataSubsetInRange(data,'z',z_min,z_max);
			metric = AnalysisMethods.QueryMetric(subset.dev,metric_string);
		end%func GetLayerRz

		function LA100LayerRzAnalysis(scan)
			if(~isa(scan,'GOMScan'))
				fprintf('AnalysisMethods::LA100LayerRzAnalysis: Input not a GOMScan\n');
				return;
			end%func LA100LayerRzAnalysis

			data = scan.data;

			% Extract consts
			n_layers = LA100.n_layers;
			layer_height = LA100.layer_height;

			% Calculate part geometry
			layer_height_vector = AnalysisMethods.GetLayerHeightVector(data,n_layers);
			if(isempty(layer_height_vector))
				return;
			end%if

			Rz = zeros(1,n_layers-1);

			for i = 1:n_layers - 1
				layer_subset = ScanMethods.GetScanDataSubsetInRange(data,'z',layer_height_vector(i),layer_height_vector(i + 1));
				ScanMethods.RemovePointsOutsideOfDeviationRange(layer_subset,-5,5);
				Rz(i) = SurfaceRoughnessCalculations.Rz(layer_subset.dev);
			end%for i

			plot(Rz);

		end%func LA100LayerRzAnalysis
	end%static methods

	methods(Static, Access = 'private')
		function layer_height_vector = GetLayerHeightVector(scan_data,number_of_layers)
			if(~isa(scan_data,'GOMScanData'))
				fprintf('AnalysisMethods::GetLayerHeightVector: Input 1 not a GOMScanData\n');
				layer_height_vector = [];
				return;
			end%if

			top_of_part = max(scan_data.z);
			bottom_of_part = min(scan_data.z);
			layer_height_vector = linspace(bottom_of_part,top_of_part,number_of_layers + 1);
			fprintf('Layer height vector generated with a layer height of %1.3f\n',...
				layer_height_vector(2) - layer_height_vector(1));

		end%func GetLayerHeightVector
	end%private methods
end%class AnalysisMethods