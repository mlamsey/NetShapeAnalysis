classdef SurfaceRoughnessCalculations
	methods(Static)
		function avg = Mean(deviation_vector)
			avg = mean(deviation_vector);
		end%func Mean

		function stddev = Stddev(deviation_vector)
			stddev = std(deviation_vector);
		end%func Stddev

		function R_a = Ra(deviation_vector)
			% Arithmetical mean
			R_a = mean(abs(deviation_vector));
		end%func Ra

		function R_q = Rq(deviation_vector)
			% Root-mean squared (Rrms)
			R_q = rms(deviation_vector);
		end%func Rq

		function R_v = Rv(deviation_vector)
			% Maximum valley depth
			R_v = abs(min(deviation_vector));
		end%func Rv

		function R_p = Rp(deviation_vector)
			% Maximum peak height
			R_p = max(deviation_vector);
		end%func Rp

		function R_z = Rz(deviation_vector)
			% Maximum height of profile
			R_z = SurfaceRoughnessCalculations.Rv(deviation_vector) + SurfaceRoughnessCalculations.Rp(deviation_vector);
		end%func Rz

		function R_sk = Rsk(deviation_vector)
			% Skewness
			n = length(deviation_vector);

			deviation_sum = 0;
			for i = 1:n
				deviation_sum = deviation_sum + deviation_vector(i).^3;
			end%for i

			R_q3 = SurfaceRoughnessCalculations.Rq(deviation_vector) .^ 3;

			R_sk = (1 / (n * R_q3)) * deviation_sum;
		end%func Rsk

		function R_ku = Rku(deviation_vector)
			% Kurtosis
			n = length(deviation_vector);

			deviation_sum = 0;
			for i = 1:n
				deviation_sum = deviation_sum + deviation_vector(i).^4;
			end%for i

			R_q4 = SurfaceRoughnessCalculations.Rq(deviation_vector) .^ 4;

			R_ku = (1 / (n * R_q4)) * deviation_sum;
		end%func Rku

		function R_zJIS = RzJIS(deviation_vector)
			[sorted_deviation,old_indices] = sort(deviation_vector);

			if(length(sorted_deviation) < 5)
				R_zJIS = SurfaceRoughnessCalculations.Rz(sorted_deviation);
				return;
			end%if

			minima = abs(sorted_deviation(1:5));
			maxima = abs(sorted_deviation(end-4:end));

			R_zJIS = (1/5) * (sum(maxima) + sum(minima));

		end%func RzJIS

		function R_zJIS = RzPercent(deviation_vector,percentage)
			[sorted_deviation,old_indices] = sort(deviation_vector);
			percentage = 0.01;

			sample_length = floor(percentage*length(deviation_vector));

			minima = abs(sorted_deviation(1:sample_length));
			maxima = sorted_deviation(end-(sample_length-1):end);

			R_zJIS = (1/sample_length) * (sum(maxima) - sum(minima));

		end%func RzJIS

		function PrintAllMetrics(deviation_vector)
			fprintf('Ra: %1.5f\n',SurfaceRoughnessCalculations.Ra(deviation_vector));
			fprintf('Rq: %1.5f\n',SurfaceRoughnessCalculations.Rq(deviation_vector));
			fprintf('Rv: %1.5f\n',SurfaceRoughnessCalculations.Rv(deviation_vector));
			fprintf('Rp: %1.5f\n',SurfaceRoughnessCalculations.Rp(deviation_vector));
			fprintf('Rz: %1.5f\n',SurfaceRoughnessCalculations.Rz(deviation_vector));
			fprintf('Rsk: %1.5f\n',SurfaceRoughnessCalculations.Rsk(deviation_vector));
			fprintf('Rku: %1.5f\n',SurfaceRoughnessCalculations.Rku(deviation_vector));
			fprintf('RzJIS: %1.5f\n',SurfaceRoughnessCalculations.RzJIS(deviation_vector));
		end%func PrintAllMetrics

	end%methods
end%class SurfaceRoughnessCalculations