function D=approxDeriv(data)
data=data(:);
data=[data(1)-(data(2)-data(1)) ; data];
data=[data ; data(length(data))+(data(length(data))-data(length(data)-1))];
d1=diff(data(1:(length(data)-1)));
d2=diff(data(2:length(data)));
D=(d1+d2)/2;