function ISO=gadmlimitedlist(j)
% gadmlimitedlist - return a list of ISO codes excluding caspian sea, etc
%
% syntax
%   ISO=gadmlimitedlist(j)
%
%   ISOlist=ISO=gadmlimitedlist;
%
%

persistent ISOlist
if isempty(ISOlist)
    g0=getgeo41_g0;
    ISOlistfull=g0.gadm0codes;

    ISOlist=setdiff(ISOlistfull,{'ATA','XCA'});
end


if nargin==1
    ISO=ISOlist{j};
else
    ISO=ISOlist;
end
