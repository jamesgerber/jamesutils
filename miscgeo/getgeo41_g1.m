function [g1,ii,countryname,statename]=getgeo41_g1(ISO);
% getgeo41 get harmonized geo data from GADM4.1
%
%  [g1]=getgeo41_g1;
%  [g1]=getgeo41_g1(ISO); (ISO = a string) returns a subset of g1 with all
%  of the states in ISO
%  [g1,ii,countryname,statename]=getgeo41_g1(ISO);  % this syntax returns a list of
%  all states within ISO
%  [g1,ii,countryname,statename]=getgeo41_g1(m); (m = an integer, 1<=m<=3686) 
% returns a subset of g1 just the mth state (it only makes sense in a loop
% over all states in the world: there's no easy a priori way to know which
% state in which country m corresponds to.


persistent savethings

if isempty(savethings)
    g1=load('/Users/jsgerber/DataProducts/ext/GADM/GADM41/gadm41_level1raster5minVer2.mat');

    g1.raster1lml=g1.raster1(landmasklogical);

    savethings.g1=g1;

else

    g1=savethings.g1;

end

if nargin==0
    % user only wants g1, already in memory, just return
    return
end

if ischar(ISO)
    % original syntax, return a list of all states

    idx=strmatch(ISO,g1.gadm0codes);
    g1=subsetofstructureofvectors(g1,idx);

    if nargout>=2
        if nargin==1
            for m=1:numel(g1.namelist1);
                ii{m}=find(g1.raster1==g1.uniqueadminunitcode(m));
                countryname{m}=g1.countrynames{m};
                statename{m}=g1.namelist1{m};
            end
        else
            error
        end
    end

else
    m=ISO;
    idx=find(g1.uniqueadminunitcode==m);
    ii=find(g1.raster1==idx);

    g1=subsetofstructureofvectors(g1,idx);
    countryname=g1.countrynames{1};
    statename=g1.namelist1{1};
end
