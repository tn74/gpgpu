function Serr=specerr(S,J,err,trialave,numsp)

% Description:
%   Not sure. Calculates some kind of error for multitaper spectrum.
% inputs:
%   S: mean(conj(J).*J,2) with all singleton dimensions removed
%   J: Actual multitaper spectrum for all channels
%   err: Spectrum estimation error
%   trialave: Average of the trials
%   numsp: Number of points for which (dtmp>=min(t)&dtmp<=max(t)) holds
% outputs:
%   Serr: (?)
 
if nargin < 4; error('Need at least 4 input arguments'); end;
if err(1)==0; error('Need err=[1 p] or [2 p] for error bar calculation. Make sure you are not asking for the output of Serr'); end;
[nf,K,C]=size(J);
errchk=err(1);
p=err(2);
pp=1-p/2;
qq=1-pp;

if trialave
   dim=K*C;
   C=1;
   dof=2*dim;
   if nargin==5; dof = fix(1/(1/dof + 1/(2*sum(numsp)))); end
   J=reshape(J,nf,dim);
else
   dim=K;
   dof=2*dim*ones(1,C);
   for ch=1:C;
     if nargin==5; dof(ch) = fix(1/(1/dof + 1/(2*numsp(ch)))); end 
   end;
end;
Serr=zeros(2,nf,C);
if errchk==1;
   Qp=chi2inv(pp,dof);
   Qq=chi2inv(qq,dof);
   Serr(1,:,:)=dof(ones(nf,1),:).*S./Qp(ones(nf,1),:);
   Serr(2,:,:)=dof(ones(nf,1),:).*S./Qq(ones(nf,1),:);
elseif errchk==2;
   tcrit=tinv(pp,dim-1);
   for k=1:dim;
       indices=setdiff(1:dim,k);
       Jjk=J(:,indices,:); % 1-drop projection
       eJjk=squeeze(sum(Jjk.*conj(Jjk),2));
       Sjk(k,:,:)=eJjk/(dim-1); % 1-drop spectrum
   end;
   sigma=sqrt(dim-1)*squeeze(std(log(Sjk),1,1)); if C==1; sigma=sigma'; end; 
   conf=repmat(tcrit,nf,C).*sigma;
   conf=squeeze(conf); 
   Serr(1,:,:)=S.*exp(-conf); Serr(2,:,:)=S.*exp(conf);
end;
Serr=squeeze(Serr);
end