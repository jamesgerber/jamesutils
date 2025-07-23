function cmap=colorbrewer(type,flag);
% reproduce a colormap from colorbrewer2.org
%
% type can be integer from 1-6, or
% 'brbg','piyg','prgn','puor','rdbu','rdylbu'
%
% flag can be 0 or 1
% if 0, straight linear adaptation
% if 1, then square root mapping around center


switch type
    case {1,'BrBG','brbg'}
        a=[84,48,5
            140,81,10
            191,129,45
            223,194,125
            246,232,195
            245,245,245
            199,234,229
            128,205,193
            53,151,143
            1,102,94
            0,60,48];
    case {2,'PiYG','piyg'}
        a=[142,1,82
            197,27,125
            222,119,174
            241,182,218
            253,224,239
            247,247,247
            230,245,208
            184,225,134
            127,188,65
            77,146,33
            39,100,25            ];
    case {3,'PRGn','prgn'}
        a=[64,0,75
            118,42,131
            153,112,171
            194,165,207
            231,212,232
            247,247,247
            217,240,211
            166,219,160
            90,174,97
            27,120,55
            0,68,27];
    case {4,'PuOr','puor'}
        a=[127,59,8
            179,88,6
            224,130,20
            253,184,99
            254,224,182
            247,247,247
            216,218,235
            178,171,210
            128,115,172
            84,39,136
            45,0,75];
    case {5,'RdBu','rdbu'}
        a=[103,0,31
            178,24,43
            214,96,77
            244,165,130
            253,219,199
            247,247,247
            209,229,240
            146,197,222
            67,147,195
            33,102,172
            5,48,97];
    case {6,'RdYlBu','rdylbu'}
        a=[165,0,38
            215,48,39
            244,109,67
            253,174,97
            254,224,144
            255,255,191
            224,243,248
            171,217,233
            116,173,209
            69,117,180
            49,54,149 ];
end

switch flag
    case 0
        
        x=[1:11]/11;
        
        xx=[1:.01:11]/11;
        
        cmap=interp1(x,a,xx)/255;
        
    case 1
        x=linspace(-1,1,11);
        xx=linspace(-1,1,1001);
        
        yy=abs(xx).^(1/2).*sign(xx);
        
        cmap=interp1(x,a,yy)/255;
    otherwise
        error
end
