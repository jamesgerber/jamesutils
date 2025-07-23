function ii=GADM41codeToOutlineLandmaskVector(gadmcode,gadmcodefasthash);
% GADMcodeToOutline - replace a GADM code with outline, use GADM
%

[g0,g1,g2,g3,g]=getgeo41;

%idx=strmatch(gadmcode,g0.gadm0codes,'exact');
idx=find(gadmcodefasthash==g0.gadm0codesfasthash)  ;

%


if numel(idx)==1

    ii=find(g0.raster0lml==idx);
    return

else

    %    idx=strmatch(gadmcode,g1.gadm1codes,'exact');

    idx=find(gadmcodefasthash==g1.gadm1codesfasthash);

    if numel(idx)==1
        ii=find(g1.raster1lml==g1.uniqueadminunitcode(idx));
        return
    else

        %    idx=strmatch(gadmcode,g2.gadm2codes_with_subscript_1,'exact');
        idx=find(gadmcodefasthash==g2.gadm2codes_with_subscript_1fasthash);

        if numel(idx)==1
            ii=find(g2.raster2lml==g2.uniqueadminunitcode(idx));
            return
        else


            %      idx=strmatch(gadmcode,g3.gadm3codes,'exact');
            idx=find(gadmcodefasthash==g3.gadm3codesfasthash);

            if numel(idx)==1

                ii=find(g3.raster3lml==g3.uniqueadminunitcode(idx));

            else
                ii=[];

                % let's try removing subscript and calling non-vector
                % version
                if isequal(gadmcode(end-1:end),'_1')
                    gadmcodeNS=[gadmcode(1:end-2) '.'];
                    idx=strmatch(gadmcodeNS,g1.gadm1codesNoSubscript,'exact');

                    if numel(idx)==1
                        ii=find(g1.raster1lml==g1.uniqueadminunitcode(idx));
                        return
                    else
                        disp([' no match for ' gadmcode])

                        ii=[];
                    end
                end
            end
        end
    end
end

