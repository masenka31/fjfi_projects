using Optim

kNNanomaly(X; k=5, proportion=0.8, plot_me=false, type="gamma", print = true)

function generate_point(k_vec, ν_vec)
    k = sample(k_vec)
    ν = sample(ν_vec)
    return (k, ν)
end

function evaluate_results(X, labels, k, ν; kwargs...)
    new_labels, _, _ = kNNanomaly(X; k=k, proportion=ν, kwargs...)
    if isnan(new_labels[1])
        return 1/length(labels)
    else
        score = flipped_score(labels, new_labels)
        return f_score(labels, score)
    end
end

k_vec = 3:30
ν_vec = 0.3:0.05:1

function RandomShooting(X, labels, k_vec, ν_vec; iter = 100, kwargs...)
    results = []
    @showprogress "RandomShooting: " for i in 1:iter
        parameters = generate_point(k_vec, ν_vec)
        F = evaluate_results(X, labels, parameters...; kwargs...)
        push!(results, [F, parameters...]')
    end
    DataFrame(vcat(results...), [:F, :k, :ν])
end

df = RandomShooting(X, labels, k_vec, ν_vec, iter = 100, print = false)

sa = SimulatedAnnealing()
optimize()

function neightbor()