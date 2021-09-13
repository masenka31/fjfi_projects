# Dataset available in the data folder or at https://machinelearningmastery.com/binary-classification-tutorial-weka/

_data = readdlm(datadir("datasets", "pima-indians-diabetes.txt"), ',')
X = collect(_data[:, 1:8]')
labels = Int.(_data[:, 9])
scatter(X[1,:], X[2,:], X[3,:], color=labels)

histogram(X[1,:])
histogram(X[2,:])
ix = findall(x -> x == 0, X[2,:])
X2 = X[:, Not(ix)]
labels = labels[Not(ix)]
histogram(X2[3,:])
ix = findall(x -> x == 0, X2[3,:])
labels = labels[Not(ix)]
X3 = X2[:, Not(ix)]
histogram(X3[4,:])
histogram(X3[5,:])
histogram(X3[6,:])
ix = findall(x -> x == 0, X3[6,:])
X4 = X3[:, Not(ix)]
labels = labels[Not(ix)]
histogram(X4[7,:])
histogram(X4[8,:])

scatter(X4[5,:], X4[4,:], X4[3,:], color=labels)

z = fit(ZScoreTransform, X4)
data = StatsBase.transform(z, X4)
scatter2(data[[2,4],:], color=labels)

df_nan = kNN_search(data, labels, 2:60, 0.3:0.025:0.95)

# F score
replace!(df_nan.F, NaN => 0)
replace!(df_nan.accuracy, NaN => 0)
p = scatter(
    df_nan.k, df_nan.v, xlims = (0,61), ylims = (0,1),
    markersize=4, zcolor=Float64.(df_nan.F), color=:jet, marker=:square, markerstrokewidth=0,
    xlabel="k", ylabel="v", colorbartitle="F score", label=""
)