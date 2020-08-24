clc
clearvars -except wall_sets slope_vector_list intercept_vector_list recalc;

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
            % wall_sets{file_i} = CrossSectionMethods.SwitchCrossSectionSetParameters(wall_sets{file_i},'y','z');
            file_i = file_i + 1;
        end%if
    end%for i

    n_walls = length(wall_sets);
    slope_vector_list = cell(1,n_walls);
    intercept_vector_list = slope_vector_list;

    fprintf('Calculating Center Lines\n');
    for i = 1:n_walls
        [slope_vector,intercept_vector] = CrossSectionMethods.GetWallCenterLinesForSet(wall_sets{i},'z');
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
    intercept_y_min = mean(intercept_vector_list{i}) - intercept_range / 2;
    intercept_y_max = mean(intercept_vector_list{i}) + intercept_range / 2;

    axes_intercept = subplot(3,3,i,'parent',figure_intercept);
    plot(intercept_vector,'parent',axes_intercept);
    hold(axes_intercept,'on');
    line([min(xlim(axes_intercept)),max(xlim(axes_intercept))],[mean(intercept_vector),mean(intercept_vector)],'color','k','linestyle','--');
    hold(axes_intercept,'off');

    legend('Intercept','Mean Intercept');
    ylim(axes_intercept,[intercept_y_min,intercept_y_max]);
    grid(axes_intercept);
    title(axes_intercept,title_string);
    xlabel(axes_intercept,'Slice (mm)');
    ylabel(axes_intercept,'Centerline Intersect (mm)');
end%for i