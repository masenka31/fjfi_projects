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
include(srcdir("toy_data.jl"))
include(srcdir("plotting.jl"))

N = 1000
prop = 0.2 # proportion of anomaly datapoints
data, labels = moons_disbalanced(N, 0.15, prop)
scatter2(data,color=labels)

df = kNN_search(data, labels, 4:30,0.3:0.05:0.95);

sort!(df,:size,rev=true)
sort!(df,:F,rev=true)
sort!(df,:recall,rev=true)
sort!(df,:precision,rev=true)
sort!(df,:accuracy,rev=true)

scatter2(data, color=df.labels[1])

first(df, 10)
binary_eval_report(labels, Float64.(df.labels[1]))
scatter2(data, color=df.labels[1])

Fbeta = f_score(labels, df.labels[1]; β=0.5)

# F score
scatter(df.k, df.ν, xlims = (0,31), ylims = (0,1), markersize=(df.size .+ 0.1).*15, zcolor=Float64.(df.F), color=:jet, xlabel="k", ylabel="ν", colorbartitle="F score", label="")
scatter(df.k, df.ν, xlims = (0,31), ylims = (0,1), markersize=6, zcolor=Float64.(df.F), color=:jet, xlabel="k", ylabel="ν", colorbartitle="F score", label="")
# Precision
scatter(df.k, df.ν, xlims = (0,31), ylims = (0,1), markersize=(df.size .+ 0.1).*15, zcolor=Float64.(df.precision), color=:jet, xlabel="k", ylabel="ν", colorbartitle="Precision", label="")
scatter(df.k, df.ν, xlims = (0,31), ylims = (0,1), markersize=6, zcolor=Float64.(df.precision), color=:jet, xlabel="k", ylabel="ν", colorbartitle="Precision", label="")
# Recall
scatter(df.k, df.ν, xlims = (0,31), ylims = (0,1), markersize=(df.size .+ 0.1).*15, zcolor=Float64.(df.recall), color=:jet, xlabel="k", ylabel="ν", colorbartitle="Recall", label="")
scatter(df.k, df.ν, xlims = (0,31), ylims = (0,1), markersize=6, zcolor=Float64.(df.recall), color=:jet, xlabel="k", ylabel="ν", colorbartitle="Recall", label="")