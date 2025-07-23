function ii=GADM41codeToOutlineLandmaskFashHashFlail(gadmcode,gadmcodefasthash,AdminLevel);
% GADMcodeToOutline - replace a GADM code with outline, try many options.
%

[g0,g1,g2,g3,g]=getgeo41;


switch AdminLevel
    case 0
        idx=find(gadmcodefasthash==g0.gadm0codesfasthash)  ;

        if isempty(idx)
            idx=strmatch(gadmcode,g0.gadm0codes);
        end
        ii=find(g0.raster0==idx);
        
    case 1
        %    idx=strmatch(gadmcode,g1.gadm1codes,'exact');
        
        idx=find(gadmcodefasthash==g1.gadm1codesfasthash);
        
        if numel(idx)==0
            idx=find(gadmcodefasthash==g1.gadm1codesNoSubscriptfasthash);
        end

        if numel(idx)==0
            idx=strmatch(gadmcode,g1.gadm1codes);
        end
        if numel(idx)==0
            idx=strmatch(strrep(gadmcode,'_2',''),g1.gadm1codesNoSubscript,'exact');
        end
        if numel(idx)==0
            idx=strmatch(strrep(gadmcode,'_1',''),g1.gadm1codesNoSubscript,'exact');
        end
        if numel(idx)==0
            idx=strmatch(strrep(gadmcode,'_2','.'),g1.gadm1codesNoSubscript,'exact');
        end
        if numel(idx)==0
            idx=strmatch(strrep(gadmcode,'_1','.'),g1.gadm1codesNoSubscript,'exact');
        end

        if numel(idx)==0
            disp(['prob for ' gadmcode])
            ii=[];
        else
            ii=find(g1.raster1==g1.uniqueadminunitcode(idx));
        end
    case 2
        


        idx=find(gadmcodefasthash==g2.gadm2codesfasthash);

        if numel(idx)==0
            idx=find(gadmcodefasthash==g2.gadm2codes_with_subscript_1fasthash);
        end
        if numel(idx)==0
            idx=find(gadmcodefasthash==g2.gadm2codes_with_subscript_1fasthash);
            
        end
        
        if numel(idx)==0
            idx=find(gadmcodefasthash==g2.gadm2codes_alldotsfasthash);
        end
        
        if isempty(idx)
            % fuuuck ... keep working.  maybe remove subscripts
            idx=strmatch( strrep(gadmcode,'_2','_1'),g2.gadm2codes_with_subscript_1);
        end

        if isempty(idx)
            % fuuuck ... keep working.  maybe remove subscripts
            idx=strmatch( strrep(gadmcode,'_1','_2'),g2.gadm2codes);
        end
        if isempty(idx)
            disp(['prob for ' gadmcode])
            ii=[];
        else

            ii=find(g2.raster2==g2.uniqueadminunitcode(idx));
        end
    case 3
        
                 idx=find(gadmcodefasthash==g3.gadm3codesfasthash);
        
        if isempty(idx)
            idx=strmatch(gadmcode,g3.gadm3codes,'exact');
        end
        if isempty(idx)
 disp(['prob for ' gadmcode])
            ii=[];
        else
            ii=find(g3.raster3==g3.uniqueadminunitcode(idx));
        end
    otherwise
        error
end


