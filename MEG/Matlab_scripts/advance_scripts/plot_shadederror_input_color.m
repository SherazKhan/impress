function plot_shadederror_input_color(S1,times,color_line,cfg)
% Sheraz khan, PhD
% sheraz@nmr.mgh.harvard.edu


nSubj=size(S1,1);

y1=mean(S1)';
y2=mean(S1)'-std(S1)'./sqrt(nSubj);
y3=mean(S1)'+std(S1)'./sqrt(nSubj);
x=times';
%figure;

plot_standarderror(x,[y1 y2 y3], 'PatchColor', color_line, 'PatchAlpha', 0.05, ...
'MainLineWidth', 2.8, 'MainLineStyle', cfg.line_style, 'MainLineColor', color_line, ...
'LineWidth', 1, 'LineStyle',cfg.line_style, 'LineColor', color_line);

axis tight
%line([0 0],[min(y2) max(y3)],'color','k','linewidth',2)
line([0 0],[-3.8 1.8],'color','k','linewidth',2)

ylim([-3.8 1.8])

box on
grid
set(gca,'fontsize',16,'fontweight','b')

xlabel('Time','fontsize',18,'fontweight','b')
ylabel('Amplitude','fontsize',18,'fontweight','b')

