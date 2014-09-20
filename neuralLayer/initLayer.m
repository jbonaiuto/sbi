% Initialize layer
% Parameters
%     layerParams=struct of layer parameters (created with initLayerParams)
%     eInSize=number of excitatory inputs for each neuron
%     iInSize=number of inhibitory inputs for each neuron
% Returns
%     layer=neural layer struct
function layer=initLayer(layerParams, eInSize, iInSize, dt)

% Intialize layer parameters
layer.params=layerParams;
% Number of excitatory inputs
layer.params.e_in_size=eInSize;
% Number of inhibitory inputs
layer.params.i_in_size=iInSize;

% Neuron variables
% Initialize membrane potential to resting level
layer.v=layerParams.vr;
% Initialize recovery variable u
layer.u=layerParams.b.*layer.v;
% Initialize spikes to zero
layer.spikes=zeros(layerParams.N,1);

% Synaptic currents
layer.IAMPA=zeros(layerParams.N,1);
layer.INMDA=zeros(layerParams.N,1);
layer.IGABAa=zeros(layerParams.N,1);
layer.IGABAb=zeros(layerParams.N,1);

% Percentage of open channels in each synapse (r_{i} in Lytton 1996)
layer.rAMPA=zeros(layerParams.N,eInSize);
layer.rNMDA=zeros(layerParams.N,eInSize);
layer.rGABAa=zeros(layerParams.N,iInSize);
layer.rGABAb=zeros(layerParams.N,iInSize);
% Concentration of activated G-protein for GABAb channels
layer.sGABAb=zeros(layerParams.N,iInSize);

% Precompute some of the exponential terms used in the synapse model
layer.params.exp1_ampa=exp(-dt/layer.params.taur_ampa);
layer.params.exp2_ampa=exp(-layer.params.beta_ampa*dt);
layer.params.exp1_nmda=exp(-dt/layer.params.taur_nmda);
layer.params.exp2_nmda=exp(-layer.params.beta_nmda*dt);
layer.params.exp1_gabaa=exp(-dt/layer.params.taur_gabaa);
layer.params.exp2_gabaa=exp(-layer.params.beta_gabaa*dt);

% Normalized synaptic conductances (summed over all synapses) (R_{on} and
%R_{off} in Lytton 1996)
layer.rAMPAon=zeros(layerParams.N,1);
layer.rAMPAoff=zeros(layerParams.N,1);
layer.rNMDAon=zeros(layerParams.N,1);
layer.rNMDAoff=zeros(layerParams.N,1);
layer.rGABAaon=zeros(layerParams.N,1);
layer.rGABAaoff=zeros(layerParams.N,1);
layer.sGABAbSum=zeros(layerParams.N,1);

% Conductance of each synapse (g_{i} in Lytton 1996)
layer.gAMPA=layerParams.g_ampa_min+(layerParams.g_ampa_max-...
    layerParams.g_ampa_min)*rand(layerParams.N,eInSize);
layer.gNMDA=layerParams.g_nmda_min+(layerParams.g_nmda_max-...
    layerParams.g_nmda_min)*rand(layerParams.N,eInSize);
layer.gGABAa=layerParams.g_gabaa_min+(layerParams.g_gabaa_max-...
    layerParams.g_gabaa_min)*rand(layerParams.N,iInSize);
layer.gGABAb=layerParams.g_gabab_min+(layerParams.g_gabab_max-...
    layerParams.g_gabab_min)*rand(layerParams.N,iInSize);

% Muscimol level
% The percentage of neurons specified by layerParams.muscimol_perc receive a 
% muscimol level of layerParams.muscimol
layer.muscimol=(rand(layerParams.N,1)<layerParams.muscimol_perc).*layerParams.muscimol;

% last input spike times
layer.last_e_input=-1*ones(layerParams.N, eInSize);
layer.last_i_input=-1*ones(layerParams.N, iInSize);

% Axonal conductance delays for each synapse
layer.e_in_delays=layerParams.min_delay+(layerParams.max_delay-...
    layerParams.min_delay).*rand(layerParams.N,eInSize);
layer.i_in_delays=layerParams.min_delay+(layerParams.max_delay-...
    layerParams.min_delay).*rand(layerParams.N,iInSize);

% Precomputed indices for getting delayed spikes
layer.e_t_idx=reshape(layer.e_in_delays,1, layer.params.N*...
    layer.params.e_in_size);
layer.e_x_idx=reshape((ones(layer.params.e_in_size,1)*(1:layer.params.N))', ...
    1, layer.params.N*layer.params.e_in_size);
layer.e_y_idx=reshape(ones(layer.params.N,1)*(1:layer.params.e_in_size), 1, ...
    layer.params.N*layer.params.e_in_size);
layer.e_delay_idx=sub2ind([round(max(layer.e_in_delays(:))/dt) ...
    layer.params.N layer.params.e_in_size], round(layer.e_t_idx/dt), layer.e_x_idx, ...
    layer.e_y_idx);
layer.i_t_idx=reshape(layer.i_in_delays,1, layer.params.N*...
    layer.params.i_in_size);
layer.i_x_idx=reshape((ones(layer.params.i_in_size,1)*(1:layer.params.N))', 1,...
    layer.params.N*layer.params.i_in_size);
layer.i_y_idx=reshape(ones(layer.params.N,1)*(1:layer.params.i_in_size), 1,...
    layer.params.N*layer.params.i_in_size);
layer.i_delay_idx=sub2ind([round(max(layer.i_in_delays(:))/dt) ...
    layer.params.N layer.params.i_in_size], round(layer.i_t_idx/dt), layer.i_x_idx,...
    layer.i_y_idx);
