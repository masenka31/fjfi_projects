include(srcdir("requirements.jl"))
include(srcdir("data_toy.jl"))

@model toy(x, y) = begin
    s ~ InverseGamma(α,β)
    m ~ Normal(μ, sqrt(Φ))
    x ~ Normal(m, sqrt(s))
    y ~ Normal(m, sqrt(s))
    return s,m
end

chain = sample(toy(x1, x2), HMC(0.1, 5), 10000)
m_hmc, s_hmc, pdm_hmc, pds_hmc = eval_HMC(chain)

# 2d visualization
pd_2d_hmc = kde(hcat(s_hmc,m_hmc))
plot(pd_2d_hmc,xlims=(-1,35),ylims=(1,7),title="Hamiltonian Monte Carlo")
plot_pd_2d_hmc = scatter!(s_hmc,m_hmc,markersize=1.5,legend=:none,colorbar=:none)

@model function linreg(X, y, δ, γ, ω)
    α ~ Gamma(δ, γ)
    θ ~ MvNormal(size(X, 2), sqrt(inv(α)))
    y ~ MvNormal(X * θ, sqrt(ω))
end

cond_θ = let X=X, y=y
    c -> begin
        θ_hat = X \ y
        Σ = Symmetric(inv(X' * X + c.α * I))
        return MvNormal(θ_hat, Σ)
    end
end

cond_α = let X=X, δ=δ, γ=γ, d=d
    c -> begin
        return Gamma(δ + d / 2, γ + sum(abs2, c.θ))
    end
end

sample(linreg(X, y, δ, γ, ω), Gibbs(GibbsConditional(:θ, cond_θ), GibbsConditional(:α, cond_α)), 1_000)
sample(linreg(X, y, δ, γ, ω),NUTS(0.65),1000)