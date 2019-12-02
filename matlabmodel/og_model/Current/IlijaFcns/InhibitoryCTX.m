function [OutICTXtoRCTX,debug] = InhibitoryCTX(InRCTX1,InRCTX2,InRCTX3,InRCTX4,Type,dt)
% Description:
%	Simulates Inhibitory Cortex neural activity
% Inputs:
%   t: current time
%   Type: type of the model. 1 = Hodgin-Huxley
% Outputs:
%	Out: boolean activations of this neuron

    n=10;
    
    persistent vi ui; %system state vi is array of scalars, and timers - For all models!
    if isempty(vi)        
        vi=-65*ones(n,1);  %
        ui=0.2*vi;
    end
    
    persistent InpICTXtoICTX OutICTXtoRCTXlocal;
    if isempty(InpICTXtoICTX)
        InpICTXtoICTX=zeros(n,1);
        OutICTXtoRCTXlocal=zeros(n,1);
    end
        
    vi_m1 = vi; %preserve previous value of vi
    ui_m1 = ui; %preserve previous value of ui
   
    
 if Type == 1
    %parameters of the model
    gei=0.1;
    Esyn2=0;
    ai=0.1;
    bi=0.2;
    ci=-65;
    di=2;
    gpeak=0.43;
    tau=5;
    
    %Inhibitory Neuron Currents
    IfromRCTX = InRCTX1 + InRCTX2 + InRCTX3 + InRCTX4;
    Iei=gei*(vi_m1-Esyn2).*(IfromRCTX);

    %Update system states
    vi=vi_m1+dt*((0.04*(vi_m1.^2))+(5*vi_m1)+140-ui_m1-Iei);
    ui=ui_m1+dt*(ai*((bi*vi_m1)-ui_m1));
    vi(vi_m1>=30)=ci;
    ui(vi_m1>=30)=ui_m1(vi_m1>=30)+di;
    
    %Figure out which cells are triggering the outputs
    
    %additional outputs
    aci=vi_m1<-10 & vi>-10;
    uci=zeros(n,1); uci(aci)=gpeak/(tau*exp(-1))/dt;
    OutICTXtoRCTXlocal=OutICTXtoRCTXlocal+dt*InpICTXtoICTX; 
    z1bdot=uci-2/tau*InpICTXtoICTX-1/(tau^2)*OutICTXtoRCTXlocal;
    InpICTXtoICTX=InpICTXtoICTX+dt*z1bdot;
    OutICTXtoRCTX=OutICTXtoRCTXlocal;    
    
    %update timers

    debug = vi;
    
 end

end