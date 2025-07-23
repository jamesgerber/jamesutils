function [NewLat,NewLong,B]=aggregate_rate_lowmemory(Lat,Long,A,Nsteps,N,aggregationmode,newclass);
%aggregate_rate_lowmemory - call aggregate_rate in small chunks.
%
% [NewLat,NewLong,SmallMatrix]=aggregate_rate_lowmemory(Lat,Long,BigMatrix,Nsteps,N,aggregationmode,newclass);
% 
if nargin<7
    newclass=class(A);
end

if nargin<6
    aggregationmode='kill';
end

Nr=size(A,1);
Nc=size(A,2);

% check Nr/(N*Nsteps) is integer
% check Nc/(N*Nsteps) is integer

iirowsteps=linspace(1,Nr+1,Nsteps+1);
iicolsteps=linspace(1,Nc+1,Nsteps+1);

iirowstepsagg=linspace(1,(Nr/N)+1,Nsteps+1);
iicolstepsagg=linspace(1,(Nc/N)+1,Nsteps+1);


 disp(['breaking up matrix into ' int2str(Nsteps) 'x' int2str(Nsteps)]);
for j=1:numel(iirowsteps)-1;
    
    iirow=iirowsteps(j):(iirowsteps(j+1)-1);
    for k=1:numel(iicolsteps)-1;
        iicol=iicolsteps(k):(iicolsteps(k+1)-1);

        AS(j,k).data=A(iirow,iicol);
        AS(j,k).iirow=iirow;
        AS(j,k).iicol=iicol;
        AS(j,k).Lat=Lat(iirow);
        AS(j,k).Long=Long(iicol);
        
    end
end



clear A

disp(['calling aggregate_rate for each of  ' int2str(Nsteps) 'x' int2str(Nsteps)]);

normalthing=0;
if normalthing==1
    for j=1:numel(iirowsteps)-1;
        for k=1:numel(iicolsteps)-1;
            AS(j,k).agg=aggregate_rate(AS(j,k).data,N,'mode',newclass);
            AS(j,k).aggLong=aggregate_rate(AS(j,k).Long,N);
            AS(j,k).aggLat=aggregate_rate(AS(j,k).Lat,N);
            AS(j,k).data='';
        end
    end
else
    for j=1:numel(iirowsteps)-1;
        for k=1:numel(iicolsteps)-1;
            tmp=single(AS(j,k).data);
            tmp(tmp==255)=nan;
            aggtmp=aggregate_rate(tmp,N,'kill','single');
            AS(j,k).agg=aggtmp;
            AS(j,k).aggLong=aggregate_rate(AS(j,k).Long,N);
            AS(j,k).aggLat=aggregate_rate(AS(j,k).Lat,N);
            AS(j,k).data='';
        end
    end
    
    
end
disp(['reassembling each of  ' int2str(Nsteps) 'x' int2str(Nsteps)]);

B=zeros(Nr/N,Nc/N,newclass);

% now assemble aggregated matrix
for j=1:numel(iirowstepsagg)-1;
    
  iirowagg=iirowstepsagg(j):(iirowstepsagg(j+1)-1);
  NewLat(iirowagg)=AS(j,1).aggLat;
  
    for k=1:numel(iicolstepsagg)-1;
        iicolagg=iicolstepsagg(k):(iicolstepsagg(k+1)-1);
        
        B(iirowagg,iicolagg)=AS(j,k).agg;
        NewLong(iicolagg)=AS(j,k).aggLong;
    end
end
