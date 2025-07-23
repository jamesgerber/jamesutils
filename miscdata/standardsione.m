function StandardsIone
%StandardsIone - print notes on standards for data manipulation
%
% Standard format for calls to functions:  
%    PlanetView(long,lat,Data)
%       where
%         long   =   mx1 column vector
%         lat    =   nx1 column vector
%         Data   =   mxn double array
%    
%   Notes:  a call to surface would thus look like surface(long,lat,Data.');
%           This orientation for the Data matrix appears to be
%           consistent with storage in NetCDF files.
%
%
%   PLOTTING
%
%     I find that using  
%       set(gcf,'renderer','zbuffer') 
%   after making a plot with lots of data seems to improve the problem with
%   being unable to close the window 
%
%
%   COLORMAPS
%
%   For data which is positive, 
%            use value -1 for missing data (i.e. data which had value 1e20)
%            use value -2 for
%   data 
%
%   DATASTRUCTURES
%
%    DS.Data = Data 
%    DS.Long
%    DS.Lat
%    DS.Units
%    DS.Title
%    DS.DataSource
%    DS.MissingValue
%    DS.DataName
%    DS.IoneDataStructure='True'
%
%
%
%   SVN
%   Currently there are two repositories:  
%     ione-svn.cfans.umn.edu/Users/svnuser/IonEdata
%and  ione-svn.cfans.umn.edu/Users/svnuser/matlab
%  
%
%  To download the data, do this:
%   (1) make the directory which will hold the data (i.e. it will contain
%   the directories LandMask/, Climate/, Crops2000/ etc.   You can make
%   this from finder or terminal.  The default location is
%   /Library/IonE/data.  You can put it anywhere you want, but you'll have
%   to update SystemGlobals.m to make some of the codes work for you.
%   (2) from a terminal, CD to the directory you have made
%   (3) execute this command
%   svn co svn+ssh://ione-svn.cfans.umn.edu/Users/svnuser/IonEdata ./
%  
%   This will take a long time to execute.  
%
%  To download the matlab code, do this:
%  (1) Make the directory which will hold source (i.e. it will contain
%  utils/ and yieldgap/)   I put mine in ~/source/matlab
%  (2) from a terminal, CD to that directory
%  (3) execute these commands:
%  svn co svn+ssh://ione-svn.cfans.umn.edu/Users/svnuser/matlab/ ./
%
% if you wanted to only check out the utils, then you could do this:
% svn co svn+ssh://ione-svn.cfans.umn.edu/Users/svnuser/matlab/utils ./utils/
% 
% you could then check out yield gap as well:
%  svn co svn+ssh://ione-svn.cfans.umn.edu/Users/svnuser/matlab/yieldgap ./yieldgap
%
% key svn commands
%  svn --help
%
%  svn status         (tells you what has changed.  it's nice to do this
%                     because it confirms that you are in the "working copy
%                     directory"  All of the following commands assume that
%                     you are in the "working copy directory" or the syntax
%                     gets a bit trickier.)
%
%  svn update        (download latest changes made to the repository)
%
%  svn add           (add a file you have written to the repository.  note
%                     that the repository won't know about this until you
%                     svn commit) 
%
%  svn commit        (upload all of your changes to the repository.  Note
%                     that you will need to give a message, which is 
%                     easiest if you use the -m syntax like this:
%                     svn commit -m "added functionality to blah blah
%                     blah")
%                     
%  
if nargin==0
  help(mfilename);
end
