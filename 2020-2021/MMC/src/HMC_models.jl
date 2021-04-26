# toy example model
@model toy(x,y,α,β,Φ,μ) = begin
    s ~ InverseGamma(α,β)
    m ~ Normal(μ, sqrt(Φ))
    x ~ Normal(m, sqrt(s))
    y ~ Normal(m, sqrt(s))
    return s,m
end

# linear regression HMC
@model linreg(X,y,γ,δ,E) = begin
    α ~ Gamma(δ,γ)
    D = Symmetric((X'*X + α*I)^(-1))
    θ ~ MvNormal(E,D)
    σ ~ truncated(Normal(0, 100), 0, Inf)
    y ~ MvNormal(X*θ,sqrt(σ))
    return θ
end
