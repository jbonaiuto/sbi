% Gets the total synaptic conductances over all synapse types within a
% layer
% Parameters
%     layer=the layer to get synaptic conductance total for (created with
%           initLayer)
% Returns
%     u=total synaptic conductance for this layer
function u=getTotalSynapticConductance(layer)

% AMPA conductance
g_ampa=layer.params.g_ampa_hat.*(layer.rAMPAon+layer.rAMPAoff);
% NMDA conductance
g_nmda=layer.params.g_nmda_hat.*(layer.rNMDAon+layer.rNMDAoff);
% GABAa conductance
g_gabaa=layer.params.g_gabaa_hat.*(layer.rGABAaon+layer.rGABAaoff);
% GABAb conductance
g_gabab=layer.params.g_gabab_hat.*layer.sGABAbSum;
% Total conductance
u=sum(g_ampa+g_nmda+g_gabaa+g_gabab);
