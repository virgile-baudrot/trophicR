data {
  int<lower=1> nData; // number of data
  int<lower=0> nFaeces[nData]; // number of faeces or pellet

  // prey available (e.g. densities of populations)
  real N_avail[nData]; // Number of individual ingested
  
  // prey ingested (e.g. measure of prey in diet)
  int N_diet[nData]; // Number of individual ingested
  
}
parameters {
  real a; // attack rate
  real h; // handling time
  
  real<lower=0> sigma;
}
transformed parameters{
  real<lower=0> phi[nData];
  
  for(i in 1:nData){
      phi[i] = a * N_avail[i] / (1 +  a * h * N_avail[i]) ;
  }
}
model {
  a ~ gamma(1,1);
  h ~ gamma(1,1);
  
  for(i in 1:nData){
      N_diet[i] ~ neg_binomial_2(nFaeces[i]*phi[i], sigma);
  }
}

