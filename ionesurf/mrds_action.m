%%  MRDS_action.   This is a script(!) which finds full-size data sets and
%%  makes a reduced-size copy.  (Full-size corresponds to 5m sampling
%%  (Long=4320, Lat=2160)

a=whos;
for j=1:length(a)
    
    %
    if    (a(j).size(1)==4320 &  a(j).size(2)==2160 ) ;
        
        MRDS.newvarname=[a(j).name 'Red'];
        
        % line to check that we aren't overwriting an existing
        % variable
        
        exval=exist(MRDS.newvarname);
        
        if exval==1
            ButtonName=...
                questdlg(['OK to overwrite ' MRDS.newvarname '?'],'Warning','No');
            
            switch ButtonName
                case {'No','Cancel'}
                    proceed=0;
                case {'Yes'}
                    proceed=1;
            end
        else
            proceed=1;
        end
        
        if proceed
            
            MRDS.ii=find(MRDS.Long>=MRDS.MinLong & MRDS.Long <= ...
                MRDS.MaxLong);
            MRDS.jj=find(MRDS.Lat>=MRDS.MinLat & MRDS.Lat <= ...
                MRDS.MaxLat);
            
            eval([MRDS.newvarname '=' a(j).name '(MRDS.ii,MRDS.jj);']);
            LongRed=MRDS.Long(MRDS.ii).';
            LatRed=MRDS.Lat(MRDS.jj).';
        end
        %%   else
        % that variable wasn't a 5minute array.  Now let's see if it's a
        % data structure
        %%     if isequal(a(j).class,'struct')
        % it's a structure
        %%     NewDSName=
        
        
        %     else
        %         try
        %           disp(['  [Long,Lat,Data,Units,TitleStr,NDS]=' ...
        %               'ExtractDataFromStructure(' a(j).name ');']);
        %                     eval(['  [Long,Lat,Data,Units,TitleStr,NDS]=' ...
        %               'ExtractDataFromStructure(' a(j).name ');']);
        %             tmp=size(Data);
        %             if (tmp(1)==4320 &  tmp(2)==2160 )
        %                 disp([a(j).name ' appears to be a 5minute data structure.'])
        %                 disp(['However, haven''t yet written code to reduce structures.'])
        %             end
        %
        %         end
    end
end


