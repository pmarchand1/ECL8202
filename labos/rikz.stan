data {
  int<lower=1> n_obs; // Nombre d'observations
  int<lower=1> n_plages; // Nombre de plages
  int<lower=0> richesse[n_obs]; // Richesse spécifique
  vector[n_obs] nap;
  int<lower=1, upper=n_plages> plage[n_obs]; // Plage correspondant à chaque obs.
  int<lower=1> n_exp; // Nombre de niveaux de la variable exposure
  int<lower=1, upper = n_exp> exposure[n_plages];
}

parameters {
  vector[n_plages] b0;
  real b_nap;
  vector[n_exp] b0_exp; // Ordonnée à l'origine moyenne pour chaque niveau d'exposure
  real<lower=0> sigma_b0; // Écart-type de l'ordonnée à l'origine
}

model {
  vector[n_obs] log_lambda;
  
  b_nap ~ normal(0, 1);
  b0_exp ~ normal(2, 1);
  sigma_b0 ~ normal(0, 0.5);
  
  b0 ~ normal(b0_exp[exposure], sigma_b0);
  log_lambda = b0[plage] + b_nap * nap;
  richesse ~ poisson_log(log_lambda);
} 
