# **Nighttime Lights - Venezuela**

[![Lifecycle:experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

# NL Venezuela - Tracking the Venezuelan humanitarian crisis and malaria re-emergence through remote sensing of nighttime lights

## Study description
In Venezuelan context the economic crises on healthcare provision, particularly on a localized scale, highlighting the underexplored use of nighttime lights to monitor service reduction in the absence of infrastructure damage. We focus on Venezuela's unprecedented socioeconomic and political crisis, triggering a major healthcare decline and an alarming rise in infectious diseases, such as malaria. The inadequate public health spending, a loss of medical assistance capacity, and crumbling basic services paint a grim picture. The deteriorating surveillance systems intensify concerns about malaria risk in the southeastern region. This study aims to use of nighttime lights to predict healthcare delivery reduction and the subsequent malaria surge in this challenging data-scarce context.
![](https://github.com/healthinnovation/NL_Venezuela/blob/main/Fig1_v3.png)

## Repository structure

1. [raw_data](https://github.com/healthinnovation/MHI/tree/main/raw_data) -  raw data (block geometries and LST) to merge with output INEI 2017 census.
2. [output/csv](https://github.com/healthinnovation/MHI/tree/main/ouput/csv) - Database created from raw data and used in the final analysis.
3. [Figures](https://github.com/healthinnovation/MHI/tree/main/images) - Figures in the main text
    - Figure 1. Study area is located on the central coast southwestern of Peru.
    - Figure 2. Diagram of the MHI construction process.
    - Figure 3. MHI estimates distribution by socioeconomic characteristics.
    - Figure 4. MHI distribution per rank of socioeconomic characteristics.
    - Figure 5.  Bivariate plot of MHI and the PCA index based on socioeconomic variables and income per capita.
    - Figure 6. Scaled effect size of each socioeconomic variable on MHI estimation by Metropolitan Lima zones.
5. [MHI/script/R](https://github.com/healthinnovation/MHI/tree/main/script/R) - Scripts in R language used to analyze and visualyze data results.
    - box_ridges_qgcomp.R - Boxviolin plots, ridges plots and Quantile G Computaiton analysis.
    - data_managemen_pca.R - Data management and Principal Component Analysis.
    - map_biscale.R - Create biscalemap showed in Figure 5
    - mhi.R - MHI calculation process
