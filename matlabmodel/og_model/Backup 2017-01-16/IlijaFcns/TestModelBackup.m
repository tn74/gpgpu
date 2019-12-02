clear all;close all;clc;

addpath(genpath('D:\SVN repository\DBS\Matlab'));

rng(777);

SetParameters

%TODO: Remove this stuff
% times when these synapses get activated (from their respective brain
% structures). Gets updated during iterations.
t_list_th(1:n) = struct('times',[]);
t_list_cor(1:n) = struct('times',[]);
t_list_str_indr(1:n) = struct('times',[]);
t_list_str_dr(1:n) = struct('times',[]);
t_list_stn(1:n) = struct('times',[]);
t_list_gpe(1:n) = struct('times',[]);
t_list_gpi(1:n) = struct('times',[]);


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
    
    

    
   
 

    
    %GPe cell currents
    Il3=gl(3)*(vge_m1-El(3));
    Ik3=gk(3)*(N3.^4).*(vge_m1-Ek(3));
    Ina3=gna(3)*(m3.^3).*H3.*(vge_m1-Ena(3));
    It3=gt(3)*(a3.^3).*R3.*(vge_m1-Eca(3));
    Ica3=gca(3)*(s3.^2).*(vge_m1-Eca(3));
    Iahp3=gahp(3)*(vge_m1-Ek(3)).*(CA3./(CA3+k1(3)));
    Isngeampa=(gsngea).*((vge_m1-Esyn(2)).*(InpSTNtoGPE_ampa1+InpSTNtoGPE_ampa2)); 
    Isngenmda=(gsngen).*((vge_m1-Esyn(2)).*(InpSTNtoGPE_nmda1+InpSTNtoGPE_nmda2)); % ILIJA: here's where you check what numbers/letters on synapse S mean
    Igege=(0.25*(pd*3+1))*(ggege).*(gsyn(3)*(vge_m1-Esyn(3)).*(InpGPEtoGPE1+InpGPEtoGPE2)); 
    Istrgpe=gstrgpe*(vge_m1-Esyn(6)).*(InpSTRtoGPE1+InpSTRtoGPE2+InpSTRtoGPE3+InpSTRtoGPE4+InpSTRtoGPE5+InpSTRtoGPE6+InpSTRtoGPE7+InpSTRtoGPE8+InpSTRtoGPE9+InpSTRtoGPE10);
    Iappgpe=3;

    

    %Striatum D2 cell currents - indirect STR
    Ina5=gna(4)*(m5.^3).*h5.*(vstr_indr_m1-Ena(4));
    Ik5=gk(4)*(n5.^4).*(vstr_indr_m1-Ek(4));
    Il5=gl(4)*(vstr_indr_m1-El(4));
    Im5=(2.6-1.1*pd)*gm*p5.*(vstr_indr_m1-Em);
    Igaba5=(ggaba/4)*(vstr_indr_m1-Esyn(7)).*(InpIDSTRtoIDSTR1+InpIDSTRtoIDSTR2+InpIDSTRtoIDSTR3+InpIDSTRtoIDSTR4);
    Icorstr5=gcorindrstr*(vstr_indr_m1-Esyn(2)).*(InpRCTXtoSTR);
    
    %Striatum D1 cell currents - Direct STR
    Ina6=gna(4)*(m6.^3).*h6.*(vstr_dr_m1-Ena(4));
    Ik6=gk(4)*(n6.^4).*(vstr_dr_m1-Ek(4));
    Il6=gl(4)*(vstr_dr_m1-El(4));
    Im6=(2.6-1.1*pd)*gm*p6.*(vstr_dr_m1-Em);
    Igaba6=(ggaba/3)*(vstr_dr_m1-Esyn(7)).*(InpDSTRtoDSTR1+InpDSTRtoDSTR2+InpDSTRtoDSTR3);
    Icorstr6=gcordrstr.*(vstr_dr_m1-Esyn(2)).*(InpRCTXtoSTR);
    
    %Excitatory Neuron Currents
    Iie=gie*(ve_m1-Esyn(1)).*(InpICTXtoRCTX1+InpICTXtoRCTX2+InpICTXtoRCTX3+InpICTXtoRCTX4);
    Ithcor=gthcor*(ve_m1-Esyn(2)).*(InpTHtoRCTX);

    
    %Inhibitory Neuron Currents
    Iei=gei*(vi_m1-Esyn(2)).*(InpRCTXtoICTX1+InpRCTXtoICTX2+InpRCTXtoICTX3+InpRCTXtoICTX4);

    %Differential Equations for cells
    
    %STN

    
for j=1:n

%ILIJA CODE
InpsGPi(j,i) = 0;
if (vsn(j,i-1)<-10 && vsn(j,i)>-10) % check for input spike
     t_list_stn(j).times = [t_list_stn(j).times; 1];
     InpsGPi(j,i) = 1;
end   
%ILIJA CODE END
   % Calculate synaptic current due to current and past input spikes
   InpSTNtoGPE_ampa1(j) = sum(syn_func_stn_gpea(t_list_stn(j).times));
   InpSTNtoGPE_nmda1(j) = sum(syn_func_stn_gpen(t_list_stn(j).times));

   InpSTNtoGPI1(j) = sum(syn_func_stn_gpi(t_list_stn(j).times));

   % Update spike times
   if t_list_stn(j).times
     t_list_stn(j).times = t_list_stn(j).times + 1;
     if (t_list_stn(j).times(1) == t_max_con/dt)  % Reached max duration of syn conductance
       t_list_stn(j).times = t_list_stn(j).times((2:max(size(t_list_stn(j).times))));
     end
   end
end
    
    %GPe
    vge(:,i)=vge_m1+dt*(1/Cm*(-Il3-Ik3-Ina3-It3-Ica3-Iahp3-Isngeampa-Isngenmda-Igege-Istrgpe+Iappgpe));
    N3=N3+dt*(0.1*(n3-N3)./tn3);
    H3=H3+dt*(0.05*(h3-H3)./th3);
    R3=R3+dt*(1*(r3-R3)./tr3);
    CA3=CA3+dt*(1*10^-4*(-Ica3-It3-kca(3)*CA3));
for j=1:n

if (vge(j,i-1)<-10 && vge(j,i)>-10) % check for input spike
     t_list_gpe(j).times = [t_list_gpe(j).times; 1];
end   
   % Calculate synaptic current due to current and past input spikes
   InpGPEtoSTN1(j) = sum(syn_func_gpe_stn(t_list_gpe(j).times));
   InpGPEtoGPI1(j) = sum(syn_func_gpe_gpi(t_list_gpe(j).times));
   InpGPEtoGPE(j) = sum(syn_func_gpe_gpe(t_list_gpe(j).times));


   % Update spike times
   if t_list_gpe(j).times
     t_list_gpe(j).times = t_list_gpe(j).times + 1;
     if (t_list_gpe(j).times(1) == t_max_con/dt)  % Reached max duration of syn conductance
       t_list_gpe(j).times = t_list_gpe(j).times((2:max(size(t_list_gpe(j).times))));
     end
   end
end
    
    %GPi % ADDED VARIABLE
    %ILIJA CODE
    VoltValsGPi(1:10,i) = vgi(:,i);
    %ILIJA CODE END

for j=1:n
%ILIJA CODE
OutsGPi(j,i) = 0;
if (vgi(j,i-1)<-10 && vgi(j,i)>-10) % check for input spike
     t_list_gpi(j).times = [t_list_gpi(j).times; 1];
     OutsGPi(j,i) = 1;
end       
%ILIJA CODE END
   % Calculate synaptic current due to current and past input spikes
   InpGPItoTH(j) = sum(syn_func_gpi_th(t_list_gpi(j).times));


   % Update spike times
   if t_list_gpi(j).times
     t_list_gpi(j).times = t_list_gpi(j).times + 1;
     if (t_list_gpi(j).times(1) == t_max_con/dt)  % Reached max duration of syn conductance
       t_list_gpi(j).times = t_list_gpi(j).times((2:max(size(t_list_gpi(j).times))));
     end
   end
end
    
    %Striatum D2
 vstr_indr(:,i)=vstr_indr_m1+(dt/Cm)*(-Ina5-Ik5-Il5-Im5-Igaba5-Icorstr5);
 m5=m5+dt*(alpham(vstr_indr_m1).*(1-m5)-betam(vstr_indr_m1).*m5);
 h5=h5+dt*(alphah(vstr_indr_m1).*(1-h5)-betah(vstr_indr_m1).*h5);
 n5=n5+dt*(alphan(vstr_indr_m1).*(1-n5)-betan(vstr_indr_m1).*n5);
 p5=p5+dt*(alphap(vstr_indr_m1).*(1-p5)-betap(vstr_indr_m1).*p5);
 InpIDSTRtoIDSTR=InpIDSTRtoIDSTR+dt*((Ggaba(vstr_indr_m1).*(1-InpIDSTRtoIDSTR))-(InpIDSTRtoIDSTR/tau_i));

for j=1:n

if (vstr_indr(j,i-1)<-10 && vstr_indr(j,i)>-10) % check for input spike
     t_list_str_indr(j).times = [t_list_str_indr(j).times; 1];
end   
   % Calculate synaptic current due to current and past input spikes
   InpSTRtoGPE1(j) = sum(syn_func_str_indr(t_list_str_indr(j).times));

   % Update spike times
   if t_list_str_indr(j).times
     t_list_str_indr(j).times = t_list_str_indr(j).times + 1;
     if (t_list_str_indr(j).times(1) == t_max_con/dt)  % Reached max duration of syn conductance
       t_list_str_indr(j).times = t_list_str_indr(j).times((2:max(size(t_list_str_indr(j).times))));
     end
   end
end

% %Striatum D1 type
 vstr_dr(:,i)=vstr_dr_m1+(dt/Cm)*(-Ina6-Ik6-Il6-Im6-Igaba6-Icorstr6);
 m6=m6+dt*(alpham(vstr_dr_m1).*(1-m6)-betam(vstr_dr_m1).*m6);
 h6=h6+dt*(alphah(vstr_dr_m1).*(1-h6)-betah(vstr_dr_m1).*h6);
 n6=n6+dt*(alphan(vstr_dr_m1).*(1-n6)-betan(vstr_dr_m1).*n6);
 p6=p6+dt*(alphap(vstr_dr_m1).*(1-p6)-betap(vstr_dr_m1).*p6);
 InpDSTRtoDSTR=InpDSTRtoDSTR+dt*((Ggaba(vstr_dr_m1).*(1-InpDSTRtoDSTR))-(InpDSTRtoDSTR/tau_i));

 
 for j=1:n

if (vstr_dr(j,i-1)<-10 && vstr_dr(j,i)>-10) % check for input spike
     t_list_str_dr(j).times = [t_list_str_dr(j).times; 1];
end   
   % Calculate synaptic current due to current and past input spikes
   InpSTRtoGPI1(j) = sum(syn_func_str_dr(t_list_str_dr(j).times));

   % Update spike times
   if t_list_str_dr(j).times
     t_list_str_dr(j).times = t_list_str_dr(j).times + 1;
     if (t_list_str_dr(j).times(1) == t_max_con/dt)  % Reached max duration of syn conductance
       t_list_str_dr(j).times = t_list_str_dr(j).times((2:max(size(t_list_str_dr(j).times))));
     end
   end
 end

%Excitatory Neuron
    ve(:,i)=ve_m1+dt*((0.04*(ve_m1.^2))+(5*ve_m1)+140-ue(:,i-1)-Iie-Ithcor);
    ue(:,i)=ue(:,i-1)+dt*(ae*((be*ve_m1)-ue(:,i-1)));
    
   for j=1:n
        if ve(j,i-1)>=30
        ve(j,i)=ce;
        ue(j,i)=ue(j,i-1)+de;
        
 t_list_cor(j).times = [t_list_cor(j).times; 1];
        end
   
   % Calculate synaptic current due to current and past input spikes
   InpRCTXtoSTR(j) = sum(syn_func_cor_d2(t_list_cor(j).times));
   InpRCTXtoSTN_ampa1(j) = sum(syn_func_cor_stn_a(t_list_cor(j).times));
   InpRCTXtoSTN_nmda1(j) = sum(syn_func_cor_stn_n(t_list_cor(j).times));

   % Update spike times
   if t_list_cor(j).times
     t_list_cor(j).times = t_list_cor(j).times + 1;
     if (t_list_cor(j).times(1) == t_max_con/dt)  % Reached max duration of syn conductance
       t_list_cor(j).times = t_list_cor(j).times((2:max(size(t_list_cor(j).times))));
     end
   end
   
   end        
    
    ace=find(ve(:,i-1)<-10 & ve(:,i)>-10);
    uce=zeros(n,1); uce(ace)=gpeak/(tau*exp(-1))/dt;
    OutRCTX=OutRCTX+dt*InpRCTXtoRCTX; 
    z1adot=uce-2/tau*InpRCTXtoRCTX-1/(tau^2)*OutRCTX;
    InpRCTXtoRCTX=InpRCTXtoRCTX+dt*z1adot;
    
    %Inhibitory InterNeuron
    vi(:,i)=vi_m1+dt*((0.04*(vi_m1.^2))+(5*vi_m1)+140-ui(:,i-1)-Iei);
    ui(:,i)=ui(:,i-1)+dt*(ai*((bi*vi_m1)-ui(:,i-1)));
    
   for j=1:n
        if vi(j,i-1)>=30
        vi(j,i)=ci;
        ui(j,i)=ui(j,i-1)+di;
        end
   end
        
    
    aci=find(vi(:,i-1)<-10 & vi(:,i)>-10);
    uci=zeros(n,1); uci(aci)=gpeak/(tau*exp(-1))/dt;
    OutICTX=OutICTX+dt*InpICTXtoICTX; 
    z1bdot=uci-2/tau*InpICTXtoICTX-1/(tau^2)*OutICTX;
    InpICTXtoICTX=InpICTXtoICTX+dt*z1bdot;


    end

    
    [TH_APs]  = find_spike_times(vth,t,n);
    [STN_APs] = find_spike_times(vsn,t,n);
    [GPe_APs] = find_spike_times(vge,t,n);
    [GPi_APs] = find_spike_times(vgi,t,n);
    [Striat_APs_indr]=find_spike_times(vstr_indr,t,n);
    [Striat_APs_dr]=find_spike_times(vstr_dr,t,n);
    [Cor_APs] = find_spike_times([ve;vi],t,2*n);