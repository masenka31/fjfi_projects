using LightGraphs, Distances
using EvalMetrics
using GraphPlot, Compose, Cairo, Fontconfig

function kNNanomaly(X; k=5, proportion=0.8, plot_me=false, type="gamma", print = true)
    nn = size(X,2)
    # calculation of distance matrix
    distM = pairwise(Euclidean(),X,dims=2)
    D = sort(distM,dims=2)
    # and the indices
    if type == "kappa"
        kappa = D[:,k]
        inds = kappa .< quantile(kappa,proportion)
    elseif type == "gamma"
        gamma = mean(D[:,1:k],dims=2)[:]
        inds = gamma .< quantile(gamma,proportion)
    elseif type == "delta"
        d = D[:, 1:k]
        delta = LinearAlgebra.norm(X - Statistics.mean(d,dims=2))
        inds = delta .< quantile(delta,proportion)
    end

    # prepare necessarry matrices
    N = sum(inds)
    newX = X[:,inds]
    newM = distM[inds,inds]

    # creating the graph and the tree
    g = SimpleGraph(newM)
    E = prim_mst(g,newM)

    G1 = SimpleGraph(N)
    for edge in E
        add_edge!(G1,edge)
    end

    # find largest distance
    Gidx = CartesianIndex.(Tuple.(E))
    v_distances = newM[Gidx]
    v_sorted = sort(v_distances,rev=true)

    G2 = deepcopy(G1)
    for i in 1:length(E)
        idx = findall(x -> x == v_sorted[i], v_distances)
        edge = E[idx]
        bool = rem_edge!(G2,edge[1])
        if bool == true
            if print
                @info "$(edge...) removed."
            end
            break
        end
    end

    # get the clusters
    c1, c2 = connected_components(G2)
    n_small = minimum(length.([c1,c2]))
    n_big = maximum(length.([c1,c2]))
    if n_small < k
        if print
            @info "Convergence failed."
        end
        return repeat([NaN],3)
    end

    # získáme teď labels pro body v clusterech
    X_labels = zeros(Int,N)
    X_labels[c2] .= 1

    # nejdřív připravíme vektory a matice
    newY = X[:,inds .== 0]
    Xc1 = newX[:,c1]
    Xc2 = newX[:,c2]
    Y_labels = []

    # a pak můžeme spustit příslušnou smyčku...
    for Y in eachcol(newY)
        # spočítáme průměrné vzdálenosti od k nejbližších sousedů
        d1 = mean(sort([evaluate(Euclidean(),Xc1[:,i],Y) for i in 1:size(Xc1,2)])[1:k])
        d2 = mean(sort([evaluate(Euclidean(),Xc2[:,i],Y) for i in 1:size(Xc2,2)])[1:k])

        # vytvoříme label
        if d1 < d2
            push!(Y_labels,[0])
        else
            push!(Y_labels,[1])
        end
    end
    Y_labels = vcat(Y_labels...)

    # a nakonec musíme vytvořit predikované labels tím způsobem, 
    # že budou namapovány do správných indexů
    final_labels = zeros(Int,nn)
    final_labels[inds] .= X_labels
    final_labels[inds .== 0] .= Y_labels

    #
    if plot_me
        nodecolor = [colorant"lightseagreen", colorant"orange"]
        nodefillc = nodecolor[X_labels .+ 1]

        draw(PNG(plotsdir("graph_before.png"),30cm,30cm), gplot(G1,nodelabel=1:N,nodefillc=nodefillc,nodesize=2))
        draw(PNG(plotsdir("graph_after.png"),30cm,30cm), gplot(G2,nodelabel=1:N,nodefillc=nodefillc,nodesize=2))
    end

    return (final_labels, n_small, N)
end

function flipped_score(labels, new_labels)
	final_labels = similar(new_labels)
	if sum(abs.(labels .- new_labels)) > length(labels)÷2
		final_labels = abs.(new_labels .- 1)
        return final_labels
	end
	return new_labels
end

function f_score(labels, score; β=1)
    r = recall(labels, score)
    p = precision(labels, score)
    (1+β^2)*(r*p)/(r+p)
end

function kNN_search(data, labels, k, v; type="gamma")
    par = Dict(
        :k => collect(k),
        :v => collect(v)
    )
    par_list = dict_list(par)

    results = []

    @showprogress "Iterating..." for i in 1:length(par_list)
        @unpack k, v = par_list[i]
        new_labels, sm, nn = kNNanomaly(data,k=k,proportion=v, type=type, print = false)

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
        else
            r = DataFrame(
                :size => NaN,
                :F => NaN,
                :precision => NaN,
                :accuracy => NaN,
                :recall => NaN,
                :k => k,
                :v => v,
                :labels => NaN
            )
            push!(results, r)
        end
        
    end

    df = vcat(results...)
    fdf = filter(x -> x.size > 0, df)
    n_prev = size(df, 1)
    n_post = size(fdf, 1)

    @info "DataFrame with $n_post combinations out of original $n_prev."
    return df
end