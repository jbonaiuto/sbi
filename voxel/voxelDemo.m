% Demonstrates the hemodynamics model
function voxelDemo()

% Run for 22s
T=22;
% Time step=1ms
dt=.001;

% Init voxel params
voxelParams=initVoxelParams();
% Init voxel
voxel=initVoxel([],voxelParams);
% Init voxel record
voxelRec=initVoxelRecord(T,dt);

% Run for T seconds
for t=dt:dt:T

    % Default input is low
    input=.1;
    % At 10s stimulate for .5s
    if t>10 && t<10.5
        input=1.1;
    end

    % Run voxel with input
    [voxel voxelRec]=runVoxel(voxel,voxelRec,input,t,dt);
end

% Plot voxel variables
subplot(2,2,1);
plot([0:dt:T-8],voxelRec.u(8000:round(T/dt))-.1,[0:dt:T-8],voxelRec.s(8000:round(T/dt)));
legend('stimulus', 'l');
subplot(2,2,2);
plot([0:dt:T-8],voxelRec.g(8000:round(T/dt)),[0:dt:T-8], voxelRec.e(8000:round(T/dt)));
legend('h', 'E');
subplot(2,2,3);
plot([0:dt:T-8],voxelRec.f_in(8000:round(T/dt)),[0:dt:T-8], voxelRec.f_out(8000:round(T/dt)),[0:dt:T-8], voxelRec.v(8000:round(T/dt)),[0:dt:T-8], voxelRec.q(8000:round(T/dt)),[0:dt:T-8], voxelRec.cb(8000:round(T/dt)));
legend('f_{in}', 'f_{out}', 'm', 'q', 'C_{B}');
subplot(2,2,4);
plot([0:dt:T-8],voxelRec.y(8000:round(T/dt)));
legend('y');

