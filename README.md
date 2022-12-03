# Baysean-mixing-model

The method was produced to analyze N and C isotopes. In this example I used water-stable isotopes (H and O) and deuterium excess (d-excess), another tracer can be tested.
Is recommended to work only with O and H or d-excess. See my publications to appreciate some examples.

![image](https://user-images.githubusercontent.com/60663771/205453619-4e4003fc-df9b-424d-8bc8-3f32877227da.png)


## Mixing model
The Bayesian mixing model was used to identify the proportional contributions of various sources to surface water flow. The stable isotope mixing model (simmr) package in R (R CoreTeam, 2019) was developed to solve mixing equations for stable isotope data using a Bayesian statistical framework (Parnell, 2019; Parnell et al., 2013, 2010). This model allows identify the proportional contribution and accounts for uncertainties and the isotope data from multiple sources (Gokool et al., 2018; Ma and Song, 2016). In origin, the Bayesian mixing models were applied to identify the signatures of stable isotopes to find the main water sources consumed by vegetation (Evaristo and McDonnell, 2017; Gokool et al., 2018; Ma and Song, 2016; Rothfuss and Javaux, 2017; Zhang et al., 2013).

To determine the proportions of water from a source, the model requires three sets of input data as a minimum. The proportion of each source's contribution to the river streamflow mixture was subsequently determined using a Markov Chain Monte Carlo function (MCMC) (Parnell, 2019; Parnell et al., 2010). In the Bayesian context, the MCMC repeatedly assess the values of the water proportion and finds those values that best fit the data representing different sources. The simulations produce plausible contributions of groundwater and rainfall (in terms of proportion) for the river streamflow and return a posterior distribution representing a true probability density of data (Brum et al., 2019; Parnell et al., 2013).


## References

Santarosa, L. V., Gastmans, D., Sánchez-Murillo, R., Santos, V. dos, Batista, L. V., &#38; Betancur, S. B. (2021). Stable isotopes reveal groundwater to river connectivity in a mesoscale subtropical watershed. <i>Isotopes in Environmental and Health Studies</i>, <i>57</i>(3), 236–253. https://doi.org/10.1080/10256016.2021.1877701


Gomes Lanças, V., Vituri Santarosa, L., Nogueira Garpelli, L., de Simone Borma, L., Stager Quaggio, C., Teixeira de Souza Martins, V., Gastmans, D., Lanças, V. G., Garpelli, L. N., Santarosa, L. v, Maciel, A. S., Esq Luis Morquio, N., de Simone Borma, L., &#38; de Souza Martins, V. T. (2022). <i>Assessment of the changes in contributions from water sources to streamflow induced by urbanization in a small-sized catchment in Southeastern Brazil using the dual stable isotopes of water ( 18 O and 2 H)</i>. <i>194</i>, 357. https://doi.org/10.1007/s10661-022-10040-9


Santarosa, L. V., Gastmans, D., &#38; Quaggio, C. S. (2022). Stable isotope modeling of the groundwater discharge in complex watersheds of the state of São Paulo, Brazil. <i>Journal of South American Earth Sciences</i>, <i>120</i>, 104063. https://doi.org/10.1016/J.JSAMES.2022.104063
