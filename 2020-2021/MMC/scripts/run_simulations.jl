# load all modules, functions and other requirements
using DrWatson
include(srcdir("requirements.jl"))
include(srcdir("HMC_models.jl"))
include(srcdir("GS_simulations.jl"))
include(srcdir("HMC_simulations.jl"))
iterations = [50,500,5000]

## TOY PROBLEM ------------------------------------------
# load data
include(srcdir("data_toy.jl"))

# run simulations
## Gibbs sampler
for iter in iterations
    GS_toy_sim(x1,x2,α,β,Φ,μ,m0,s0,iter)
end

# HMC
for iter in iterations
    HMC_toy_sim(x1,x2,α,β,Φ,μ,iter)
end

### LINEAR REGRESSION -------------------------------------
include(srcdir("data_linreg.jl"))
## Gibbs sampler
@time for iter in iterations
    GS_LR_sim(X,y,δ,γ,d,α0,θ0,iter)
end

## HMC
@time for iter in iterations
    HMC_LR_sim(X,y,δ,γ,iter)
end