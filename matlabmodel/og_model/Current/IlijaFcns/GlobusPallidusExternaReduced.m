function [Out,debug] = GlobusPallidusExternaReduced(InSTN11,InSTN12,InSTN21,InSTN22,InGPE1,InGPE2,Type,pd,dt)
% Description:
%	Simulates GPe neural activity
% Inputs:
%	InSTN1x: boolean activations from STN ampa neurons
%	InSTN2x: boolean activations from STN nmda neurons
%	InGPEx: boolean activations from GPe neurons
%	InidSTRx: boolean activations from idSTR neurons
%   pd: Parkinson Disease 1=yes, 0=no
%   dt: sampling period
%   Type: type of the model. 1 = Hodgin-Huxley
% Outputs:
%	Out: boolean activations of these neurons

    n=10;
    
    persistent vge t_STN11 t_STN12 t_STN21 t_STN22 t_GPE1 t_GPE2; %system state vge is array of scalars, and timers - For all models!
    if isempty(vge)        
        vge=-62+randn(n,1)*5;  %TH  % normal distribution with mean = -62/-63.8 and SD = 5
        t_STN11 = cell(n,1);
        t_STN12 = cell(n,1);
        t_STN21 = cell(n,1);
        t_STN22 = cell(n,1);
        t_GPE1 = cell(n,1);
        t_GPE2 = cell(n,1);
    end
    
    persistent N3 H3 R3 CA3 gsngea gsngen ggege;
    if isempty(N3)
        N3=gpe_ninf(vge);
        H3=gpe_hinf(vge);
        R3=gpe_rinf(vge);
        CA3=0.1; 
        gsngea=zeros(n,1);
        gsngea(randperm(10,2)')=0.3*rand(2,1);
        gsngen=zeros(n,1);
        gsngen(randperm(10,2)')=0.002*rand(2,1);
        ggege=1*rand(n,1);
    end
    
    vge_m1 = vge; %preserve previous value of vge
   
 if sum(InSTN11) %if input is triggering, add a timer to the system AMPA
     t_STN11 = AddTimers(t_STN11,InSTN11);
 end
 if sum(InSTN12) %if input is triggering, add a timer to the system AMPA
     t_STN12 = AddTimers(t_STN12,InSTN12);
 end
 if sum(InSTN21) %if input is triggering, add a timer to the system AMPA
     t_STN21 = AddTimers(t_STN21,InSTN21);
 end
 if sum(InSTN22) %if input is triggering, add a timer to the system AMPA
     t_STN22 = AddTimers(t_STN22,InSTN22);
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
    k1=10;
    tr3=30;
    Eca=120;
    gca=0.15;
    gahp=10;
    Esyn2=0;
    gsyn=1;
    Esyn3=-85;
    Cm=1;
    kca=15;
    t_max_con=1000;
    m3=gpe_minf(vge_m1);
    n3=gpe_ninf(vge_m1);
    h3=gpe_hinf(vge_m1);
    a3=gpe_ainf(vge_m1);
    s3=gpe_sinf(vge_m1);
    r3=gpe_rinf(vge_m1);
    tn3=gpe_taun(vge_m1);
    th3=gpe_tauh(vge_m1);
    
    %GPe cell currents
    Il3=gl*(vge_m1-El);
    Ik3=gk*(N3.^4).*(vge_m1-Ek);
    Ina3=gna*(m3.^3).*H3.*(vge_m1-Ena);
    It3=gt*(a3.^3).*R3.*(vge_m1-Eca);
    Ica3=gca*(s3.^2).*(vge_m1-Eca);
    Iahp3=gahp*(vge_m1-Ek).*(CA3./(CA3+k1));
    IfromSTN1 = cellfun(@(x,y) sum(syn_func_stn_gpea(x))+sum(syn_func_stn_gpea(y)),t_STN11,t_STN12); %<-----From inputs
    IfromSTN2 = cellfun(@(x,y) sum(syn_func_stn_gpen(x))+sum(syn_func_stn_gpen(y)),t_STN21,t_STN22); %<-----From inputs
    IfromGPE = cellfun(@(x,y) sum(syn_func_gpe_gpe(x))+sum(syn_func_gpe_gpe(y)),t_GPE1,t_GPE2); %<-----From inputs
    Isngeampa=(gsngea).*((vge_m1-Esyn2).*(IfromSTN1)); 
    Isngenmda=(gsngen).*((vge_m1-Esyn2).*(IfromSTN2)); % ILIJA: here's where you check what numbers/letters on synapse S mean
    Igege=(0.25*(pd*3+1))*(ggege).*(gsyn*(vge_m1-Esyn3).*(IfromGPE)); 
    Iappgpe=3;

    %Update system states
    vge=vge_m1+dt*(1/Cm*(-Il3-Ik3-Ina3-It3-Ica3-Iahp3-Isngeampa-Isngenmda-Igege+Iappgpe));
    N3=N3+dt*(0.1*(n3-N3)./tn3);
    H3=H3+dt*(0.05*(h3-H3)./th3);
    R3=R3+dt*(1*(r3-R3)./tr3);
    CA3=CA3+dt*(1*10^-4*(-Ica3-It3-kca*CA3));
    
    %Figure out which cells are triggering the outputs
    Out = vge_m1<-10 & vge>-10;
    
    %update timers
    t_STN11 = cellfun(@(x) x+dt,t_STN11,'UniformOutput',false);
    t_STN11 = CleanUpTimers(t_STN11,t_max_con); %removes timers for non-conducting
    t_STN12 = cellfun(@(x) x+dt,t_STN12,'UniformOutput',false);
    t_STN12 = CleanUpTimers(t_STN12,t_max_con); %removes timers for non-conducting  
    t_STN21 = cellfun(@(x) x+dt,t_STN21,'UniformOutput',false);
    t_STN21 = CleanUpTimers(t_STN21,t_max_con); %removes timers for non-conducting
    t_STN22 = cellfun(@(x) x+dt,t_STN22,'UniformOutput',false);
    t_STN22 = CleanUpTimers(t_STN22,t_max_con); %removes timers for non-conducting  
    t_GPE1 = cellfun(@(x) x+dt,t_GPE1,'UniformOutput',false);
    t_GPE1 = CleanUpTimers(t_GPE1,t_max_con); %removes timers for non-conducting
    t_GPE2 = cellfun(@(x) x+dt,t_GPE2,'UniformOutput',false);
    t_GPE2 = CleanUpTimers(t_GPE2,t_max_con); %removes timers for non-conducting

    debug = vge;
    
 end

end