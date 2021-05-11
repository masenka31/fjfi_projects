using LightGraphs, Distances
using Random
using Plots
using Statistics
using GraphPlot, Compose, Cairo, Fontconfig
include(scriptsdir("kNNanomaly", "kNNanomaly.jl"))
include(srcdir("toy_script.jl"))
include(srcdir("plotting.jl"))

n1,n2 = 40,50
X1 = randn(3,n1)
X2 = randn(3,n2) .+ 2.5
sidx = shuffle(1:n1+n2)
X = hcat(X1,X2)[:,sidx]
labels = vcat(zeros(Int,n1),ones(Int,n2))[sidx]

# plotting data
prev = scatter(X[1,:],X[2,:],X[3,:],color=labels)

@time new_labels, sm, nn = kNNanomaly(X,k=15,proportion=0.6, plot_me = true);

post = scatter(X[1,:],X[2,:],X[3,:],color=new_labels)
plot(prev, post, layout = (1,2), aspect_ratio=:equal, size=(600,300), label = ["" ""], title = ["original" "kNNanomaly"])

# evaluation of results
final_labels = Float_score(new_labels)
binary_eval_report(labels, final_labels)


N = 1000
inds = shuffle(1:N);
data = moons(N,0.25)[:,inds];


scatter2(data,color=labels)

@time new_labels, sm, nn = kNNanomaly(data,k=25,proportion=0.4);

prev = scatter2(data, color=labels);
post = scatter2(data, color=new_labels);
plot(prev, post, layout = (1,2), aspect_ratio=:equal,size=(600,300))

using EvalMetrics
final_labels = Float_score(new_labels)
binary_eval_report(labels, final_labels)
rocplot(labels, final_labels)
prplot(labels, final_labels)