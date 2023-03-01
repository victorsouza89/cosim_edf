% download and extract the distribution archive to the current folder
%unzip(['https://github.com/CATIA-Systems/FMIKit-Simulink/releases/' ...
%  'download/v3.0/FMIKit-Simulink-3.0.zip'], 'FMIKit-Simulink-3.0')

% add the folder to the MATLAB path
addpath(fullfile(pwd, 'FMIKit-Simulink-3.0'))

% initialize FMI Kit
FMIKit.initialize()

% executing:
% https://github.com/CATIA-Systems/FMIKit-Simulink/blob/main/docs/fmu_export.md