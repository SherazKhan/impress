
function Handle = plot_standarderror(X,Y,varargin)

error(nargchk(2, 32, nargin));

X = resize(X);
Y = resize(Y);

args = varargin;
N_varg = length(args);
if mod(N_varg,2) ~= 0
  error('Parameters must be input in pairs');
end

str_chk = true;
for n=1:2:N_varg
  str_chk = str_chk & ~isnumeric(args{n});
end
if ~str_chk
  error(['Parameter must be input in the form ''string'', ''value'', ' ...
  'although ''value'' may also be string.']);
end


%%% Figure Handle, Axes Handle and axis
param.axeshandle = [];
param.figurehandle = [];
param.axis.x = [];
param.axis.y = [];
for n=1:2:N_varg
  switch lower(args{n})
      case 'axeshandle'
        param.axeshandle = args{n+1};
      case 'figurehandle'
        param.figurehandle = args{n+1};
      case 'xscale'
        param.axis.x = args{n+1};
      case 'yscale';
        param.axis.y = args{n+1};
  end
end
param.name.main = {'mainlinewidth' 'mainlinestyle' 'mainlinecolor'};
param.name.line = {'linewidth' 'linestyle' 'linecolor'};
param.name.patch = {'patchcolor' 'patchalpha'};
param.name.marker = {'marker' 'markersize' 'markerfacecolor' 'markeredgecolor'};
param.name.handles = {'axeshandle' 'figurehandle'};
param.name.axis = {'xscale' 'yscale'};
param.value.main = {0 0 0};
param.value.line = {0 0 0};
param.value.patch = {[0 0 0] 0};
param.value.marker = {'' 0 [0 0 0] [0 0 0]};

%%% Checking Handles
if ~isempty(param.axeshandle)
  H_Axes = param.axeshandle;
  if ~isempty(param.figurehandle)
    I = param.axeshandle == allchild(param.figurehandle);
    I = logical(sum(I));
    if I
      set(0,'CurrentFigure',param.figurehandle);
    else
      disp('Handle of figure ignored due to not matching with handle of axes');
    end
  end
else
  H_Axes = newplot;
end

%%% Set Scale
if ~isempty(param.axis.x)
  set(H_Axes,'XScale',param.axis.x);
end
if ~isempty(param.axis.y)
  set(H_Axes,'YScale',param.axis.y);
end

%%% Setting parameters
if size(Y,2) == 1
  Hplot = plot(X,Y(:,1), 'Parent',H_Axes);
  for n=1:2:N_varg
    switch lower(args{n})
      case param.name.main{1}
        set(Hplot, 'LineWidth', args{n+1});
        param.value.main{1} = args{n+1};
      case param.name.main{2}
        set(Hplot, 'LineStyle', args{n+1});
        param.value.main{2} = args{n+1};
      case param.name.main{3}
        set(Hplot, 'Color', args{n+1});
        param.value.main{3} = args{n+1};
      case [param.name.handles param.name.axis]
      case [param.name.line param.name.patch param.name.marker]
        disp('Some parameters are not read');
      otherwise
        error('Unknown parameter. Please type ''help plot_patch'' for more information')
    end
  end
  Handle = Hplot;
elseif size(Y,2) == 2
  Hpatch = patch('Parent',H_Axes, ...
    'XData', [X(:,1);flipud(X(:,1))], ...
    'YData', [Y(:,1);flipud(Y(:,2))]);
  set(Hpatch, 'EdgeAlpha',0);
  H_hold = get(H_Axes,'NextPlot');
  set(H_Axes,'NextPlot','add');
  Hconf = plot(X, [Y(:,1) Y(:,2)], 'Parent',H_Axes);
  for n=1:2:N_varg
    switch lower(args{n})
      case param.name.line{1}
        set(Hconf(1), 'LineWidth', args{n+1});
        set(Hconf(2), 'LineWidth', args{n+1});
        param.value.line{1} = args{n+1};
      case param.name.line{2}
        set(Hconf(1), 'LineStyle', args{n+1});
        set(Hconf(2), 'LineStyle', args{n+1});
        param.value.line{2} = args{n+1};
      case param.name.line{3}
        set(Hconf(1), 'Color', args{n+1});
        set(Hconf(2), 'Color', args{n+1});
        param.value.line{3} = args{n+1};
      case param.name.patch{1}
        set(Hpatch, 'FaceColor', args{n+1});
        param.value.patch{1} = args{n+1};
      case param.name.patch{2}
        set(Hpatch, 'FaceAlpha', args{n+1});
        param.value.patch{2} = args{n+1};
      case param.name.marker{1}
        set(Hpatch, 'Marker', args{n+1});
        param.value.marker{1} = args{n+1};
      case param.name.marker{2}
        set(Hpatch, 'MarkerSize', args{n+1});
        param.value.marker{2} = args{n+1};
      case param.name.marker{3}
        set(Hpatch, 'MarkerFaceColor', args{n+1});
        param.value.marker{3} = args{n+1};
      case param.name.marker{4}
        set(Hpatch, 'MarkerEdgeColor', args{n+1});
        param.value.marker{4} = args{n+1};
      case [param.name.handles param.name.axis]
      case param.name.main
        disp('Some parameters are not read');
      otherwise
        error('Unknown parameter. Please type ''help plot_patch'' for more information')
    end
  end
  Handle.Confidence = Hconf;
  if param.value.patch{2} == 0
    delete(Hpatch);
  else
      Handle.Patch = Hpatch;
  end
  set(H_Axes, 'NextPlot',H_hold);
else
  Hpatch = patch('Parent', H_Axes, ...
    'XData', [X(:,1);flipud(X(:,1))], ...
    'YData', [Y(:,2);flipud(Y(:,3))]);
  set(Hpatch, 'EdgeAlpha',0);
  H_hold = get(H_Axes,'NextPlot');
  hold(H_Axes,'all');
  Hplot = plot(X,Y(:,1), 'Parent', H_Axes);
  Hconf = plot(X,[Y(:,2) Y(:,3)], 'Parent', H_Axes);
  for n=1:2:N_varg
    switch lower(args{n})
      case param.name.main{1}
        set(Hplot, 'LineWidth', args{n+1});
        param.value.main{1} = args{n+1};
      case param.name.main{2}
        set(Hplot, 'LineStyle', args{n+1});
        param.value.main{2} = args{n+1};
      case param.name.main{3}
        set(Hplot, 'Color', args{n+1});
        param.value.main{3} = args{n+1};
      case param.name.line{1}
        set(Hconf(1), 'LineWidth', args{n+1});
        set(Hconf(2), 'LineWidth', args{n+1});
        param.value.line{1} = args{n+1};
      case param.name.line{2}
        set(Hconf(1), 'LineStyle', args{n+1});
        set(Hconf(2), 'LineStyle', args{n+1});
        param.value.line{2} = args{n+1};
      case param.name.line{3}
        set(Hconf(1), 'Color', args{n+1});
        set(Hconf(2), 'Color', args{n+1});
        param.value.line{3} = args{n+1};
      case param.name.patch{1}
        set(Hpatch, 'FaceColor', args{n+1});
        param.value.patch{1} = args{n+1};
      case param.name.patch{2}
        set(Hpatch, 'FaceAlpha', args{n+1});
        param.value.patch{2} = args{n+1};
      case param.name.marker{1}
        set(Hpatch, 'Marker', args{n+1});
        param.value.marker{1} = args{n+1};
      case param.name.marker{2}
        set(Hpatch, 'MarkerSize', args{n+1});
        param.value.marker{2} = args{n+1};
      case param.name.marker{3}
        set(Hpatch, 'MarkerFaceColor', args{n+1});
        param.value.marker{3} = args{n+1};
      case param.name.marker{4}
        set(Hpatch, 'MarkerEdgeColor', args{n+1});
        param.value.marker{4} = args{n+1};
      case [param.name.handles param.name.axis]
      otherwise
        error('Unknown parameter. Please type ''help plot_patch'' for more information')
    end
  end
  Handle.Confidence = Hconf;
  Handle.Plot = Hplot;
  if param.value.patch{2} == 0
    delete(Hpatch);
  else
      Handle.Patch = Hpatch;
  end
  set(H_Axes, 'NextPlot',H_hold);
end

%%% functions
function X = resize(X, par)
if nargin < 2
  par = 1;
end
if ~isnumeric(par)
  if strcmpi(par,'horizontal')
    par = 2;
  elseif strcmpi(par,'vertical')
    par = 1;
  else
    error('wrong second parameter')
  end
end
if (par == 1)
  if size(X,1) < size(X,2)
    X = X';
  end
else
  if size(X,1) > size(X,2)
    X = X';
  end
end

