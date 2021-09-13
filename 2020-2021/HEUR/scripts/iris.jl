using MLDatasets

features = Iris.features()
labels = Iris.labels()
l = unique(labels)
lb = zeros(length(labels))
lb[labels .== "Iris-versicolor"] .= 1
lb[labels .== "Iris-virginica"] .= 2
lb = Int.(lb)

scatter2(features, color=lb)
scatter2(features[2:3,:], color=lb)
scatter2(features[3:4,:], color=lb)


idx = sample(51:150, 100,replace=false)
data = features[:, idx]
labels = lb[idx]

scatter2(data, color=labels)

labels[labels .== 2] .= 1
df_nan = kNN_search(data, labels, 2:50, 0.025:0.025:1)

# F score
replace!(df_nan.F, NaN => 0)
sort!(df_nan, :F, rev=true)
p = scatter(
    df_nan.k, df_nan.v, xlims = (0,51), ylims = (0,1),
    markersize=4, zcolor=Float64.(df_nan.F), marker=:square, markerstrokewidth=0,
    xlabel="k", ylabel="v", colorbartitle="F score", label="", xticks=0:5:50, color=:jet
)

bestF = df_nan[1,:F]
# hledat, kolik potřebuju on average kroků k nalezení nejlepšího řešení, maximum iterací např. 1000

# random shooting
df_RS, best_RS = random_shooting(data, labels, k_max = 50)
df_SA, best_SA = simulated_annealing(data, labels; T=10, k_max = 50, max_iter = 100, α = 0.9)

RS_res = []
for i in 1:30
    df_RS, best_RS = random_shooting(data, labels, k_max = 50)
    push!(RS_res, best_RS)
end

SA_res = []
for i in 1:30
    df_SA, best_SA = simulated_annealing(data, labels; T=10, k_max = 50, max_iter = 100, α = 0.9)
    push!(SA_res, best_SA)
end

df = DataFrame(zeros(5*5, 3), [:T, :α, :F])
index = 1
for (i, T) in enumerate([0.1, 1, 10, 100, 1000])
    for (j, α) in enumerate(0.2:0.2:1)
        res = []
        for l in 1:30
            df_SA, best_SA = simulated_annealing(data, labels; T=T, k_max = 50, max_iter = 100, α = α)
            push!(res, best_SA)
        end
        df[index, :T] = T
        df[index, :α] = α
        df[index, :F] = mean(res)
        index += 1
    end
end

mean(RS_res)
mean(SA_res)
