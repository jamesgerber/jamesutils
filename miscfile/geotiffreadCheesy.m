function [a,R]=geotiffreadCheesy(basetif);
% call geotiffread and get some extra information for saving the tif
%
%  Syntax
%    [a,R]=geotiffreadCheesy(filename);
%
%    Syntax used by geotiffwriteCheesy:
%    [info,R]=geotiffreadCheesy{'getinfo'}
%
%  This function calls geotiffread but makes a side call to geotiffinfo,
%  and stores that info in a persistent variable.  geotiffwriteCheesy makes
%  a call to this with the 'getinfo' syntax to recover that information for
%  writing a tif
%
%  See Also:  geotiffwriteCheesy
%
% J Gerber October 2021

persistent Rstore info


switch basetif
    case {'info','geotiffinfo','getinfo'}
        a=info;
R=Rstore;
    otherwise
        [a,R]=geotiffread(basetif);
        info=geotiffinfo(basetif);
        Rstore=R;
end



