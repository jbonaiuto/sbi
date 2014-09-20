% Initializes a struct to store a record of a layer's activity
% Parameters
%     layer - the layer whose activity to record (created with initLayer)
%     T - the total length of the simulation (in seconds)
%     dt - the simulation time step (in seconds)
%     debug - debug level (>1 records synapse activity)
% Returns
%     rec - struct to store layer activity
function rec=initLayerRecord(layer, T, dt, debug)

% input spikes stacks
rec.in_e_spikes=zeros(round(max(layer.e_in_delays(:))/dt), layer.params.N, layer.params.e_in_size);
rec.in_i_spikes=zeros(round(max(layer.i_in_delays(:))/dt), layer.params.N, layer.params.i_in_size);

% length of record
len=round(T/dt);

% Record output spikes and firing rate
rec.out_spikes=zeros(len, layer.params.N);
rec.firing_rate=zeros(len, layer.params.N);

% Record synapse and voltage data
if debug>1
    % record neural data
    rec.v=zeros(len, layer.params.N);

    % record synaptic data
    rec.rAMPA=zeros(len,layer.params.N);
    rec.rNMDA=zeros(len,layer.params.N);
    rec.rGABAa=zeros(len,layer.params.N);
    rec.rGABAb=zeros(len,layer.params.N);
    rec.sGABAb=zeros(len,layer.params.N);
    rec.IAMPA=zeros(len,layer.params.N);
    rec.INMDA=zeros(len,layer.params.N);
    rec.IGABAa=zeros(len,layer.params.N);
    rec.IGABAb=zeros(len,layer.params.N);
end

