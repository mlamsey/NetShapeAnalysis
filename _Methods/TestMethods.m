classdef TestMethods
	properties(Constant)

	end%const
	methods(Static)
		function vargout = TestWindowSizes(scan)
			if(~isa(scan,'GOMScan'))
				fprintf('TestMethods::TestWindowSizes: Input not a GOMScan\n');
				vargout = [];
				return;
			end%if

			data = scan.data;
			disp('uwu')
		end%func TestWindowSizes
	end%static methods
end%class TestMethods