function DPD=DataProductsDir;
% return directory linking to DataProducts/


[ret, name] = system('hostname');

switch name(1:10)
    case 'C02F930BMD' % 'C02F930BMD6'
        DPD='/Users/jsgerber/DataProducts/';
    case 'MacBook1003' % 'MacBook1003'
        DPD='/Volumes/Monarch/DataProducts/';
    case 'Jamess-MBP'
        DPD='/Users/jsgerber/DataProducts/';
    case {'Jamess-Mac','jamess-mac'}
        DPD='/Users/jsgerber/DataProducts/';

    otherwise
        name=getenv('USER');
        switch name
            case 'jsgerber'
                DPD='/Users/jsgerber/DataProducts/';
            case 'samst'
                DPD = 'E:/DataProducts/';
            otherwise
                name=getenv('USERNAME');
                switch name
                    case 'samst'
                        DPD = 'E:\DataProducts\';
                    otherwise 
                        error
                end
                

        end

end
