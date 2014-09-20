% Compute the firing rate of each neuron in a layer
% Parameters
%     layerRec=record of layer activity (created with initLayerRecorD)
%     T=simulation duration
%     dt=time step
% Returns
%     layerRec=update record of layer activity
function firing_rate=computeFiringRate(spikes, T, dt)

firing_rate=zeros(size(spikes));
delta=.1;
alpha=1/delta;
for t=1:round(T/dt)
    [time neuron]=find(spikes(max(1,t-500):t,:)>0);
    if time
        idx=sub2ind(size(spikes),time,neuron);
        tau=dt*time;
        firing_rate(t,:)=accumarray(neuron, (alpha^2).*tau.*exp(-alpha.*tau), [length(firing_rate(t,:)) 1]);
    end
end


