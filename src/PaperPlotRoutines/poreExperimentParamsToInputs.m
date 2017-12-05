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
function [param] = poreExperimentParamsToInputs( filename )
% set fix parameter
lbox = 1e-7; % meter
konUnscaled = 1e9; % molar^(-1), s^(-1)
bt = 1e-3; % molar
% load data from unknown variable name
temp = load( filename );
dataName = fields(temp);
data = temp.( dataName{1} );
% calculate time scale
tau = lbox^2 ./ data(:,1);
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
