% Run a voxel
% Parameters
%     voxel=voxel to run (created with initVoxel)
%     rec=record of voxel activity (created with initVoxelRecord)
%     input=flow-inducing signal
%     t=current time
%     dt=time step duration
% Returns
%     voxel=voxel that was run
%     rec=record of voxel activity
function [voxel rec]=runVoxel(voxel, rec, input, t, dt)

voxel.u=input;
    
% run voxel with coupling signal input
u=voxel.u;
u_0=mean(rec.u_0);

% until the voxel has been run long enough for the noise synaptic activity
% to saturate and the baseline computed, run null input
if t<3.5
    u=.1;
    u_0=.1;
end

% compute blood flow-inducing signal (modified from Riera et al., 2004)
voxel.s=voxel.s+dt*(voxel.params.eta*(u-u_0)/u_0-...
    voxel.s/voxel.params.tau_s-(voxel.f_in-1)/voxel.params.tau_f);
% compute incoming blood flow (from Zheng et al., 2002)
voxel.f_in=voxel.f_in+dt*voxel.s;

% compute oxygen extraction fraction (from Zheng et al., 2002)
voxel.e=voxel.e+dt/(voxel.params.phi/voxel.f_in)*...
    (-voxel.e+(1-voxel.g)*...
    (1-(1-voxel.params.e_0/(1-voxel.params.g_0))^(1/voxel.f_in)));

% compute mean oxygen concentration of the capillary (from Zheng et al,.
% 2002)
voxel.cb=voxel.cb+dt/(voxel.params.phi/voxel.f_in)*...
    (-voxel.cb-(voxel.params.c_ab*voxel.e)/log(1-voxel.e/(1-voxel.g))+...
    voxel.params.c_ab*voxel.g);

% transform ratio of tissue oxygen concentration to arterial plasma oxygen
% concentration and mean oxygen concentration of the capillary to cerebral
% metabolic rate of oxygen (from Zheng et al., 2002)
voxel.cmr_o=(voxel.cb-voxel.g*voxel.params.c_ab)/...
    (voxel.params.cb_0-voxel.params.g_0*voxel.params.c_ab);

% compute ratio of tissue oxygen concentration to arterial plasma oxygen
% concentration - related to metabolic demand (modified from Zheng et al.,
% 2002 to use s instead of u)
voxel.g=voxel.g+dt/(voxel.params.j*voxel.params.v_ratio*...
    ((voxel.params.r*voxel.params.transitTime)/voxel.params.e_0))*...
    ((voxel.cmr_o-1)-voxel.params.k*voxel.s);

% transform venous inflow to change in blood volume (from Zheng et al.,
% 2002
voxel.v=voxel.v+dt/voxel.params.tau_o*(voxel.f_in-voxel.f_out);

% transform blood volume to venous outflow (from Zheng et al., 2002)
voxel.f_out=voxel.v^(1.0/voxel.params.alpha);    

% transform venous inflow, volume, and oxygen extraction to changes
% in deoxyhemoglobin (from Zheng et al., 2002)
voxel.q=voxel.q+dt/voxel.params.tau_o*...
    (voxel.f_in*(voxel.e/voxel.params.e_0)-voxel.f_out*voxel.q/voxel.v);

% transform changes in blood volume and deoxyhemoglobin into the BOLD
% response (from Zheng et al., 2002)
voxel.y=voxel.params.v_0*((voxel.params.k1+voxel.params.k2)*(1-voxel.q)-...
    (voxel.params.k2+voxel.params.k3)*(1-voxel.v));

% Record voxel data
rec=recordVoxel(voxel, rec, t, dt);

