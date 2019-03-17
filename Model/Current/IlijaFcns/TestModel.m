clear all;close all;clc;

addpath(genpath('D:\SVN repository\DBS\Matlab'));


SetParameters


%All starting values set, starting the simulation

       
    for i=2:length(t)  
        
        vth_m1=vth(:,i-1);   
        vsn_m1=vsn(:,i-1);     
        vge_m1=vge(:,i-1);    
        vgi_m1=vgi(:,i-1);
        vstr_indr_m1=vstr_indr(:,i-1);
        vstr_dr_m1=vstr_dr(:,i-1);
        ve_m1=ve(:,i-1);
        vi_m1=vi(:,i-1);

    % Synapse parameters 
    
    InpSTNtoGPE_ampa2(2:n)=InpSTNtoGPE_ampa1(1:n-1); %ILIJA
    InpSTNtoGPE_ampa2(1)=InpSTNtoGPE_ampa1(n);
    
    InpSTNtoGPE_nmda2(2:n)=InpSTNtoGPE_nmda1(1:n-1);
    InpSTNtoGPE_nmda2(1)=InpSTNtoGPE_nmda1(n);
    
    InpSTNtoGPI2(2:n)=InpSTNtoGPI1(1:n-1);
    InpSTNtoGPI2(1)=InpSTNtoGPI1(n);

    InpGPEtoSTN2(1:n-1)=InpGPEtoSTN1(2:n);
    InpGPEtoSTN2(n)=InpGPEtoSTN1(1);
    
    InpGPEtoGPI2(1:n-1)=InpGPEtoGPI1(2:n);
    InpGPEtoGPI2(n)=InpGPEtoGPI1(1);
    
    InpGPEtoGPE1(1:n-1)=InpGPEtoGPE(2:n);
    InpGPEtoGPE1(n)=InpGPEtoGPE(1);
    
    InpGPEtoGPE2(3:n)=InpGPEtoGPE(1:n-2);
    InpGPEtoGPE2(1:2)=InpGPEtoGPE(n-1:n);
        
    InpGPEtoGPI3(3:n)=InpGPEtoGPI1(1:n-2);
    InpGPEtoGPI3(1:2)=InpGPEtoGPI1(n-1:n);
    
    InpIDSTRtoIDSTR1=InpIDSTRtoIDSTR(all); %no numbers = actual states, values
    InpIDSTRtoIDSTR2=InpIDSTRtoIDSTR(bll);
    InpIDSTRtoIDSTR3=InpIDSTRtoIDSTR(cll);
    InpIDSTRtoIDSTR4=InpIDSTRtoIDSTR(dll);

    InpICTXtoRCTX1=OutICTX(ell);
    InpICTXtoRCTX2=OutICTX(fll);
    InpICTXtoRCTX3=OutICTX(gll);
    InpICTXtoRCTX4=OutICTX(hll);

    InpRCTXtoICTX1=OutRCTX(ill);
    InpRCTXtoICTX2=OutRCTX(jll);
    InpRCTXtoICTX3=OutRCTX(kll);
    InpRCTXtoICTX4=OutRCTX(lll);

    InpDSTRtoDSTR1=InpDSTRtoDSTR(mll);
    InpDSTRtoDSTR2=InpDSTRtoDSTR(nll);
    InpDSTRtoDSTR3=InpDSTRtoDSTR(oll);

    InpSTRtoGPE2(1:n-1)=InpSTRtoGPE1(2:n);
    InpSTRtoGPE2(n)=InpSTRtoGPE1(1);
    InpSTRtoGPE3(1:n-2)=InpSTRtoGPE1(3:n);
    InpSTRtoGPE3(n-1:n)=InpSTRtoGPE1(1:2);
    InpSTRtoGPE4(1:n-3)=InpSTRtoGPE1(4:n);
    InpSTRtoGPE4(n-2:n)=InpSTRtoGPE1(1:3);
    InpSTRtoGPE5(1:n-4)=InpSTRtoGPE1(5:n);
    InpSTRtoGPE5(n-3:n)=InpSTRtoGPE1(1:4);
    InpSTRtoGPE6(1:n-5)=InpSTRtoGPE1(6:n);
    InpSTRtoGPE6(n-4:n)=InpSTRtoGPE1(1:5);
    InpSTRtoGPE7(1:n-6)=InpSTRtoGPE1(7:n);
    InpSTRtoGPE7(n-5:n)=InpSTRtoGPE1(1:6);
    InpSTRtoGPE8(1:n-7)=InpSTRtoGPE1(8:n);
    InpSTRtoGPE8(n-6:n)=InpSTRtoGPE1(1:7);
    InpSTRtoGPE9(1:n-8)=InpSTRtoGPE1(9:n);
    InpSTRtoGPE9(n-7:n)=InpSTRtoGPE1(1:8);
    InpSTRtoGPE10(1:n-9)=InpSTRtoGPE1(10:n);
    InpSTRtoGPE10(n-8:n)=InpSTRtoGPE1(1:9);

    InpRCTXtoSTN_ampa2(1:n-1)=InpRCTXtoSTN_ampa1(2:n);
    InpRCTXtoSTN_ampa2(n)=InpRCTXtoSTN_ampa1(1);
    
    InpRCTXtoSTN_nmda2(1:n-1)=InpRCTXtoSTN_nmda1(2:n);
    InpRCTXtoSTN_nmda2(n)=InpRCTXtoSTN_nmda1(1);
    
    InpSTRtoGPI2(1:n-1)=InpSTRtoGPI1(2:n);
    InpSTRtoGPI2(n)=InpSTRtoGPI1(1);
    InpSTRtoGPI3(1:n-2)=InpSTRtoGPI1(3:n);
    InpSTRtoGPI3(n-1:n)=InpSTRtoGPI1(1:2);
    InpSTRtoGPI4(1:n-3)=InpSTRtoGPI1(4:n);
    InpSTRtoGPI4(n-2:n)=InpSTRtoGPI1(1:3);
    InpSTRtoGPI5(1:n-4)=InpSTRtoGPI1(5:n);
    InpSTRtoGPI5(n-3:n)=InpSTRtoGPI1(1:4);
    InpSTRtoGPI6(1:n-5)=InpSTRtoGPI1(6:n);
    InpSTRtoGPI6(n-4:n)=InpSTRtoGPI1(1:5);
    InpSTRtoGPI7(1:n-6)=InpSTRtoGPI1(7:n);
    InpSTRtoGPI7(n-5:n)=InpSTRtoGPI1(1:6);
    InpSTRtoGPI8(1:n-7)=InpSTRtoGPI1(8:n);
    InpSTRtoGPI8(n-6:n)=InpSTRtoGPI1(1:7);
    InpSTRtoGPI9(1:n-8)=InpSTRtoGPI1(9:n);
    InpSTRtoGPI9(n-7:n)=InpSTRtoGPI1(1:8);
    InpSTRtoGPI10(1:n-9)=InpSTRtoGPI1(10:n);
    InpSTRtoGPI10(n-8:n)=InpSTRtoGPI1(1:9);
    
    m3=gpe_minf(vge_m1);m4=gpe_minf(vgi_m1);
    n3=gpe_ninf(vge_m1);n4=gpe_ninf(vgi_m1);
    h3=gpe_hinf(vge_m1);h4=gpe_hinf(vgi_m1);
    a3=gpe_ainf(vge_m1);a4=gpe_ainf(vgi_m1);
    s3=gpe_sinf(vge_m1);s4=gpe_sinf(vgi_m1);
    r3=gpe_rinf(vge_m1);r4=gpe_rinf(vgi_m1);

    tn3=gpe_taun(vge_m1);tn4=gpe_taun(vgi_m1);
    th3=gpe_tauh(vge_m1);th4=gpe_tauh(vgi_m1);
    tr3=30;tr4=30;
    
    
    

    
    
    
    
    

    
    

    %Differential Equations for cells

   
    
    
    %Inhibitory InterNeuron
   

        
    
    aci=find(vi(:,i-1)<-10 & vi(:,i)>-10);
    uci=zeros(n,1); uci(aci)=gpeak/(tau*exp(-1))/dt;
    OutICTX=OutICTX+dt*InpICTXtoICTX; 
    z1bdot=uci-2/tau*InpICTXtoICTX-1/(tau^2)*OutICTX;
    InpICTXtoICTX=InpICTXtoICTX+dt*z1bdot;


    end