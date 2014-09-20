% Demonstrates properties of each synapse type
function synapseDemo()

% Run for 1.5s
T=1.5;
% Time step=1ms
dt=.001;

% Initialize regular spiking layer with 1 neuron
layerParams=initLayerParams(1,'RS');
% Initialize layer with 1 excitatory input and 1 inhibitory input
layer=initLayer(layerParams,1,1,dt);
layer.gAMPA=layer.params.g_ampa_max;
layer.gNMDA=layer.params.g_nmda_max;
layer.gGABAa=layer.params.g_gabaa_max;
layer.gGABAb=layer.params.g_gabab_max;
layerRec=initLayerRecord(layer,T,dt,2);

% Run for T seconds
for t=dt:dt:T

    % Generate input spikes
    e_spike=0;
    i_spike=0;
    t_idx=round(t/dt);
    if t_idx==250 || t_idx==500 || t_idx==525 || t_idx==750 || t_idx==775 || t_idx==800
        e_spike=1;
        i_spike=1;
    end

    % Run layer
    [layer layerRec]=runLayer(layer,layerRec,e_spike,i_spike,t,dt,2);
end

% Plot synaptic conductances
subplot(2,2,1);
plot(layer.params.g_ampa_hat.*layerRec.rAMPA);
ylabel('Conductance (nS)');
title('AMPA');
subplot(2,2,2);
plot(layer.params.g_nmda_hat.*layerRec.rNMDA);
title('NMDA');
subplot(2,2,3);
plot(layer.params.g_gabaa_hat.*layerRec.rGABAa);
ylabel('Conductance (nS)');
xlabel('Time (ms)');
title('GABAa');
subplot(2,2,4);
plot(layer.params.g_gabab_hat.*layerRec.sGABAb);
xlabel('Time (ms)');
title('GABAb');
