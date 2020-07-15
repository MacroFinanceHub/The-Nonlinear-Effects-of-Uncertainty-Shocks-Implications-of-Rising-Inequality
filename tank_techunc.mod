// Declare endogenous variables
var y_til pi i_hat y_hat rn_hat nu z a sigma_a sigma_z sigma_nu c_hat h_hat Mu_p_hat c_u_hat gamma_hat;
// Declare exogenous variables
varexo e_nu e_z e_a e_siga e_sigz e_signu;
// Declare parameters
parameters beta sigma psi epsilon_p zeta delta rho_nu rho_z rho_a phi_pi phi_y tau lambda Mu_p omega kappa Psi Del_p_pi gamma Phi psi_a sd_e_nu sd_e_z sd_e_a rho_siga rho_sigz rho_sigz1 rho_sigz2 rho_signu sigma_siga sigma_sigz sigma_signu sd_e_siga sd_e_sigz sd_e_signu;
//prefs/technology
//beta=0.9745; - w-rule, 0.9743 - p-rule , 0.9679 u-rule
beta = 0.9745;
sigma = 1;
//sigma = 2;
psi = 1;
epsilon_p = 10;
zeta = 105.63;
//asset mrkt
delta = 0.92;
//exo processes
rho_nu = 0.5;
//rho_z = 0.99; from basu and bundick
//rho_z = 0.94;
rho_z = 0.5;
rho_a = 0.9;
//rho_a = 0.96;
rho_siga = 0.88;
//rho_siga = 0.5;
//rho_sigz = 0.88;
//rho_sigz = 0.95;%brings difference down to be negative at h=8/9 sooner
//rho_sigz = 0.99;
rho_sigz = 0.85;
rho_sigz1 = 0.88;
rho_sigz2 = 0.08;
rho_signu = 0.88;
//sigma_siga = 0.1;
sigma_siga = 0.05;
//sigma_sigz = 0.1;
sigma_sigz = 0.045;
//sigma_signu = 0.1;
sigma_signu = 0.05;
load parameterfile
set_param_value('sd_e_nu', sd_e_nu);
set_param_value('sd_e_z', sd_e_z);
set_param_value('sd_e_a', sd_e_a);
set_param_value('sd_e_siga', sd_e_siga);
set_param_value('sd_e_sigz', sd_e_sigz);
set_param_value('sd_e_signu', sd_e_signu);
set_param_value('lambda', lambda);
set_param_value('psi_a', psi_a);
//monetary policy
phi_pi = 1.5;
phi_y = 0.5/4;
//transfer rule  of illiquid profits
// tau = 1;-wealth-based rule: profits both liquid and illiquid end up with unconstrained hhs/ tau = 0 - uniform distribtion of illiquid profits across hhs & productivity based rule (no difference in tank model)
tau = 1;
//share of constrained hhs
//lambda = 0.21; //now we vary lambda
//
Mu_p = epsilon_p/(epsilon_p -1);
omega = epsilon_p/(zeta*Mu_p);
kappa = omega*(sigma + psi);
Psi = ((1-lambda)*(1-delta*(1-tau)))/((1-lambda+(Mu_p-1)*(1-delta*(1-tau)*lambda))^2);
//see eqn 18? Pi = 1 at zero inflation ss? 
Del_p_pi = 1 - (zeta/2)*(0)^2;
gamma = ((Del_p_pi*Mu_p -1)*(1-delta*(1-tau))) / ( 1-lambda +(Del_p_pi*Mu_p -1)*(1-delta*(1-tau)*lambda) );
Phi = (lambda*(sigma+psi)*Psi)/(1-lambda*gamma);
//psi_a = 0.5; // this vary's with tightness of the borrowing limit???


// Declare TANK model-- eqns 13-15 in note plus eqns to add uncertainty 24-25 in note. In paper, section 5.1.
//model(linear);
model;
y_til = y_til(+1) - (1/(sigma*(1-Phi))*(i_hat - pi(+1)- rn_hat) ) ;

pi = beta*pi(+1) + kappa*y_til;

i_hat = phi_pi*pi + phi_y*y_hat + nu; 
//i_hat = phi_pi*pi(-1) + phi_y*y_hat + nu; try this last ditch effort?
nu = rho_nu*nu(-1)+ sigma_nu*e_nu;

rn_hat = (1-rho_z)*z + sigma*(1-rho_a)*psi_a*a;

//y_til = y - yn; no hats? yn_hat = psi_a*a
//try this?
y_til = y_hat - psi_a*a;

// AR1
z = rho_z*z(-1) + sigma_z(-1)*e_z;
//z = rho_z*z(-1) + sigma_z*e_z; in slides now!
a = rho_a*a(-1) + sigma_a*e_a;
sigma_a = rho_siga*sigma_a(-1) + sigma_siga*e_siga;
sigma_z = rho_sigz*sigma_z(-1) + sigma_sigz*e_sigz;
sigma_nu = rho_signu*sigma_nu(-1) + sigma_signu*e_signu;

//AR2
//sigma_z = rho_sigz1*sigma_z(-1) + rho_sigz2*sigma_z(-2) + sigma_sigz*e_sigz; 
//sigma_z = rho_sigz1*sigma_z(-1) - y_hat*(1+sigma_z) + sigma_sigz*e_sigz;
//test sigma_z as a function of output gap:

//other aggegates
c_hat = y_hat;
//c_hat = c_hat(+1) - (1/sigma)*(i_hat - pi(+1)) - (1/sigma)*(z(+1)-z) - (h_hat(+1)-h_hat);
h_hat = Phi*y_til;
Mu_p_hat = (1+psi)*a - (sigma+psi)*y_hat;
c_u_hat = c_hat - Phi*y_til;
gamma_hat = -(sigma+psi)*Psi*y_til;

end;

// Declare shocks
shocks;
var e_nu; stderr sd_e_nu;
var e_z; stderr sd_e_z;
var e_a; stderr sd_e_a;
var e_siga; stderr sd_e_siga;
var e_sigz; stderr sd_e_sigz;
var e_signu; stderr sd_e_signu;
end;

// Declare simulation command
stoch_simul(order = 3, nograph);
//stoch_simul;
//stoch_simul(irf = 15);

//checks
model_diagnostics; 

//simulate for 100 quarters: shutting down shocks each time 
//stoch_simul(periods = 200, drop = 100, tex);

