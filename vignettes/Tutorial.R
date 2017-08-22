## ------------------------------------------------------------------------
library(trophicR)
library(ggplot2)
library(dplyr)
library(rstan)

## ----H2testData----------------------------------------------------------
 data("data_H2test")

## ------------------------------------------------------------------------
plt_H2test <- ggplot() + theme_light() +
  labs(x = "prey available", y = "prey ingested") +
  geom_point(aes(x = data_H2test$N_avail, y = data_H2test$N_diet))
plt_H2test

## ----H2testFit-----------------------------------------------------------
fit_H2test <- trophicFit_H2test(data = data_H2test)

## ------------------------------------------------------------------------
result_H2test <- extract(fit_H2test, pars = c('a', 'h', 'phi'))
phi_q50 <- apply(result_H2test$phi, 2, quantile, probs = 0.5, na.rm = TRUE)
phi_qinf95 <- apply(result_H2test$phi, 2, quantile, probs = 0.025, na.rm = TRUE)
phi_qsup95 <- apply(result_H2test$phi, 2, quantile, probs = 0.975, na.rm = TRUE)

plt_H2test + geom_point(aes(x = data_H2test$N_avail, y = phi_q50), color="red") +
  geom_errorbar(aes(x = data_H2test$N_avail, ymin = phi_qinf95, ymax = phi_qsup95), color="pink") + 
  geom_ribbon(aes(x = data_H2test$N_avail, ymin = phi_qinf95, ymax = phi_qsup95), fill="pink", alpha = 0.3)

## ----foxData-------------------------------------------------------------
data("fox_Raoul2010")

# plot of the data set
df_fox <- data.frame(density = c(fox_Raoul2010$N_avail[,1], fox_Raoul2010$N_avail[,2]),
                     diet = c(fox_Raoul2010$N_diet[,1], fox_Raoul2010$N_diet[,2] ),
                     species = c(rep("Arvicola scherman",41), rep("Microtus arvalis", 41)))

plt_foxData <- ggplot(data = df_fox) + theme_light() +
  labs(x = "prey available", y = "prey ingested") +
  geom_point(aes(x = density, y = diet, color = species))
plt_foxData

## ----foxFitH2------------------------------------------------------------
fit_foxH2 <- trophicFit(data = fox_Raoul2010, trophic_model = "holling2")

