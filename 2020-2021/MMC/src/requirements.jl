# required packages
using Plots
using Distributions
using KernelDensity
using StatsPlots
using LaTeXStrings
using Turing
using LinearAlgebra
using DataFrames

## GIBBS SAMPLER ----------------------------------------------
# GS for toy problem
function run_GS_toy(x1,x2,α,β,Φ,μ,m,s,iter)
    mi = zeros(iter+1)
    si = zeros(iter+1)
    mi[1] = m;
    si[1] = s;
    for i in 1:iter
        E = (1/Φ + 2/si[i])^(-1) * (μ/Φ + (x1 + x2)/si[i])
        var = (1/Φ + 2/si[i])^(-1)
        mi[i+1] = rand(Normal(E,var))
        a = α + 1
        b = 0.5*(mi[i+1] - x1)^2 + 0.5(mi[i+1] - x2)^2 + β
        si[i+1] = rand(InverseGamma(a,b))
    end
    return mi, si
end

# GS for linear regression
function run_GS_LR(X,y,δ,γ,d,α0,θ0,iter)
    α = zeros(iter+1)
    θ = zeros(iter+1,3)
    α[1] = α0
    θ[1,:] = θ0

    # Gibbs sampler loop
    for i in 1:iter
        E = (X'*X)^(-1)*X'*y
        D = Symmetric((X'*X + α[i]*I)^(-1))
        θ[i+1,:] = rand(MvNormal(E,D))

        a = δ + d/2
        b = γ + norm(θ[i+1,:])^2
        α[i+1] = rand(Gamma(a,b))
    end

    θ = θ[2:end,:];
    θ1 = θ[:,1];
    θ2 = θ[:,2];
    θ3 = θ[:,3];

    return α,θ1,θ2,θ3
end

## HMC ------------------------------------------------------------------
# get values from HMC toy chain
function HMCtoy_params(chain)
    mi_hmc = chain.value[:,:m,1]
    si_hmc = chain.value[:,:s,1]

    return mi_hmc, si_hmc
end

### HELPER PLOTTING FUNCTIONS --------------------------------------------
# plot θ parameters and their true values
function plot_θ(θ1,θ2,θ3)
    plot(kde(θ1),label=L"\mathrm{kde}",legendtitle=L"\mathrm{odhad} \; \theta_1",legendfontsize=10,legend=:outerright);
    vline!([4.1],label=L"\theta_1^{true}",color=:black);
    p1 = plot!(fit_mle(Normal,θ1),label=L"\mathrm{fit } \; \mathcal{N}");

    vline([-5.8],label=L"\theta_2^{true}",color=:black);
    plot!(kde(θ2),label=L"\mathrm{kde}",legendtitle=L"\mathrm{odhad} \; \theta_2",legendfontsize=10,legend=:outerright);
    p2 = plot!(fit_mle(Normal,θ2),label=L"\mathrm{fit } \; \mathcal{N}");

    vline([-2.3],label=L"\theta_3^{true}",color=:black);
    plot!(kde(θ3),label=L"\mathrm{kde}",legendtitle=L"\mathrm{odhad} \; \theta_3",legendfontsize=10,legend=:outerright);
    p3 = plot!(fit_mle(Normal,θ3),label=L"\mathrm{fit } \; \mathcal{N}");

    plt_final = plot(p1,p2,p3,layout=(3,1),size=(600,400))
    return plt_final
end

## plot confidence intervals
# count confidence
function calculate_confidence(x)
    q1 = quantile(x,0.025)
    q2 = quantile(x,0.975)
    E = mean(x)
    return vcat(E,q1,q2)
end

# plot confidence
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
