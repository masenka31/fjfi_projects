# load functions
include(srcdir("requirements.jl"))
# load data
include(srcdir("data_linreg.jl"))

# initial values
α0 = 0.5
θ0 = [0 0 0];

# vectors setup
iter = 5000
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

