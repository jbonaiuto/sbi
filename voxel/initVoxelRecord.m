% Initialize record of voxel activity
% Parameters
%     T=simulation duration
%     dt=time step
% Returns
%     rec=record of voxel activity
function rec=initVoxelRecord(T, dt)

rec.u_0=zeros(round(2/dt),1);
rec.u=zeros(round(T/dt),1);
rec.s=zeros(round(T/dt),1);
rec.f_in=zeros(round(T/dt),1);
rec.g=zeros(round(T/dt),1);
rec.e=zeros(round(T/dt),1);
rec.cb=zeros(round(T/dt),1);
rec.cmr_o=zeros(round(T/dt),1);
rec.f_out=zeros(round(T/dt),1);
rec.v=zeros(round(T/dt),1);
rec.q=zeros(round(T/dt),1);
rec.y=zeros(round(T/dt),1);

