module HEUR

using DrWatson
using Distributions, Statistics#, StatsBase
using Random
using Plots
using DataFrames
using EvalMetrics
using ProgressMeter

include("toy_data.jl")
include("kNNanomaly.jl")
include("plotting.jl")
include("algorithms.jl")

export moons, moons_disbalanced
export scatter2, scatter2!, scatter3, scatter3!
export kNN_search
export random_shooting, simulated_annealing

end #module