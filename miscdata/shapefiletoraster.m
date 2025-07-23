function [Long,Lat,Raster,Areasqkm]=ShapeFileToRaster(S,FieldName,MatrixTemplate,plotflag,namelist)
% ShapefileToRaster - Turn a shapefile into a raster
%
%  Syntax:
%      [Long,Lat,RASTER]=ShapeFileToRaster(S,FIELD,MATRIXTEMPLATE,PLOTFLAG);
%
%      S is a vector of structures with the fields "X" "Y" and
%      FIELD.  This function most useful when S comes from a SHAPEREAD command
%      executed on a .shp file.
%      RASTER will be a matrix corresponding to the values of the field
%      FIELD.
%
%      If MatrixTemplate is a structure with fields .lat .long and .matrix it will use those. 
%
%      if PLOTFLAG is 1, a plot will be made as things go alond
%
%      [Long,Lat,RASTER]=ShapeFileToRaster(S,FIELD,MATRIXTEMPLATE,PLOTFLAG,UNITNAMES);
%      will print out UNITNAMES at each step.  Useful for figuring out
%      which regions taking too long.
%
%      Possible problems:
%      * Not all shaperead commands result in an X,Y that are in lat/long.
%      Function would fail in this case
%      * If polygons overlap, then results will be arbitrary
%      * Function can be very slow
%      * This function is based on the function inpolygon
%      I don't know how well this would behave if we tried to
%      operate it on a shapefile which included a bunch of lakes.
%
%    Example
%   S=shaperead([iddstring ...
%   'AdminBoundary2005/Vector_ArcGISShapefile/gladmin_m3lcover'])
%
%   %make a smaller shapefile just for demonstrating this code
%
%
%    NS=S(1:800);
%
%   for j=1:800
%    NS(j).NumericalField=j;
%   end
%
%   template=datablank(0,'30min');
%
%   [Long,Lat,Raster]=ShapeFileToRaster(NS,'NumericalField',template,0);
%
%   see also movePointsToGridCorners

switch nargin
    case 0
        help(mfilename)
        return
    case 1
        %debugging only.   % commented out debuggin lines below
        FieldName='d';
        plotflag=0;
        MatrixTemplate=ones(4320,2160);
    case 2
        plotflag=0;
        MatrixTemplate=ones(4320,2160);
    case 3
        plotflag=0;
end

if nargout==1
    error(' called with only 1 arg ... you probably don''t mean that ... its longitude ');
end


if isstruct(MatrixTemplate);
    
    Long=MatrixTemplate.long;
    Lat=MatrixTemplate.lat;
    Matrix=0*ones(size(MatrixTemplate.matrix));
    MatrixTemplate=MatrixTemplate.matrix;
else
    Matrix=0*ones(size(MatrixTemplate));
    [Long,Lat]=InferLongLat(Matrix);
end
[LatGrid,LongGrid]=meshgrid(Lat,Long);

if plotflag==1
    figure(11)
    clf
    axis([min(Long) max(Long) min(Lat) max(Lat)])
    hold on
end

%hh=waitbar(0,'working ... ')
for j=1:length(S);
    
    if nargin==5
        j
        char(namelist{j})
    end

    S(j);
    % if int(j/length(
 %   waitbar(j/length(S),hh);
    %end
    %for j=120;
    xx=S(j).X;
    yy=S(j).Y;
    
    xx(2:end+1)=xx;
    xx(1)=NaN;
    yy(2:end+1)=yy;
    yy(1)=NaN;
    
    
    kk=find(isnan(xx));
    if length(kk)==1
        error('This S vector isn''t quite working out ... expect more NANs')
    end
    
    %    disp(['Working on ' S(j).ID '(' num2str(j) ' out of ' num2str(length(S)) ...
    %        ').  ' num2str(length(kk)-1) ' regions.']);
    
    LogicalCountryMatrix=logical(zeros(size(MatrixTemplate)));
    
    ii=find(LongGrid > nanmin(xx)-.1 & LongGrid < nanmax(xx)+.1 & ...
        LatGrid > nanmin(yy)-.1 & LatGrid < nanmax(yy)+.1);
    jj=(LongGrid > nanmin(xx)-.1 & LongGrid < nanmax(xx)+.1 & ...
        LatGrid > nanmin(yy)-.1 & LatGrid < nanmax(yy)+.1);
    AreaAdditionSpace=0;
    for k=2:length(kk);%
        
        x=xx(kk(k-1)+1:kk(k)-1);
        y=yy(kk(k-1)+1:kk(k)-1);
        
        
        AreaSquareDegrees=polyarea(x,y);
        AreaAdditionSpace=AreaAdditionSpace+AreaSquareDegrees*(40075/360)^2*cosd(mean(y));
        
        
        
        if plotflag==1
            figure(11)
            plot(xx,yy,x,y,'r')
            hold on
            drawnow
            PlotMatrix=NaN*ones(size(MatrixTemplate));
            LogicalPlotMatrix=0*ones(size(MatrixTemplate));
        end
        
        % jsg Nov 2012: find ii outside of this loop.  it turns out this
        % find statement takes waaaay longer than inpolygon for some calls
        % the downside of course is that ii isn't as limited in space
        %    ii=find(LongGrid > min(x)-.1 & LongGrid < max(x)+.1 & ...
        %        LatGrid > min(y)-.1 & LatGrid < max(y)+.1);
        
        [IN ON]=inpolygon(LongGrid(ii),LatGrid(ii),x,y);
        
        %     Matrix(ii)=(IN | ON)*getfield(S(j),FieldName);
        
        LogicalCountryMatrix(ii)=     LogicalCountryMatrix(ii) | IN | ON;
        
        
        if plotflag==1
            IN=IN|ON;
            LogicalPlotMatrix(ii)=LogicalPlotMatrix(ii) | IN;
            PlotMatrix(ii)=IN;
            PlotMatrix(ii(find(IN==0)))=NaN;
            iiLong=find(Long > min(x)-.1 & Long < max(x)+.1);
            iiLat=find(Lat > min(y)-.1 & Lat < max(y)+.1);
            figure(11)
            hold on
            tmp=double(LogicalPlotMatrix);
            tmp(find(tmp==0))=0;
            surface(Long(iiLong),Lat(iiLat),tmp(iiLong,iiLat).');
            hold on
            drawnow
   %         shading flat
        end
    end  % end of k loop over regions within each country
    % end of country loop
    jj=find(LogicalCountryMatrix);
    %  if (FieldName~='d')
    Matrix(jj)=getfield(S(j),FieldName);
    % else
    %     Matrix(jj)=1;
    % end
    
    Areasqkm(j)=AreaAdditionSpace;
    
    
end % end of j loop over countries

%delete(hh)
Raster=Matrix;
