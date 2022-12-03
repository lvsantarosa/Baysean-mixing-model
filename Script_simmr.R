library(ggplot2)
library(rjags) #Install the JAGS-4.3.1.exe 
library(R2jags)
library(simmr)
library(bayesplot)
library(Rcpp)
library(rstanarm)
library(readxl)


## This spreadsheet is to input data set mode easily

Exemple <- read_excel("Exemple.xlsx")

## Here is to select the tracer used, the method was produced to analyze N and C isotopes
## In this example I used water-stable isotopes (H and O) and deuterium excess (d-excess), another tracer can be tested.
## Is recommended to work only with O and H or d-excess
## See my publications to appreciate some examples
## The simmr package present other modes of analysis in the examples

## Select the tracers/isotopes dataset to do the simulation
mix = matrix(c(Exemple$O, Exemple$H, Exemple$D), nrow = 110, ncol = 3)

## This column can represent multi-site sampling, experiments, or time periods.
## In a test, I found a limit equal to 100 groups
groups = Exemple$Group

## Here the names of tracers/isotopes selected
colnames(mix) = Exemple$col_names[1:3]

## Input the endmembers of sources to find the proportion in the dataset
s_names = Exemple$s_names[1:2]

## Input the means and standard deviation of the endmembers of sources 
s_means = matrix(c(Exemple$O_s_means[1:2], Exemple$H_s_means[1:2], Exemple$D_s_means[1:2]), nrow = 2, ncol = 3)
s_sds = matrix(c(Exemple$O_s_sds[1:2], Exemple$H_s_sds[1:2], Exemple$D_s_sds[1:2]), nrow = 2, ncol = 3)

## Input all variables with the simmr_load function
simmr_in = simmr_load(mixtures=mix,
                      source_names=s_names,
                      source_means=s_means,
                      group = groups,
                      source_sds=s_sds)

# Print
simmr_in

# Plot
plot(simmr_in,
     group = 1:50, xlab = expression(paste(delta^18, "O", sep = "")),
     ylab = expression(paste(delta^2, "H", sep = "")),
     title = "Plot "
)

# Run MCMC for each group
simmr_out <- simmr_mcmc(simmr_in)

# Print output
simmr_out

# Summarise output, you can chage the groups to present the metrics 
summary(simmr_out, type = "quantiles", group = 1)
summary(simmr_out, type = "quantiles", group = c(1:110))
summary(simmr_out, type = c("quantiles", "statistics"), group = c(1, 3))

# Plot - only a single group allowed
plot(simmr_out, type = "boxplot", group = 5, title = "simmr output group 2")
plot(simmr_out, type = c("density", "matrix"), grp = 6, title = "simmr output group 6")

# Compare groups
compare_groups(simmr_out, source = "Groundwater", groups = 1:110)
compare_groups(simmr_out, source = "Rainfall", groups = 1:110)
compare_groups(simmr_out, source = "Rainfall", groups = c(4:5, 7, 2))

               