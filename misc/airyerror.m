function E=AiryError(tep,t,y)
% AIRYERROR - determine mean square error of data and sine wave model  
%
% SYNTAX
% E=AiryError(tep,t,y) - tep is a vector representing a sine function,
% with format [T, Eta, phase, mean] (mean is optional and defaults to 0), 
% and t and y are vectors defining the data to be tested.
%
%  Called by BestAiryFit.m

T=tep(1);
eta=tep(2);
phase=tep(3);

if length(tep)==3
    xmean=0;
else
    xmean=tep(4);
end

ynum=xmean+eta*cos(t*2*pi/T+phase);

E=sum((y-ynum).^2)/sum(y.^2);
