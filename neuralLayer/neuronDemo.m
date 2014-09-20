% Demonstrates spiking properties of Izhikevich neurons
function neuronDemo()

% Run for 1s
T=1;
% Time step=1ms
dt=.001;

% Each neuron gets 40 excitatory inputs
eSize=40;
% Each neuron gets 10 inhibitory inputs
iSize=10;

e_freq=[1:2:80];
i_freq=[1:1:10];

% Initialize regular spiking cell layer with 1 neuron
layerParams1=initLayerParams(1,'RS');
layer1=initLayer(layerParams1,eSize,iSize,dt);
layerRec1=initLayerRecord(layer1,T,dt,2);

% Initialize chattering cell layer with 1 neuron
layerParams2=initLayerParams(1,'CH');
layer2=initLayer(layerParams2,eSize,iSize,dt);
layerRec2=initLayerRecord(layer2,T,dt,2);

% Initialize fast spiking cell layer with 1 neuron
layerParams3=initLayerParams(1,'FS');
layer3=initLayer(layerParams3,eSize,iSize,dt);
layerRec3=initLayerRecord(layer3,T,dt,2);

% Initialize low threshold spiking cell layer with 1 neuron
layerParams4=initLayerParams(1,'LTS');
layer4=initLayer(layerParams4,eSize,iSize,dt);
layerRec4=initLayerRecord(layer4,T,dt,2);


% Run for T seconds
for t=dt:dt:T

    % Generate random input spikes
    e_spike=rand(1,eSize)<e_freq.*dt;
    i_spike=rand(1,iSize)<i_freq.*dt;

    % Run layers
    [layer1 layerRec1]=runLayer(layer1,layerRec1,e_spike,i_spike,t,dt,2);
    [layer2 layerRec2]=runLayer(layer2,layerRec2,e_spike,i_spike,t,dt,2);
    [layer3 layerRec3]=runLayer(layer3,layerRec3,e_spike,i_spike,t,dt,2);
    [layer4 layerRec4]=runLayer(layer4,layerRec4,e_spike,i_spike,t,dt,2);
end

layerRec1.firing_rate=computeFiringRate(layerRec1.out_spikes, T, dt);
layerRec2.firing_rate=computeFiringRate(layerRec2.out_spikes, T, dt);
layerRec3.firing_rate=computeFiringRate(layerRec3.out_spikes, T, dt);
layerRec4.firing_rate=computeFiringRate(layerRec4.out_spikes, T, dt);

% Plot membrane potential for each layer
subplot(4,2,1);
plot(layerRec1.v);
ylabel('Membrane potential (mV)');
title('regular spiking');
subplot(4,2,2);
plot(layerRec1.firing_rate);
ylabel('Firing rate (Hz)');
title('regular spiking');
ylim([0 50]);
subplot(4,2,3);
plot(layerRec2.v);
ylabel('Membrane potential (mV)');
title('chattering');
subplot(4,2,4);
plot(layerRec2.firing_rate);
ylabel('Firing rate (Hz)');
title('chattering');
ylim([0 50]);
subplot(4,2,5);
plot(layerRec3.v);
ylabel('Membrane potential (mV)');
title('fast spiking');
subplot(4,2,6);
plot(layerRec3.firing_rate);
ylabel('Firing rate (Hz)');
title('fast spiking');
ylim([0 50]);
subplot(4,2,7);
plot(layerRec4.v);
xlabel('Time (ms)');
ylabel('Membrane potential (mV)');
title('low threshold spiking');
subplot(4,2,8);
plot(layerRec4.firing_rate);
ylabel('Firing rate (Hz)');
title('low threshold spiking');
ylim([0 50]);
drawnow();
