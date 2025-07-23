function [MatrixToOrderedRow,MatrixToOrderedRowReduced]=MakeIndexArrays(Nrow,Ncol);
legacy=0;
if legacy==1
    ii=[1:4  (1:4)+Nrow (1:4)+Nrow*2 (1:4)+Nrow*3];
    
    jj=[];
    for j=1:(Nrow/4);
        jj=[jj ii+4*(j-1)];
    end
    
    kk=[];
    for j=1:Ncol/4;
        kk=[kk jj+Nrow*4*(j-1)];
    end
    
    MatrixToOrderedRow=kk;
    
    %%% now small version
    ii=[1:2  (1:2)+Nrow/2];
    
    jj=[];
    for j=1:(Nrow/4);
        jj=[jj ii+2*(j-1)];
    end
    
    kk=[];
    for j=1:Ncol/4;
        kk=[kk jj+Nrow*(j-1)];
    end
    
    MatrixToOrderedRowReduced=kk;
else
    ii=[1:4  (1:4)+Nrow (1:4)+Nrow*2 (1:4)+Nrow*3];
    
    jj=-1*ones(1,Nrow*4);
    for j=1:(Nrow/4);
        jj((1:16)+(j-1)*16)=[ii+4*(j-1)];
    end
    
    kk=-1*ones(1,Nrow*Ncol);
    
    N=length(jj);
    
    for j=1:Ncol/4;
        kk( (1:N)+ (j-1)*N)=jj+Nrow*4*(j-1);
    end
    
    MatrixToOrderedRow=kk;
    
    %%% now small version
    ii=[1:2  (1:2)+Nrow/2];
    
    jj=[];
    for j=1:(Nrow/4);
        jj=[jj ii+2*(j-1)];
    end
    
    kk=-1*ones(1,Nrow*Ncol/4);
    for j=1:Ncol/4;
        kk( (1:length(jj))+ (j-1)*length(jj))=[jj+Nrow*(j-1)];
    end
    
    MatrixToOrderedRowReduced=kk;
end
