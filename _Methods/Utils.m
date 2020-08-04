classdef Utils
	properties(Constant)

	end%const

	methods(Static)
		function new_vector = DecimateVector(old_vector,decimation_factor)
			% Inefficient, but it works
			n_entries = floor(length(old_vector) / decimation_factor);
			new_vector = [];
			for i = 1:n_entries
				new_vector(i,:) = old_vector(i * decimation_factor,:);
			end%for i
		end%func DecimateVector

		function distance3 = Distance3(x1,y1,z1,x2,y2,z2)
			distance3 = sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2);
		end%func Distance3

		function logical_flags = GetFlagsForLogicalIndices(logical_index)
			logical_flags = [];
			j = 1;
			for i = 1:length(logical_index)
				if(logical_index(i))
					logical_flags(j) = i;
					j = j + 1;
				end%if
			end%for i
		end%func GetFlagsForLogicalIndices
	end%static methods
end%class Utils