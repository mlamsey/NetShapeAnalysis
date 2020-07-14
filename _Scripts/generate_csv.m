% Script to render all of the scan files into parsed csvs

txt_directory = 'OverhangSurfaceRoughness';
csv_directory = 'OverhangCSV';

contents = dir(txt_directory);

for i = 1:length(contents)
	fprintf('File %i/%i\n',i,length(contents));
	file_name = contents(i).name;
	if(~strcmp(file_name,'.') && ~strcmp(file_name,'..'))
		if(strcmp(file_name(end-3:end),'.txt'))
			full_name = strcat(txt_directory,'/',contents(i).name);
			current_scan = SurfaceScan(full_name);
			ProcessSurfaceScan.StandardCleanup(current_scan);

			write_name = strcat(csv_directory,'/',contents(i).name(1:end-4),'.csv');
			FileTools.WriteScanToCSV(current_scan,write_name);
		end%if
	end%if
end%for i