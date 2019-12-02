function [Out,OutRCTXtoICTX,debug] = ExcitatoryCTX(InTH1,InICTX1,InICTX2,InICTX3,InICTX4,Type,dt)
% Description:
%	Simulates Excitatory Cortex neural activity
% Inputs:
%	InTH: boolean activations from TH neurons
%   t: current time
%   Type: type of the model. 1 = Hodgin-Huxley
% Outputs:
%	Out: boolean activations of this neuron

    n=10;
    
    persistent ve ue t_TH1; %system state ve is array of scalars, and timers - For all models!
    if isempty(ve)        
        ve=-65*ones(n,1);  %
        ue=0.2*ve;
        t_TH1 = cell(n,1);
    end
    
    persistent InpRCTXtoRCTX OutRCTXtoICTXlocal;
    if isempty(InpRCTXtoRCTX)
        InpRCTXtoRCTX=zeros(n,1);
        OutRCTXtoICTXlocal=zeros(n,1);
    end
        
    ve_m1 = ve; %preserve previous value of ve
    ue_m1 = ue; %preserve previous value of ue
   
 if sum(InTH1) %if input is triggering, add a timer to the system
     t_TH1 = AddTimers(t_TH1,InTH1);
 end
    
 if Type == 1
    %parameters of the model
    gie=0.2;
    Esyn1=-85;
    gthcor=0.15;
    Esyn2=0;
    ae=0.02;
    be=0.2;
    ce=-65;
    de=8;
    gpeak=0.43;
    tau=5;
    t_max_con=1000;
    
    %Excitatory Neuron Currents
    IfromICTX=InICTX1+InICTX2+InICTX3+InICTX4;
    IfromTH = cellfun(@(x) sum(syn_func_th(x)),t_TH1); %<-----From inputs
    Iie=gie*(ve_m1-Esyn1).*(IfromICTX);
    Ithcor=gthcor*(ve_m1-Esyn2).*(IfromTH);

    %Update system states
    ve=ve_m1+dt*((0.04*(ve_m1.^2))+(5*ve_m1)+140-ue_m1-Iie-Ithcor);
    ue=ue_m1+dt*(ae*((be*ve_m1)-ue_m1));
    ve(ve_m1>=30)=ce;
    ue(ve_m1>=30)=ue_m1(ve_m1>=30)+de;
    
    %Figure out which cells are triggering the outputs
    Out = ve_m1>=30;
    
    %additional outputs
    ace=ve_m1<-10 & ve>-10;
    uce=zeros(n,1); uce(ace)=gpeak/(tau*exp(-1))/dt;
    OutRCTXtoICTXlocal=OutRCTXtoICTXlocal+dt*InpRCTXtoRCTX; 
    z1adot=uce-2/tau*InpRCTXtoRCTX-1/(tau^2)*OutRCTXtoICTXlocal;
    InpRCTXtoRCTX=InpRCTXtoRCTX+dt*z1adot;
    OutRCTXtoICTX = OutRCTXtoICTXlocal;
    
    %update timers
    t_TH1 = cellfun(@(x) x+dt,t_TH1,'UniformOutput',false);
    t_TH1 = CleanUpTimers(t_TH1,t_max_con); %removes timers for non-conducting

    debug = ve;
    
 end

end