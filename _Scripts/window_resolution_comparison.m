% Script to generate figures for comparison

window_sizes = [2.5,5,10,20];

for i = 1:length(window_sizes)
	% subplot(2,2,i);
	TestMethods.TestSquareWindows(s,window_sizes(i));
end%for i