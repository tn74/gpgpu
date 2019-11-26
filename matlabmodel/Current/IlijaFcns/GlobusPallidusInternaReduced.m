function [Out,debug] = GlobusPallidusInternaReduced(InSTN1,InSTN2,InGPE1,InGPE2,Type,dt)
% ATTENTION: For some reason, you are supposed to use GPEtoGPI2 and
% GPEtoGPI3 as acutal inputs for this thing!
% Description:
%	Simulates GPi neural activity
% Inputs:
%	InSTNx: boolean activations from GPi neurons
%	InGPEx: boolean activations from GPi neurons
%	InSTRx: boolean activations from GPi neurons
%   dt: sampling period
%   Type: type of the model. 1 = Hodgin-Huxley
% Outputs:
%	Out: boolean activations of this neuron

    n=10;
    
    persistent vgi t_STN1 t_STN2 t_GPE1 t_GPE2; %system state vgi is array of scalars, and timers - For all models!
    if isempty(vgi)        
        vgi=-62+randn(n,1)*5;  %TH  % normal distribution with mean = -62/-63.8 and SD = 5
        t_STN1 = cell(n,1);
        t_STN2 = cell(n,1);
        t_GPE1 = cell(n,1);
        t_GPE2 = cell(n,1);
    end
    
    persistent N4 H4 R4 CA4 gsngi;
    if isempty(N4)
       N4=gpe_ninf(vgi);
       H4=gpe_hinf(vgi);
       R4=gpe_rinf(vgi);
       CA4=0.1;
       gsngi=zeros(n,1);
       gsngi(randperm(10,5)')=0.15;
    end
    
    vgi_m1 = vgi; %preserve previous value of vgi
   
 if sum(InSTN1) %if input is triggering, add a timer to the system
     t_STN1 = AddTimers(t_STN1,InSTN1);
 end
 if sum(InSTN2) %if input is triggering, add a timer to the system
     t_STN2 = AddTimers(t_STN2,InSTN2);
 end
 if sum(InGPE1) %if input is triggering, add a timer to the system
     t_GPE1 = AddTimers(t_GPE1,InGPE1);
 end
 if sum(InGPE2) %if input is triggering, add a timer to the system
     t_GPE2 = AddTimers(t_GPE2,InGPE2);
 end
    
 if Type == 1
    %parameters of the model
    gl=0.1;
    El=-65;
    gk=30;
    Ek=-80;
    gna=120;
    Ena=55;
    gt=0.5;
    Eca=120;
    gca=0.15;
    gahp=10;
    k1=10;
    Esyn4=0;
    Esyn5=-85;
    ggigi=0.5;
    Cm=1;
    tr4=30;
    kca=15;
    t_max_con=1000;
    m4=gpe_minf(vgi_m1);
    n4=gpe_ninf(vgi_m1);
    h4=gpe_hinf(vgi_m1);
    a4=gpe_ainf(vgi_m1);
    s4=gpe_sinf(vgi_m1);
    r4=gpe_rinf(vgi_m1);
    tn4=gpe_taun(vgi_m1);
    th4=gpe_tauh(vgi_m1);
    
    %GPi cell currents
    Il4=gl*(vgi_m1-El);
    Ik4=gk*(N4.^4).*(vgi_m1-Ek);
    Ina4=gna*(m4.^3).*H4.*(vgi_m1-Ena);
    It4=gt*(a4.^3).*R4.*(vgi_m1-Eca);
    Ica4=gca*(s4.^2).*(vgi_m1-Eca);
    Iahp4=gahp*(vgi_m1-Ek).*(CA4./(CA4+k1));
    IfromSTN = cellfun(@(x,y) sum(syn_func_stn_gpi(x))+sum(syn_func_stn_gpi(y)),t_STN1,t_STN2); %<-----From inputs
    IfromGPE = cellfun(@(x,y) sum(syn_func_gpe_gpi(x))+sum(syn_func_gpe_gpi(y)),t_GPE1,t_GPE2); %<-----From inputs
    Isngi=(gsngi).*((vgi_m1-Esyn4).*(IfromSTN));
    Igigi=ggigi*((vgi_m1-Esyn5).*(IfromGPE)); 
    Iappgpi=3;

    %Update system states
    vgi=vgi_m1+dt*(1/Cm*(-Il4-Ik4-Ina4-It4-Ica4-Iahp4-Isngi-Igigi+Iappgpi));
    N4=N4+dt*(0.1*(n4-N4)./tn4);
    H4=H4+dt*(0.05*(h4-H4)./th4);
    R4=R4+dt*(1*(r4-R4)./tr4);
    CA4=CA4+dt*(1*10^-4*(-Ica4-It4-kca*CA4));
    
    %Figure out which cells are triggering the outputs
    Out = vgi_m1<-10 & vgi>-10;
    
    %update timers
    t_STN1 = cellfun(@(x) x+dt,t_STN1,'UniformOutput',false);
    t_STN1 = CleanUpTimers(t_STN1,t_max_con); %removes timers for non-conducting
    t_STN2 = cellfun(@(x) x+dt,t_STN2,'UniformOutput',false);
    t_STN2 = CleanUpTimers(t_STN2,t_max_con); %removes timers for non-conducting    
    t_GPE1 = cellfun(@(x) x+dt,t_GPE1,'UniformOutput',false);
    t_GPE1 = CleanUpTimers(t_GPE1,t_max_con); %removes timers for non-conducting
    t_GPE2 = cellfun(@(x) x+dt,t_GPE2,'UniformOutput',false);
    t_GPE2 = CleanUpTimers(t_GPE2,t_max_con); %removes timers for non-conducting

    debug = vgi;
    
 end

end