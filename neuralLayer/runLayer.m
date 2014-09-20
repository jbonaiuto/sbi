% Run a network layer
% Parameters
%    layer=layer to run (created with initLayer)
%    rec=recording struct (created with initLayerRecord)
%    e_input=excitatory input (spikes)
%    i_input=inhibitory input (spikes)
%    t=current time
%    dt=time step
%    debug=debug level
% Returns
%    layer=layer that was run
%    rec=struct storing layer activity
function [layer rec]=runLayer(layer, rec, e_input, i_input, t, dt, debug)

% get delayed excitatory input spikes
delayedEInput=reshape(rec.in_e_spikes(layer.e_delay_idx),...
    layer.params.N, layer.params.e_in_size);        

% get delayed inhibitory input spikes
delayedIInput=reshape(rec.in_i_spikes(layer.i_delay_idx),...
    layer.params.N, layer.params.i_in_size);

% run excitatory synapses
layer=runExcitatorySynapses(layer, delayedEInput, t, dt);

% run inhibitory synapses
layer=runInhibitorySynapses(layer, delayedIInput, t, dt);

% compute total synaptic current
Isyn=layer.IAMPA+layer.INMDA+layer.IGABAa+layer.IGABAb;

% reset neurons that spiked last time step
fired=find(layer.v>=layer.params.vpeak);
layer.v(fired)=layer.params.c(fired);
layer.u(fired)=layer.u(fired)+layer.params.d(fired);

% update membrane potential
layer.v=layer.v+(layer.params.k.*(layer.v-layer.params.vr).*...
    (layer.v-layer.params.vt)-layer.u-Isyn)./layer.params.Cm;
layer.u=layer.u+(layer.params.a.*(layer.params.b.*(layer.v-...
    layer.params.vr)-layer.u));

% remove overshoot from neurons that spiked this time step
fired=find(layer.v>=layer.params.vpeak);
layer.v(fired)=layer.params.vpeak(fired);

% set spike output for this time step
layer.spikes(:)=0;
layer.spikes(fired)=1;

% record layer activity
rec=recordLayer(layer, e_input, i_input, rec, t, dt, debug);
