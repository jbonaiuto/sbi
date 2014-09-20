% Runs inhibitory synapses in a layer
% Parameters
%     layer=layer to run (created with initLayer)
%     input=input spikes
%     t=current simulation time
%     dt=time step
% Returns
%     layer=layer that was run
function layer=runInhibitorySynapses(layer, input, t, dt)

%%% Run GABAA synapses
%% run unoptimized algorithm if muscimol
if layer.params.muscimol>0
    total_neurotrans=input.*layer.params.t_max+rand(size(input)).*repmat(layer.muscimol,1,size(input,2));
    layer.rGABAa=max(zeros(size(layer.rGABAa)),min(ones(size(layer.rGABAa)),layer.rGABAa+dt.*(layer.params.alpha_gabaa.*total_neurotrans.*(1-layer.rGABAa)-layer.params.beta_gabaa.*layer.rGABAa)));
    layer.rGABAaon=sum(layer.rGABAa,2);
%% run optimized algorithm if no muscimol
else
    %% Update total normalized conductances based on currently active synapses
    % indices of active synapses
    [post pre]=find(input>0);
    nGABAaActive=0;
    if post
        post=reshape(post,length(post),1);
        pre=reshape(pre,length(pre),1);
        activeIdx=sub2ind(size(input),post,pre);

        % time since last spike (ISI in Lytton, 1996)
        timeDiff=t-layer.last_i_input(activeIdx)*dt;

        % update normalized conductances for active synapses (equation 3.3b in 
        % Lytton, 1996)
        layer.rGABAa(activeIdx)=layer.rGABAa(activeIdx).*...
            exp(-layer.params.beta_gabaa.*timeDiff);

        % update last input times for active synapses
        layer.last_i_input(activeIdx)=round(t/dt);

        % normalized conductances for each synapse (g'_{i} in Lytton, 1996)
        g_prime_gabaa=layer.gGABAa(activeIdx)./layer.params.g_gabaa_max;

        r_prime_gabaa=accumarray(post, g_prime_gabaa.*layer.rGABAa(activeIdx),...
            [layer.params.N 1]);

        % update total normalized conductances
        layer.rGABAaon=layer.rGABAaon+r_prime_gabaa;
        layer.rGABAaoff=layer.rGABAaoff-r_prime_gabaa;

        % sum of normalized conductances of active synapses (N_{on} in Lytton,
        % 1996)
        nGABAaActive=accumarray(post, g_prime_gabaa, [layer.params.N 1]);
    end
    %%

    %% Update total normalized conductances based on synapses active in the
    % last time step
    % indices of synapses active in the last time step
    [post pre]=find(layer.last_i_input==round(t/dt)-1);
    if post
        post=reshape(post,length(post),1);
        pre=reshape(pre,length(pre),1);
        lastActiveIdx=sub2ind(size(input),post, pre);

        % time since last spike (ISI in Lytton 1996)    
        timeDiff=t-layer.last_i_input(lastActiveIdx)*dt;

        % update normalized conductance for synapses that were active in the last
        % time step (equation 3.3a in Lytton 1996)
        layer.rGABAa(lastActiveIdx)=layer.params.rinf_gabaa+...
            (layer.rGABAa(lastActiveIdx)-layer.params.rinf_gabaa).*...
            exp(-timeDiff/layer.params.taur_gabaa);

        % update total normalized conductances
        g_prime_gabaa=layer.gGABAa(lastActiveIdx)./layer.params.g_gabaa_max;

        r_prime_gabaa=accumarray(post, g_prime_gabaa.*layer.rGABAa(lastActiveIdx),...
            [layer.params.N 1]);

        % update total normalized conductances
        layer.rGABAaon=layer.rGABAaon-r_prime_gabaa;
        layer.rGABAaoff=layer.rGABAaoff+r_prime_gabaa;
    end
    %%

    % update total normalized conductances
    % equation 3.2a in Lytton 1996
    layer.rGABAaon=nGABAaActive*layer.params.rinf_gabaa+(layer.rGABAaon-...
        nGABAaActive*layer.params.rinf_gabaa)*layer.params.exp1_gabaa;
    % equation 3.2b in Lytton 1996
    layer.rGABAaoff=layer.rGABAaoff*layer.params.exp2_gabaa;
end


%% Run GABAB synapses
% update percentage of open channels for each synapse (equation 1.22a in
% Destexhe et al 1996)
layer.rGABAb=layer.rGABAb+dt*(layer.params.k1_gabab.*input.*...
    layer.params.t_max.*(1-layer.rGABAb)-layer.params.k2_gabab.*...
    layer.rGABAb);
% update concentration of G-protein for GABAb (equation 1.22b in Destexhe
% et al 1996)
layer.sGABAb=layer.sGABAb+dt*(layer.params.k3_gabab.*layer.rGABAb-...
    layer.params.k4_gabab.*layer.sGABAb);
s_n=layer.sGABAb.^layer.params.n_gabab;
layer.sGABAbSum=sum((layer.gGABAb./layer.params.g_gabab_max).*s_n./...
    (s_n+layer.params.kd_gabab),2);

% compute synaptic currents
layer.IGABAa=layer.params.g_gabaa_hat.*(layer.rGABAaon+...
    layer.rGABAaoff).*(layer.v-layer.params.V_gabaa);
% equation 1.22c from Destexhe et al 1996
layer.IGABAb=layer.params.g_gabab_hat.*layer.sGABAbSum.*(layer.v-...
    layer.params.V_gabab);
%%

