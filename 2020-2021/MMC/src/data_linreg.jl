# generate linear regression data
N = 100
x1 = rand(Uniform(-5,15),N)
x2 = rand(Uniform(-7,7),N)
X = hcat(ones(N,1),x1,x2)
θ_init = [4.1; -5.8; -2.3]
y = X*θ_init .+ rand(MvNormal(zeros(N),3))

# plot 
# scatter(x1,x2,y,aspect_ratio=:equal,label="data")

# hyperparameters
γ = 0.5;
δ = 1.1;
# γ = 0;
# δ = 0;
d = 3

# initial parameter values for Gibbs sampler
θ0 = [0 0 0]
α0 = 0.5