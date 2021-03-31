clc, close all

if(~isa(s,'GOMScan'))
	file_path = 'C:\Users\pty883\University of Tennessee\UT_MABE_Welding - Documents\GKN Invar\Scans\GOM\Export\[P] Full Res Tool Mold Surface.asc';
	s = GOMScan(file_path);
end%if

deviation_threshold = 4;
li_dev = abs(s.data.dev - mean(s.data.dev)) <= deviation_threshold;
subset_dev = s.data.dev(li_dev);

[counts,centers] = hist(subset_dev,50);

count_threshold = 100;
li_count = counts > count_threshold;
centers_subset = centers(li_count);
r_z = max(centers_subset) - min(centers_subset)