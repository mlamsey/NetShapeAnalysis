function WriteCellArrayToCSV(cell_array,file_name)
	export_matrix = [];
	for i = 1:length(cell_array)
		current_entry = cell_array{i};
		for j = 1:length(current_entry)
			export_matrix(i,j) = current_entry(j);
		end%for j
	end%for i
	csvwrite(file_name,export_matrix);
end%func WriteCellArrayToCSV