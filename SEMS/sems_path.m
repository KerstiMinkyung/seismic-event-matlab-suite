function sems_path

%SEMS_PATH: Sets path for m-files used by 'sems_gui' and 'sems_program'
%
%INPUTS: none
%
%OUTPUTS: none

% Author: Dane Ketner, Alaska Volcano Observatory
% $Date$
% $Revision$

addpath(genpath('C:\AVO\SEMS'));
addpath(genpath('C:\AVO\GISMO'));
addpath('C:\AVO\Deep LP');
addpath(genpath('C:\AVO\MatLAB Tools\dynamicDateTicks'));
addpath(genpath('C:\AVO\MatLAB Tools\fastsmooth'));
addpath(genpath('C:\AVO\MatLAB Tools\nansuite'));
addpath(genpath('C:\AVO\MatLAB Tools\miniSeed'));
addpath(genpath('C:\AVO\MatLAB Tools\Yair_Altman'));

javaaddpath({
   'C:\Winston1.1\lib\colt.jar', ...
   'C:\Winston1.1\lib\mysql.jar', ...
   'C:\Winston1.1\lib\winston-bin.jar'});

format compact
