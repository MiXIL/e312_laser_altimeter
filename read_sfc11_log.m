function [distance,timestamp, strength,voltage] = read_sfc11_log(fname)
% read_sfc11_log - read SF11-C laser altimeter data from .log files 
% created by sfc11_serial
%
% Inputs:
%    fname - path to log file
%
% Outputs:
%   distance - distance/altitude in meters
%   timestamp - (optional) UTC string timestamp
%   strength - (optional) measurement strength (percentage)
%   voltage - (optional) measurement voltage (volts)
%
% Log file format:
%
% UTCyyy-mm-dd-hh:mm:ss.sss     0.00 m  0.000 V  100 %
%
% For example:
%
% UTC2019-12-05-19:03:53.869     0.00 m  0.000 V  100 %
%
% Author: Samuel Prager
% University of Southern California
% email: sprager@usc.edu
% Created: 2019/12/05 16:03:52; Last Revised: 2019/12/05 16:03:52; 

fid = fopen(fname);
s = textscan(fid,'%s %f m %f V %f %%');
fclose(fid);

timestamp = s{1};
distance = s{2};
voltage = s{3};
strength = s{4};

end