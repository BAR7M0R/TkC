function [text] = bity2text(bity)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
bina_par_d=reshape(bity,9,numel(bity)/9)';
decy_par_d=bi2de(bina_par_d);
text=char(decy_par_d');
end

