function [Out,debug] = ThalamusReduced(InGPI,Type,dt)
% Description:
%	Simulates thalamus neuron activity
% Inputs:
%	InGPI: boolean activations from GPi neurons
%   t: current time
%   Type: type of the model. 1 = Hodgin-Huxley
% Outputs:
%	Out: boolean activations of this neuron
%rng(666);

    n=10;
    
    persistent vth t_GPI; %system state vth is array of scalars, and timers - For all models!
    if isempty(vth)        
        vth=-62+randn(n,1)*5;  %TH  % normal distribution with mean = -62/-63.8 and SD = 5
        t_GPI = cell(n,1);
    end
    
    persistent H1 R1;
    if isempty(H1)
        H1=th_hinf(vth);     
        R1=th_rinf(vth);     
    end
    
    vth_m1 = vth; %preserve previous value of vth
    
 if sum(InGPI) %if input is triggering, add a timer to the system
     t_GPI = AddTimers(t_GPI,InGPI);
 end
    
 if Type == 1
    %parameters of the model
    gl=0.05;
    El=-70;
    gna=3;
    Ena=50;
    gk=5;
    Ek=-75;
    Et=0;
    gt=5;
    ggith=0.112;
    Esyn=-85;
    Cm=1;
    t_max_con=1000;
    m1=th_minf(vth_m1);
    p1=th_pinf(vth_m1);
    h1=th_hinf(vth_m1);
    th1=th_tauh(vth_m1);
    r1=th_rinf(vth_m1);
    tr1=th_taur(vth_m1);   
    
    %thalamic cell currents
    Il1=gl*(vth_m1-El);
    Ina1=gna*(m1.^3).*H1.*(vth_m1-Ena);
    Ik1=gk*((0.75*(1-H1)).^4).*(vth_m1-Ek);
    It1=(p1.^2).*R1.*(vth_m1-Et)*gt;
    IfromGPi = cellfun(@(x) sum(syn_func_gpi_th(x)),t_GPI); %<-----From inputs
    Igith=ggith*(vth_m1-Esyn).*(IfromGPi); 
    Iappth=1.2;    

    %Update system states
    vth = vth_m1+dt*(1/Cm*(-Il1-Ik1-Ina1-It1-Igith+Iappth));
    H1=H1+dt*((h1-H1)./th1);
    R1=R1+dt*((r1-R1)./tr1);
    
    %Figure out which cells are triggering the outputs
    Out = vth_m1<-10 & vth>-10;
    
    %update timers
    t_GPI = cellfun(@(x) x+dt,t_GPI,'UniformOutput',false);
    t_GPI = CleanUpTimers(t_GPI,t_max_con); %removes timers for non-conducting
    
    debug = vth;

 end

end