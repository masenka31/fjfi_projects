# HEUR

This is a Julia project using `DrWatson.jl` for reproducible results. The project aims to use kNN anomaly detection algorithm presented in paper *From outliers to prototypes: Ordering data*. The simple heuristic used in the paper does not work well for inbalanced datasets.

The aim of this work is to compare other heuristics (random shooting and simulated annealing) when there are limited number of evaluation of the function for a chosen combination of hyperparameters.

## Code structure

The project is a Julia package. All source codes are in folder `src`. The `scripts` folder presents various scripts and unfinished miniprojects. The notebooks can be found in folder `notebooks`. The main work is presented in the notebook *kNN-anomaly (HEUR project).ipynb*.