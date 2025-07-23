function [jprime,EES]=subplot_mp(m,n,j,Order);
% subplot_mp - reorder subplots
%
%
%  matlab subplots are  populated like this
%
%  1  2  3  4
%  5  6  7  8
%
%
%  This function help to populate them in other orders.
%
%  Option 1:
%
%   2  4  6  8
%   1  3  5  7
%
%  Also, this returns whether or not the subplot is edge-adjacent on the
%  North, South, East, or West edges.
%
%  if Order=-1, no subplot is made (useful for getting the EES structure)
%
%
% for j=1:20;
% [jp,EES]=subplot_mp(5,4,j,1)
% text(.5,.5,num2str(j))
% if EES.N==1
%  title(num2str(j))
% end
% if EES.W==1
%  ylabel(' kt ')
% end
% end

if nargin==0
    help(mfilename)
    return
end

if nargin==3
    Order=0;
end


N=0;
S=0;
E=0;
W=0;
switch Order
    case 0
        % normal order
        h=subplot(m,n,j);
        
        if j<=n
            N=1;
        end
        if j>(n*m-n)
            S=1;
        end
        
        if mod(j,n)==0
            E=1;
        end
        if mod(j,n)==1
            W=1;
        end
            
        jprime=j;

        EES.E=E;
        EES.N=N;
        EES.W=W;
        EES.S=S;
        
    case 1
        
        
        M=m; % number rows in original basis
        N=n; % number cols in original basis
        
        [n m]=ind2sub([N M],j);  % row, col in original basis
        
        mp=N-n+1 % row in new basis
        np=m;  % column in new basis
        
        jprime=sub2ind([M N],np,mp);
        
        
        [jprime,EES]=subplot_mp(N,M,jprime,0);

end



      