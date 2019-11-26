clear all;close all;clc;
%addpath(genpath('D:\DukeRepo\DBS\Matlab'));
addpath(genpath('D:\SVN repository\DBS\Matlab'));
%load('THInputs');
d = [];
for i = 1:1:10001%0->0.01->100
%[outs,deb] = NeuronThalamus(InpsTH(:,i),1,0.01); %zeros(10,1)   
%[outs,deb] = NeuronThalamus(~mod(i,3)*ones(10,1),1,0.01); %zeros(10,1)
%[outs,deb] = SubThalamicNucleus(~mod(i,30)*ones(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),1,0.01);
%[outs,deb] = GlobusPallidusInterna(zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),1,0.01);
%[outs,deb] = GlobusPallidusExterna(zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),1,1,0.01);
%[outs,deb] = IndirectStriatum(zeros(10,1),1,1,0.01);
%[outs,deb] = DirectStriatum(zeros(10,1),1,1,0.01);
%[outs,outs2,deb] = ExcitatoryCTX(zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),1,0.01);
[outs,deb] = InhibitoryCTX(zeros(10,1),zeros(10,1),zeros(10,1),zeros(10,1),1,0.01);
d = [d deb];
end