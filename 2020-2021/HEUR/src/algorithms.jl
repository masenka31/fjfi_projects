function evaluate_Fscore(data, labels, k, v)
    new_labels, sm, nn = [], NaN, NaN
    try
        new_labels, sm, nn = kNNanomaly(data,k=k,proportion=v, print = false);
    catch e
        @warn "Some error occured."
        sm = NaN
    end

    if !(isnan(sm))
        # create labels
        score = flipped_score(labels, new_labels)
        # save parameters and results
        r = DataFrame(
            :size => sm/nn,
            :F => f_score(labels, score),
            :precision => precision(labels, score),
            :accuracy => accuracy(labels, score),
            :recall => recall(labels, score),
            :k => k,
            :v => v,
            :labels => [score]
        )
        return r[1,:F], r
    else
        # return 0 F-score when nothing is computed
        return NaN, NaN
    end
end

"""
    random_shooting(data, labels; max_iter = 100, k_max = 200)

Randomly samples the hyperparameters for `max_iter` iterations and returns
the achieved score.
"""
function random_shooting(data, labels; max_iter = 100, k_max = 200)
    # k values are to be sampled from possible values
    k_values = 1:k_max
    # v values are sampled from the Uniform distribution U(0,1)

    results = []

    @showprogress "Simulation in progress: " for i in 1:max_iter
        k = sample(k_values)
        v = rand()

        new_labels, sm, nn = [], NaN, NaN
        try
            new_labels, sm, nn = kNNanomaly(data,k=k,proportion=v, print = false);
        catch e
            @warn "Some error occured."
            sm = NaN
        end

        if !(isnan(sm))
            # create labels
            score = flipped_score(labels, new_labels)
            # save parameters and results
            r = DataFrame(
                :size => sm/nn,
                :F => f_score(labels, score),
                :precision => precision(labels, score),
                :accuracy => accuracy(labels, score),
                :recall => recall(labels, score),
                :k => k,
                :v => v,
                :labels => [score]
            )
            push!(results, r)
        end
    end

    if size(results, 1) == 0
        @info "No combination found."
        return
    end

    df = vcat(results...)
    na_idx = map(x -> !isnan(x[:F]), eachrow(df))
    df = df[na_idx, :]
    sort!(df, :F, rev=true)

    @info "Returning resulting DataFrame with $(size(df,1)) combinations out of original $max_iter."
    @info "Best achieved F-score: $(round(df[1,:F], digits=3))."
    return df, df[1,:F]
end

function simulated_annealing(data, labels; T=10, k_max = 200, max_iter = 100, α = 0.9)
    results = DataFrame[]
    scale = sqrt(T)
    start = (k = sample(1:k_max), v = rand())
    current, r = evaluate_Fscore(data, labels, start.k, start.v)
    j = 1
    while isnan(current)
        start = (k = sample(1:k_max), v = rand())
        current, r = evaluate_Fscore(data, labels, start.k, start.v)
        j += 1
    end
    history = [current]
    push!(results, r)
    x = start
    @showprogress "Simulation in progress: " for i in j:max_iter
        k_prop = x.k + round(Int, rand(Uniform(-100,100))*T)
        while k_prop < 1
            k_prop = x.k + round(Int, rand(Uniform(-100,100))*T)
        end
        v_prop = x.v + rand(Uniform(-1,1)) * T
        while v_prop  > 1 || v_prop < 0
            v_prop = x.v + rand(Uniform(-1,1)) * T
        end

        new_value, r = evaluate_Fscore(data, labels, k_prop, v_prop)
        if isnan(new_value)
            prop = x
        else
            Δ = new_value - current
            current = new_value
            if Δ > 0
                prop = (k = k_prop, v = v_prop)
                push!(results, r)
            elseif Δ < 0 && rand(Bernoulli(exp(Δ/T)))
                prop = (k = k_prop, v = v_prop)
                push!(results, r)
            else
                prop = x
            end
        end
        x = prop
        T = T*α
        push!(history, current)
    end
    vcat(results...), maximum(history)
end

"""
    random_shooting(data, labels, max_value; max_iter = 100, k_max = 200)

Randomly samples the hyperparameters for `max_iter` iterations and returns
the achieved score.
"""
function random_shooting(data, labels, max_value; max_iter = 1000, k_max = 50)
    # k values are to be sampled from possible values
    k_values = 1:k_max
    # v values are sampled from the Uniform distribution U(0,1)

    results = []
    i_max = max_iter

    @showprogress "Simulation in progress: " for i in 1:max_iter
        k = sample(k_values)
        v = rand()

        new_labels, sm, nn = [], NaN, NaN
        try
            new_labels, sm, nn = kNNanomaly(data,k=k,proportion=v, print = false);
        catch e
            @warn "Some error occured."
            sm = NaN
        end

        if !(isnan(sm))
            # create labels
            score = flipped_score(labels, new_labels)
            # save parameters and results
            r = DataFrame(
                :size => sm/nn,
                :F => f_score(labels, score),
                :precision => precision(labels, score),
                :accuracy => accuracy(labels, score),
                :recall => recall(labels, score),
                :k => k,
                :v => v,
                :labels => [score]
            )
            push!(results, r)
            if r[1,:F] >= max_value
                @info "Maximum value found in iteration no. $i."
                i_max = i
                break
            end
        end
    end

    if size(results, 1) == 0
        @info "No combination found."
        return
    end

    df = vcat(results...)
    na_idx = map(x -> !isnan(x[:F]), eachrow(df))
    df = df[na_idx, :]
    sort!(df, :F, rev=true)
    return df, df[1,:F], i_max
end

#df, best, imax = random_shooting(data, labels, 0.76; k_max = 60, max_iter = 1000)

function simulated_annealing(data, labels, max_value; T=10, k_max = 200, max_iter = 1000, α = 0.9)
    results = DataFrame[]
    scale = sqrt(T)
    start = (k = sample(1:k_max), v = rand())
    current, r = evaluate_Fscore(data, labels, start.k, start.v)

    i_max = max_iter
    j = 1
    while isnan(current)
        start = (k = sample(1:k_max), v = rand())
        current, r = evaluate_Fscore(data, labels, start.k, start.v)
        j += 1
    end

    history = [current]
    push!(results, r)
    x = start

    @showprogress "Simulation in progress: " for i in j:max_iter
        k_prop = x.k + round(Int, rand(Uniform(-100,100))*T)
        while k_prop < 1
            k_prop = x.k + round(Int, rand(Uniform(-100,100))*T)
        end
        v_prop = x.v + rand(Uniform(-1,1)) * T
        while v_prop  > 1 || v_prop < 0
            v_prop = x.v + rand(Uniform(-1,1)) * T
        end

        new_value, r = evaluate_Fscore(data, labels, k_prop, v_prop)

        if isnan(new_value)
            prop = x
        else
            Δ = new_value - current
            current = new_value
            if Δ > 0
                prop = (k = k_prop, v = v_prop)
                push!(results, r)
            elseif Δ <= 0
                if 0 <= exp(Δ/T) <= 1
                    if rand(Bernoulli(exp(Δ/T)))
                        prop = (k = k_prop, v = v_prop)
                        push!(results, r)
                    else
                        prop = x
                    end
                else
                    prop = x
                end
            end
        end
        x = prop
        T = T*α
        push!(history, current)
        if new_value >= max_value
            @info "Maximum value found in iteration no. $i."
            i_max = i
            break
        end
    end
    vcat(results...), maximum(history), i_max
end

#df, best, imax = simulated_annealing(data, labels, 0.76; k_max = 60, max_iter = 1000)