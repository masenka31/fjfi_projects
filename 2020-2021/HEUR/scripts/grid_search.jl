using DrWatson
using LightGraphs, Distances
using Random
using Plots
using Statistics
using GraphPlot, Compose, Cairo, Fontconfig
using ProgressMeter
using DataFrames
using EvalMetrics

include(srcdir("kNNanomaly.jl"))
include(scriptsdir("algorithms.jl"))
include(srcdir("toy_data.jl"))
include(srcdir("plotting.jl"))

N = 1500
prop = 0.33 # proportion of anomaly datapoints
seed = 31
_data, _labels = moons_disbalanced(N, 0.2, prop; seed=seed)
Random.seed!(seed)
perm_idx = sample(1:length(_labels), length(_labels), replace=false)
data = _data[:, perm_idx]
labels = _labels[perm_idx]
scatter2(data,color=labels)

df_nan = kNN_search(data, labels, 2:60,0.025:0.025:1);
df = deepcopy(df_nan)
replace!(df.F, NaN => 0)
sort!(df, :F, rev=true)

# F score
p = scatter(
    df_nan.k, df_nan.v, xlims = (0,61), ylims = (0,1),
    markersize=4, zcolor=Float64.(df_nan.F), color=:jet, marker=:square, markerstrokewidth=0,
    xlabel="k", ylabel="v", colorbartitle="F score", label=""
)
safesave(plotsdir("grid_search.png"), p)
# Accuracy
scatter(df.k, df.v, xlims = (0,81), ylims = (0,1), markersize=3, zcolor=Float64.(df.accuracy), color=:jet, xlabel="k", ylabel="v", colorbartitle="Accuracy", label="")
# Recall
scatter(df.k, df.v, xlims = (0,81), ylims = (0,1), markersize=3, zcolor=Float64.(df.recall), color=:jet, xlabel="k", ylabel="v", colorbartitle="Recall", label="")


# random shooting
df_RS, best_RS = random_shooting(data, labels, k_max = 60)
df_SA, best_SA = simulated_annealing(data, labels; T=10, k_max = 60, max_iter = 100, α = 0.9)

RS_res = []
for i in 1:30
    df_RS, best_RS = random_shooting(data, labels, k_max = 60)
    push!(RS_res, best_RS)
end

SA_res = []
for i in 1:30
    df_SA, best_SA = simulated_annealing(data, labels; T=10, k_max = 60, max_iter = 100, α = 0.9)
    push!(SA_res, best_SA)
end

mean(RS_res)
mean(SA_res)

df_RS, best_RS, i = random_shooting(data, labels, 0.91, k_max = 60, max_iter = 1000)
df_SA, best_SA = simulated_annealing(data, labels, 0.91; T=10, k_max = 60, max_iter = 1000, α = 0.9)

RS_results = Dict(:df => DataFrame[], :F => [], :iter => [])
for i in 1:50
    df_RS, best, iter = random_shooting(data, labels, 0.91, k_max = 60, max_iter = 1000)
    push!(RS_results[:df], df_RS)
    push!(RS_results[:F], best)
    push!(RS_results[:iter], iter)
end

SA_results = Dict(:df => DataFrame[], :F => [], :iter => [], :α => [], :T => [])
for i in 1:50
    for T in [0.1, 1, 10, 100]
        for α in [0.5, 0.6, 0.7, 0.8, 0.9, 1]
            df_SA, best_SA, iter = simulated_annealing(data, labels, 0.91; T=T, k_max = 60, max_iter = 1000, α = α)
            push!(SA_results[:df], df_SA)
            push!(SA_results[:F], best_SA)
            push!(SA_results[:iter], iter)
            push!(SA_results[:α], α)
            push!(SA_results[:T], T)
        end
    end
end

SA_df = DataFrame(SA_results)
gdf = groupby(SA_df, [:T, :α])
map(i -> size(gdf[i],1), 1:24)
iters = map(i -> mean(gdf[i][:, :iter]), 1:24)
sort(iters)
