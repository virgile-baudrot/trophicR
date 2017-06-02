data {
  int<lower=1> n_data; // number of data

  real Ningest[n_data]; // number of data

}
transformed data {


}
parameters {
  real[n_data] a; // attack rate
  real[n_data] h; // handling time

}

transformed parameters{


}
model {

  real<lower=0> ingest; //
  real<lower=0> sigma;

  ingest = a*Ningest/(1+a*h*Ningest);

  Ningest ~ normal(ingest, sigma);

}
