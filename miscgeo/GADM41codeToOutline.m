function ii=GADM41codeToOutline(gadmcode);
% GADMcodeToOutline - replace a GADM code with outline, use GADM
%

[g0,g1,g2,g3,g]=getgeo41;

%  don't need persistent - have them in getgeo41

idx=strmatch(gadmcode,g0.gadm0codes,'exact');
if numel(idx)==1

    ii=find(g0.raster0==idx);
    return

else

    idx=strmatch(gadmcode,g1.gadm1codes,'exact');

    if numel(idx)==1
        ii=find(g1.raster1==g1.uniqueadminunitcode(idx));
        return
    else
        idx=strmatch(gadmcode,g2.gadm2codes_with_subscript_1,'exact');
        jdx=strmatch(gadmcode,g2.gadm2codes,'exact');
        if numel(idx)==1
            ii=find(g2.raster2==g2.uniqueadminunitcode(idx));
            return
        elseif numel(jdx)==1
            ii=find(g2.raster2==g2.uniqueadminunitcode(jdx));
            return
        end
            idx=strmatch(gadmcode,g3.gadm3codes,'exact');
            if numel(idx)==1
                ii=find(g3.raster3==g3.uniqueadminunitcode(idx));
            else
                ii=[];
                disp([' no match for ' gadmcode])
            end
        end
    end
end


