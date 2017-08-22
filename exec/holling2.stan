data {
  int<lower=1> nData; // number of data
  int<lower=1> nSpecies; // number of species
  int<lower=0> nFaeces[nData]; // number of faeces or pellet
  
  // prey available (e.g. densities of populations)
  matrix[nData, nSpecies] N_avail; // Number of individual ingested

  // prey ingested (e.g. measure of prey in diet)
  int N_diet[nData, nSpecies]; // Number of individual ingested

}
parameters {
  row_vector<lower=0>[nSpecies] a; // attack rate
  row_vector<lower=0>[nSpecies] h; // handling time
  
  real<lower=0> sigma;
}
transformed parameters{
  matrix<lower=0>[nData, nSpecies] phi;

  for(i in 1:nData){
    for(j in 1:nSpecies){
      //sum_avail[i,j] = a[j] * h[j] * N_avail[i,j];
      //phi[i, j] = a[j] * N_avail[i,j] / (1 + sum(sum_avail[i,1:nSpecies]));
      phi[i, j] = a[j] * N_avail[i,j] / (1 +  sum(a .* h .* N_avail[i] ));
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
