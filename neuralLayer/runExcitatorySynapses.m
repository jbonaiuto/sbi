% Runs excitatory synapses in a layer
% Parameters
%     layer=layer to run (created with initLayer)
%     input=input spikes
%     t=current simulation time
%     dt=time step
% Returns
%     layer=layer that was run
function layer=runExcitatorySynapses(layer, input, t, dt)

%% Update total normalized conductances based on currently active synapses
% indices of active synapses
[post pre]=find(input>0);
nAMPAActive=0;
nNMDAActive=0;
if post
    post=reshape(post,length(post),1);
    pre=reshape(pre,length(pre),1);
    activeIdx=sub2ind(size(input),post,pre);

    % time since last spike (ISI in Lytton, 1996)
    timeDiff=t-layer.last_e_input(activeIdx)*dt;

    % update normalized conductances for active synapses (equation 3.3b in 
    % Lytton, 1996)
    layer.rAMPA(activeIdx)=layer.rAMPA(activeIdx).*...
        exp(-layer.params.beta_ampa.*timeDiff);
    layer.rNMDA(activeIdx)=layer.rNMDA(activeIdx).*...
        exp(-layer.params.beta_nmda.*timeDiff);

    % update last input times for active synapses
    layer.last_e_input(activeIdx)=round(t/dt);

    % normalized conductances for each synapse (g'_{i} in Lytton, 1996)
    g_prime_ampa=layer.gAMPA(activeIdx)./layer.params.g_ampa_max;
    g_prime_nmda=layer.gNMDA(activeIdx)./layer.params.g_nmda_max;

    r_prime_ampa=accumarray(post, g_prime_ampa.*layer.rAMPA(activeIdx),...
        [layer.params.N 1]);
    r_prime_nmda=accumarray(post, g_prime_nmda.*layer.rNMDA(activeIdx),...
        [layer.params.N 1]);

    % update total normalized conductances
    layer.rAMPAon=layer.rAMPAon+r_prime_ampa;
    layer.rAMPAoff=layer.rAMPAoff-r_prime_ampa;
    layer.rNMDAon=layer.rNMDAon+r_prime_nmda;
    layer.rNMDAoff=layer.rNMDAoff-r_prime_nmda;

    % sum of normalized conductances of active synapses (N_{on} in
    % Lytton, 1996)
    nAMPAActive=accumarray(post, g_prime_ampa, [layer.params.N 1]);
    nNMDAActive=accumarray(post, g_prime_nmda, [layer.params.N 1]);
end
%%

%% Update total normalized conductances based on synapses active in the
% last time step
% indices of synapses active in the last time step
[post pre]=find(layer.last_e_input==round(t/dt)-1);
if post
    post=reshape(post,length(post),1);
    pre=reshape(pre,length(pre),1);
    lastActiveIdx=sub2ind(size(input),post,pre);

    % time since last spike (ISI in Lytton 1996)    
    timeDiff=t-layer.last_e_input(lastActiveIdx)*dt;

    % update normalized conductance for synapses that were active in the last
    % time step (equation 3.3a in Lytton 1996)
    layer.rAMPA(lastActiveIdx)=layer.params.rinf_ampa+...
        (layer.rAMPA(lastActiveIdx)-layer.params.rinf_ampa).*...
        exp(-timeDiff/layer.params.taur_ampa);
    layer.rNMDA(lastActiveIdx)=layer.params.rinf_nmda+...
        (layer.rNMDA(lastActiveIdx)-layer.params.rinf_nmda).*...
        exp(-timeDiff/layer.params.taur_nmda);

    % normalized conductances for each synapse (g'_{i} in Lytton, 1996)
    g_prime_ampa=layer.gAMPA(lastActiveIdx)./layer.params.g_ampa_max;
    g_prime_nmda=layer.gNMDA(lastActiveIdx)./layer.params.g_nmda_max;

    r_prime_ampa=accumarray(post, g_prime_ampa.*layer.rAMPA(lastActiveIdx),...
        [layer.params.N 1]);
    r_prime_nmda=accumarray(post, g_prime_nmda.*layer.rNMDA(lastActiveIdx),...
        [layer.params.N 1]);

    % update total normalized conductances
    layer.rAMPAon=layer.rAMPAon-r_prime_ampa;
    layer.rAMPAoff=layer.rAMPAoff+r_prime_ampa;
    layer.rNMDAon=layer.rNMDAon-r_prime_nmda;
    layer.rNMDAoff=layer.rNMDAoff+r_prime_nmda;
end
%%

% update total normalized conductances
% equation 3.2a in Lytton 1996
layer.rAMPAon=nAMPAActive*layer.params.rinf_ampa+(layer.rAMPAon-...
    nAMPAActive*layer.params.rinf_ampa)*layer.params.exp1_ampa;
layer.rNMDAon=nNMDAActive*layer.params.rinf_nmda+(layer.rNMDAon-...
    nNMDAActive*layer.params.rinf_nmda)*layer.params.exp1_nmda;

% equation 3.2b in Lytton 1996
layer.rAMPAoff=layer.rAMPAoff*layer.params.exp2_ampa;
layer.rNMDAoff=layer.rNMDAoff*layer.params.exp2_nmda;

% compute synaptic currents   
layer.IAMPA=layer.params.g_ampa_hat.*(layer.rAMPAon+layer.rAMPAoff).*...
    (layer.v-layer.params.V_ampa);
layer.INMDA=layer.params.g_nmda_hat.*(layer.rNMDAon+layer.rNMDAoff).*...
    (1./(1+exp(-.062.*layer.v.*layer.params.CMg/3.57))).*(layer.v-...
    layer.params.V_nmda);
