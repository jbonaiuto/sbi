% Record voxel activity
% Parameters
%     voxel=voxel to record from (created with initVoxel)
%     rec=record of voxel activity (created with initVoxelRecord)
%     t=current time
%     dt=time step
% Returns
%     rec=record of voxel activity
function rec=recordVoxel(voxel, rec, t, dt)

% index to record current data at
idx=round(t/dt);
if t>=1.5+dt && t<=3.5
    % Compute baseline neurovascular coupling signal for 2s
    rec.u_0(idx-round(1.5/dt))=voxel.u;
end
rec.u(idx)=voxel.u;
rec.s(idx)=voxel.s;
rec.f_in(idx)=voxel.f_in;
rec.g(idx)=voxel.g;
rec.e(idx)=voxel.e;
rec.cb(idx)=voxel.cb;
rec.cmr_o(idx)=voxel.cmr_o;
rec.f_out(idx)=voxel.f_out;
rec.v(idx)=voxel.v;
rec.q(idx)=voxel.q;
rec.y(idx)=voxel.y;

