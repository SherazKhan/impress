function events=fm_read_events(filename)

addpath /autofs/cluster/transcend/fahimeh/fieldtrip-20130901

ft_defaults();

hdr = ft_read_header(filename);
events=ft_read_event(filename,'header',hdr);