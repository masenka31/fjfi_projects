include(srcdir("requirements.jl"))
include(srcdir("data_toy.jl"))

## Gibbs sampler --------------------------------------------------------------------
# do simulation
m_gs, s_gs, pdm_gs, pds_gs = run_GS(x1,x2,α,β,Φ,μ,m,s,iter)

# 2d visualization
pd_2d_gs = kde(hcat(s_gs,m_gs))
scatter(s_gs,m_gs,markersize=1.5,legend=:none,colorbar=:none,alpha=0.4);
plot_pd_2d_gs = plot!(pd_2d_gs,xlims=(-1,35),ylims=(1,7),title="Gibbs sampler");


## Hamiltonian Monte Carlo ----------------------------------------------------------
# define model
@model toy(x, y) = begin
    s ~ InverseGamma(α,β)
    m ~ Normal(μ, sqrt(Φ))
    x ~ Normal(m, sqrt(s))
    y ~ Normal(m, sqrt(s))
    return s,m
end

# do simulation
chain = sample(toy(x1, x2), HMC(0.1, 5), iter);
m_hmc, s_hmc, pdm_hmc, pds_hmc = eval_HMC(chain);

# 2d visualization
pd_2d_hmc = kde(hcat(s_hmc,m_hmc))
scatter(s_hmc,m_hmc,markersize=1.5,legend=:none,colorbar=:none,alpha=0.4);
plot_pd_2d_hmc = plot!(pd_2d_hmc,xlims=(-1,35),ylims=(1,7),title="Hamiltonian Monte Carlo");


## Results --------------------------------------------------------------------------
# compare distributions for m
plot(pdm_gs,title="Kernel Density Estimation for m",label="Gibbs sampler");
plot_kde_m = plot!(pdm_hmc,label="Hamiltonian Monte Carlo")

# compare distributions for s
plot(pds_gs,title="Kernel Density Estimation for s",label="Gibbs sampler",xlims=(-1,35));
plot_kde_s = plot!(pds_hmc,label="Hamiltonian Monte Carlo")

# 2d visualization
plot_kde_2d = plot(layout=(1,2),plot_pd_2d_gs, plot_pd_2d_hmc,size=(1200,600))

function mean_std(m,s)
    return [mean(m) std(m) mean(s) std(s)]
end

df = hcat(["Gibbs"; "HMC"],vcat(mean_std(m_gs,s_gs),mean_std(m_hmc,s_hmc))) |> DataFrame
table = rename(df, [:method, :mean_m,:std_m,:mean_s,:std_s])
