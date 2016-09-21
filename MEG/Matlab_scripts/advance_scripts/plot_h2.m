function hh=plot_h2(dat)

load('/autofs/cluster/transcend/fahimeh/fm_functions/Mines/flatHelmet.mat');
figure;
%set(gcf,'position',[3          54        1493        1066])
% hAxes=gca;
hold on;



hold on
hh=patch('Faces',     Faces,'Vertices',  Vertices,'FaceVertexCData', dat,...
    'EdgeColor', 'k','EdgeAlpha', 0.01, 'FaceColor', 'interp','BackfaceLighting', 'lit','facealpha',1);
hold on
axis('equal')
axis('off')
camroll(90)
set(gca,'fontsize',12,'fontweight','b')
set(gca,'clim',[-max(abs(dat)) max(abs(dat))])