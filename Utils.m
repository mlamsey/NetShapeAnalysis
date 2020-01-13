classdef Utils
	properties(Constant)

	end%const

	methods(Static)
		function new_vector = DecimateVector(old_vector,decimation_factor)
			% Inefficient, but it works
			n_entries = floor(length(old_vector) / decimation_factor);
			new_vector = [];
			for i = 1:n_entries
				new_vector(i) = old_vector(i * decimation_factor);
			end%for i
		end%func DecimateVector
	end%static methods
end%class Utils