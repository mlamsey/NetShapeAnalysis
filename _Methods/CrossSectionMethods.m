classdef CrossSectionMethods
	properties(Constant)
		wall_center_line_buffer_bounds = 0.025; % percent 0-1
		wall_subset_sample_upper_offset = 2.5; % mm
        wall_subset_sample_lower_offset = 8*2.25; %mm
	end%const

	methods(Static)
		function new_set = SwitchCrossSectionSetParameters(original_set,axis_1,axis_2)
			new_set = original_set;
			for i = 1:length(original_set)
				new_set{i} = CrossSectionMethods.SwitchCrossSectionParameters(original_set{i},axis_1,axis_2);
			end%for i
		end%func SwitchCrossSectionSetParameters
		
		function new_cross_section = SwitchCrossSectionParameters(original_cross_section,axis_1,axis_2)
			if(~isa(original_cross_section,'GOMCrossSection'))
				fprintf('CrossSectionMethods::SwitchCrossSectionParameters: Input 1 not a GOMCrossSection\n');
				new_cross_section = original_cross_section;
				return;
			end%if

			parameter_1 = CrossSectionMethods.GetParameter(original_cross_section,axis_1);
			parameter_2 = CrossSectionMethods.GetParameter(original_cross_section,axis_2);

			new_cross_section = CrossSectionMethods.SetParameter(original_cross_section,axis_1,parameter_2);
			new_cross_section = CrossSectionMethods.SetParameter(new_cross_section,axis_2,parameter_1);

		end%func SwitchCrossSectionParameters

        function cross_section_subset = GetCrossSectionSubsetInAxisRange(cross_section,height_axis)
			switch height_axis
				case 'x'
					cross_section_axis = cross_section.x;
				case 'y'
					cross_section_axis = cross_section.y;
				case 'z'
					cross_section_axis = cross_section.z;
				otherwise
					fprintf('CrossSectionMethods::GetCrossSectionSubsetInAxisRange: Height Axis input not recognized\n');
			end%switch

			cross_section_min = min(cross_section_axis);
			cross_section_max = max(cross_section_axis);

			cross_section_range = cross_section_max - cross_section_min;

			% subset_min = cross_section_min + CrossSectionMethods.wall_center_line_buffer_bounds * cross_section_range;
			% subset_max = cross_section_max - CrossSectionMethods.wall_center_line_buffer_bounds * cross_section_range;

			subset_min = cross_section_min + CrossSectionMethods.wall_subset_sample_lower_offset;
			subset_max = cross_section_max - CrossSectionMethods.wall_subset_sample_upper_offset;

			logical_indices = cross_section_axis > subset_min & cross_section_axis < subset_max;

			cross_section_subset = CrossSectionMethods.CreateCrossSectionSubsetWithLogicalIndices(cross_section,logical_indices);
		end%func GetCrossSectionSubsetInRange

		function cross_section_subset = GetCustomCrossSectionSubsetInAxisRange(cross_section,height_axis,lower_offset,upper_offset)
			switch height_axis
				case 'x'
					cross_section_axis = cross_section.x;
				case 'y'
					cross_section_axis = cross_section.y;
				case 'z'
					cross_section_axis = cross_section.z;
				otherwise
					fprintf('CrossSectionMethods::GetCrossSectionSubsetInAxisRange: Height Axis input not recognized\n');
			end%switch

			cross_section_min = min(cross_section_axis);
			cross_section_max = max(cross_section_axis);

			cross_section_range = cross_section_max - cross_section_min;

			% subset_min = cross_section_min + CrossSectionMethods.wall_center_line_buffer_bounds * cross_section_range;
			% subset_max = cross_section_max - CrossSectionMethods.wall_center_line_buffer_bounds * cross_section_range;

			subset_min = cross_section_min + lower_offset;
			subset_max = cross_section_max - upper_offset;

			logical_indices = cross_section_axis > subset_min & cross_section_axis < subset_max;

			cross_section_subset = CrossSectionMethods.CreateCrossSectionSubsetWithLogicalIndices(cross_section,logical_indices);
		end%func GetCrossSectionSubsetInRange
        
        function cross_section_subset = CreateCrossSectionSubsetWithLogicalIndices(cross_section,logical_indices)
			cross_section_subset = cross_section; % copy

			cross_section_subset.x = cross_section_subset.x(logical_indices);
			cross_section_subset.y = cross_section_subset.y(logical_indices);
			cross_section_subset.z = cross_section_subset.z(logical_indices);
			cross_section_subset.n_x = cross_section_subset.n_x(logical_indices);
			cross_section_subset.n_y = cross_section_subset.n_y(logical_indices);
			cross_section_subset.n_z = cross_section_subset.n_z(logical_indices);
		end%func CreateCrossSectionSubsetWithLogicalIndices
    end
    
	methods(Static, Access = 'private')
		function parameter_values = GetParameter(cross_section,parameter_name)
			parameter_name = lower(parameter_name);
			switch parameter_name
				case 'x'
					parameter_values = cross_section.x;
				case 'n_x'
					parameter_values = cross_section.n_x;
				case 'y'
					parameter_values = cross_section.y;
				case 'n_y'
					parameter_values = cross_section.n_y;
				case 'z'
					parameter_values = cross_section.z;
				case 'n_z'
					parameter_values = cross_section.n_z;
				otherwise
					fprintf('CrossSectionMethods::GetParameter: Invalid Parameter Name\n');
			end%switch
		end%func GetAxis

		function new_cross_section = SetParameter(cross_section,parameter_name,values)
			new_cross_section = cross_section;
			switch parameter_name
				case 'x'
					new_cross_section.x = values;
				case 'n_x'
					new_cross_section.x = values;
				case 'y'
					new_cross_section.y = values;
				case 'n_y'
					new_cross_section.y = values;
				case 'z'
					new_cross_section.z = values;
				case 'n_z'
					new_cross_section.z = values;
				otherwise
					fprintf('CrossSectionMethods::SetParameter: Invalid Parameter name\n');
			end%switch
		end%func SetAxis
	end%private methods
end%class CrossSectionAnalysis