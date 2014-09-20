% Initialize voxel parameters
% Returns
%     params=struct of voxel parameters
function params=initVoxelParams()

% synaptic efficacy (value from Zheng et al., 2002)
params.eta=0.01;
% signal decay time constant (value from Zheng et al., 2002)
params.tau_s=1;
% autoregulatory feedback time constant (value from Zheng et al., 2002)
params.tau_f=1/0.9;

% arteriolar blood oxygen concentration (value from Zheng et al., 2002)
params.c_ab=1.0;

% resting net oxygen extraction fraction by capillary bed (value
% from Friston et al., 2000)
params.e_0=0.34;
% capillary transit time (value from Zheng et al., 2002)
params.transitTime=.2;
% parameter (value from Zheng et al., 2002)
params.phi=.15*params.transitTime;
% baseline ratio of tissue and arterial plasma oxygen concentration 
% (value from Zheng et al., 2002)
params.g_0=0.1;
% baseline mean oxygen concentration of the capillary (value from 
% Zheng et al,. 2002)
params.cb_0=0.71;
% ratio c_p/c_b (value from Zheng et al., 2002)
params.r=0.01;
% volume ratio (value from Zheng et al., 2002)
params.v_ratio=50;
% scaling factor (value from Zheng et al., 2002)
params.j=8;
% change in metabolic demand (value from Zheng et al, 2002)
params.k=0.05;

% venous time constant (value from Friston et al., 2000)
params.tau_o=.3;
% resting blood volume fraction (value from Friston et al., 2000)
params.v_0=0.02;
% Grubb's parameter
params.alpha=0.38;

% MR parameters (from Obata et al, 2004)
% strength of main magnetic field (Tesla)
params.B0=4.7;
% echo time (s)
params.TE=.020;
% magnetic field dependent frequency offset (from Behzadi & Liu, 2005)
params.freq_offset=40.3*(params.B0/1.5);
params.k1=4.3*params.freq_offset*params.e_0*params.TE;
% resting intravascular transverse relaxation time (41.4ms at 4T, from
% Yacoub et al, 2001)
params.T_2E=.0414;
% resting extravascular transverse relaxation time (23.5ms at 4T from
% Yacoub et al, 2001)
params.T_2I=.0235;
% effective intravascular spin density (assumed to be equal to
% extravascular spin density, from Behzadi & Liu, 2005)
params.s_e_0=1;
% effective extravascular spin density (assumed to be equal to
% intravascular spin density, from Behzadi & Liu, 2005)
params.s_i_0=1;
% blood signal
params.s_e=params.s_e_0*exp(-params.TE/params.T_2E);
% tissue signal
params.s_i=params.s_i_0*exp(-params.TE/params.T_2I);
% instrinsic ratio of blood to tissue signals at rest
params.beta=params.s_e/params.s_i;
% slope of the intravascular relaxation rate versus extraction fraction
% (from Behzadi & Liu, 2005, 25s^-1 is measured value at 1.5T)
params.r_0=25*(params.B0/1.5)^2;
params.k2=params.beta*params.r_0*params.e_0*params.TE;
params.k3=params.beta-1;

