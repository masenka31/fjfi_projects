# load functions
include(srcdir("requirements.jl"))
# load data
include(srcdir("data_linreg.jl"))

# initial parameter values
α0 = 0.5
θ0 = [1; 1; 1]

# constant values calculated prior to simulation
a = δ + d/2
E = (X'*X)^(-1)*X'*y

# ridge regression Turing model
# y has uninformative prior
@model linreg1(X, y) = begin
    b0 = γ + norm(θ0)^2
    α0 = rand(Gamma(a,b0))
    D0 = Symmetric((X'*X + α0*I)^(-1))
    θ1 = rand(MvNormal(E,D0))
    b = γ + norm(θ1)^2
    # and sample the parameters...
    ω ~ truncated(Normal(0, 100), 0, Inf)
    α ~ Gamma(a,b)
    D = Symmetric((X'*X + α*I)^(-1))
    θ ~ MvNormal(E,D)
    y ~ MvNormal(X*θ,sqrt(ω))
    return θ
end

# classic
@model linreg(X,y,γ,δ,E) = begin
    α ~ Gamma(γ,δ)
    D = Symmetric((X'*X + α*I)^(-1))
    θ ~ MvNormal(E,D)
    σ ~ truncated(Normal(0, 100), 0, Inf)
    y ~ MvNormal(X*θ,sqrt(σ))
    return θ
end


result0 = sample(linreg1(X,y), HMC(0.005,5), 100, progress=true)
result1 = sample(linreg1(X,y), HMC(0.005,5), 1000, progress=true)
result1 = sample(linreg1(X,y), HMC(0.005,5), 10000, progress=true)
result2 = sample(linreg1(X,y), NUTS(0.65), 1000, progress=true)


θ1 = result.value[:,Symbol("θ[1]"),1]
θ2 = result.value[:,Symbol("θ[2]"),1]
θ3 = result.value[:,Symbol("θ[3]"),1]
α = result.value[:,:α,1]

f1 = fit_mle(Normal,θ1)
f2 = fit_mle(Normal,θ2)
f3 = fit_mle(Normal,θ3)
fa = fit_mle(Gamma,α)

vysledek.value[:]

x = hcat(x1,x2)

@model function linear_regression(x, y)
    # Set variance prior.
    σ₂ ~ truncated(Normal(0, 100), 0, Inf)
    
    # Set intercept prior.
    intercept ~ Normal(0, sqrt(3))
    
    # Set the priors on our coefficients.
    nfeatures = size(x, 2)
    coefficients ~ MvNormal(nfeatures, sqrt(10))
    
    # Calculate all the mu terms.
    mu = intercept .+ x * coefficients
    y ~ MvNormal(mu, sqrt(σ₂))
end

chain = sample(linear_regression(x,y), HMC(0.05,5), 50);