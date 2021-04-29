# GIG distribuce a pomocné funkce
g(α, β) = 4 .* β ./ (4 .+ α)
λ(α, β) = @. α + β + (3 - exp(-sqrt(g(α, β))))/2
Θ(x) = x > 0 ? x : 0

function gig(x, α, β)
    lambda = λ(α, β)
    x = Θ.(x)
    K = @. besselk(α+1, 2*sqrt(lambda*β))
    A = @. 1/(2*(sqrt(β/lambda))^(α+1)*K)
    @. A * x^α * exp(-β/x) * exp(-lambda*x)
end

# simulační funkce# definice podmínek
p1(x) = x
p2(x) = 0.5 + x
p3(x) = 1.1*x

function simulate(iter, p::Function=p1)
    procento = []
    X = []
    Y = []
    for k in 1:iter
        n = Int(1e5)
        x = gig_rand(n)
        y = deepcopy(x)
        o = gig_rand(1)
        j = 0
        @showprogress "Simulation $k/$iter:  " for i in 1:n
            if x[i] > p(o)
                y[i+j] = o
                y = push_in(y, x[i]-o, i+j)
                j += 1
                o = gig_rand(1)
            end
        end

        pripojeno = length(y) - length(x)
        pripojeno_procent = pripojeno/length(y)*100
        push!(procento, pripojeno_procent)
        push!(X, x)
        push!(Y, y)
    end
    return procento, X, Y
end