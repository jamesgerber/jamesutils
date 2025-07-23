function newlims=SmartCAxisLimit(caxis)
% SMARTCAXISLIMIT - adjust coloraxis limits to 'nice' values.
%
% SYNTAX
% newlims=SmartCAxisLimit(caxis) - set newlims to 'nice' approximations of 
% coloraxis limits caxis.
c1=caxis(1);
c2=caxis(2);

if c1*c2 > 0
    disp(['haven''t yet progammed clims on same side of 0'])

    if c2>0
        % both are positive
        newlims=[RoundDown(c1) RoundUp(c2)];
    else
                newlims=[RoundUp(c1) RoundUp(c2)];
    end



else
    
   if c2 < c1
       error
       return
   end
   
   
   newc2= RoundUp(c2);
   newc1= -RoundUp(-c1);
   
   newlims=[newc1 newc2];
   
   
end


function a=RoundUp(x);
% round up x to the nearest 'nice' value

%from 1-2 -> round to next .2 up
%from 2-5 -> round to next 0.5
%from 5-10 -> round to next 1


if x==0
    a=0;
    return;
end

y=log10(x);

n=floor(y);

tmp=x/10^n;


if tmp >1 & tmp <2
    
    b=ceil(tmp*5)/5;
elseif tmp < 5
        b=ceil(tmp*2)/2;
else
    b=ceil(tmp*1)/1;
end

a=b*10^n;

function a=RoundDown(x);
% round up x to the nearest 'nice' value

%from 1-2 -> round to next .2 up
%from 2-5 -> round to next 0.5
%from 5-10 -> round to next 1

y=log10(x);

n=floor(y);

tmp=x/10^n;


if tmp >1 & tmp <2
    
    b=floor(tmp*5)/5;
elseif tmp < 5
        b=floor(tmp*2)/2;
else
    b=floor(tmp*1)/1;
end

a=b*10^n;
