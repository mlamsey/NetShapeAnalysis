classdef SurfaceScan < handle & matlab.mixin.Copyable
	properties
		time;
		robot_x;
		robot_y;
		robot_z;
		robot_a;
		robot_b;
		robot_c;
		voltage;
		current;
		weld_on;
		scan_profile;
	end%properties

	methods(Static)
		function scan_data = LoadSurfaceScanFromFile(file_path)
			fprintf('Importing Data...');
			data = importdata(file_path,',');
			fprintf(' Import Complete\n');

			scan_data.time = data(:,1);
			scan_data.robot_x = data(:,2);
			scan_data.robot_y = data(:,3);
			scan_data.robot_z = data(:,4);
			scan_data.robot_a = data(:,5);
			scan_data.robot_b = data(:,6);
			scan_data.robot_c = data(:,7);
			scan_data.voltage = data(:,8);
			scan_data.current = data(:,9);
			scan_data.weld_on = data(:,10);
			scan_data.scan_profile = data(:,11:end);
		end%func LoadSurfaceScanFromFile
	end%Static methods

	methods
		function obj = SurfaceScan(file_path)
			data = SurfaceScan.LoadSurfaceScanFromFile(file_path);
			obj.time = data.time;
			obj.robot_x = data.robot_x;
			obj.robot_y = data.robot_y;
			obj.robot_z = data.robot_z;
			obj.robot_a = data.robot_a;
			obj.robot_b = data.robot_b;
			obj.robot_c = data.robot_c;
			obj.voltage = data.voltage;
			obj.current = data.current;
			obj.weld_on = logical(data.weld_on);
			obj.scan_profile = data.scan_profile;
		end%func Constructor
	end%methods
end%class SurfaceScan