function [MeanVal,RMSVal,MaxPos,MaxNeg,SigVal,SigPosAmplitude,Tp,tm01,tm02]=GetScalarIrregWaveStats(t_in,x_in);
%GETSCALARIRREGWAVESTATS - Calculate scalar stats from a time series

%first need regular wave grid

delt=mean(diff(t_in));
t=t_in(1):delt:t_in(end);
x=interp1(t_in,x_in,t);

%now on a regular grid

OS.MeanVal=mean(x);
OS.RMSVal=sqrt(var(x));
OS.MaxPos=max(x);
OS.MaxNeg=min(x);

[swh_psd,swh_avg]=AnalyzeSWH(x);
OS.SigAmp_m0=swh_psd/2;
OS.SigAmp_3=swh_avg/2;

if nargout==1
   MeanVal=OS;
end

