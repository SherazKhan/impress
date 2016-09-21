function [cfg]=take_MMF_correct_sign(ERF1,ERF2,times,cfg)


data1=load(ERF1);
data2=load(ERF2);

MMF=data2.event_data-data1.event_data;

plot_shadederror_color(MMF*cfg.Sign,times,cfg.color);
title([cfg.Title])
xlabel('time')
ylabel(['MMF'])



