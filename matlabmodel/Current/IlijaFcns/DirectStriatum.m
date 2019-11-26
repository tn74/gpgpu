function [Out,debug] = DirectStriatum(InRCTX,Type,pd,dt)
% ATTENTION: For some reason, you are supposed to use reordered inputs (not
% the same that you use for outputs from idSTR
% Description:
%	Simulates GPe neural activity
% Inputs:
%	InRCTX: boolean activations from RCTX neurons
%   pd: Parkinson Disease 1=yes, 0=no
%   dt: sampling period
%   Type: type of the model. 1 = Hodgin-Huxley
% Outputs:
%	Out: boolean activations of these neurons

    n=10;
    
    persistent vstr_dr t_RCTX; %system state vstr_dr is array of scalars, and timers - For all models!
    if isempty(vstr_dr)        
        vstr_dr=-63.8+randn(n,1)*5;  %TH  % normal distribution with mean = -62/-63.8 and SD = 5
        t_RCTX = cell(n,1);
    end
    
    persistent m6 h6 n6 p6 gcordrstr InpDSTRtoDSTR pick1 pick2 pick3 pick4;
    if isempty(m6)        
        m6=alpham(vstr_dr)./(alpham(vstr_dr)+betam(vstr_dr));
        h6=alphah(vstr_dr)./(alphah(vstr_dr)+betah(vstr_dr));
        n6=alphan(vstr_dr)./(alphan(vstr_dr)+betan(vstr_dr));
        p6=alphap(vstr_dr)./(alphap(vstr_dr)+betap(vstr_dr)); 
        gcordrstr=(0.07-0.044*pd)+0.001*rand(n,1);
        InpDSTRtoDSTR=zeros(n,1); 
        pick1=randsample(n,n);
        pick2=randsample(n,n);
        pick3=randsample(n,n);
    end
    
    vstr_dr_m1 = vstr_dr; %preserve previous value of vstr_dr
   
 if sum(InRCTX) %if input is triggering, add a timer to the system
     t_RCTX = AddTimers(t_RCTX,InRCTX);
 end
    
 if Type == 1
    %parameters of the model
    gna=100;
    Ena=50;
    gk=80;
    Ek=-100;
    gl=0.1;
    El=-67;
    gm=1;
    Em=-100;
    Cm=1;
    ggaba=0.1;
    Esyn7=-80;
    Esyn2=0;
    tau_i=13;
    t_max_con=1000;
    %Striatum D1 cell currents - Direct STR
    Ina6=gna*(m6.^3).*h6.*(vstr_dr_m1-Ena);
    Ik6=gk*(n6.^4).*(vstr_dr_m1-Ek);
    Il6=gl*(vstr_dr_m1-El);
    Im6=(2.6-1.1*pd)*gm*p6.*(vstr_dr_m1-Em);
    IfromDSTR=InpDSTRtoDSTR(pick1)+InpDSTRtoDSTR(pick2)+InpDSTRtoDSTR(pick3); %<-----From inputs
    IfromRCTX=cellfun(@(x) sum(syn_func_cor_d2(x)),t_RCTX); %<-----From inputs TODO check with Karthik, why did he keep d2 as a function here too
    Igaba6=(ggaba/3)*(vstr_dr_m1-Esyn7).*(IfromDSTR);
    Icorstr6=gcordrstr.*(vstr_dr_m1-Esyn2).*(IfromRCTX);

    %Update system states
     vstr_dr=vstr_dr_m1+(dt/Cm)*(-Ina6-Ik6-Il6-Im6-Igaba6-Icorstr6);
     m6=m6+dt*(alpham(vstr_dr_m1).*(1-m6)-betam(vstr_dr_m1).*m6);
     h6=h6+dt*(alphah(vstr_dr_m1).*(1-h6)-betah(vstr_dr_m1).*h6);
     n6=n6+dt*(alphan(vstr_dr_m1).*(1-n6)-betan(vstr_dr_m1).*n6);
     p6=p6+dt*(alphap(vstr_dr_m1).*(1-p6)-betap(vstr_dr_m1).*p6);
     InpDSTRtoDSTR=InpDSTRtoDSTR+dt*((Ggaba(vstr_dr_m1).*(1-InpDSTRtoDSTR))-(InpDSTRtoDSTR/tau_i));
    
    %Figure out which cells are triggering the outputs
    Out = vstr_dr_m1<-10 & vstr_dr>-10;
    
    %update timers
    t_RCTX = cellfun(@(x) x+dt,t_RCTX,'UniformOutput',false);
    t_RCTX = CleanUpTimers(t_RCTX,t_max_con); %removes timers for non-conducting

    debug = vstr_dr;
    
 end

end