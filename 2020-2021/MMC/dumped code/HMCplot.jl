toy_data = collect_results!(datadir("toy_HMC"))

data = groupby(toy_data,:iter)

for i in 1:length(data)
    plt = [plot() for j in 1:10]
    for j in 1:10
        p = marginalkde
    end
end

# for GS we need to calculate confidence intervals manually
function calculate_confidence(x)
    q1 = quantile(x,0.025)
    q2 = quantile(x,0.975)
    E = mean(x)
    return vcat(E,q1,q2)
end

# k = 1 -> 50 iterations
# k = 2 -> 500 iterations
# k = 3 -> 5000 iterations

k = 1
CI_m = hcat([calculate_confidence(x) for x in data[k][:m]]...)
CI_s = hcat([calculate_confidence(x) for x in data[k][:s]]...)

function plot_CI(CI;ylabel="")
    p = plot(ylabel=ylabel,xticks=:none,legend=:none)
    for i in 1:size(CI,2)
        y = CI[1,i]
        u = CI[2,i]
        l = CI[3,i]
        p = plot!([i-0.1; i+0.1],[u;u],color=:black)
        p = plot!([i-0.1;i+0.1],[l;l],color=:black)
        p = plot!([i;i],[l;u],color=:black)
        p = scatter!([i],[y],color=:gray)
    end
    return p
end

