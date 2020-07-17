% Script to generate figures for comparison

%% TEST 001
% Various square window sizes

% window_sizes = [2.5,5,10,20];

% for i = 1:length(window_sizes)
% 	% subplot(2,2,i);
% 	TestMethods.TestSquareWindows(s,window_sizes(i));
% end%for i

%% TEST 002
% Test raw vs resampled for square windows
RzJIS_raw = TestMethods.TestRectangularWindows(s,'RzJIS',2.3,2.3);
RzJIS_resampled = TestMethods.TestRectangularWindows(s2,'RzJIS',2.3,2.3);

RzJIS_raw_layers = zeros(1,length(RzJIS_raw));
RzJIS_resampled_layers = zeros(1,length(RzJIS_resampled));

for i = 1:length(RzJIS_raw_layers)
	RzJIS_raw_layers(i) = mean(RzJIS_raw(i,:));
end%for i

for i = 1:length(RzJIS_resampled_layers)
	RzJIS_resampled_layers(i) = mean(RzJIS_resampled(i,:));
end%for i

figure;
plot(RzJIS_raw_layers);
hold on;
plot(RzJIS_resampled_layers);
hold off;
xlabel('Layer Number');
ylabel('RzJIS Value');
title('RzJIS Comparison - Averaged across 2.3mm square windows');
legend('Raw','Resampled');