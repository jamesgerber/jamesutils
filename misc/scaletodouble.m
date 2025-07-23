function IM=ScaleToDouble(Image,cls)
% SCALETODOUBLE - try to ensure that image is properly formatted double
%
% SYNTAX
% IM=ScaleToDouble(Image) - set IM to double version of Image
% IM=ScaleToDouble(Image,cls) - convert IM from format cls to double
%
% Note - this function assumes that the image has at least one moderately
% bright pixel, and it's only designed to work with uint8 or uint16
% formats.
%
% EXAMPLE
% im = imread('ngc6543a.jpg');
% im = ScaleToDouble(im);

if (nargin==1)
    cls=class(Image);
end
if strcmpi(cls,'double')
    IM=double(Image);
    if (max2d(Image)>1)
        if (max2d(Image<256))
            IM=IM/255;
        else IM=IM/65535;
        end
    end
end
if strcmpi(cls,'uint8')
    IM=double(Image)/255;
end
if strcmpi(cls,'uint16')
    IM=double(Image)/65535;
end