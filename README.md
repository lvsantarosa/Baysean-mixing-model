<h1 align="center">Bayesian Mixing Model for Water Stable Isotopes</h1>

<p align="center">
  <em>Quantifying the proportional contribution of water sources to streamflow with <code>simmr</code> + JAGS</em>
</p>

<p align="center">
  <img alt="R" src="https://img.shields.io/badge/R-%E2%89%A5%204.0-276DC3?logo=r&logoColor=white">
  <img alt="simmr" src="https://img.shields.io/badge/package-simmr-1f6feb">
  <img alt="JAGS" src="https://img.shields.io/badge/requires-JAGS%204.3.1-orange">
  <img alt="Topic" src="https://img.shields.io/badge/topic-stable%20isotope%20hydrology-2ea44f">
</p>

<p align="center">
  <img src="https://user-images.githubusercontent.com/60663771/205453787-4316bce4-7d54-4870-bbb2-9b9343e3bfd8.png" width="650" alt="Example simmr output">
</p>

---

## Overview

This repository provides a ready-to-run **Bayesian isotope mixing model** workflow in R to estimate how much
each source (e.g. **groundwater** vs. **rainfall**) contributes to a water mixture such as river streamflow.

The routine was originally built for **N and C isotopes**, and here it is applied to **water stable isotopes**
(δ<sup>18</sup>O, δ<sup>2</sup>H) and **deuterium excess (d-excess)**. Other tracers can be tested.

> [!TIP]
> It is recommended to work **only with δ<sup>18</sup>O and δ<sup>2</sup>H**, *or* with **d-excess** —
> not all three at once. See the [publications](#papers-that-used-this-method) below for applied examples.

---

## Repository contents

| File | Description |
| --- | --- |
| `Script_simmr.R` | **Main script** — generic, spreadsheet-driven workflow (read `Exemple.xlsx`, run MCMC, plot, compare groups). |
| `Exemple.xlsx` | Example input dataset (110 samples, 2 sources, 3 tracers). |
| `Santarosa et al., 2022 - exemple.R` | Reproducible script with hard-coded data from the published paper. |
| `JAGS-4.3.1.exe` | JAGS installer for Windows (must be installed **before** running the scripts). |
| `simmr.Rproj` | RStudio project file. |

---

## How the model works

The Bayesian mixing model identifies the proportional contributions of various sources to surface water flow.
The stable isotope mixing model package **`simmr`** (R Core Team, 2019) solves mixing equations for stable
isotope data within a Bayesian statistical framework (Parnell, 2019; Parnell et al., 2013, 2010). The approach
accounts for the **uncertainty** of the isotope data of multiple sources (Gokool et al., 2018; Ma and Song, 2016).
Originally, Bayesian mixing models were applied to stable isotope signatures to find the main water sources
consumed by vegetation (Evaristo and McDonnell, 2017; Gokool et al., 2018; Ma and Song, 2016;
Rothfuss and Javaux, 2017; Zhang et al., 2013).

To determine the proportions of water coming from each source, the model requires **three sets of input data
as a minimum**:

1. the **mixture** measurements (the samples to be explained);
2. the **source means** (endmember signatures);
3. the **source standard deviations**.

The proportion of each source's contribution to the river streamflow mixture is then determined with a
**Markov Chain Monte Carlo (MCMC)** routine (Parnell, 2019; Parnell et al., 2010). In the Bayesian context,
MCMC repeatedly evaluates candidate values of the water proportions and retains those that best fit the data
representing the different sources. The simulations produce plausible contributions of groundwater and rainfall
(as proportions) to river streamflow and return a **posterior distribution**, i.e. a true probability density of
the data (Brum et al., 2019; Parnell et al., 2013).

---

## Getting started

### 1. Install JAGS

`simmr` relies on **JAGS**, which is *not* an R package and must be installed separately.

- **Windows:** run the bundled `JAGS-4.3.1.exe` (or download it from [SourceForge](https://sourceforge.net/projects/mcmc-jags/files/)).
- **macOS / Linux:** install JAGS from the same SourceForge page, `brew install jags`, or `sudo apt install jags`.

### 2. Install the R packages

```r
install.packages(c("ggplot2", "rjags", "R2jags", "simmr",
                   "bayesplot", "Rcpp", "rstanarm", "readxl"))
```

### 3. Run the model

Open `simmr.Rproj` in RStudio, then run `Script_simmr.R`. By default it reads `Exemple.xlsx`
from the project folder.

---

## Input data format

`Exemple.xlsx` is a single sheet where the **sample data** and the **source (endmember) data** live side by side.
Replace the values with your own, keeping the column names.

**Samples (one row per sample):**

| Column | Meaning |
| --- | --- |
| `Group` | Group label — multi-site sampling, experiment, or time period (e.g. `T01`, `T02`, …). |
| `O` | δ<sup>18</sup>O of the sample (‰). |
| `H` | δ<sup>2</sup>H of the sample (‰). |
| `D` | d-excess of the sample (‰). |

**Tracers and sources (first rows only):**

| Column | Meaning |
| --- | --- |
| `col_names` | Names of the tracers used, in the same order as the mixture matrix (e.g. `O18`, `H2`, `D-excess`). |
| `s_names` | Names of the sources / endmembers (e.g. `Rainfall`, `Groundwater`). |
| `O_s_means`, `H_s_means`, `D_s_means` | Mean signature of each source for each tracer. |
| `O_s_sds`, `H_s_sds`, `D_s_sds` | Standard deviation of each source for each tracer. |

> [!IMPORTANT]
> The script builds fixed-size matrices, so update `nrow` (number of samples) and `ncol`
> (number of tracers) in `Script_simmr.R`, and the `[1:n]` indexes used for the source columns,
> to match your own dataset.

---

## Workflow at a glance

```r
simmr_in  <- simmr_load(mixtures = mix, source_names = s_names,
                        source_means = s_means, source_sds = s_sds,
                        group = groups)   # 1. load data
plot(simmr_in)                            # 2. isospace plot (check the mixture is bounded by the sources)
simmr_out <- simmr_mcmc(simmr_in)         # 3. run the MCMC
summary(simmr_out, type = "diagnostics")  # 4. check convergence
plot(simmr_out, type = "boxplot", group = 5)             # 5. posterior contributions
compare_groups(simmr_out, source = "Groundwater", groups = 1:110)  # 6. compare groups / time
```

Notes:

- Plotting a `simmr_out` object is allowed for **one group at a time**; `summary()` accepts several groups.
- In testing, the number of groups was limited to about **100**.
- Always inspect the isospace plot first: if the samples fall outside the polygon formed by the sources,
  the sources are not able to explain the mixture.

---

## Papers that used this method

- Santarosa, L. V., Gastmans, D., Sánchez-Murillo, R., Santos, V. dos, Batista, L. V., & Betancur, S. B. (2021).
  Stable isotopes reveal groundwater to river connectivity in a mesoscale subtropical watershed.
  *Isotopes in Environmental and Health Studies*, 57(3), 236–253.
  https://doi.org/10.1080/10256016.2021.1877701

- Gomes Lanças, V., Vituri Santarosa, L., Nogueira Garpelli, L., de Simone Borma, L., Stager Quaggio, C.,
  Teixeira de Souza Martins, V., & Gastmans, D. (2022). Assessment of the changes in contributions from water
  sources to streamflow induced by urbanization in a small-sized catchment in Southeastern Brazil using the dual
  stable isotopes of water (<sup>18</sup>O and <sup>2</sup>H).
  *Environmental Monitoring and Assessment*, 194, 357.
  https://doi.org/10.1007/s10661-022-10040-9

- Santarosa, L. V., Gastmans, D., & Quaggio, C. S. (2022). Stable isotope modeling of the groundwater discharge
  in complex watersheds of the state of São Paulo, Brazil.
  *Journal of South American Earth Sciences*, 120, 104063.
  https://doi.org/10.1016/J.JSAMES.2022.104063

---

## References

Brum, M., Vadeboncoeur, M. A., Ivanov, V., Asbjornsen, H., Saleska, S., Alves, L. F., Penha, D., Dias, J. D.,
Aragão, L. E. O. C., Barros, F., Bittencourt, P., Pereira, L., & Oliveira, R. S. (2019). *Journal of Ecology*.
· Evaristo, J., & McDonnell, J. J. (2017). *Scientific Reports*.
· Gokool, S., Riddell, E. S., Swemmer, A., Nippert, J. B., Raubenheimer, R., & Chetty, K. T. (2018). *Ecohydrology*.
· Ma, Y., & Song, X. (2016). *Journal of Hydrology*.
· Parnell, A. (2019). *simmr: A Stable Isotope Mixing Model* (R package).
· Parnell, A. C., Inger, R., Bearhop, S., & Jackson, A. L. (2010). *PLoS ONE*.
· Parnell, A. C., Phillips, D. L., Bearhop, S., Semmens, B. X., Ward, E. J., Moore, J. W., Jackson, A. L.,
Grey, J., Kelly, D. J., & Inger, R. (2013). *Environmetrics*.
· R Core Team (2019). *R: A Language and Environment for Statistical Computing*.
· Rothfuss, Y., & Javaux, M. (2017). *Biogeosciences*.
· Zhang, Y., Shen, Y., Sun, H., & Gates, J. B. (2013). *Hydrological Processes*.

---

## Contact

Questions, suggestions, or an application you would like to share?
Open an [issue](../../issues) or get in touch — contributions are welcome.
