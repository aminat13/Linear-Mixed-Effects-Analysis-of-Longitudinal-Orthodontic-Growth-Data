# Linear-Mixed-Effects-Analysis-of-Longitudinal-Orthodontic-Growth-Data
---
This repository contains an analysis of a longitudinal orthodontic dataset using linear mixed-effects models in R. The project was completed as part of the Advanced Data Analytics module in the MSc Technologies and Analytics in Precision Medicine.

The analysis investigates how facial bone growth changes with age and whether sex influences baseline measurements or growth trajectories.
---
## Project Overview

The dataset originates from a longitudinal study conducted at the University of North Carolina Dental School, where researchers measured facial bone growth in children using skull X-rays. Measurements were taken repeatedly for each subject over time.

Because the dataset contains repeated measurements from the same individuals, observations are not independent. Linear mixed-effects models were therefore used to account for within-subject correlation while estimating population-level trends. 

Research Question: 

How does facial bone distance change with age, and do males and females differ in their baseline measurements or growth rates? 
---
## Dataset

The dataset includes measurements from 27 children followed from age 8 to 14, with measurements taken every two years.

- Variable	Description
- Subject	Child identifier
- Sex	Male or Female
- Age at measurement (8, 10, 12, 14)
- Distance between pituitary and pterygomaxillary fissure (mm)

### Dataset structure:

- 27 subjects
- 4 repeated measurements per subject
- 108 total observations
- Balanced longitudinal design
---
## Methods

The analysis was conducted in R using packages including:

- nlme
- lme4
- lmerTest
- ggplot2
- dplyr
- tidyr
- performance
- psych

The workflow consisted of four main stages:

### 1. Exploratory Data Analysis

- Calculated summary statistics by age and sex
- Visualised individual growth trajectories using a spaghetti plot
- Examined trends in bone distance across age groups

Example plot produced:

distance_by_age.png
spag_plot.png

These visualisations illustrate within-subject growth trajectories and highlight variability between individuals.

### 2. Mixed Effects Model Building

Three mixed-effects models were fitted:

Model 1 – Random Intercept Model

distance ~ age + (1 | Subject)

Assumes:

- Subjects have different baseline measurements

- All individuals share the same growth slope.

Model 2 – Random Intercept with Sex Interaction

distance ~ age * Sex + (1 | Subject)

Tests whether:

- Baseline distance differs by sex

- Growth rate differs by sex.

Model 3 – Random Intercept and Random Slope Model

distance ~ age * Sex + (1 + age | Subject)

Allows each subject to have:

- Their own baseline
- Their own growth rate.

### Model Selection

Models were compared using:

- Akaike Information Criterion (AIC)
- Likelihood ratio test

The random intercept model provided the best balance of fit and parsimony.

Intraclass Correlation Coefficient (ICC)

The ICC quantifies how much variation occurs between individuals versus within individuals over time.

In this dataset:

ICC ≈ 0.63

This indicates that 63% of variance in bone distance is explained by differences between children, justifying the use of mixed-effects modelling. 

### Model Diagnostics

Model assumptions were evaluated using:

- Residuals vs fitted values plot
- Q–Q plot of residuals
- Q–Q plot of random effects

Generated figures include:

- residuals_plot.png
- qq_res.png
- qq_ran.png

Diagnostic plots indicated that:

- residuals were approximately normally distributed
- variance was roughly constant across fitted values
- random effects followed an approximately normal distribution.
---
## Key Results

The final model showed:

- Age is a significant predictor of facial bone distance
- Bone distance increases on average by ~0.66–0.78 mm per year
- Sex does not significantly affect baseline distance
- However, growth rates differ between sexes, with males showing slightly steeper increases.
- These findings suggest that while children differ in their baseline facial bone measurements, their individual growth slopes are broadly similar, making a random intercept model sufficient. 
---
Repository Structure
├── scripts
│   └── assignment1_workflow.R
│
├── results
│   └── figures
│       ├── spag_plot.png
│       ├── slopes.png
│       ├── residuals_plot.png
│       ├── qq_res.png
│       └── qq_ran.png
│
├── report
│   └── ADA_assignment_1.pdf
│
└── README.md

### Running the Analysis

Clone the repository:

git clone https://github.com/aminat13/<repository-name>

Open the R script:

scripts/assignment1_workflow.R

Run the script to reproduce:
- exploratory analysis
- mixed model fitting
- model comparisons
- diagnostic plots

## Skills Demonstrated

This project demonstrates practical skills in:

- Linear mixed-effects modelling
- Longitudinal data analysis
- Model comparison (AIC & likelihood ratio tests)
- Statistical interpretation of fixed and random effects
- Data visualisation using ggplot2
- Reproducible research workflows in R

## References

Potthoff, R. F. & Roy, S. N. (1964).
A generalized multivariate analysis of variance model useful especially for growth curve problems. Biometrika.
