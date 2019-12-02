function [Out,debug] = SubThalamicNucleusReduced(InGPE1,InGPE2,DBScurrent,Type,dt)
% Description:
%	Simulates thalamus neuron activity
% Inputs:
%	InRCTX1: boolean activations from GPi neurons
%   t: current time
%   Type: type of the model. 1 = Hodgin-Huxley
% Outputs:
%	Out: boolean activations of this neuron

    n=10;
    
    persistent vsn t_GPE1 t_GPE2; %system state vsn is array of scalars, and timers - For all models!
    if isempty(vsn)        
        vsn=-62+randn(n,1)*5;  %TH  % normal distribution with mean = -62/-63.8 and SD = 5
        t_GPE1 = cell(n,1);
        t_GPE2 = cell(n,1);
    end
    
    persistent N2 H2 M2 A2 B2 C2 D2 D1 P2 Q2 R2 CAsn2;
    if isempty(N2)
        N2=stn_ninf(vsn);
        H2=stn_hinf(vsn);
        M2=stn_minf(vsn);
        A2=stn_ainf(vsn);
        B2=stn_binf(vsn);
        C2=stn_cinf(vsn);
        D2=stn_d2inf(vsn);
        D1=stn_d1inf(vsn);
        P2=stn_pinf(vsn);
        Q2=stn_qinf(vsn);
        R2=stn_rinf(vsn);
        CAsn2=0.005*ones(n,1);
    end
    
    vsn_m1 = vsn; %preserve previous value of vsn
   
 if sum(InGPE1) %if input is triggering, add a timer to the system
     t_GPE1 = AddTimers(t_GPE1,InGPE1);
 end
 if sum(InGPE2) %if input is triggering, add a timer to the system
     t_GPE2 = AddTimers(t_GPE2,InGPE2);
 end
    
 if Type == 1
    %parameters of the model
    Kca=2*10^-3;
    Z=2;
    F=96485;
    Cao=2000;
    R=8314;
    T=298;
    alp=1/(Z*F);
    con=(R*T)/(Z*F);
    Ecasn=con*log(Cao./CAsn2);
    gna=49;
    Ena=60;
    gk=57;
    Ek=-90;
    ga=5;
    gL=15;
    gt=5;
    gcak=1;
    gl=0.35;
    El=-60;
    ggesn=0.5;
    Esyn=-85;
    Cm=1;
    t_max_con=1000;
    n2=stn_ninf(vsn_m1);
    m2=stn_minf(vsn_m1);
    h2=stn_hinf(vsn_m1);
    a2=stn_ainf(vsn_m1);
    b2=stn_binf(vsn_m1);
    c2=stn_cinf(vsn_m1);
    d2=stn_d2inf(vsn_m1);
    d1=stn_d1inf(vsn_m1);
    p2=stn_pinf(vsn_m1);
    q2=stn_qinf(vsn_m1);
    r2=stn_rinf(vsn_m1); 
    td2=130;
    tr2=2;
    tn2=stn_taun(vsn_m1);
    tm2=stn_taum(vsn_m1);
    th2=stn_tauh(vsn_m1);
    ta2=stn_taua(vsn_m1);
    tb2=stn_taub(vsn_m1);
    tc2=stn_tauc(vsn_m1);
    td1=stn_taud1(vsn_m1);
    tp2=stn_taup(vsn_m1);
    tq2=stn_tauq(vsn_m1);
    
    %STN cell currents
    Ina2=gna*(M2.^3).*H2.*(vsn_m1-Ena);
    Ik2=gk*(N2.^4).*(vsn_m1-Ek);
    Ia2=ga*(A2.^2).*(B2).*(vsn_m1-Ek);
    IL2=gL*(C2.^2).*(D1).*(D2).*(vsn_m1-Ecasn);
    It2=(gt*(P2.^2).*(Q2).*(vsn_m1-Ecasn));
    Icak2=gcak*(R2.^2).*(vsn_m1-Ek);
    Il2=gl*(vsn_m1-El);
    IfromGPe = cellfun(@(x,y) sum(syn_func_gpe_stn(x))+sum(syn_func_gpe_stn(y)),t_GPE1,t_GPE2); %<-----From inputs
    Igesn=(ggesn*((vsn_m1-Esyn).*(IfromGPe))); 

    %Update system states
    vsn=vsn_m1+dt*(1/Cm*(-Ina2-Ik2-Ia2-IL2-It2-Icak2-Il2-Igesn+DBScurrent));
    N2=N2+dt*((n2-N2)./tn2); 
    H2=H2+dt*((h2-H2)./th2);
    M2=M2+dt*((m2-M2)./tm2); 
    A2=A2+dt*((a2-A2)./ta2);
    B2=B2+dt*((b2-B2)./tb2); 
    C2=C2+dt*((c2-C2)./tc2);
    D2=D2+dt*((d2-D2)./td2); 
    D1=D1+dt*((d1-D1)./td1);
    P2=P2+dt*((p2-P2)./tp2); 
    Q2=Q2+dt*((q2-Q2)./tq2);
    R2=R2+dt*((r2-R2)./tr2);     
    CAsn2=CAsn2+dt*((-alp*(IL2+It2))-(Kca*CAsn2));
    
    %Figure out which cells are triggering the outputs
    Out = vsn_m1<-10 & vsn>-10;
    
    %update timers
    t_GPE1 = cellfun(@(x) x+dt,t_GPE1,'UniformOutput',false);
    t_GPE1 = CleanUpTimers(t_GPE1,t_max_con); %removes timers for non-conducting
    t_GPE2 = cellfun(@(x) x+dt,t_GPE2,'UniformOutput',false);
    t_GPE2 = CleanUpTimers(t_GPE2,t_max_con); %removes timers for non-conducting

    debug = vsn;
    
 end

end