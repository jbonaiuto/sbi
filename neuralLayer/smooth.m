function [out1,out2] = smooth(in1,in2,in3);
% smooth	- smooth signal by convolving with Gaussian bell
%--------------------------------------------------------------------------------
% Input(s): 	in1 - signal
%		in2 - bin for Gaussian bell (optional, default 1)
%		in3 - sigma of Gaussian (optional, default 3)
% Output(s):	out1 - smoothed signal
%		out2.y - Gaussian bell
%		out2.t - Gaussian bell timescale
% Usage:	out1 = smooth(in1,2,4);
%
% Last modified 29.11.02
% Copyright (c) 2002 Igor Kagan					 
% kigor@tx.technion.ac.il
% http://igoresha.virtualave.net
%--------------------------------------------------------------------------------
%
% see Abeles 1982: Quantification, smoothing, and confidence limits for single-units'
% histogram. Journal of Neurosci Meth 5: 317-325

if nargin<2,
	bin = 1;
else
	bin = in2;
end

if nargin<3,
	s=3; % SIGMA (ms)
else
	s=in3;
end

t=-3*s:bin:3*s;
lg = length(t);
b=exp(-t.^2/(2*s^2));
% Normalization 
tb=(1.003/(2*pi*s)^.5)*b;
divider=sum(tb);

in = in1;
for k=1:size(in1,1)
        in1 = in(k,:);
        
        ini_len = length(in1);
        
        in1=[in1(1)*ones(size(1:lg/2)) in1 in1(end)*ones(size(1:lg/2))];
        
        %in1=[fliplr(in1(1:lg/2)) in1 fliplr(in1(length(in1)-lg/2:length(in1)))];
        
        %in1=in1(3*s:length(in1)-(3*s+1));
        
        out1=(1/divider)*(1.003/(2*pi*s)^.5)*conv(in1,b);
        out1 = out1(lg+1:end-lg);
        out1 = resample(out1,ini_len,length(out1));
        
        out(k,:) = out1;
end
        
out1 = out;
out2.y = b;
out2.t = t;
