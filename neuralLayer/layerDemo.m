% Demonstrates network of two layers - pyramidal and interneurons
function [layerRec1 layerRec2]=layerDemo()

% Duration=2s
T=2;
% Time step=1ms
dt=.001;

pyrN=400;
intN=100;

% Each neuron gets 40 excitatory inputs
eSize=400;
% Each neuron gets 10 inhibitory inputs
iSize=100;

% Frequency of excitatory input
e_freq=10;
% Frequency of inhibitory input
i_freq=1;

% Connection probabilities between and within layers
% Probability of excitatory input neuron projecting to neuron in pyramidal layer
p_exte_e=.2;
% Probability of inhibitory input neuron projecting to neuron in pyramidal layer
p_exti_e=.2;
% Probability of inhibitory input neuron projecting to neuron in interneuron layer
p_exte_i=.2;
% Probability of excitatory input neuron projecting to neuron in interneuron layer
p_exti_i=.2;
% Probability of cells in pyramidal layer projecting to other pyramidal cells
p_e_e=.2;
% Probability of cells in interneuron layer projecting to pyramidal cells
p_i_e=.2;
% Probability of cells in pyramidal layer projecting to interneurons
p_e_i=.2;
% Probability of cells in inteneuron layer projecting to other interneurons
p_i_i=.3;

% Initialize pyramidal cell layer
layerParams1=initLayerParams(pyrN,'RS-CH');
layer1=initLayer(layerParams1,pyrN+eSize,intN+iSize,dt);
layerRec1=initLayerRecord(layer1,T,dt,0);

% Initialize interneuron cell layer
layerParams2=initLayerParams(intN,'FS-LTS');
layer2=initLayer(layerParams2,pyrN+eSize,intN+iSize,dt);
layerRec2=initLayerRecord(layer2,T,dt,0);

% Initialize synapses according to projection probabilities
for j=1:pyrN
    for k=1:pyrN
        if rand>=p_e_e || j==k
            layer1.gAMPA(j,k)=0;
        end
        if rand>=p_e_e || j==k
            layer1.gNMDA(j,k)=0;
        end
    end
    for k=pyrN+1:pyrN+eSize
        if rand>=p_exte_e
            layer1.gAMPA(j,k)=0;
        end
        if rand>=p_exte_e
            layer1.gNMDA(j,k)=0;
        end
    end
end

for j=1:pyrN
    for k=1:intN
        if rand>=p_i_e
            layer1.gGABAa(j,k)=0;
        end
        if rand>=p_i_e
            layer1.gGABAb(j,k)=0;
        end
    end
    for k=intN+1:intN+iSize
        if rand>=p_exti_e
            layer1.gGABAa(j,k)=0;
        end
        if rand>=p_exti_e
            layer1.gGABAa(j,k)=0;
        end
    end
end

for j=1:intN
    for k=1:pyrN
        if rand>=p_e_i
            layer2.gAMPA(j,k)=0;
        end
        if rand>=p_e_i
            layer2.gNMDA(j,k)=0;
        end
    end
    for k=pyrN+1:pyrN+eSize
        if rand>=p_exte_i
            layer2.gAMPA(j,k)=0;
        end
        if rand>=p_exte_i
            layer2.gNMDA(j,k)=0;
        end
    end
end

for j=1:intN
    for k=1:intN
        if rand>=p_i_i
            layer2.gGABAa(j,k)=0;
        end
        if rand>=p_i_i
            layer2.gGABAb(j,k)=0;
        end
    end
    for k=intN+1:intN+iSize
        if rand>=p_exti_i
            layer2.gGABAa(j,k)=0;
        end
        if rand>=p_exti_i
            layer2.gGABAb(j,k)=0;
        end
    end
end

% Run for T seconds
for t=dt:dt:T

    % Print time steps every 100ms
    if mod(t,.1)==0
        t
    end

    % Generate random input spikes
    e_spike=rand(1,eSize)<e_freq.*dt;
    i_spike=rand(1,iSize)<i_freq.*dt;

    % Run layers
    [layer1 layerRec1]=runLayer(layer1,layerRec1,[repmat(layer1.spikes',pyrN,1) repmat(e_spike,pyrN,1)],[repmat(layer2.spikes',pyrN,1) repmat(i_spike,pyrN,1)],t,dt,0);

    [layer2 layerRec2]=runLayer(layer2,layerRec2,[repmat(layer1.spikes',intN,1) repmat(e_spike,intN,1)],[repmat(layer2.spikes',intN,1) repmat(i_spike,intN,1)],t,dt,0);
end

% Compute population firing rate for each layer
layerRec1.firing_rate=computePopulationFiringRate(layerRec1.out_spikes, T, dt);
layerRec2.firing_rate=computePopulationFiringRate(layerRec2.out_spikes, T, dt);

% Plot spike raster
subplot(3,2,1);
[t x]=find(layerRec1.out_spikes>0);
plot(t*dt,x,'.');ylim([1 pyrN]);xlim([dt T]);
subplot(3,2,2);
[t x]=find(layerRec2.out_spikes>0);
plot(t*dt,x,'.');ylim([1 intN]);xlim([dt T]);

% Plot firing rates
subplot(3,2,3);
plot([dt*25:dt*25:T],layerRec1.firing_rate);ylim([0 max(layerRec1.firing_rate)+10]);
subplot(3,2,4);
plot([dt*25:dt*25:T],layerRec2.firing_rate);ylim([0 max(layerRec2.firing_rate)+10]);

% Plot spectrograms
edges=[0:.01:T];
psth=zeros(length(edges),1);
for j=1:size(layerRec1.out_spikes,2)
    t=find(layerRec1.out_spikes(:,j)>0).*.001;
    if length(t)>0
        psth=psth+histc(t,edges);   
    end
end
subplot(3,2,5);
spectrogram(psth,32,30,256,1E2,'yaxis');

psth=zeros(length(edges),1);
for j=1:size(layerRec2.out_spikes,2)
    t=find(layerRec2.out_spikes(:,j)>0).*.001;
    if length(t)>0
        psth=psth+histc(t,edges);   
    end
end
subplot(3,2,6);
spectrogram(psth,32,30,256,1E2,'yaxis');
