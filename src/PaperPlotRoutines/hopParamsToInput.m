
% Data should be in the form
% data(:,1) = Df (m^2/s)
% data(:,2) = Db (m^2/s)
% data(:,3) = kD (molar)
% Output is
% paramInput(:,1) = nu
% paramInput(:,2) = konBt
% paramInput(:,3) = koff
% paramInput(:,4) = bt
% 
%
function [param] = hopParamsToInput( filename, lbox, lScale, bt )
% set fix parameter
konUnscaled = 1e9; % molar^(-1), s^(-1)
% load data from unknown variable name
temp = load( filename );
dataName = fields(temp);
data = temp.( dataName{1} );
% calculate time scale
% turn Da to muM
fprintf('Converting meters to microns in Da\n')
dA = data(:,1) * lScale^2;
tau = lbox^2 ./ dA;
% scale kon by timescale
kon = konUnscaled * tau;
% build data
paramInput = zeros( size( data, 1 ), 4 );
paramInput(:,1) = data(:,2) ./ data(:,1); % nu
paramInput(:,2) = kon * bt; % nu
paramInput(:,3) = data(:,3) .* kon; % nu
paramInput(:,4) = bt; % nu
% store
param.input = paramInput;
param.data = data;
