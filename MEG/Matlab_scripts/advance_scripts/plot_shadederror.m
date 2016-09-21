function plot_shadederror(S1,times,cond)
% Sheraz khan, PhD
% sheraz@nmr.mgh.harvard.edu


nSubj=size(S1,1);

y1=mean(S1)';
y2=mean(S1)'-0.5*std(S1)'./sqrt(nSubj);
y3=mean(S1)'+0.5*std(S1)'./sqrt(nSubj);
x=times';
%figure;
if cond==1
plot_standarderror(x,[y1 y2 y3], 'PatchColor', [0.11 0.63 0.89], 'PatchAlpha', 0.2, ...
'MainLineWidth', 2.8, 'MainLineStyle', '-', 'MainLineColor', [0.11 0.63 0.89], ...
'LineWidth', 1, 'LineStyle','-', 'LineColor', [0.11 0.63 0.89]);
elseif cond==2
plot_standarderror(x,[y1 y2 y3], 'PatchColor', [0.89 0.3 0.11], 'PatchAlpha', 0.2, ...
'MainLineWidth', 2.8, 'MainLineStyle', '-', 'MainLineColor', [0.89 0.3 0.11], ...
'LineWidth', 1, 'LineStyle','-', 'LineColor', [0.89 0.3 0.11]);
end
axis tight
%line([0 0],[min(y2) max(y3)],'color','k','linewidth',2)




% ylim([-3.8 1.8])

box on
%grid
set(gca,'fontsize',16,'fontweight','b')

xlabel('time(s)','fontsize',18,'fontweight','b')
ylabel('amplitude','fontsize',18,'fontweight','b')
