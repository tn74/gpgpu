function [Out,debug] = IndirectStriatum(InRCTX,Type,pd,dt)
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
    
    persistent vstr_indr t_RCTX; %system state vstr_indr is array of scalars, and timers - For all models!
    if isempty(vstr_indr)        
        vstr_indr=-63.8+randn(n,1)*5;  %TH  % normal distribution with mean = -62/-63.8 and SD = 5
        t_RCTX = cell(n,1);
    end
    
    persistent m5 h5 n5 p5 InpIDSTRtoIDSTR pick1 pick2 pick3 pick4;
    if isempty(m5)        
        m5=alpham(vstr_indr)./(alpham(vstr_indr)+betam(vstr_indr));
        h5=alphah(vstr_indr)./(alphah(vstr_indr)+betah(vstr_indr));
        n5=alphan(vstr_indr)./(alphan(vstr_indr)+betan(vstr_indr));
        p5=alphap(vstr_indr)./(alphap(vstr_indr)+betap(vstr_indr));
        InpIDSTRtoIDSTR=zeros(n,1); 
        pick1=randsample(n,n);
        pick2=randsample(n,n);
        pick3=randsample(n,n);
        pick4=randsample(n,n);
    end
    
    vstr_indr_m1 = vstr_indr; %preserve previous value of vstr_indr
   
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
    ggaba=0.1;
    Esyn7=-80;
    gcorindrstr=0.07;
    Esyn2=0;
    Cm=1;
    tau_i=13;
    t_max_con=1000;
    %Striatum D2 cell currents - indirect STR
    Ina5=gna*(m5.^3).*h5.*(vstr_indr_m1-Ena);
    Ik5=gk*(n5.^4).*(vstr_indr_m1-Ek);
    Il5=gl*(vstr_indr_m1-El);
    Im5=(2.6-1.1*pd)*gm*p5.*(vstr_indr_m1-Em);
    IfromidSTR = InpIDSTRtoIDSTR(pick1)+InpIDSTRtoIDSTR(pick2)+InpIDSTRtoIDSTR(pick3)+InpIDSTRtoIDSTR(pick4); %<-----From inputs
    IfromRCTX=cellfun(@(x) sum(syn_func_cor_d2(x)),t_RCTX); %<-----From inputs
    Igaba5=(ggaba/4)*(vstr_indr_m1-Esyn7).*(IfromidSTR);
    Icorstr5=gcorindrstr*(vstr_indr_m1-Esyn2).*(IfromRCTX);

    %Update system states
     vstr_indr=vstr_indr_m1+(dt/Cm)*(-Ina5-Ik5-Il5-Im5-Igaba5-Icorstr5);
     m5=m5+dt*(alpham(vstr_indr_m1).*(1-m5)-betam(vstr_indr_m1).*m5);
     h5=h5+dt*(alphah(vstr_indr_m1).*(1-h5)-betah(vstr_indr_m1).*h5);
     n5=n5+dt*(alphan(vstr_indr_m1).*(1-n5)-betan(vstr_indr_m1).*n5);
     p5=p5+dt*(alphap(vstr_indr_m1).*(1-p5)-betap(vstr_indr_m1).*p5);
     InpIDSTRtoIDSTR=InpIDSTRtoIDSTR+dt*((Ggaba(vstr_indr_m1).*(1-InpIDSTRtoIDSTR))-(InpIDSTRtoIDSTR/tau_i));
    
    %Figure out which cells are triggering the outputs
    Out = vstr_indr_m1<-10 & vstr_indr>-10;
    
    %update timers
    t_RCTX = cellfun(@(x) x+dt,t_RCTX,'UniformOutput',false);
    t_RCTX = CleanUpTimers(t_RCTX,t_max_con); %removes timers for non-conducting

    debug = vstr_indr;
    
 end

end