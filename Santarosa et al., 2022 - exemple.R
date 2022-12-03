library(ggplot2)
library(rjags) #Instalar manualmente o JAGS 4.3. 0
library(R2jags)
library(simmr)
library(bayesplot)
library(Rcpp)
library(rstanarm)

mix = matrix(c(-6.78, -7, -6.02, -6.64, -7.04, -6.93, -7.41, -6.73, -7.53, -6.08, -6.74, 
               -7.64, -7.78, -7.06,-7.14,-5.88,-6.62,-6.47,-7.64,-7.46,-7.3,-6.87,-7.08,
               -6.72,-7.11,-8.55,-6.52,-6.88,-7.25,-7.04,-5.7,-6.37,-6.75,-6.66,-6.61,-7.09,
               -6.91,-6.69,-5.8,-6.82,-7.07,-6.34,-6.08,-6.19,-5.66,-5.44,-6.49,-7.07,-6.78,
               -6.56,-7.17,-7.52,-7.25,-5.79,-6.84,-6.83,-7.1,-6.38, -6.58,-6.77,-5.69,-5.91,-5.28,-5.18,-6.14,-5.83,-3.87,-5.43,-3.72,
               -4.71,-4.83,-4.94,-5.26,-5.38,-4.91,-4.72,-4.86,-5.65,-5.66,-5.79,
               -5.48,-4.89,-4.69,-5.73,-5.79,-6.75,-7.65,-6.17,-6.66, -7.16, -6.27, 
               -7, -6.34, -9.42, -7.74, -6.52, -5.95,-5.85,-7,-7.94,-8.47,-7.33,-7.18,
               -6.88,-5.42,-4.87,-8.82,-6,-7.51,-6.68,-6.86,-8.43,-9.13,-9.35,-9.49,
               -8.33,-8.63,-10.21, -41.4, -43.4, -39.8,-40.2,-42.7,-44.9,-48.8,-42.8,-49.3,-37.5,-44.5,-43.1,-45.8,-45.2,-46.6,-37.5,-41.6,-41.7,
               -49.8,-48.4,-46.7,-45.3,-50.9,-46.6,-47.3,-52.4,-40.5,-36.6,-39.9,-42.7,-34.2,-40.3,
               -41.5,-41,-40.4,-43.9,-42.1,-41.5,-35.2,-40.6,-42.8,-43.9,-42.5,-42.7,-38.9,-33.2,
               -40.5,-45.6,-42.7,-40.4,-43,-44.2,-44.4,-31.5,-42.2,-42,-44,-43.4, -38.3,-40.5,-33,-35.2,-33.7,-32.7,-39.1,-37.3,-19.8,
               -33.2,-17.6,-31.7,-30.8,-31,-32.5,-34.2,-28.8,-29.6,-34.3,-36.3,-34.6,-36.8,
               -34.3,-31.1,-30.2,-35.4,-35.6,-40.7,-44.1,-35.4,-37.5, -44, -38.8,-46.6,-42.7,
               -63.8,-51.5,-41.1,-37.9,-39.3,-47.8,-54.6,-58.9,-52.3,-51,-45.7,-38.8,-36.7,
               -65.6,-39.8,-55.9,-45.8,-46.6,-57.9,-56.5,-64.1,-62.1,-53.5,-55.8,-65.8), ncol=2, nrow=118)

colnames(mix) = c('d18O','d2H')

s_names = c("Rain", "GRW")

s_means = matrix(c(-5.81,-6.9,
                   -32.52,-45.05), ncol=2, nrow=2)
s_sds = matrix(c(2.89,0.43,
                 23.92,3.41), ncol=2, nrow=2)

simmr_in = simmr_load(mixtures=mix,
                      source_names=s_names,
                      source_means=s_means,
                      source_sds=s_sds)

plot(simmr_in)
plot(simmr_in,xlab=expression(paste(delta^18, "O (\u2030)",sep="")), 
     ylab=expression(paste(delta^2, "H (\u2030)",sep="")), 
     title='Isospace plot of example data')

simmr_out = simmr_mcmc(simmr_in)

summary(simmr_out,type='diagnostics')
summary(simmr_out,type='statistics')
summary(simmr_out,type='quantiles')
plot(simmr_out,type='density')
plot(simmr_out,type='matrix')
compare_sources(simmr_out,source_names=c("Rain", "GRW"))

plot(simmr_out,type='boxplot', title = "Sources contribution",
     ggargs = 
       theme_classic()+
       theme(legend.position = "", 
             panel.background = element_rect(fill = "White", colour = "white",
                                             size = 1, linetype = "solid"),
             panel.grid.major.x = element_line(size = 1.5, linetype = 'dashed',
                                               colour = "grey40"), 
             panel.grid.minor = element_line(size = 1, linetype = 'dotted',
                                             colour = "white"),
             text = element_text(family = "Arial", size = 36, color = "black"),
             axis.text = element_text(size = 36, colour = "black"), 
             line = element_line(colour = "black", size = 3)))

