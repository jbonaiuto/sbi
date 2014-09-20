% Initialize a voxel
% Parameters
%     net=network inside voxel
%     params=voxel parameters (created with initVoxelParams)
% Returns
%     voxel=LIP voxel
function voxel=initVoxel(net, params)

voxel.net=net;
voxel.params=params;

% neurovascular coupling signal
voxel.u=0;
% blood flow-inducing signal
voxel.s=0;
% venous blood inflow
voxel.f_in=1;
% ratio of tissue and arterial plasma oxygen concentration
voxel.g=params.g_0;
% net oxygen extraction fraction by capillary bed
voxel.e=params.e_0;
% mean oxygen concentration in the capillary
voxel.cb=params.cb_0;
% venous blood outflow
voxel.f_out=1;
% blood volume
voxel.v=1;
% deoxyhemoglobin
voxel.q=1;
% oxygen metabolism
voxel.cmr_o=1;
% BOLD signal
voxel.y=0;
