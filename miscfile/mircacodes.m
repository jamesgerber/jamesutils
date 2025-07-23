function output=MIRCAcodes(input)
% MIRCAcodes - relate MIRCA name with a MIRCA number
%
% SYNTAX
% MIRCAcodes(number) returns the MIRCA name associated with number
% MIRCAcodes(numbers) returns the MIRCA names associated with vector
% numbers
% MIRCAcodes(name) returns the MIRCA number associated with name
% MIRCAcodes(names) returns the MIRCA numbers associated with cell array
% names
%
%  example
%
%    MIRCAcodes(3)
%
%    MIRCAcodes('rice')
%
%    MIRCAcodes({'rice'})
%

    
namelist={'wheat','maize','rice','barley','rye','millet','sorghum','soybean','sunflower',...
	  'potato','cassava','sugarcane','sugarbeet','oilpalm','rapeseed','groundnut',...
	  'cg_pulses','cg_fruit_citrus','date','grape','cotton','cocoa','coffee','cg_others_perennial',...
	  'past2000','cg_others_annual'};


if isnumeric(input)
  output=char(namelist(input));
  return
end

ii=strmatch(char(input),namelist);

if numel(ii) ~= 1
  error (['didn''t find a unique match for ' char(input) ])
else
  
  output=ii;
end

  