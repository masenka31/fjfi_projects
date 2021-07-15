using Plots, Distributions, DataFrames, CSV
using Survival

data_dirty = CSV.read("..\\data\\clinic_trial.csv", DataFrame)
data_dirty = data_dirty[!,1:8]

data = dropmissing(data_dirty)

NA_model = fit(NelsonAalen, data[:,:survt], data[:,:cens])

x = NA_model.times
y = NA_model.chaz

plot(x,y)