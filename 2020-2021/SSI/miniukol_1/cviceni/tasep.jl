pr = 0.5
iter = 100

pocet_bunek = 15
X0 = rand(Bernoulli(pr),pocet_bunek)
pocet_castic = sum(X0)
c = collect(1:pocet_bunek)

function update_pozice(X0,p)
    X = X0
    for i in 1:pocet_bunek-1
        muze_hop = true
        k = 1
        while muze_hop
            if X0[i] == 1 && X0[i+k] == 0
                if k + 1 == pocet_bunek
                    muze_hop = false
                else
                    k = k + 1
                end
            else
                muze_hop = false
            end
            hop = rand(Bernoulli(p))
            if hop
                X[i] = 0
                X[i+k] = 1
            end
        end
    end
    if X0[end] == 1 && X0[1] == 0
        hop = rand(Bernoulli(p))
        if hop
            X[end] = 0
            X[1] = 1
        end
    end
    return X
end

function update_me(X0)
    skocim = X0 .- 2 .* vcat(X0[2:end],X0[1])
    X = abs.(minimum(hcat(skocim,zeros(length(skocim))),dims=2))
    X = X .!= 0
end

function plot_table(p,n)
    p = plot!([0.5,n+0.5],[-0.5,-0.5],linecolor=:black,aspect_ratio=:equal,grid=:false,ticks=:false,label="")
    p = plot!([0.5,n+0.5],[0.5,0.5],linecolor=:black,label="")
    for i in 1:n+1
        p = plot!([i-0.5,i-0.5],[-0.5,0.5],linecolor=:black,label="")
    end
    return p
end

kolo = collect(1:pocet_castic)
animation = @animate for i in 1:iter
    X = X0
    global X0 = update_me(X)
    if X[1] == 0 && X0[1] == 1
        global kolo = vcat(kolo[end],kolo[1:end-1])
    end
    bb = X0 |> BitArray
    indexy = c[bb[:]]
    p = scatter(indexy,zeros(length(indexy)),markersize=:15,label="",zcolor=kolo);
    plot_table(p,pocet_bunek)
end
gif(animation, "zkouska.gif", fps=1)