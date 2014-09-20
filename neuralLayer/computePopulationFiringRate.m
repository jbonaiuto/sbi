% Compute the population firing rate of the neurons in a layer
% Parameters
%     layerRec=record of layer activity (created with initLayerRecorD)
%     T=simulation duration
%     dt=time step
% Returns
%     layerRec=update record of layer activity
function firing_rate=computePopulationFiringRate(spikes, T, dt)

binSize=25;

% Find all spikes
[tt xx]=find(spikes>0);

% Bin and sum spikes
binned=hist(tt,[1:binSize:round(T/dt)]);

% Smooth histogram
firing_rate=smooth(binned,25,33);

