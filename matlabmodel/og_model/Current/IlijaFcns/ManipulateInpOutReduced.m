  %Directs appropriate outputs to appropriate inputs  
    InpSTNtoGPE_ampa2(2:n)=InpSTNtoGPE_ampa1(1:n-1); 
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