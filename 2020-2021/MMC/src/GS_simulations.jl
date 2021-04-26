# simulation function for Toy problem and GS sampler
function GS_toy_sim(x1,x2,α,β,Φ,μ,m0,s0,iter)
    Mtmp = zeros(1,iter+1)
    Stmp = zeros(1,iter+1)

    for i in 1:10
        m, s = run_GS_toy(x1,x2,α,β,Φ,μ,m0,s0,iter)
        marginalkde(m,s,size=(300,300))
        plt_dist = plot!(xlabel=["m" "" ""],ylabel=["" "" "s"])
        safesave(plotsdir("gs_toy","iter=$(iter)_$i.pdf"),plt_dist)

        Mtmp = vcat(Mtmp,m')
        Stmp = vcat(Stmp,s')

        data = Dict(
            :Em => mean(m),
            :Es => mean(s),
            :iter => iter,
            :m0 => m0,
            :s0 => s0,
            :m => m,
            :s => s,
        )
        safesave(datadir("gs_toy",savename(data, "bson")),data)
    end

    M = Mtmp[2:end,:]
    S = Stmp[2:end,:]
    ci_m = hcat([calculate_confidence(M[i,:]) for i in 1:10]...)
    ci_s = hcat([calculate_confidence(S[i,:]) for i in 1:10]...)

    plt_m = plot_CI(ci_m,ylabel="m")
    plt_m = plot!(size=(320,220))
    plt_s = plot_CI(ci_s,ylabel="s")
    plt_s = plot!(size=(320,220))
    safesave(plotsdir("gs_toy","ci_m_iter=$iter.pdf"),plt_m)
    safesave(plotsdir("gs_toy","ci_s_iter=$iter.pdf"),plt_s)
end

# simulation function for linear regression and GS sampler
function GS_LR_sim(X,y,δ,γ,d,α0,θ0,iter)
    θ1m = zeros(1,iter)
    θ2m = zeros(1,iter)
    θ3m = zeros(1,iter)

    for i in 1:10
        α,θ1,θ2,θ3 = run_GS_LR(X,y,δ,γ,d,α0,θ0,iter)
        plt = plot_θ(θ1,θ2,θ3)
        safesave(plotsdir("gs_lr","iter=$(iter)_$i.pdf"),plt)

        θ1m = vcat(θ1m,θ1')
        θ2m = vcat(θ2m,θ2')
        θ3m = vcat(θ3m,θ3')

        data = Dict(
            :Eθ1 => mean(θ1),
            :Eθ2 => mean(θ2),
            :Eθ3 => mean(θ3),
            :iter => iter,
            :θ0 => θ0,
            :α0 => α0,
            :α => α,
            :θ => hcat(θ1,θ2,θ3),
        )
        safesave(datadir("gs_lr",savename(data, "bson")),data)

    end

    θ1 = θ1m[2:end,:]
    θ2 = θ2m[2:end,:]
    θ3 = θ3m[2:end,:]

    ci1 = hcat([calculate_confidence(θ1[i,:]) for i in 1:10]...)
    ci2 = hcat([calculate_confidence(θ2[i,:]) for i in 1:10]...)
    ci3 = hcat([calculate_confidence(θ3[i,:]) for i in 1:10]...)

    p1 = plot_CI(ci1,ylabel=L"\theta_1")
    p2 = plot_CI(ci2,ylabel=L"\theta_2")
    p3 = plot_CI(ci3,ylabel=L"\theta_3")

    ci_plot = plot(p1,p2,p3,layout=(3,1),size=(600,500))
    safesave(plotsdir("gs_lr","ci_theta_iter=$iter.pdf"),ci_plot)
end