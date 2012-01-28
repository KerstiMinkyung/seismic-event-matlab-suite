function sems_path
%
%SEMS_PATH: Sets path for m-files used by 'sems_gui' and 'sems_program'
%
%INPUTS: none
%
%OUTPUTS: none

addpath(genpath('C:\Documents and Settings\dketner\Desktop\Backup_2011_11_18\SEMS'));
addpath(genpath('C:\Documents and Settings\dketner\Desktop\Backup_2011_11_18\MatLAB Tools'));
addpath(genpath('C:\Documents and Settings\dketner\Desktop\Backup_2011_11_18\Redoubt'));

javaaddpath({
   'C:\Winston1.1\lib\colt.jar', ...
   'C:\Winston1.1\lib\mysql.jar', ...
   'C:\Winston1.1\lib\winston-bin.jar'});
