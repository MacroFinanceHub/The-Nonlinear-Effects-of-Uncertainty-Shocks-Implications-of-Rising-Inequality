// Declare endogenous variables
var y_til pi i_hat y_hat rn_hat nu z a;
// Declare exogenous variables
varexo e_nu e_z e_a;
// Declare parameters
parameters beta sigma psi epsilon_p zeta delta tri rho_nu rho_z rho_a phi_pi phi_y tau lambda Mu_p omega kappa Psi Del_p_pi gamma Phi psi_a sd_e_nu sd_e_z sd_e_a;
//prefs/technology
beta=0.9745;
sigma = 1;
psi = 1;
epsilon_p = 10;
zeta = 105.63;
//asset mrkt
delta = 0.92;
tri = 0.5;
//exo processes
rho_nu = 0.5;
rho_z = 0.5;
rho_a = 0.9;
//monetary policy
phi_pi = 1.5;
phi_y = 0.5/4;
//transfer rule-this is wealth-based rule
tau = 1;
//share of constrained hhs
lambda = 0.21;
//
Mu_p = epsilon_p/(epsilon_p -1);
omega = epsilon_p/(zeta*Mu_p);
kappa = omega*(sigma + psi);
Psi = ((1-lambda)*(1-delta*(1-tau)))/((1-lambda+(Mu_p-1)*(1-delta*(1-tau)*lambda))^2);
//see eqn 18? Pi = 1 at zero inflation ss? 
Del_p_pi = 1 - (zeta/2)*(0)^2;
gamma = ((Del_p_pi*Mu_p -1)*(1-delta*(1-tau))) / ( 1-lambda +(Del_p_pi*Mu_p -1)*(1-delta*(1-tau)*lambda) );
Phi = (lambda*(sigma+psi)*Psi)/(1-lambda*gamma);
//psi_a = (1+psi)/(sigma+psi);
psi_a = 0.5;

load parameterfile
set_param_value('sd_e_nu', sd_e_nu);
set_param_value('sd_e_z', sd_e_z);
set_param_value('sd_e_a', sd_e_a);



// If you change the parameter values you can do this:
// load parameterfile 
// set_param_value('rho_nu', rho_nu)
// set_param_value('rho_vartheta', rho_vartheta);

// Declare NK model
//model(linear);
//y_gap=y_gap(+1)-(1/sigma)*(R-pi(+1));
//pi=beta*pi(+1)+kappa_tilde*y_gap+nu;
//R=delta_pi*pi+delta_y*y_gap+vartheta;
//nu=rho_nu*nu(-1)+e_nu;
//vartheta=rho_vartheta*vartheta(-1)+e_vartheta;

// Declare TANK model-- eqns 13-15 in note
model(linear);
y_til = y_til(+1) - (1/(sigma*(1+Phi))*(i_hat - pi(+1)- rn_hat) ) ;

pi = beta*pi(+1) + kappa*y_til;

i_hat = phi_pi*pi + phi_y*y_hat + nu;
nu = rho_nu*nu(-1)+ e_nu;

rn_hat = (1-rho_z)*z + sigma*(1-rho_a)*psi_a*a;

//y_til = y - yn; no hats? yn_hat = psi_a*a
//try this?
y_til = y_hat - psi_a*a;

// AR1
z = rho_z*z(-1) + e_z;
a = rho_a*a(-1) + e_a;

end;

// Declare shocks
shocks;
var e_nu; stderr sd_e_nu;
var e_z; stderr sd_e_z;
var e_a; stderr sd_e_a;
end;

// Declare simulation command
stoch_simul(irf = 15,nograph);

//checks
model_diagnostics; 

//simulate for 100 quarters: shutting down shocks each time 
stoch_simul(periods = 200, drop = 100, tex);

