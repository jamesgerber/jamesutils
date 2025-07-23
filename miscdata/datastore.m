function varargout=datastore(name,data,masktype)
% datastore - gateway function for storing only a cropmask
%
%  
%  Syntax
%      Call with two arguments to write data to a file:
%    datastore(filename,data);   % where data is 4320x2160
%
%      Call with one input argument / one output argument to retrieve data
%   data=datastore(filename)
%
%
%   This is nearly equivalent to DataStoreGateway in matlab/fertilizer


if nargin==0
    help(mfilename)
    return
end

if nargin<3
    masktype='crop';
end


if nargout==1
    disp(['retrieving data for ' name])
  
  load(name);
  
  tmp = length(store);
  switch tmp
      case 2069588
          ii = AgriMaskIndices;
      case 920953
          ii = CropMaskIndices;
  end
    
  data=-1*nan(4320,2160);
  
  data(ii)=store(:);  %note that store is dataname within saved file
    varargout{1}=data;
else
    switch masktype
        case 'crop'
            ii=CropMaskIndices;
        case 'agri'
            ii=AgriMaskIndices;
        case 'land'
            ii=LandMaskIndices
        otherwise
            error
    end           
    store=data(ii);
    save(name,'store');
end
