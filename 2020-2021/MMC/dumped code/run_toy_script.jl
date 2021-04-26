include("requirements.jl")
include("data_toy.jl")

iter = 100000

@model toy(x, y) = begin
    s ~ InverseGamma(α,β)
    m ~ Normal(μ, sqrt(Φ))
    x ~ Normal(m, sqrt(s))
    y ~ Normal(m, sqrt(s))
    return s,m
end

chain0 = sample(toy(x1, x2), HMC(0.1, 5), iter)
m_hmc, s_hmc, pdm_hmc, pds_hmc = eval_HMC(chain0)
eval_table = mean_std(m_hmc, s_hmc)
for i in 1:49
    chain = sample(toy(x1, x2), HMC(0.1, 5), iter)
    m_hmc, s_hmc, pdm_hmc, pds_hmc = eval_HMC(chain)
    global eval_table = vcat(eval_table, mean_std(m_hmc,s_hmc))
end

eval_table10 = eval_table
eval_table100 = eval_table
eval_table1000 = eval_table
eval_table10000 = eval_table
eval_table100000 = eval_table

HMC_eval = [eval_table10,eval_table100,eval_table1000,eval_table10000]

using DrWatson

using BSON: @save, @load
@save "../results/eval_HMC.bson" HMC_eval

a1 = mean(eval_table10,dims=1)
a2 = mean(eval_table100,dims=1)
a3 = mean(eval_table1000,dims=1)
a4 = mean(eval_table10000,dims=1)
a5 = mean(eval_table100000,dims=1)
