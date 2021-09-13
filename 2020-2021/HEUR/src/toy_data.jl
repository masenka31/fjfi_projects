"""
    moons(N,noise=0.2; seed=nothing)

Generates the moons dataset with equal number of points in both
moons. Returns data and labels.
"""
function moons(N,noise=0.2; seed=nothing)
    # set random seed if seed given
    !isnothing(seed) ? Random.seed!(seed) : nothing

    outer_x = cos.(range(0,pi,length=N÷2))
    outer_y = sin.(range(0,pi,length=N÷2))
    inner_x = 1 .- cos.(range(0,pi,length=N÷2))
    inner_y = 1 .- sin.(range(0,pi,length=N÷2)) .- 0.5
    XX = hcat(vcat(inner_x,outer_x),vcat(inner_y,outer_y))'
    X = XX .+ rand(Normal(0,noise),size(XX))
    labels = vcat(zeros(Int, N÷2), ones(Int, N÷2))
    return X, labels
end

"""
    moons_disbalanced(N,noise=0.2,prop=0.2; seed=nothing)

Generates the moons dataset with unequal number of points in moons based on given
proportion. Returns data and labels.
"""
function moons_disbalanced(N,noise=0.2,prop=0.2; seed=nothing)
    # set random seed if seed given
    !isnothing(seed) ? Random.seed!(seed) : nothing

    n1 = round(Int, N*prop)
    n2 = N - n1
    outer_x = cos.(range(0,pi,length=n1))
    outer_y = sin.(range(0,pi,length=n1))
    inner_x = 1 .- cos.(range(0,pi,length=n2))
    inner_y = 1 .- sin.(range(0,pi,length=n2)) .- 0.5
    XX = hcat(vcat(inner_x,outer_x),vcat(inner_y,outer_y))'
    X = XX .+ rand(Normal(0,noise),size(XX))
    labels = vcat(zeros(Int, n2), ones(Int, n1))
    return X, labels
end