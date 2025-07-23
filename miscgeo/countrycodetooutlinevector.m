function [outline, indices] = CountryCodetoOutline(countrycode)

% CountryCodetoOutline.m
%
% Syntax: [outline, indices] = CountryCodetoOutline(countrycode);
%         [outline, indices] = CountryCodetoOutline({countrycode1,...
%         countrycode2,countrycode3});
%    where countrycode is:
%    - a SAGE 3-letter country code OR
%    - a SAGE 5-letter/number code for a state-level political unit OR
%    - a SAGE 8-letter/number code for a county-level political unit OR
%    - a cell array of country codes (each a string)
%
% Returns a logical 5 min x 5 min array with 1s for the country of
% interest (outline). Will also return indices if two output arguments are
% requested.
%
% Examples:
%    [outline] = CountryCodetoOutline('USA');
%    [outline] = CountryCodetoOutline('USA01');
%    [outline, ii] = CountryCodetoOutline('CAN');
%
% ***IMPORTANT NOTES***: The first time this code is run, you will have to
% build a .mat file of hash tables using raw AdminBoundary info. This will
% likely take ~20 minutes(!). You may also need to change the Java Heap
% Space for Matlab to 256 MB, else Matlab may not be able to save the hash
% tables. To see how to increase Java memory, see this MathWorks tutorial:
% http://www.mathworks.com/support/solutions/en/data/1-18I2C/
%
% Written by Nathan Mueller (~7.8.2010)
%  - modified 1.20.2011 to use AdminUnits2010 revised data (fixes
%  problem in Brazil of missing area not in a SN unit & fixes messed up
%  Canadian county-level units). This will save a new hashtable in misc
%  file - you can delete the old one if you want.
%  - modified 4.27.2011 to make outline a logical and to allow use of cell
%  arrays of countrycodes / SAGEcodes.
%
% see also: StandardCountryNames.m ContinentOutline.m

if nargin==0;
    help(mfilename);
    return;
end

if iscell(countrycode)
    compositeoutline = zeros(4320,2160);
    compositeii = [];
    for c = 1:length(countrycode)
        tmp = countrycode{c};
        [outline,ii] = CountryCodetoOutline(tmp);
        compositeoutline(ii) = 1;
        compositeii = [compositeii; ii];
    end
    outline = compositeoutline;
    indices = compositeii;
end

persistent snu_htable state_htable ctry_htable ctry_outlines ctry_outlines_vector lmlindices

if isstr(countrycode)
    % check to see if the 'state_htable' hash table exists in memory
    if isempty(snu_htable);
        
        % if the hash table doesn't exist, try to load it from misc folder
        ht_path = [iddstring '/misc/admin_hashtable2010.mat'];
        if exist(ht_path) == 2
            eval(['load ' ht_path]);
            ctry_outlines=single(ctry_outlines);
            ctry_outlines_vector=ctry_outlines(landmasklogical);
            lmlindices=find(landmasklogical);

            % if it doesn't exist in the folder, construct the hash table using
            % AdminBoundary data
        else
            
            path = [iddstring 'AdminBoundary2010/Raster_NetCDF/' ...
                '3_M3lcover_5min/admincodes.csv'];
            admincodes = ReadGenericCSV(path);
            
            % build list of 5-letter/number codes for state-level entries and a
            % list of 3-letter/number codes for country-level entries
            for c = 1:length(admincodes.SAGE_ADMIN)
                code = admincodes.SAGE_ADMIN{c};
                admincodes.SAGE_STATE{c} = code(1:5);
                admincodes.SAGE_COUNTRY{c} = code(1:3);
            end
            
            countrycodes = unique(admincodes.SAGE_COUNTRY);
            statecodes = unique(admincodes.SAGE_STATE);
            sagecodes = unique(admincodes.SAGE_ADMIN);
            
            
            path = [iddstring 'AdminBoundary2010/Raster_NetCDF/' ...
                '3_M3lcover_5min/admin_5min_r2.nc'];
            [DS] = OpenNetCDF(path);
            AdminGrid = DS.Data;
            
            % Create hash table for AdminBoundary codes - this cuts down on the
            % look-up time for creating logical arrays of country outlines.
            disp('Creating hash table for SAGE_ADMIN codes and values in 5 min grid')
            pb_htable = java.util.Properties;
            for n = 1:length(admincodes.SAGE_ADMIN)
                pb_htable.put(admincodes.SAGE_ADMIN{n},admincodes.Value_in_5min_bdry_file(n));
            end
            
            disp('Creating hash table for SAGE_ADMIN codes and map indices')
            
            snu_htable = java.util.Properties;
            
            for c = 1:length(sagecodes);
                sagecode = sagecodes{c};
                disp(sagecode);
                gridno = pb_htable.get(sagecode);
                ii = find(AdminGrid == gridno);
                if ~isempty(ii)
                    snu_htable.put(sagecode,ii);
                end
            end
            
            disp(['Creating hash table for SAGE_STATE codes ' ...
                'and SAGE_ADMIN codes'])
            
            state_htable = java.util.Properties;
            
            for c = 1:length(statecodes);
                statecode = statecodes{c};
                disp(statecode);
                staterows = strmatch(statecode, admincodes.SAGE_STATE);
                sagecodes = admincodes.SAGE_ADMIN(staterows);
                state_htable.put(statecode,sagecodes);
            end
            
            disp('Creating outlines and hash table for SAGE_COUNTRY codes')
            
            ctry_outlines = zeros(4320,2160);
            ctry_htable = java.util.Properties;
            for c = 1:length(countrycodes);
                ccode = countrycodes{c};
                disp(ccode);
                countryrows = strmatch(ccode, admincodes.SAGE_COUNTRY);
                ac = admincodes.SAGE_ADMIN(countryrows);
                for n = 1:length(ac)
                    code = ac{n};
                    gridno = pb_htable.get(code);
                    ii = find(AdminGrid == gridno);
                    if ~isempty(ii)
                        ctry_outlines(ii) = c;
                    end
                end
                ctry_htable.put(ccode,c);
            end
            
            savepath = ['save ' iddstring '/misc/admin_hashtable2010.mat '...
                'snu_htable state_htable ctry_htable ctry_outlines'];
            eval(savepath);
            
        end
    end
    
    % build outlines; procedure depends on whether you are asking for a
    % country, state, or county-level political unit
    if length(countrycode) == 3;
        
        c = ctry_htable.get(countrycode);
        indices = (ctry_outlines_vector == c);
        outline = logical(zeros(4320,2160));
        outline(lmlindices(indices)) = 1;
        
    elseif length(countrycode) == 5;
        outline = logical(zeros(4320,2160));
        sagecodes = state_htable.get(countrycode);
        indices = [];
        for c = 1:length(sagecodes);
            sc = sagecodes(c);
            ii = snu_htable.get(sc);
            indices = [indices; ii];
        end
        outline(indices) = 1;
        
    elseif length(countrycode == 8);
        
        outline = logical(zeros(4320,2160));
        indices = snu_htable.get(countrycode);
        outline(indices) = 1;
        
    else
        
        warning('invalid SAGE code');
        
    end
end

%outline = logical(outline);