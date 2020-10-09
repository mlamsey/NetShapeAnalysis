%% GKN Invar Preform Cross Section Analysis
clc, close all, clear all

file_path = 'C:\Users\pty883\University of Tennessee\UT_MABE_Welding - Documents\GKN Invar\Scans\Invar\[P] Cross Section Deviation.asc';

g = GOMDeviationSection(file_path);
subset = g.z > 0;

f = figure;
a = axes('parent',f);
plot(g.x(subset),g.z(subset),'parent',a);

PlotTools.SquareAxes2(a);
grid on;
xlabel('X (mm)');
ylabel('Z (mm)');