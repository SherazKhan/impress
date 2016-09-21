function plot_shadederror_color(S1,times,color)
% Sheraz khan, PhD
% sheraz@nmr.mgh.harvard.edu


nSubj=size(S1,1);

y1=mean(S1)';
y2=mean(S1)'-std(S1)'./sqrt(nSubj);
y3=mean(S1)'+std(S1)'./sqrt(nSubj);
x=times';
%figure;

plot_standarderror(x,[y1 y2 y3], 'PatchColor', color, 'PatchAlpha', 0.3, ...
'MainLineWidth', 2.5, 'MainLineStyle', '-', 'MainLineColor', color, ...
'LineWidth', 1, 'LineStyle','-', 'LineColor', color);

axis tight
line([0 0],[min(y2) max(y3)],'color','k','linewidth',2)


box on
grid
set(gca,'fontsize',16,'fontweight','b')

xlabel('Time','fontsize',18,'fontweight','b')
ylabel('Amplitude','fontsize',18,'fontweight','b')

