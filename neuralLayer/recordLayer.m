% Update the struct storing layer activity with data from the current time step
% Parameters
%     layer=the layer whose activity to record
%     e_input=excitatory input in the current time step (spikes)
%     i_input=inhibitory input in the current time step (spikes)
%     rec=the struct of layer activity to update
%     t=the current time (in seconds)
%     dt=simulation time step (in seconds)
%     debug=debug level (>1 records synaptic activity)
function rec=recordLayer(layer, e_input, i_input, rec, t, dt, debug)

% push spikes to stack

%rec.in_e_spikes=[reshape(e_input,[1,layer.params.N,layer.params.e_in_size]);...
%    rec.in_e_spikes(1:end-1,:,:)];
rec.in_e_spikes=[shiftdim(e_input,-1); rec.in_e_spikes(1:end-1,:,:)];
rec.in_i_spikes=[shiftdim(i_input,-1); rec.in_i_spikes(1:end-1,:,:)];

% index to store data at
idx=round(t/dt);
rec.out_spikes(idx,:)=layer.spikes;

if debug>1
    % record neural data
    rec.v(idx,:)=layer.v;

    % record synaptic data
    rec.rAMPA(idx,:)=layer.rAMPAon+layer.rAMPAoff;
    rec.rNMDA(idx,:)=layer.rNMDAon+layer.rNMDAoff;
    rec.rGABAa(idx,:)=layer.rGABAaon+layer.rGABAaoff;
    rec.rGABAb(idx,:)=sum(layer.rGABAb,2);
    rec.sGABAb(idx,:)=layer.sGABAbSum;
    rec.IAMPA(idx,:)=layer.IAMPA;
    rec.INMDA(idx,:)=layer.INMDA;
    rec.IGABAa(idx,:)=layer.IGABAa;
    rec.IGABAb(idx,:)=layer.IGABAb;
end

