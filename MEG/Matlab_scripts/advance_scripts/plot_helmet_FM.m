function plot_helmet_FM(index)

load('/autofs/cluster/transcend/fahimeh/fm_functions/Mines/flatHelmetSK.mat');
figure;
hAxes=gca;
patch('Faces',     Faces,'Vertices',  Vertices,'Facecolor',[1 1 175/255],...
    'EdgeColor', 'k','EdgeAlpha', 0.05,'BackfaceLighting', 'lit','facealpha',1);
hold on
axis('equal')
axis('off')
radii = [Vertices(:,2);Vertices(:,1)];
PlotNoseEars(hAxes, (max(radii)-min(radii))/4, 1);

   scatter3(Vertices(index,1),Vertices(index,2),Vertices(index,3),100,....
                'MarkerEdgeColor','r',...
                'MarkerFaceColor',[0 0 0]);


