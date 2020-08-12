function ShiftAnalysis(data_set,data_set_name)

	titles = {'+40^\circ','+30^\circ','+20^\circ','+10^\circ','+0^\circ',...
		'-10^\circ','-20^\circ','-30^\circ','-40^\circ'};

	mm_transient_offset = 25; % 1 in
	golay_order = 1;
	golay_window = 25;
	f = figure('name',data_set_name);

	for i = 1:8
		raw = data_set(i,:);
		subset = sgolayfilt(raw,golay_order,golay_window);

		start_indices = 1:mm_transient_offset;
		start_subset = subset(start_indices);
		center_indices = (mm_transient_offset + 1):(length(subset) - mm_transient_offset);
		center_subset = subset(center_indices);
		end_indices = (length(subset) - mm_transient_offset + 1):length(subset);
		end_subset = subset(end_indices);

		subplot(2,4,i);
		% plot(start_indices,start_subset);
		% hold on;
		% plot(center_indices,center_subset);
		% plot(end_indices,end_subset);
		% plot(raw,'k.','markersize',1)
		% hold off;

		% center_offset = mean(center_subset);
		% f_start = fit(start_indices',start_subset','exp1');
		% f_end = fit(end_indices',end_subset','exp1');

		% start_exp_fit = f_start.a .* exp(f_start.b .* start_indices);
		% end_exp_fit = f_end.a .* exp(f_end.b .* end_indices);

		f_start = fit(start_indices',start_subset','poly1');
		f_center = fit(center_indices',center_subset','poly1');
		f_end = fit(end_indices',end_subset','poly1');

		start_linear_fit = f_start.p1 .* start_indices + f_start.p2;
		% center_linear_fit = f_center.p1 .* center_indices + f_center.p2;
		center_linear_fit = ones(1,length(center_indices)) .* mean(center_subset);
		end_linear_fit = f_end.p1 .* end_indices + f_end.p2;

		% hold on;
		% plot(start_indices,start_linear_fit,'k--');
		% % line([center_indices(1),center_indices(end)],[center_offset,center_offset],'color','k','linestyle','--');
		% plot(center_indices,center_linear_fit,'k--');
		% plot(end_indices,end_linear_fit,'k--');
		% hold off;

		% ylim([-10,10]);
		% xlabel('Cross Section (mm)');
		% ylabel('Centerline Angle (degrees)');
		% title(titles{i});
		% grid on;

		% legend('Start Section','Center Section','End Section','Raw Data','Location','south');

		start_control_action = -1 .* tan(start_linear_fit .* (pi / 180));
		center_control_action = -1 .* tan(center_linear_fit .* (pi / 180));
		end_control_action = -1 .* tan(end_linear_fit .* (pi / 180));

		plot(start_indices,start_control_action);
		hold on;
		plot(center_indices,center_control_action);
		plot(end_indices,end_control_action);
		line([0,end_indices(end)],[0,0],'color','k','linewidth',2)
		hold off;
		xlabel('Cross Section (mm)');
		ylabel('Path Shift per Layer (mm)');
		grid on;
		title(titles{i});
		ylim([-0.15,0.15]);

	end
end%func ShiftAnalysis