function OutputList=continent(InputList)
% Continent - return a list of countries in each continent
%
%  SYNTAX
%     continent(names) - where names is a single string or a cell array of
%     strings, return the list of countries in each specified continent or
%     the continent containing the specified country.
%
%  EXAMPLES
%     continent('Europe')
%
%     continent('France')
%
%     continent({'northamerica','southamerica'})
%
%   See Also:  ContinentOutline
%
%%http://www.worldatlas.com/cntycont.htm
if nargin==0
    help(mfilename)
    return
end

if iscell(InputList)
  for j=1:length(InputList);
    OutputList{j}=continent(InputList{j});
  end
  return
end

if iscell(InputList)
    Input=InputList{1};
else
    Input=InputList;
end


switch lower(Input)
    case 'africa';
        OutputList=AfricaList;
    case {'north','northamerica'}
        OutputList=NorthAmericaList;
    case {'south','southamerica'}
        OutputList=SouthAmericaList;
    case {'oceana'}
        OutputList=OceanaList;
    case {'asia'}
        OutputList=AsiaList;
    case {'europe'}
        OutputList=EuropeList;
    otherwise
        %%
        %is this country in Africa?
        CountryList=AfricaList;
        j= strmatch(lower(Input),lower(CountryList));
        if ~isempty(j)
            
            if length(j)>1
                error('ambiguous country definition')
            else
                OutputList='Africa';
            end
        end
        
        %% Is this country in Europe?
        CountryList=EuropeList;
        j= strmatch(lower(Input),lower(CountryList));
        if ~isempty(j)
            
            if length(j)>1
                error('ambiguous country definition')
            else
                OutputList='Europe';
            end
        end
        
        %% 
        CountryList=NorthAmericaList;
        j= strmatch(lower(Input),lower(CountryList));
        if ~isempty(j)
            
            if length(j)>1
                error('ambiguous country definition')
            else
                OutputList='North America';
            end
        end
        
             %% 
        CountryList=SouthAmericaList;
        j= strmatch(lower(Input),lower(CountryList));
        if ~isempty(j)
            
            if length(j)>1
                error('ambiguous country definition')
            else
                OutputList='South America';
            end
        end
            
        
             %% 
        CountryList=AsiaList;
        j= strmatch(lower(Input),lower(CountryList));
        if ~isempty(j)
            
            if length(j)>1
                error('ambiguous country definition')
            else
                OutputList='Asia';
            end
        end
        
        %%
                CountryList=OceanaList;
        j= strmatch(lower(Input),lower(CountryList));
        if ~isempty(j)
            
            if length(j)>1
                error('ambiguous country definition')
            else
                OutputList='Oceana';
            end
        end
        
        if ~exist('OutputList')
            OutputList='Did not recognize';
        end
        
  %called with a single country.
end



%%% Continents

function  OutputList=AfricaList;
OutputList= ...
{'Algeria',
'Angola ',
'Benin ',
'Botswana ',
'Burkina ',
'Burundi ',
'Cameroon ',
'Cape Verde ',
'Central African ',
' Republic ',
'Chad ',
'Comoros ',
'Congo ',
'Congo ',
' (Dem. Rep.) ',
'Djibouti ',
'Egypt ',
'Equatorial Guinea ',
'Eritrea ',
'Ethiopia ',
'Gabon ',
'Gambia ',
'Ghana ',
'Guinea ',
'Guinea-Bissau ',
'Ivory Coast ',
'Kenya ',
'Lesotho ',
'Liberia ',
'Libya ',
'Madagascar ',
'Malawi ',
'Mali ',
'Mauritania ',
'Mauritius ',
'Morocco ',
'Mozambique ',
'Namibia ',
'Niger ',
'Nigeria ',
'Rwanda ',
'Sao Tome and Principe ',
'Senegal ',
'Seychelles ',
'Sierra Leone ',
'Somalia ',
'South Africa ',
'Sudan ',
'Swaziland ',
'Tanzania ',
'Togo ',
'Tunisia ',
'Uganda ',
'Zambia ',
'Zimbabwe'};

function  OutputList=AsiaList;
OutputList=...
    {'Afghanistan ',
'Bahrain ',
'Bangladesh ',
'Bhutan ',
'Brunei ',
'Burma (Myanmar) ',
'Cambodia ',
'China ',
'East Timor ',
'India ',
'Indonesia ',
'Iran ',
'Iraq ',
'Israel ',
'Japan ',
'Jordan ',
'Kazakhstan ',
'Korea (north) ',
'Korea (south) ',
'Kuwait ',
'Kyrgyzstan ',
'Laos ',
'Lebanon ',
'Malaysia ',
'Maldives ',
'Mongolia ',
'Nepal ',
'Oman ',
'Pakistan ',
'Philippines ',
'Qatar ',
'Russian ',
'Federation ',
'Saudi Arabia ',
'Singapore ',
'Sri Lanka ',
'Syria ',
'Tajikistan ',
'Thailand ',
'Turkey ',
'Turkmenistan ',
'United Arab Emirates ',
'Uzbekistan ',
'Vietnam ',
'Yemen '};

function  OutputList=EuropeList;
     OutputList={...
	 'Albania ',
'Andorra ',
'Armenia ',
'Austria ',
'Azerbaijan ',
'Belarus ',
'Belgium ',
'Bosnia ',
'and Herzegovina ',
'Bulgaria ',
'Croatia ',
'Cyprus ',
'Czech Republic ',
'Denmark ',
'Estonia ',
'Finland ',
'France ',
'Georgia ',
'Germany ',
'Greece ',
'Hungary ',
'Iceland ',
'Ireland ',
'Italy ',
'Latvia ',
'Liechtenstein ',
'Lithuania ',
'Luxembourg ',
'Macedonia ',
'Malta ',
'Moldova ',
'Monaco ',
'Montenegro ',
'Netherlands ',
'Norway ',
'Poland ',
'Portugal ',
'Romania ',
'San Marino ',
'Serbia ',
'Slovakia ',
'Slovenia ',
'Spain ',
'Sweden ',
'Switzerland ',
'Ukraine ',
'United Kingdom ',
'Vatican City '};

function  OutputList=NorthAmericaList;
OutputList=...
    {'Antigua and Barbuda',
'Bahamas ',
'Barbados ',
'Belize ',
'Canada ',
'Costa Rica ',
'Cuba ',
'Dominica ',
'Dominican Rep. ',
'El Salvador ',
'Grenada ',
'Guatemala ',
'Haiti ',
'Honduras ',
'Jamaica ',
'Mexico ',
'Nicaragua ',
'Panama ',
'St. Kitts and Nevis ',
'St. Lucia ',
'St. Vincent and the Grenadines ',
'Trinidad and Tobago ',
'United States '};

function  OutputList=OceanaList;
OutputList=...
    {'Australia ',
'Fiji ',
'Kiribati ',
'Marshall Islands ',
'Micronesia ',
'Nauru ',
'New Zealand ',
'Palau ',
'Papua New Guinea ',
'Samoa ',
'Solomon Islands ',
'Tonga ',
'Tuvalu ',
'Vanuatu'};

function  OutputList=SouthAmericaList;
OutputList=...
    {'Argentina ',
'Bolivia ',
'Brazil ',
'Chile ',
'Colombia ',
'Ecuador ',
'Guyana ',
'Paraguay ',
'Peru ',
'Suriname ',
'Uruguay ',
'Venezuela '};