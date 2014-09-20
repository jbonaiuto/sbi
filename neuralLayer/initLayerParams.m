% Initialize layer parameters
% Parameters
%     N=size of layer (number of neurons)
%     type=type of neurons 
%          RS=regular spiking, 
%          CH=chattering, 
%          RS-CH=randomly distributed between regular spiking and 
%                chattering, 
%          FS=fast spiking,
%          LTS=low-threshold spiking, 
%          FS-LTS=randomly distributed between fast spiking and low 
%                 threshold spiking
% Returns
%     layerParams=struct of layer parameters
function layerParams=initLayerParams(N, type)

% Set number of neurons
layerParams.N=N;

% maximal concentration of neurotransmitter released during a pulse (mM)
layerParams.t_max=1*10^-3;

%% Initialize neural parameters
% Initialize regular spiking cells
if strcmp(type,'RS')>0
    % From Izhikevich et al (2004)
    % (a,b,c,d,k,vpeak)=(.03,-2,-50,100,0.7,35)
    % corresponds to regular spiking (RS) cell
    % majority of pyramidal cortex in mammalian cortex are RS type 
    % (Steriade et al., 2001)
    layerParams.a=0.03*ones(N,1);
    layerParams.b=-2*ones(N,1);
    layerParams.c=-50*ones(N,1);
    layerParams.d=100*ones(N,1);
    layerParams.k=0.7*ones(N,1);
    % Membrane capacitance
    layerParams.Cm=100*ones(N,1);
    % Resting membrane potential
    layerParams.vr=-60*ones(N,1);
    % Membrane potential threshold
    layerParams.vt=-40*ones(N,1);
    % Peak membrane potential
    layerParams.vpeak=35*ones(N,1);
% Initialize chattering cells
elseif strcmp(type,'CH')>0
    % From Izhikevich et al (2004)
    % (a,b,c,d,k,vpeak)=(.03,-2,-40,150,1.5,25)
    % corresponds to regular spiking (RS) cell
    layerParams.a=0.03*ones(N,1);
    layerParams.b=-2*ones(N,1);
    layerParams.c=-40*ones(N,1);
    layerParams.d=150*ones(N,1);
    layerParams.k=1.5*ones(N,1);
    % Membrane capacitance
    layerParams.Cm=100*ones(N,1);
    % Resting membrane potential
    layerParams.vr=-60*ones(N,1);
    % Membrane potential threshold
    layerParams.vt=-40*ones(N,1);
    % Peak membrane potential
    layerParams.vpeak=25*ones(N,1);
% Randomly distributed between regular spiking cells and chattering cells 
% (biased to regular spiking cells)
elseif strcmp(type,'RS-CH')>0
    layerParams.a=0.03*ones(N,1);
    layerParams.b=-2*ones(N,1);
    layerParams.c=-50+10.*rand(N,1).^2;
    layerParams.d=100+50*rand(N,1).^2;
    layerParams.k=0.7+0.8*rand(N,1).^2;
    % Membrane capacitance
    layerParams.Cm=100*ones(N,1);
    % Resting membrane potential
    layerParams.vr=-60*ones(N,1);
    % Membrane potential threshold
    layerParams.vt=-40*ones(N,1);
    % Peak membrane potential
    layerParams.vpeak=35-10*rand(N,1).^2;
% Initialize fast spiking cells
elseif strcmp(type,'FS')>0
    % From Izhikevich et al (2004)
    % (a,b,c,d,k,Cm,vr,vt,vpeak)=(0.1,0.2,-65,20,1,100,-56,-38,40)
    % corresponds to fast spiking (FS) interneuron.
    layerParams.a=0.1*ones(N,1);
    layerParams.b=0.2*ones(N,1);
    layerParams.c=-65.0*ones(N,1);
    layerParams.d=20*ones(N,1);
    layerParams.k=1*ones(N,1);
    % Membrane capacitance
    layerParams.Cm=100*ones(N,1);
    % Resting membrane potential
    layerParams.vr=-56*ones(N,1);
    % Membrane potential threshold
    layerParams.vt=-38*ones(N,1);
    % Peak membrane potential
    layerParams.vpeak=40*ones(N,1);
% Initialize low threshold spiking cells
elseif strcmp(type,'LTS')>0
    % From Izhikevich et al (2004)
    % (a,b,c,d,k,Cm,vr,vt,vpeak)=(0.02,0.25,-65,150,1.5,50,-60,-40,25)
    % corresponds to fast spiking (FS) interneuron.
    layerParams.a=0.02*ones(N,1);
    layerParams.b=0.25*ones(N,1);
    layerParams.c=-65.0*ones(N,1);
    layerParams.d=150*ones(N,1);
    layerParams.k=1.5*ones(N,1);
    % Membrane capacitance
    layerParams.Cm=50*ones(N,1);
    % Resting membrane potential
    layerParams.vr=-60*ones(N,1);
    % Membrane potential threshold
    layerParams.vt=-40*ones(N,1);
    % Peak membrane potential
    layerParams.vpeak=25*ones(N,1);
% Randomly distributed between fast spiking and low threshold spiking cells
elseif strcmp(type,'FS-LTS')>0
    layerParams.a=0.02+0.08*rand(N,1);
    layerParams.b=0.25-0.05*rand(N,1);
    layerParams.c=-65.0-0*rand(N,1);
    layerParams.d=150.0-130*rand(N,1);
    layerParams.k=1.5-.5*rand(N,1);
    % Membrane capacitance
    layerParams.Cm=50+50*rand(N,1);
    % Resting membrane potential
    layerParams.vr=-60+4*rand(N,1);
    % Membrane potential threshold
    layerParams.vt=-40-2*rand(N,1);
    % Peak membrane potential
    layerParams.vpeak=25+15*rand(N,1);
end
%%

%% Initialize AMPA synapse parameters
% AMPA maximal conductance 0.35-1.0 nS (Destexhe et al., 1996)
layerParams.g_ampa_min=0.35;
layerParams.g_ampa_max=1.0;
% (G^{hat} in Lytton 1996)
layerParams.g_ampa_hat=layerParams.g_ampa_max;
% AMPA conductance rise time constant 1.1*10^6 M^-1s^-1 (Destexhe et al., 
% 1996)
layerParams.alpha_ampa=1.1*10^6;
% AMPA conductance decay time constant 190s^-1 (Destexhe et al., 1996)
layerParams.beta_ampa=190;
% steady-state r value (R_{inf} in Lytton 1996)
layerParams.rinf_ampa=(layerParams.alpha_ampa*layerParams.t_max)/...
    (layerParams.alpha_ampa*layerParams.t_max+layerParams.beta_ampa);
% time constant (\tau_{R} in Lytton 1996)
layerParams.taur_ampa=1/(layerParams.alpha_ampa*layerParams.t_max+...
    layerParams.beta_ampa);
%%

%% Initialize NMDA synapse parameters
% NMDA maximal conductance 0.01-0.6 nS (Destexhe et al., 1996) (G^{hat} in 
% Lytton 1996)
layerParams.g_nmda_min=0.01;
layerParams.g_nmda_max=0.6;
% (G^{hat} in Lytton 1996)
layerParams.g_nmda_hat=layerParams.g_nmda_max;
% NMDA conductance rise time constant 7.2*10^4 M^-1s^-1 (Destexhe et al., 
% 1996)
layerParams.alpha_nmda=7.2*10^4;
% NMDA conductance decay time constant 6.6 s^-1 (Destexhe et al., 1996)
layerParams.beta_nmda=6.6;
% steady-state r value (R_{inf} in Lytton 1996)
layerParams.rinf_nmda=(layerParams.alpha_nmda*layerParams.t_max)/...
    (layerParams.alpha_nmda*layerParams.t_max+layerParams.beta_nmda);
% time constant (\tau_{R} in Lytton 1996)
layerParams.taur_nmda=1/(layerParams.alpha_nmda*layerParams.t_max+...
    layerParams.beta_nmda);
% Extracellular Mg concentration 1-2 mM (Destexhe et al., 1996)
layerParams.CMg=1.5+.5*rand(N,1);
%%

%% Initialize GABA-A synapse parameters
% GABA-A maximal conductance 0.25-1.2 nS (Destexhe et al., 1996) (G^{hat} 
% in Lytton 1996)
layerParams.g_gabaa_min=0.25;
layerParams.g_gabaa_max=1.2;
% (G^{hat} in Lytton 1996)
layerParams.g_gabaa_hat=layerParams.g_gabaa_max;
% GABA-A conductance rise time constant 5*10^6 M^-1s^-1 (Destexhe et al., 
% 1996)
layerParams.alpha_gabaa=5*10^6;
% GABA-A conductance decay time constant 180 s^-1 (Destexhe et al., 1996)
layerParams.beta_gabaa=180;
% steady-state r value (R_{inf} in Lytton 1996)
layerParams.rinf_gabaa=(layerParams.alpha_gabaa*layerParams.t_max)/...
    (layerParams.alpha_gabaa*layerParams.t_max+layerParams.beta_gabaa);
% time constant (\tau_{R} in Lytton 1996)
layerParams.taur_gabaa=1/(layerParams.alpha_gabaa*layerParams.t_max+...
    layerParams.beta_gabaa);
%%

%% Initialize GABA-B synapse parameters
% GABA-B maximal conductance 1 nS for K+ channels (Destexhe et al., 1996)
layerParams.g_gabab_min=.1;
layerParams.g_gabab_max=1;
% (G^{hat} in Lytton 1996)
layerParams.g_gabab_hat=layerParams.g_gabab_max;
% GABA-B conductance rate constant 100 uM^4 (K_{d} in Destexhe et al., 1996)
layerParams.kd_gabab=100;
% GABA-B conductance rate constant 9*10^4M^-1s^-1 (K_{1} in Destexhe 
% et al., 1996)
layerParams.k1_gabab=9*10^4;
% GABA-B conductance rate constant 1.2 s^-1 (K_{2} in Destexhe et al., 
% 1996)
layerParams.k2_gabab=1.2;
% GABA-B conductance rate constant 180 s^-1 (K_{3} in Destexhe et al., 
% 1996)
layerParams.k3_gabab=180;
% GABA-B conductance rate constant 34 s^-1 (K_{4} in Destexhe et al., 1996)
layerParams.k4_gabab=34;
% GABA-B - number of binding sites (n in Destexhe et al., 1996)
layerParams.n_gabab=4;
%%

%% Initialize muscimol-related parameters
% Muscimol level
layerParams.muscimol=0;
% Percentage of neurons in a layer affected by muscimol during injection
layerParams.muscimol_perc=.75;

%% Initialize synaptic current potential parameters
% AMPA current reversal potential
layerParams.V_ampa=0.0;
% NMDA current reversal potential
layerParams.V_nmda=0.0;
% GABAA current reversal potential - chloride reversal potential 
% (Destexhe et al., 1996)
layerParams.V_gabaa=-70.0;
% GABAB current reversal potential - potassium reversal potential
% (Destexhe et al., 1996)
layerParams.V_gabab=-95.0;
%%

%% Axonal delays
% min axonal delay (s)
layerParams.min_delay=.001;
% max axonal delay (s)
layerParams.max_delay=.005;
%%
