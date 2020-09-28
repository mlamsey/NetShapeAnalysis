clc
clearvars -except wall_sets slope_vector_list intercept_vector_list recalc dir_path;

if(~exist('recalc','var'))
    recalc = true;
end%if

if(recalc)
    fprintf('Importing GOM Cross Sections\n');
    dir_path = uigetdir;

    dir_info = dir(dir_path);
    n_files = length(dir_info);

    % Instantiate bonus iterators
    file_i = 1;

    % Loop through all files
    for i = 1:n_files
        sub_dir_name = dir_info(i).name;

        % check if filenames are NOT navigation targets
        if(contains(sub_dir_name,'wall'))
            % Generate path, import contour data, assign contour in set
            if(ispc)
                sub_path = strcat(dir_info(i).folder,'\',sub_dir_name);
            else
                sub_path = strcat(dir_info(i).folder,'/',sub_dir_name);
            end%if

            wall_sets{file_i} = FileTools.ImportCrossSectionSetFromDirectory(sub_path);

            % Fix Wall 5
            if(strcmp(sub_dir_name,'wall5'))
                temp_set = wall_sets{file_i};
                wall_subset = {temp_set{1:50}};
                wall_subset = flip(wall_subset);
                
                for k = 1:50
                    temp_set{k} = wall_subset{k};
                end%for i

                wall_sets{file_i} = temp_set;
            end%if
            % wall_sets{file_i} = CrossSectionMethods.SwitchCrossSectionSetParameters(wall_sets{file_i},'y','z');
            file_i = file_i + 1;
        end%if
    end%for i

    n_walls = length(wall_sets);
    slope_vector_list = cell(1,n_walls);
    intercept_vector_list = slope_vector_list;

    fprintf('Calculating Center Lines\n');
    for i = 1:n_walls
        fprintf('Wall %i...\n',i);
        [slope_vector,intercept_vector] = CrossSectionAnalysisMethods.GetWallCenterLinesForSet(wall_sets{i},'z');
        slope_vector_list{i} = slope_vector;
        intercept_vector_list{i} = intercept_vector;
    end%for i

    recalc = false;
end%if

% Calculate plot bounds
angle_y_max = 0;
angle_y_min = 0;
intercept_y_range = 0;

for i = 1:length(wall_sets)
    slope_vector = slope_vector_list{i};
    angle_vector = atan(slope_vector) .* 180 ./ pi;
    angle_min = min(angle_vector);
    if(angle_min < angle_y_min)
        angle_y_min = angle_min;
    end%if

    angle_max = max(angle_vector);
    if(angle_max > angle_y_max)
        angle_y_max = angle_max;
    end%if

    intercept_range = max(intercept_vector_list{i}) - min(intercept_vector_list{i});
    if(intercept_range > intercept_y_range)
        intercept_y_range = intercept_range;
    end%if

end%for i

% Plot
fprintf('Plotting\n');
% figure_slope = figure('position',[100,100,1200,800]);
figure_intercept = figure('position',[100,100,1200,800]);

plot_angle_labels = {'+40^{\circ}','+30^{\circ}','+20^{\circ}','+10^{\circ}','0^{\circ}','-10^{\circ}','-20^{\circ}','-30^{\circ}','-40^{\circ}'};

% cad_center_lines = 25.4 .* [1.25,0,-1.25,-2.5,5.75,1.25,0,-1.25,-2.5];
cad_center_lines = 25.4 .* [1.25,0,-1.25,-2.5,2.75,1.25,0,-1.25,-2.5];

angles = flip(-40:10:40);
angle_export = {};

for i = 1:length(wall_sets)
    title_string = strcat('Torch at',{' '},plot_angle_labels{i});
    title_string = title_string{1};

    slope_vector = slope_vector_list{i};
    angle_vector = (atan(slope_vector) .* 180 ./ pi);
    % axes_slope = subplot(3,3,i,'parent',figure_slope);
    % plot(angle_vector,'parent',axes_slope);
    % ylim(axes_slope,[angle_y_min,angle_y_max]);
    % grid(axes_slope,'on');
    % title(axes_slope,title_string);
    % xlabel(axes_slope,'Slice (mm)');
    % ylabel(axes_slope,'Angle (degrees)');

    angle_export{i} = angle_vector;

    intercept_vector = intercept_vector_list{i};
    % intercept_y_min = mean(intercept_vector_list{i}) - intercept_range / 2;
    % intercept_y_max = mean(intercept_vector_list{i}) + intercept_range / 2;
    intercept_y_min = mean(intercept_vector_list{i}) - 5;
    intercept_y_max = mean(intercept_vector_list{i}) + 5;

    axes_intercept = subplot(3,3,i,'parent',figure_intercept);
    plot(intercept_vector,'parent',axes_intercept);
    hold(axes_intercept,'on');

    cad_height = cad_center_lines(i);
    wall_height = mean(intercept_vector);

    line([min(xlim(axes_intercept)),max(xlim(axes_intercept))],[wall_height,wall_height],'color','k','linestyle','--'); 
    line([min(xlim(axes_intercept)),max(xlim(axes_intercept))],[cad_height,cad_height],'color','r','linestyle','--'); 
    hold(axes_intercept,'off');

    separation(i) = wall_height - cad_height;

    % legend('Intercept','Mean Intercept','CAD Centerline');
    ylim(axes_intercept,[intercept_y_min,intercept_y_max]);
    grid(axes_intercept);
    title(axes_intercept,title_string);
    xlabel(axes_intercept,'Slice (mm)');
    ylabel(axes_intercept,'Centerline Intersect (mm)');

    fprintf('Wall Plot %i: Angle %1.1f, Separation %1.3fmm\n',i,angles(i),separation(i));
    fprintf('CAD Centerline: %1.3fmm, Wall Intercept: %1.3fmm\n\n',cad_height,wall_height);
end%for i

figure;
plot(angles,separation);
% plot(separation);
grid on;
title('Deviation from CAD Centerline');
xlabel('Torch Angle (Degrees)');
ylabel('Deviation (mm)');