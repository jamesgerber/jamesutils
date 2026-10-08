function CCCC=MonfredaNameToSpamName(cropname);
% MonfredaNameToSpamName - Monfreda name to SPAM Name


% I generated this code with ChatGPT using the prompt below, I then had to
% go back and correct by hand.

switch cropname
    case 'wheat'
        CCCC='WHEA';
    case 'rice'
        CCCC='RICE';
    case 'maize'
        CCCC='MAIZ';
    case 'barley'
        CCCC='BARL';
    case 'small millet'
        CCCC='MILL';
    case 'pearl millet'
        CCCC='PMIL';
    case 'sorghum'
        CCCC='SORG';
    case 'other cereals'
        CCCC='OCER';
    case 'potato'
        CCCC='POTA';
    case 'sweetpotato' % changed this one
        CCCC='SWPO';
    case 'yams'
        CCCC='YAMS';
    case 'cassava'
        CCCC='CASS';
    case 'other roots'
        CCCC='ORTS';
    case 'bean'
        CCCC='BEAN';
    case 'chickpea'
        CCCC='CHIC';
    case 'cowpea'
        CCCC='COWP';
    case 'pigeon pea'
        CCCC='PIGE';
    case 'lentil'
        CCCC='LENT';
    case 'other pulses'
        CCCC='OPUL';
    case 'soybean'
        CCCC='SOYB';
    case 'groundnut'
        CCCC='GROU';
    case 'coconut'
        CCCC='CNUT';
    case 'oilpalm'
        CCCC='OILP';
    case 'sunflower'
        CCCC='SUNF';
    case 'rapeseed'
        CCCC='RAPE';
    case 'sesame'  % changed this
        CCCC='SESA';
    case 'other oil crops'
        CCCC='OOIL';
    case 'sugarcane'
        CCCC='SUGC';
    case 'sugarbeet'
        CCCC='SUGB';
    case 'cotton'
        CCCC='COTT';
    case 'other fibre crops'
        CCCC='OFIB';
    case 'arabic coffee'
        CCCC='COFF';
    case 'robust coffee'
        CCCC='RCOF';
    case 'cocoa'
        CCCC='COCO';
    case 'tea'
        CCCC='TEAS';
    case 'tobacco'
        CCCC='TOBA';
    case 'banana'
        CCCC='BANA';
    case 'plantain'
        CCCC='PLNT';
    case 'citrus'
        CCCC='CITR';
    case 'other tropical fruit'
        CCCC='TROF';
    case 'temperate fruit'
        CCCC='TEMF';
    case 'tomato'
        CCCC='TOMA';
    case 'onion'
        CCCC='ONIO';
    case 'other vegetables'
        CCCC='VEGE';
    case 'rubber'
        CCCC='RUBB';
    case 'rest of crops'
        CCCC='REST';
    otherwise
        error('Unknown crop name: %s', cropname);
end



% 
% 
% 
%     % from Cao et al:
% ID		Short name	Crop name
% 1		whea		Wheat
% 2		rice		Rice
% 3		maiz		Maize
% 4		barl		Barley
% 5		mill		Small Millet
% 6		pmil		Pearl Millet
% 7		sorg		Sorghum
% 8		ocer		Other Cereals
% 9		pota		Potato
% 10		swpo		Sweet Potato
% 11		yams		Yams
% 12		cass		Cassava
% 13		orts		Other Roots
% 14		bean		Bean
% 15		chic		Chickpea
% 16		cowp		Cowpea
% 17		pige		Pigeon Pea
% 18		lent		Lentil
% 19		opul		Other Pulses
% 20		soyb		Soybean
% 21		grou		Groundnut
% 22		cnut		Coconut
% 23		oilp		Oilpalm
% 24		sunf		Sunflower
% 25		rape		Rapeseed
% 26		sesa		Sesame Seed
% 27		ooil		Other Oil Crops
% 28		sugc		Sugarcane
% 29		sugb		Sugarbeet
% 30		cott		Cotton
% 31		ofib		Other Fibre Crops
% 32		coff		Arabic Coffee
% 33		rcof		Robust Coffee
% 34		coco		Cocoa
% 35		teas		Tea
% 36		toba		Tobacco
% 37		bana		Banana
% 38		plnt		Plantain
% 39		citr		Citrus
% 40		trof		Other Tropical Fruit
% 41		temf		Temperate Fruit
% 42		toma		Tomato
% 43		onio		Onion
% 44		vege		Other Vegetables
% 45		rubb		Rubber
% 46		rest		Rest Of Crops


% The prompt: 
%i'd like you to generalize a case statement in matlab for me. I want the
%input to be lowercase FAO-style crop names, and the output to be four
%character codes you'll infer from the table. First I'll give you the
%correct case statement for wheat, then i'll pas in the table with teh 4
%character codes.     

%switch cropname case 'wheat' CCCC='WHEA';

% then repasted table above


%Note that this is in the code that Peiyu provided:
%crop_full_name = {'Wheat', 'Rice', 'Maize', 'Barley', 'Small Millet', 'Pearl Millet', 'Sorghum', 'Other Cereals', 'Potato', 'Sweet Potato', 'Yams', 'Cassava', 'Other Roots', 'Bean', 'Chickpea', 'Cowpea','Pigeon Pea', 'Lentil', 'Other Pulses', 'Soybean', 'Groundnut', 'Coconut', 'Oilpalm', 'Sunflower', 'Rapeseed', 'Sesame Seed', 'other oil Crops', 'Sugarcane', 'Sugarbeet', 'Cotton', 'Other Fibre Crops', 'Arabic Coffee', 'Robust Coffee', 'Cocoa', 'Tea', 'Tobacco', 'Banana', 'Plantain', 'Citrus', 'Other Tropical Fruit', 'Temperate Fruit', 'Tomato', 'Onion', 'Other Vegatables', 'Rubber', 'Rest of Crops'};

% Abbreviation of name
%Crop_abb_name = {'WHEA', 'RICE', 'MAIZ', 'BARL', 'MILL', 'PMIL', 'SORG', 'OCER', 'POTA', 'SWPO', 'YAMS', 'CASS', 'ORTS', 'BEAN', 'CHIC', 'COWP', 'PIGE', 'LENT', 'OPUL', 'SOYB', 'GROU', 'CNUT', 'OILP', 'SUNF', 'RAPE', 'SESA', 'OOIL', 'SUGC', 'SUGB', 'COTT', 'OFIB', 'COFF', 'RCOF', 'COCO', 'TEAS', 'TOBA', 'BANA', 'PLNT', 'CITR', 'TROF', 'TEMF', 'TOMA', 'ONIO', 'VEGE', 'RUBB', 'REST'};
