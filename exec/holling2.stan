data {
  int<lower=1> nData; // number of data
  int<lower=1> nSpecies; // number of species
  int<lower=0> nFaeces[nData]; // number of faeces or pellet
  
  int spID[nData]; // identification of species
  int spID_posmin[nSpecies]; //
  int spID_posmax[nSpecies];

  // prey available (e.g. densities of populations)
  real N_avail[nData, nSpecies]; // Number of individual ingested

  // prey ingested (e.g. measure of prey in diet)
  int N_diet[nData, nSpecies]; // Number of individual ingested

}
parameters {
  real a[nSpecies]; // attack rate
  real h[nSpecies]; // handling time
  
  real<lower=0> sigma;
}
transformed parameters{
  real<lower=0> phi[nData, nSpecies];

  for(i in 1:nData){
    for(j in 1:nSpecies){
    phi[i, j] = a[j] * N_avail[i,j] / (1 +  a[j] * h[j] * sum(N_avail[i,1:nSpecies]) ) ;
    }
  }
}
model {
  a ~ gamma(1,1);
  h ~ gamma(1,1);

  for(i in 1:nData){
    for(j in 1:nSpecies){
      N_diet[i, j] ~ neg_binomial_2(nFaeces[i]*phi[i, j], sigma);
    }
  }
}
generated quantities{
  real lik[nData, nSpecies];  // pointwise predictive density
  real rep[nData, nSpecies]; //predicted values
  
  for(i in 1:nData) {
    for(j in 1:nSpecies){
      lik[i, j] = exp(neg_binomial_2_lpmf(N_diet[i, j] | nFaeces[i]*phi[i, j], sigma));
      rep[i, j] = neg_binomial_2_rng(nFaeces[i]*phi[i, j], sigma);
    }
  }
}
